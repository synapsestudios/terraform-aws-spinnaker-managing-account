# AWS Spinnaker Managing Account

This module creates the necessary IAM roles and policies to manage Spinnaker Managed Accounts (Client AWS Accounts).

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.12.6 |
| aws | ~> 2.53 |
| template | ~> 2.1 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 2.53 |
| template | ~> 2.1 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| spinnaker-managed-arns | List of managed accounts (ARNs) | `list(string)` | n/a | yes |
| tags | A mapping of tags to assign to the Spinnaker resources. | `map(string)` | n/a | yes |
| create\_auth\_user | If true, a Spinnker User will be created | `bool` | `false` | no |
| s3\_bucket\_name | Name of S3 state store, this will be prepended by 'spinnaker-state-'. | `string` | `"synapsestudios-com"` | no |

## Outputs

| Name | Description |
|------|-------------|
| spinnaker-auth-role-arn | n/a |
| spinnaker-user-access-key-id | n/a |
| spinnaker-user-access-key-secret | n/a |
| spinnaker-user-arn | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->