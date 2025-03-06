variable "region" {
  type    = string
  default = "us-east-1"
}

variable "ssl_cert" {
  type    = string
  default = "arn:aws:acm:us-east-1:686255956392:certificate/9968e4c0-d02c-47e6-9d67-c1e04865bbde"
}

variable "tags" {
  type = map(string)
  default = {
    Environment = "poc"
  }
}

variable "environment" {
  type    = string
  default = "poc"
}

variable "lgtm_hostname" {
  type    = string
  default = "lgtm.local-poc.com"
}

variable "grafana_hostname" {
  type    = string
  default = "grafana.local-poc.com"
}

variable "prometheus_hostname" {
  type    = string
  default = "prometheus.local-poc.com"
}

variable "loki_bucket_name" {
  description = "Name of the S3 bucket for Loki chunks"
  type        = string
  default     = "loki-chk-6790"
}

variable "loki_ruler_bucket_name" {
  description = "Name of the S3 bucket for Loki ruler"
  type        = string
  default     = "loki-rul-6790"
}

variable "tempo_bucket_name" {
  description = "Name of the S3 bucket for Tempo"
  type        = string
  default     = "tempo-bucket-6790"
}

variable "mimir_blocks_bucket_name" {
  description = "Name of the S3 bucket for Mimir blocks"
  type        = string
  default     = "mimir-blocks-6790"
}

variable "mimir_ruler_bucket_name" {
  description = "Name of the S3 bucket for Mimir ruler"
  type        = string
  default     = "mimir-ruler-6790"
}

variable "loki_basic_auth_htpasswd" {
  description = "htpasswd content for Loki basic auth"
  type        = string
  default     = "admin@123"
}

variable "loki_canary_username" {
  description = "Username for Loki canary"
  type        = string
  default     = "admin"
}

variable "loki_canary_password" {
  description = "Password for Loki canary"
  type        = string
  default     = "admin"
}