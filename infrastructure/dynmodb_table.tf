resource "aws_dynamodb_table" "table" {
  name           = var.dynamodb_table_name
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = var.hash_key 

  dynamic "attribute" {
    for_each = var.attributes
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  ttl {
    attribute_name = ""
    enabled        = false
  }

  tags = {
    Name        = "${var.dynamodb_table_name}-table"
    Environment = "production"
  }
}
