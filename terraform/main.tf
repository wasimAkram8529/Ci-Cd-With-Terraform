provider "aws" {
  region = "us-east-1"
}


resource "aws_s3_bucket" "website" {
  bucket = var.bucket_name
  force_destroy = true
  tags = {
    Name = var.bucket_name
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.website.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "website_public_access" {
  bucket                  = aws_s3_bucket.website.id
  block_public_acls       = false
  ignore_public_acls      = false
  block_public_policy     = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "website_policy" {
  bucket = aws_s3_bucket.website.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      "Sid": "Statement1",
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
        "s3:GetObject"
      ]
      Resource  = "${aws_s3_bucket.website.arn}/*"
    }]
  })
  depends_on = [
    aws_s3_bucket_public_access_block.website_public_access
  ]
}


