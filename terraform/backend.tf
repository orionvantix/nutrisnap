terraform {
  backend "s3" {
    # Configured via -backend-config in CI/CD pipeline
    # Values injected from GitHub secrets:
    # bucket = TF_STATE_BUCKET
    # key    = "nutrisnap/terraform.tfstate"
    # region = "us-east-1"
    encrypt = true
  }
}
