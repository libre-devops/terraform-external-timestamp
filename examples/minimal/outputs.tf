output "os" {
  description = "The detected host operating system."
  value       = module.timestamp.os
}

output "timestamp" {
  description = "The timestamp generated at plan time."
  value       = module.timestamp.timestamp
}
