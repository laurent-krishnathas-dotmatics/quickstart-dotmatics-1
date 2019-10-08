//
//
//  @author Laurent Krishnathas
//  @version 2018/04/01
//


output "name" {
  value = "${var.name}"
}

output "environment" {
  value = "${var.environment}"
}

//output "ec2_id" {
//  value = "${module.ec2.id}"
//}
//
//output "ec2_private_ip" {
//  value = "${module.ec2.private_ip}"
//}
//
//output "key_name" {
//  value = "${module.ec2.key_name}"
//}
