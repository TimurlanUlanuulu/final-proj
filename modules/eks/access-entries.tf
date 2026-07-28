locals {
  standard_access_entries = {
    for key, entry in var.access_entries :
    key => entry
    if entry.type == "STANDARD"
  }

  access_entries_with_policy = {
    for key, entry in var.access_entries :
    key => entry
    if entry.type == "STANDARD" && entry.policy_arn != null
  }
}

resource "aws_eks_access_entry" "this" {
  for_each = var.access_entries

  cluster_name  = aws_eks_cluster.this.name
  principal_arn = each.value.principal_arn
  type          = each.value.type

  tags = merge(
    var.tags,
    {
      Name = "${var.cluster_name}-${each.key}-access-entry"
    }
  )
}

resource "aws_eks_access_policy_association" "this" {
  for_each = local.access_entries_with_policy

  cluster_name  = aws_eks_cluster.this.name
  principal_arn = each.value.principal_arn
  policy_arn    = each.value.policy_arn

  access_scope {
    type = try(each.value.access_scope.type, "cluster")

    namespaces = try(
      each.value.access_scope.type == "namespace"
      ? each.value.access_scope.namespaces
      : null,
      null
    )
  }

  depends_on = [
    aws_eks_access_entry.this
  ]
}