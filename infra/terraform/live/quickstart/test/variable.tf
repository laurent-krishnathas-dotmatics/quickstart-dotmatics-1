//
//
//  @author Laurent Krishnathas
//  @version 2018/04/01
//

variable "name" {
  default = "quickstart"
}

variable "environment" {
  default = "test"
}

variable "aws_region" {
  default = "eu-west-1"
}

variable "route53_record_hostedzone_id" {
  default = ""
}

variable "s3_alb_log_buket" {
  default = ""
}
variable "domain" {default = ""}


variable "ec2_instance_web_ebs_volume" {
  default = ""
}

variable "certificate_domain_click_arn" {
  default = ""
}

variable "certificate_domain_com_arn" {
  default = ""
}

variable "ebs_volume" {default = ""}

