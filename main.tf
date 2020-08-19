locals {
  s3_bucket_name = "spinnaker-state-${var.s3_bucket_name}"
}

##########################
# Role - SpinnakerAuthRole
##########################
resource "aws_iam_role" "spinnaker-auth-role" {
  name               = "SpinnakerAuthRole"
  path               = "/spinnaker/"
  description        = "EC2 Role and Instance Profile with which Spinnaker Runs."
  assume_role_policy = file("${path.module}/policies/SpinnakerAuthRole.json")
}

############################
# Spinnaker Instance Profile
############################
resource "aws_iam_instance_profile" "spinnaker-auth-role" {
  name = "SpinnakerAuthRole"
  path = "/spinnaker/"
  role = aws_iam_role.spinnaker-auth-role.name
}

######################
# User - SpinnakerUser
######################
resource "aws_iam_user" "spinnaker-user" {
  count = var.create_auth_user ? 1 : 0

  name = "SpinnakerUser"
  path = "/spinnaker/"
  tags = var.tags
}

############################
# Access Key - SpinnakerUser
############################
resource "aws_iam_access_key" "spinnaker-user" {
  count = var.create_auth_user ? 1 : 0

  user = aws_iam_user.spinnaker-user[0].id
}

###################################
# Policy Attachment - SpinnakerUser
###################################
resource "aws_iam_user_policy" "user-role" {
  count = var.create_auth_user ? 1 : 0

  name   = "SpinnakerAuthRole"
  user   = aws_iam_user.spinnaker-user[0].name
  policy = data.template_file.spinnaker-user-policy.rendered
}

#######################################
# Policy Attachment - SpinnakerAuthRole
#######################################
resource "aws_iam_role_policy_attachment" "auth-role" {
  role       = aws_iam_role.spinnaker-auth-role.name
  policy_arn = aws_iam_policy.auth-role.arn
}

resource "aws_iam_policy" "auth-role" {
  name   = "SpinnakerAssumeRolePolicy"
  policy = data.template_file.spinnaker-user-policy.rendered
}

########################################################
# Policy Attachment - AmazonEC2ContainerRegistryReadOnly
########################################################
resource "aws_iam_role_policy_attachment" "ecr-read-only" {
  role       = aws_iam_role.spinnaker-auth-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

############################################
# Template - S3 Policy Spinnaker State Store
############################################
data "template_file" "spinnaker-user-policy" {
  template = file("${path.module}/policies/SpinnakerUser.json")
  vars = {
    spinnaker-managed-arns = jsonencode(var.spinnaker-managed-arns)
  }
}

############################
# S3 - Spinnaker State Store
############################
resource "aws_s3_bucket" "spinnaker-state" {
  bucket = local.s3_bucket_name
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = var.tags
}

############################################
# Template - S3 Policy Spinnaker State Store
############################################
data "template_file" "aws-s3-policy" {
  template = file("${path.module}/policies/s3.json")

  vars = {
    s3-bucket-arn = aws_s3_bucket.spinnaker-state.arn
  }
}

############################
# Policy - SpinnakerS3Policy
############################
resource "aws_iam_policy" "spinnaker-s3-policy" {
  name        = "SpinnakerS3Policy"
  description = "SpinnakerS3Policy"

  policy = data.template_file.aws-s3-policy.rendered
}

#######################################
# Policy Attachment - SpinnakerS3Policy
#######################################
resource "aws_iam_policy_attachment" "spinnaker-role-s3-policy" {
  name       = "SpinnakerS3Policy"
  roles      = [aws_iam_role.spinnaker-auth-role.name]
  policy_arn = aws_iam_policy.spinnaker-s3-policy.arn
}

#######################################
# Policy Attachment - SpinnakerS3Policy
#######################################
resource "aws_iam_policy_attachment" "spinnaker-usr-s3-policy" {
  count = var.create_auth_user ? 1 : 0

  name       = "SpinnakerS3Policy"
  users      = [aws_iam_user.spinnaker-user[0].name]
  policy_arn = aws_iam_policy.spinnaker-s3-policy.arn
}

