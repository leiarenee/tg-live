

variable "application_name" {
  description = "Name of the application"
  type        = string
}

variable "container_image" {
  description = "Container image to be deployed"
  type        = string
}

variable "namespace" {
  description = "Namespace where application will be deployed."
  type        = string
  default     =  "default"
}

variable "replicas" {
  description = "Number of pod replications to be deployed."
  type        = number
  default     = 1
}

variable "labels" {
  description = "Map of deployment labels. Exluding application = <app_name>"
  type        = map
  default     = {}
}

variable "selectors_match_labels" {
  description = "Pod selector according to labels exluding application = <app_name>"
  type        = map
  default     = {}
}

variable "raw_config" {
  description = "Other kubernetes configuration data"
  type        = any
  default     = {}
}

variable "env" {
  description = "Environment variables"
  type        = any
  default     = []
}
