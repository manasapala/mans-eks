  
output "vpc_id" {
  value = "${aws_vpc.example.id}"
}

output "app_subnet_ids" {
  value = "${aws_subnet.application.*.id}"
}

output "gateway_subnet_ids" {
  value = "${aws_subnet.gateway.*.id}"
}

output "eks_kubeconfig" {
  value = "${local.kubeconfig}"
  depends_on = [
    "aws_eks_cluster.tf_eks"
  ]
}

output "target_group_arn" {
  value = "${aws_lb_target_group.tf_eks.arn}"
}

output "node_sg_id" {
  value = "${aws_security_group.tf-eks-node.id}"
}
