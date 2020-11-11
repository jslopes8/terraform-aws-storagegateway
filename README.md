# Terraform Storage Gateway

## Firewall


From | To  | Protocol | Port| How Used |
-----| --- | -------- |----- | ---------| 
VM Storage Gateway | AWS | TCP 	| 443(HTTPS) | Para comunicação de um VM AWS Storage Gateway para um AWS service endpoint.
Web Browser | VM Storage Gateway | TCP | 80(HTTP) | Porta 80 é usada apenas durante a ativação.
VM Storage | DNS | UDP/TCP | 53(DNS) | Para comunicação entre a VM Storage Gateway e DNS server.
VM Storage Gateway | NTP | UDP | 123(NTP) | Usado para sincronizar a hora da VM com a host.
VM Storage Gateway | AWS | TCP | 22(SSH) | Não precisa dessa porta aberta para a operação normal do seu gateway, mas é necessária para a troubleshooting.


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
        location_arn            = module.s3_bucket.s3_arn[0]
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
