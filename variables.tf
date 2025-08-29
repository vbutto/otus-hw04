# Идентификаторы облака и каталога
variable "cloud_id" {
  description = "Yandex Cloud cloud ID"
  type        = string
}

variable "folder_id" {
  description = "Yandex Cloud folder ID"
  type        = string
}

# Зона по умолчанию (лучше ru-central1-a или ru-central1-b)
variable "zone" {
  description = "Default availability zone"
  type        = string
  default     = "ru-central1-a"
}

# Путь к ключу сервисного аккаунта
variable "sa_key_file" {
  description = "Path to service account key JSON file"
  type        = string
}

# Путь к вашему публичному SSH-ключу
variable "ssh_public_key_path" {
  description = "Path to your SSH public key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

# IP-адрес (или диапазон), с которого разрешён доступ по SSH на frontend
variable "my_ip" {
  description = "Your external IP for SSH access (CIDR)"
  type        = string
  default     = "0.0.0.0/0" # замените на свой реальный IP/32
}

# CIDR для всей VPC и подсетей
variable "vpc_cidr" {
  description = "CIDR for VPC"
  type        = string
  default     = "10.10.0.0/16"
}

variable "subnet_front_cidr" {
  description = "CIDR for frontend subnet (public)"
  type        = string
  default     = "10.10.10.0/24"
}

variable "frontend_ip" {
  description = "Static internal IP for frontend VM (must belong to subnet_front_cidr)"
  type        = string
  default     = "10.10.10.10"
}

variable "subnet_back_cidr" {
  description = "CIDR for backend subnet (private)"
  type        = string
  default     = "10.10.20.0/24"
}

variable "backend_ip" {
  description = "Static internal IP for backend VM (must belong to subnet_back_cidr)"
  type        = string
  default     = "10.10.20.10"
}

variable "subnet_db_cidr" {
  description = "CIDR for database subnet (private)"
  type        = string
  default     = "10.10.30.0/24"
}

variable "db_ip" {
  description = "Static internal IP for db VM (must belong to subnet_db_cidr)"
  type        = string
  default     = "10.10.30.10"
}

variable "bastion_ip" {
  description = "Static internal IP for bastion VM"
  type        = string
}