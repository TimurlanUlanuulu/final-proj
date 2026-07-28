resource "aws_launch_template" "nodes" {
  name_prefix = "${var.name}-nodes-"

  description = "Launch template for self-managed EKS worker nodes"

  image_id = local.node_ami_id

  update_default_version = true

  iam_instance_profile {
    arn = aws_iam_instance_profile.nodes.arn
  }

  vpc_security_group_ids = [
    aws_security_group.workers.id
  ]

  user_data = base64encode(local.node_user_data)

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
    instance_metadata_tags      = "enabled"
  }

  monitoring {
    enabled = true
  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = var.node_root_volume_size
      volume_type           = var.node_root_volume_type
      encrypted             = true
      delete_on_termination = true
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      var.tags,
      {
        Name                                        = "${var.name}-worker-node"
        "kubernetes.io/cluster/${var.cluster_name}" = "owned"
      }
    )
  }

  tag_specifications {
    resource_type = "volume"

    tags = merge(
      var.tags,
      {
        Name = "${var.name}-worker-volume"
      }
    )
  }

  tag_specifications {
    resource_type = "network-interface"

    tags = merge(
      var.tags,
      {
        Name = "${var.name}-worker-eni"
      }
    )
  }

  depends_on = [
    aws_iam_role_policy_attachment.nodes_eks_worker,
    aws_iam_role_policy_attachment.nodes_ecr_pull,
    aws_iam_role_policy_attachment.nodes_ssm
  ]

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-node-launch-template"
    }
  )
}

resource "aws_autoscaling_group" "nodes" {
  name_prefix = "${var.name}-nodes-"

  min_size         = var.node_min_size
  desired_capacity = var.node_desired_size
  max_size         = var.node_max_size

  vpc_zone_identifier = var.worker_subnet_ids

  health_check_type         = "EC2"
  health_check_grace_period = 300

  capacity_rebalance = true

  protect_from_scale_in = false

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.nodes.id
        version            = "$Latest"
      }

      dynamic "override" {
        for_each = var.node_instance_types

        content {
          instance_type = override.value
        }
      }
    }

    instances_distribution {
      on_demand_base_capacity                  = 0
      on_demand_percentage_above_base_capacity = var.node_on_demand_percentage

      on_demand_allocation_strategy = "prioritized"
      spot_allocation_strategy      = "price-capacity-optimized"
    }
  }

  instance_refresh {
    strategy = "Rolling"

    preferences {
      min_healthy_percentage = 50
      instance_warmup        = 300
    }

    triggers = [
      "tag"
    ]
  }

  dynamic "tag" {
    for_each = merge(
      var.tags,
      {
        Name                                        = "${var.name}-worker-node"
        "kubernetes.io/cluster/${var.cluster_name}" = "owned"
      }
    )

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  tag {
    key                 = "k8s.io/cluster-autoscaler/enabled"
    value               = "true"
    propagate_at_launch = false
  }

  tag {
    key                 = "k8s.io/cluster-autoscaler/${var.cluster_name}"
    value               = "owned"
    propagate_at_launch = false
  }


  depends_on = [
    aws_eks_access_entry.nodes,
    aws_launch_template.nodes
  ]

  lifecycle {
    create_before_destroy = true

    ignore_changes = [
      desired_capacity
    ]
  }
}