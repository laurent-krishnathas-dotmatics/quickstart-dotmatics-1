//
//
//  @author Laurent Krishnathas
//  @version 2019/03/01
//

//
//module "iam_instance_profile" {
//  source = "../modules/iam_instance_profile"
//  aws_region = "${var.aws_region}"
//  name = "${var.name}"
//  environment = "${var.environment}"
//  tags = "${local.tags}"
//}
//
//module ec2 {
//  source = "../modules/ec2"
//  aws_region = "${var.aws_region}"
//  name = "${var.name}"
//  environment = "${var.environment}"
//  vpc_id = "${data.aws_vpc.this.id}"
//
//  subnet_id = "${data.aws_subnet_ids.public.ids[0]}"
//
//  //  iam_instance_profile = "dotmatics-devops-ssmrole"
//  iam_instance_profile = "${module.iam_instance_profile.name}"
//
//  //  WARNING any change will create a new ec2 so need to configure via ansible
//  user_data = <<-EOF
//                #!/bin/bash
//                set -u
//                set -e
//                set -x
//
//                echo "starting user_data version 2019/04/04 16h29 ..."
//                hostname
//                whoami
//                id
//                echo "user_data finised"
//
//                EOF
//  tags = "${local.tags}"
//}
//


resource "aws_key_pair" "this" {
  key_name   = "${var.name}-${var.environment}"
  public_key="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCd6TyxYEK3uELPsTE6vEs03o+Uav3rNX/ABDowXqSgIDyCFTxRefz54+6Gnl9lwDXqb1edmLvOp3dk44weUC24Lze2naElu/NS3pG4UK54L4muFTPP1EP0/2hfzvw6rSS5u2EIsRxFnbz3Bo30W1AttcSXxeJ3PSwqaQ54dykjIRlrndx88rJOh1lTZAtN5JBBNcb1DO+yn4PoJuaBTzpnulz/yC/7kh1hHBRmGFYCy5TSFf7HhE4s0RPpr2N7u/y7nDMlwiNj4vCPY4/k+Z6GeXSWSKjmxPae5rCN/eYML/nDChpSD64j2fGsiTloLuVoBQqKQfR2H1mcci20K8gz lk@mac05.local"
}

resource "aws_s3_bucket" "this" {
  bucket = "${var.name}-${var.environment}-dotmatics-devops-v2"

  acl    = "private"
}