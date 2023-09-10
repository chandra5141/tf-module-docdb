resource "aws_docdb_subnet_group" "docdb_subnet_group" {
  name       = "${var.env}-docdb_subnet_group"
  subnet_ids = var.subnet_ids

  tags = merge(
    local.common_tags,
    { Name = "${var.env}-docdb_subnet_group" }
  )
}

resource "aws_security_group" "docdb_sg" {
  name        = "${var.env}-docdb_security_group"
  description = "${var.env}-docdb_security_group"
  vpc_id      = var.vpc_id


  ingress {
    description      = "MongoDB"
    from_port        = 27017
    to_port          = 27017
    protocol         = "tcp"
    cidr_blocks      = var.allow_cidr

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    { Name = "${var.env}-docdb_security_group" }
  )

}

resource "aws_docdb_cluster" "docdb_cluster" {
  cluster_identifier      = "${var.env}-docdb-cluster"
  engine                  = "docdb"
  master_username         = data.aws_ssm_parameter.docdb_user.value
  master_password         = data.aws_ssm_parameter.docdb_password.value
  skip_final_snapshot     = true
  db_subnet_group_name    = aws_docdb_subnet_group.docdb_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.docdb_sg.id]
#  storage_encrypted       = true
#  kms_key_id              = data.aws_kms_key.key.arn

  tags = merge(
    local.common_tags,
    { Name = "${var.env}-docdb_cluster" }
  )

}

resource "aws_docdb_cluster_instance" "cluster_instances" {
  count              = var.no_of_instance_docdb
  identifier         = "${var.env}-docdb_cluster-instance-${count.index+1}"
  cluster_identifier = aws_docdb_cluster.docdb_cluster.id
  instance_class     = var.instance_class
#  storage_encrypted       = true
#  kms_key_id              = data.aws_kms_key.key.arn

  tags = merge(
    local.common_tags,
    { Name = "${var.env}-docdb_cluster_instance" }
  )

}