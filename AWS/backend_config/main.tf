resource "aws_s3_bucket" "backend_config" {
  bucket = "friendsapp-backend-config"

  tags = {
    Name        = "friendsapp backend config"
    Environment = "Dev"
  }
}
