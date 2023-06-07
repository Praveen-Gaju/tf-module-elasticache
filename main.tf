resource "aws_elasticache_cluster" "elasticache" {
  cluster_id           = "${var.env}-elasticache"
  engine               = var.engine
  engine_version       = var.engine_version
  node_type            = var.node_type
  num_cache_nodes      = var.num_cache_nodes
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.main.name

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

#elasticache endpoint parameter
resource "aws_ssm_parameter" "ealsticache_endpoint" {
  name  = "${var.env}.elasticache.endpoint"
  type  = "String"
  value = aws_elasticache_cluster.elasticache.cache_nodes[0].address
}