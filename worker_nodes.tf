########################################################################################
#data "aws_ami" "eks-worker" {
#  filter {
#    name   = "name"
#    values = ["amazon-eks-node-${var.cluster_version}-v*"]
#  }

#  most_recent = true
#  owners      = ["amazon"] # Amazon EKS AMI Account ID
#}
data "aws_ami" "eks-worker" {
  most_recent = true
  owners      = ["aws-marketplace"]

  filter {
    name   = "name"
    values = ["CIS Ubuntu Linux 18.04 LTS Benchmark*"]
  }
}
locals {
  tf-eks-node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.tf_eks.endpoint}' --b64-cluster-ca '${aws_eks_cluster.tf_eks.certificate_authority.0.data}' 'example-cluster'
USERDATA
}

resource "aws_launch_configuration" "tf_eks" {
  associate_public_ip_address = true
  iam_instance_profile        = "${aws_iam_instance_profile.node.name}"
  image_id                    = "${data.aws_ami.eks-worker.id}"
  instance_type               = "t2.micro"
  name_prefix                 = "terraform-eks"
  security_groups             = ["${aws_security_group.tf-eks-node.id}"]
  user_data_base64            = "${base64encode(local.tf-eks-node-userdata)}"
#  key_name                    = "${var.keypair-name}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group" "tf_eks" {
  name        = "terraform-eks-nodes"
  port        = 31742
  protocol    = "HTTP"
  vpc_id      = aws_vpc.example.id
  target_type = "instance"
}

resource "aws_autoscaling_group" "tf_eks" {
  desired_capacity     = "2"
  launch_configuration = "${aws_launch_configuration.tf_eks.id}"
  max_size             = "3"
  min_size             = 1
  name                 = "terraform-tf-eks"
  #vpc_zone_identifier = flatten(["${var.app_subnet_ids}"])
  vpc_zone_identifier = aws_subnet.application[*].id
  target_group_arns   = ["${aws_lb_target_group.tf_eks.arn}"]

  tag {
    key                 = "Name"
    value               = "terraform-tf-eks"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/example-cluster"
    value               = "owned"
    propagate_at_launch = true
  }
}
