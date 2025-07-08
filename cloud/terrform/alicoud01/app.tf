variable "var_app_instance_type" {
  type        = string
  default     = "ecs.c7.large"
  description = <<EOT
  {
    "Label": {
      "zh-cn": "应用实例规格",
      "en": "App Instance Type"
    },
    "AssociationProperty": "ALIYUN::ECS::Instance::InstanceType",
    "AssociationPropertyMetadata": {
      "ZoneId": "$${var_vsw_zone_id}"
    }
  }
  EOT
}


variable "var_app_system_disk_category" {
  type        = string
  default     = "cloud_essd"
  description = <<EOT
  {
    "AssociationProperty": "ALIYUN::ECS::Disk::SystemDiskCategory",
    "AssociationPropertyMetadata": {
      "ZoneId": "$${var_vsw_zone_id}",
      "InstanceType": "$${var_app_instance_type}"
    },
    "Label": {
      "en": "App Instance System Disk Type",
      "zh-cn": "应用系统盘类型"
    }
  }
  EOT
}

resource "alicloud_security_group" "res_sg_app" {
  vpc_id = alicloud_vpc.res_vpc.id
  name   = "应用安全组"
}

resource "alicloud_security_group_rule" "res_sg_app_rule_22" {
  security_group_id = alicloud_security_group.res_sg_app.id
  type              = "ingress"
  priority          = 1
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  cidr_ip           = "0.0.0.0/0"
  policy            = "accept"
  port_range        = "22/22"
  description       = "SSH"
}

resource "alicloud_security_group_rule" "res_sg_app_rule_80" {
  security_group_id = alicloud_security_group.res_sg_app.id
  type              = "ingress"
  priority          = 1
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  cidr_ip           = "0.0.0.0/0"
  policy            = "accept"
  port_range        = "80/80"
  description       = "HTTP"
}


resource "alicloud_instance" "res_app_instance" {
  count                      = 2
	instance_name              = "AppInstance"
  availability_zone          = var.var_vsw_zone_id
  security_groups            = [alicloud_security_group.res_sg_app.id]
  instance_type              = var.var_app_instance_type
  system_disk_category       = var.var_app_system_disk_category
  system_disk_size           = 40
  image_id                   = "centos_7_9_x64_20G_alibase_20230613.vhd"
  vswitch_id                 = alicloud_vswitch.res_vsw_app.id
  password                   = "AppPassword!"
  internet_charge_type       = "PayByTraffic"
  instance_charge_type       = "PostPaid"
  user_data                  = format(file("${path.cwd}/app_userdata.sh"), alicloud_instance.res_db_instance.private_ip)
}

resource "alicloud_slb_load_balancer" "res_app_clb" {
  load_balancer_name    ="APPSLB"
  vswitch_id            = alicloud_vswitch.res_vsw_app.id
  load_balancer_spec    = "slb.s2.small"
  internet_charge_type  = "paybytraffic"
  address_type          = "internet"
}

resource "alicloud_slb_server_group" "res_clb_group" {
  load_balancer_id = alicloud_slb_load_balancer.res_app_clb.id
}

resource "alicloud_slb_server_group_server_attachment" "res_clb_group_att" {
  count           = 2
  server_group_id = alicloud_slb_server_group.res_clb_group.id
  server_id       = alicloud_instance.res_app_instance[count.index].id
  port            = 80
  weight          = 100
}

resource "alicloud_slb_listener" "res_clb_listener" {
  load_balancer_id          = alicloud_slb_load_balancer.res_app_clb.id
  server_group_id           = alicloud_slb_server_group.res_clb_group.id
  backend_port              = 80
  frontend_port             = 80
  protocol                  = "tcp"
  bandwidth                 = 10
}