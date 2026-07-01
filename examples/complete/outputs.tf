output "os" {
  description = "The detected host operating system."
  value       = module.timestamp.os
}

output "timestamp" {
  description = "The timestamp generated at plan time with the custom format."
  value       = module.timestamp.timestamp
}
