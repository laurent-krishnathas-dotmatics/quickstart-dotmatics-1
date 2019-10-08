//
//
//  @author Laurent Krishnathas
//  @version 2018/04/01
//

//resource "aws_route53_record" "alb" {
//  zone_id = "${var.route53_record_hostedzone_id}"
//  name    = "${var.name}-${var.environment}"
//  type    = "A"
//
//  alias {
//    name                   = "${module.alb.dns_name}"
//    zone_id                = "${module.alb.load_balancer_zone_id}"
//    evaluate_target_health = true
//  }
//}
