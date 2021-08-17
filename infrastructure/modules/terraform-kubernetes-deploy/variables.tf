
variable "deploy" {
  description = "Deployment Configurations"
  type = any
  default = {}
}

variable "application_name" {
  description = "Name of the application"
  type        = string
}

variable "namespace" {
  description = "Namespace where application will be deployed."
  type        = string
  default     =  "default"
}

