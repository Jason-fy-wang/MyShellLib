variable "var_vpc_cidr" {
    type = string
    default = "10.0.0.0/8"
    description = <<EOT
    {
        "Label": {
            "en": "VPC cidr",
            "zh-en": "VPC CIDR"
        },

        "AllowedValues": [
            "10.0.0.0/8",
            "172.16.0.0/12",
            "192.168.0.0/16"
        ]
    }
    EOT
}

variable "var_vsw_zone_id" {
    type = string
    description = <<EOT
    {
        "Label": {
            "en": "Availability Zone",
            "zh-cn":"可用区"
        },
        "AssociationProperty": "ALIYUN::ECS::Instance::ZoneId"
    }
    EOT
}

resource "alicloud_vpc" "res_vpc" {
    vpc_name = "测试环境VPC"
    cidr_block = var.var_vpc_cidr
}

resource "alicloud_vswitch" "res_vsw_db" {
    vswitch_name = "数据库交换机"
    zone_id = var.var_vsw_zone_id
    vpc_id = alicloud_vpc.res_vpc.id
    cidr_block =var.var_vpc_cidr == "10.0.0.0/8" ? "10.0.0.0/24": var.var_vpc_cidr=="172.16.0.0/12"?"172.16.0.0/24":"192.168.0.0/24"
}

resource "alicloud_vswitch" "res_vsw_app" {
    vswitch_name = "应用交换机"
    zone_id = var.var_vsw_zone_id
    vpc_id = alicloud_vpc.res_vpc.id
    cidr_block = var.var_vpc_cidr == "10.0.0.0/8" ? "10.0.1.0/24":var.var_vpc_cidr=="172.16.0.0/12"?"172.16.1.0/24":"192.168.1.0/24"
}
