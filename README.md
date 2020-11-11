# Terraform Storage Gateway

## Usage
```hcl
module "storage_exemplo" {
    source = "git@github.com:jslopes8/terraform-aws-storagegateway.git?ref=v0.1"

    gateway_name        = "GW-Demo"
    s3_location         = local.s3_location

    gateway_timezone    = "GMT-3:00"
    gateway_type        = "FILE_S3"
    gateway_ip_address  = "54.221.68.194"
    smb_guest_password  = local.smb_guest_password


    storagegateway_local_disk   = "/dev/sdb"
    smb_file_share = [{
        authentication          = "GuestAccess"
        default_storage_class   = "S3_STANDARD"
        guess_mime_type         = "true"
        location_arn            = module.s3_cdn_test.s3_arn[0]
        default_tags            = local.tags 
    }]

    default_tags    = local.tags
}
```

## Requirements

| Name | Version |
| ---- | ------- |
| aws | ~> 3.14 |
| terraform | 0.13 |

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Variables Inputs
| Name | Description | Required | Type | Default |
| ---- | ----------- | -------- | ---- | ------- |

## Variable Outputs
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
| Name | Description |
| ---- | ----------- 
