terraform {
  required_providers {
    time = "~> 0.3" 
  }
}

resource "time_static" "ts" {
 triggers = {
   value = var.trigger_tokken
 }
}

output "timestamp" {
  value = replace(time_static.ts.id,":","-")
}

variable "trigger_tokken" {
  type        = string
  default     = "0"
  description = "Changing value forces to create a new time stamp."
}