variable "var_db_instance_type" {
  type        = string
  default     = "ecs.c7.large"
  description = <<EOT
  {
    "Label": {
      "zh-cn": "DB实例规格",
      "en": "DB Instance Type"
    },
    "AssociationProperty": "ALIYUN::ECS::Instance::InstanceType",
    "AssociationPropertyMetadata": {
      "ZoneId": "杭州 可用区F"
    },
    "AllowedValues": [
        "ecs.n4.large",
        "ecs.hfc5.large",
        "ecs.c7.large"
    ]
  }
  EOT
}

variable "var_db_system_disk_category" {
  type        = string
  default     = "cloud_essd"
  description = <<EOT
  {
    "AssociationProperty": "ALIYUN::ECS::Disk::SystemDiskCategory",
    "AssociationPropertyMetadata": {
      "ZoneId": "杭州 可用区F",
      "InstanceType": "$${var_db_instance_type}"
    },
    "Label": {
      "en": "DB Instance System Disk Type",
      "zh-cn": "DB系统盘类型"
    },
    "AllowedValues": [
        "cloud_essd",
        "cloud_ssd",
        "cloud_efficiency"
    ]
  }
  EOT
}

resource "alicloud_security_group" "res_sg_db" {
  vpc_id = alicloud_vpc.res_vpc.id
  name   = "DB安全组"
}


resource "alicloud_security_group_rule" "res_sg_db_rule_22" {
  security_group_id = alicloud_security_group.res_sg_db.id
  type              = "ingress"
  priority          = 1
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  cidr_ip           = "0.0.0.0/0"
  policy            = "accept"
  port_range        = "22/22"
  description       = "SSH"
}

resource "alicloud_security_group_rule" "res_sg_db_rule_3306" {
  security_group_id = alicloud_security_group.res_sg_db.id
  type              = "ingress"
  priority          = 1
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  cidr_ip           = "0.0.0.0/0"
  policy            = "accept"
  port_range        = "3306/3306"
  description       = "MYSQL"
}


resource "alicloud_instance" "res_db_instance" {
	instance_name              = "DBInstance"
  availability_zone          = var.var_vsw_zone_id
  security_groups            = [alicloud_security_group.res_sg_db.id]
  instance_type              = var.var_db_instance_type
  system_disk_category       = var.var_db_system_disk_category
  system_disk_size           = 40
  image_id                   = "centos_7_9_x64_20G_alibase_20230613.vhd"
  vswitch_id                 = alicloud_vswitch.res_vsw_db.id
  password                   = "DBPassword!"
  internet_charge_type       = "PayByTraffic"
  instance_charge_type       = "PostPaid"
  private_ip                 = var.var_vpc_cidr == "10.0.0.0/8" ? "10.0.0.100" : var.var_vpc_cidr == "172.16.0.0/12" ? "172.16.0.100" : "192.168.0.100"
  user_data                  = file("${path.cwd}/db_userdata.sh")
}


