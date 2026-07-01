output "is_linux" {
  description = "True when the host running Terraform is Linux (or another non-Windows POSIX host)."
  value       = local.is_linux
}

output "is_windows" {
  description = "True when the host running Terraform is Windows."
  value       = local.is_windows
}

output "os" {
  description = "The detected host operating system, either \"Windows\" or \"Linux\"."
  value       = local.os
}

output "timestamp" {
  description = "The timestamp generated at plan time, formatted per the OS-specific format variable and lowercased."
  value       = local.timestamp
}
