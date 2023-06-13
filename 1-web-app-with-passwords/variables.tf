variable rg_name {
  type        = string
  default     = "my-rg"
  description = "Name of the resource group"
}

variable location { 
  type        = string
  default     = "northeurope"
  description = "Location of the resources"
}

variable app_service_plan_sku { 
  type        = string
  default     = "P1v2"
  description = "SKU for the app service plan to use"
}

