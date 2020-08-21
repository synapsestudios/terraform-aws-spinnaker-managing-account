output "spinnaker-user-access-key-id" {
  value = var.create_auth_user ? aws_iam_access_key.spinnaker-user[0].id : null
}

output "spinnaker-user-access-key-secret" {
  value = var.create_auth_user ? aws_iam_access_key.spinnaker-user[0].secret : null
}

output "spinnaker-auth-role-arn" {
  value = aws_iam_role.spinnaker-auth-role.arn
}

output "spinnaker-user-arn" {
  value = var.create_auth_user ? aws_iam_user.spinnaker-user[0].arn : null
}
