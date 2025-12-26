provider "aws" {
  region = "us-east-1"
}


resource "aws_s3_bucket" "remote_backend" {
  bucket = var.bucket_name
  tags = {
    Name = var.bucket_name
    environment = var.environment
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.remote_backend.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.remote_backend.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.remote_backend.id
  block_public_acls = false 
  ignore_public_acls = false 
  block_public_policy = false 
  restrict_public_buckets = false 
}

resource "aws_s3_bucket_policy" "public_read_policy" {
  bucket = aws_s3_bucket.remote_backend.id
  policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Statement1",
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": "${aws_s3_bucket.remote_backend.arn}/*"
    }
  ]
})
depends_on = [ aws_s3_bucket_public_access_block.block_public_access ]
}

