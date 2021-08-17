provider "random" {
  version = "~> 2.1"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper = false
}

variable "trigger_tokken" {
  type        = string
  default     = "0"
  description = "Changing value forces to create a new time stamp."
}

output "random_id" {
  value = random_string.suffix.id
}