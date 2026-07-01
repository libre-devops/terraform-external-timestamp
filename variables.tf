variable "linux_timestamp_format" {
  description = "date(1) format string used on Linux/macOS (must begin with +). See `man date`."
  type        = string
  default     = "+%d-%m-%Y:%H:%M"

  validation {
    condition     = startswith(var.linux_timestamp_format, "+")
    error_message = "linux_timestamp_format must begin with '+' (the date(1) format flag)."
  }
}

variable "windows_timestamp_format" {
  description = "Get-Date -Format string used on Windows (for example dd-MM-yyyy:HH:mm)."
  type        = string
  default     = "dd-MM-yyyy:HH:mm"
}

variable "working_dir" {
  description = "Optional working directory the programs run in. Defaults to the module directory when null."
  type        = string
  default     = null
}
