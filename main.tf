resource "aws_elasticache_cluster" "elasticache" {
  cluster_id           = "${var.env}-elasticache"
  engine               = var.engine
  engine_version       = var.engine_version
  node_type            = var.node_type
  num_cache_nodes      = var.num_cache_nodes
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.main.name
  security_group_ids   = [aws_security_group.main.id]

  tags       = merge(
    var.tags,
    { Name = "${var.env}-elasticache" }
  )
}

resource "aws_elasticache_subnet_group" "main" {
  name       = "${var.env}-elasticache"
  subnet_ids = var.subnet_ids

  tags       = merge(
    var.tags,
    { Name = "${var.env}-subnet-group" }
  )
}

#security group
resource "aws_security_group" "main" {
  name        = "${var.env}-elasticache"
  description = "${var.env}-elasticache"
  vpc_id      = var.vpc_id

  ingress {
    description      = "ELASTICACHE"
    from_port        = 6379
    to_port          = 6379
    protocol         = "tcp"
    cidr_blocks      = var.allow_subnets
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags       = merge(
    var.tags,
    { Name = "${var.env}-elasticache" }
  )
}


#elasticache endpoint parameter
resource "aws_ssm_parameter" "ealsticache_endpoint" {
  name  = "${var.env}.elasticache.endpoint"
  type  = "String"
  value = aws_elasticache_cluster.elasticache.cache_nodes[0].address
}