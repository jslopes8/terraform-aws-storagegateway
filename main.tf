resource "aws_storagegateway_gateway" "main" {
    count   = var.create ? 1 : 0

    gateway_ip_address  = var.gateway_ip_address
    gateway_name        = var.gateway_name
    gateway_timezone    = var.gateway_timezone
    gateway_type        = var.gateway_type
    smb_guest_password  = var.smb_guest_password

    dynamic "smb_active_directory_settings" {
        for_each = var.active_directory_settings
        content {
            domain_name = lookup(smb_active_directory_settings.value, "domain_name", null)
            password    = lookup(smb_active_directory_settings.value, "password", null)
            username    = lookup(smb_active_directory_settings.value, "username", null)
        }
    }

    tags = var.default_tags
}
resource "aws_storagegateway_nfs_file_share" "main" {
    depends_on  = [ aws_storagegateway_gateway.main ]

    count   = var.create ? length(var.nfs_file_share) : 0

    gateway_arn             = aws_storagegateway_gateway.main.0.arn
    client_list             = var.nfs_file_share[count.index]["cidr_blocks"]
    location_arn            = var.nfs_file_share[count.index]["bucket_arn"]
    role_arn                = var.nfs_file_share[count.index]["role_arn"]
    squash                  = lookup(var.nfs_file_share[count.index], "squash", null)
    default_storage_class   = lookup(var.nfs_file_share[count.index], "storage_class", null)
    object_acl              = lookup(var.nfs_file_share[count.index], "object_acl", null)
    tags                    = lookup(var.nfs_file_share[count.index], "default_tags", null)

    dynamic "nfs_file_share_defaults" {
        for_each    = var.nfs_file_share_defaults
        content {
            directory_mode  = lookup(nfs_file_share_defaults.value, "directory_mode", null)
            file_mode       = lookup(nfs_file_share_defaults.value, "file_mode", null)
            group_id        = lookup(nfs_file_share_defaults.value, "group_id", null)
            owner_id        = lookup(nfs_file_share_defaults.value, "owner_id", null)
        }
    }
}
resource "aws_storagegateway_smb_file_share" "main" {
    depends_on  = [ aws_storagegateway_gateway.main ]

    count   = var.create ? length(var.smb_file_share) : 0

    gateway_arn     = aws_storagegateway_gateway.main.0.arn
    role_arn        = aws_iam_role.main.arn
    authentication          = var.smb_file_share[count.index]["authentication"]
    location_arn            = var.smb_file_share[count.index]["location_arn"]
    default_storage_class   = var.smb_file_share[count.index]["default_storage_class"]
    guess_mime_type_enabled = var.smb_file_share[count.index]["guess_mime_type"]
    tags                    = lookup(var.smb_file_share[count.index], "default_tags", null)
}
resource "aws_storagegateway_cache" "main" {
    disk_id     = data.aws_storagegateway_local_disk.main.id
    gateway_arn = aws_storagegateway_gateway.main.0.arn
}
data "aws_storagegateway_local_disk" "main" {
    disk_node   = var.storagegateway_local_disk
    gateway_arn = aws_storagegateway_gateway.main.0.arn
}
data "aws_iam_policy_document" "main" {
    statement {
        actions = [
            "s3:GetAccelerateConfiguration", "s3:GetBucketLocation",
            "s3:GetBucketVersioning", "s3:ListBucket",
            "s3:ListBucketVersions", "s3:ListBucketMultipartUploads"
        ]
        resources = [
            "arn:aws:s3:::${var.s3_location}"
        ]
        effect = "Allow"
    }
    statement {
        actions = [
            "s3:AbortMultipartUpload", "s3:DeleteObject",
            "s3:DeleteObjectVersion", "s3:GetObject",
            "s3:GetObjectAcl", "s3:GetObjectVersion",
            "s3:ListMultipartUploadParts", "s3:PutObject",
            "s3:PutObjectAcl"
        ]
        resources = [
            "arn:aws:s3:::${var.s3_location}/*"
        ]
        effect = "Allow"
    }
}
data "aws_iam_policy_document" "assume_role_policy_document" {
    statement {
        effect = "Allow"
        principals {
            identifiers = [
                "storagegateway.amazonaws.com",
            ]
            type = "Service"
        }
        actions = [
            "sts:AssumeRole",
        ]
    }
}
resource "aws_iam_role" "main" {
    name               = "${var.gateway_name}-StorageGatewayAccessRole"
    assume_role_policy = data.aws_iam_policy_document.assume_role_policy_document.json
    description        = var.gateway_description
}
resource "aws_iam_policy" "main" {
    name   = "${var.gateway_name}-StorageGatewayAccessPolicy"
    policy = data.aws_iam_policy_document.main.json
}
resource "aws_iam_role_policy_attachment" "main" {
    role       = aws_iam_role.main.id
    policy_arn = aws_iam_policy.main.arn
}
