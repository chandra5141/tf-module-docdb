resource "aws_docdb_subnet_group" "docdb_subnet_group" {
  name       = "${var.env}-docdb_subnet_group"
  subnet_ids = var.subnet_ids

  tags = merge(
    local.common_tags,
    { Name = "${var.env}-docdb_subnet_group" }
  )
}