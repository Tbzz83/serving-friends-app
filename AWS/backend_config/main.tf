resource "aws_s3_bucket" "backend_config" {
  bucket = "friendsapp-backend-config"
  object_lock_enabled = true

  tags = {
    Name        = "friendsapp backend config"
    Environment = "Dev"
  }
}
