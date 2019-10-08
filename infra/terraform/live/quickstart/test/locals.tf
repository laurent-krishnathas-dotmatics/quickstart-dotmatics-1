//
//
//  @author Laurent Krishnathas
//  @version 2018/04/01
//

locals {
  tags = "${map("Environment", "${var.environment}",
                "Project", "${var.name}",
                "Workspace", "${terraform.workspace}",
                "Terraform", "true",
                "Name", "${var.name}-${var.environment}"

  )}"

//  https_listeners_count = 1
//  https_listeners = "${list(
//                        map(
//                            "certificate_arn", "${var.certificate_dotmatics_click_arn}",
//                            "port", 443,
//                            "ssl_policy", "ELBSecurityPolicy-TLS-1-2-2017-01",
//                            "target_group_index", 0
//


  # helpful for debugging
  #   https_listeners_count    = 0
  #   https_listeners          = "${list()}"
  #   http_tcp_listeners_count = 0
  #   http_tcp_listeners       = "${list()}"
  #   target_groups_count      = 0
  #   target_groups            = "${list()}"
  #   extra_ssl_certs_count    = 0
  #   extra_ssl_certs          = "${list()}"
}