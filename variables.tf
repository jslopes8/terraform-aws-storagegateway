variable "create" {
    type = bool
    default = true
}
variable "gateway_ip_address" {
    type = string
}
variable "gateway_name" {
    type = string
}
variable "gateway_timezone" {
    type = string
}
variable "gateway_type" {
    type = string
}
variable "smb_guest_password" {
    type = string
    default = null
}
variable "gateway_description" {
    type = string
    default = null
}
variable "nfs_file_share" {
    type = any
    default = []
}
variable "nfs_file_share_defaults" {
    type = any
    default = []
}
variable "smb_file_share" {
    type = any
    default = []
}
variable "default_tags" {
    type = map(string)
    default = {}
}
variable "active_directory_settings" {
    type = any
    default = []
}
variable "storagegateway_local_disk" {
    type = string
    default = null
}
variable "s3_location" {
    type = string
}
