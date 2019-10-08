//
//
//  @author Laurent Krishnathas
//  @version 2018/04/01
//

provider "aws" {
  region = "${var.aws_region}"
  profile = "devops-prod"
  version = "~> 1.43"
}