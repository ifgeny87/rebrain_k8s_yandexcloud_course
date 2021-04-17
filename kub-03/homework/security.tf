resource "yandex_kms_symmetric_key" "kms_symmetric" {
  name = "kms-symmetric"
  description = "example-symetric-key"
  default_algorithm = "AES_256"
  rotation_period = "720h" // 30 days
}
