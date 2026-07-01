# Generate a timestamp at plan time (not apply time), cross platform, with no cloud credentials.
#
# Why not Terraform's own timestamp()? That returns a fixed RFC3339 UTC string and is only known at
# apply. This module runs an external program during plan, so the value is available to expressions
# that must be resolved before apply (for example a resource name suffix), and the format is yours.
#
# OS detection first: path.module is joined to a helper with a literal backslash. On Windows that
# resolves to a real path, so Terraform runs printf.cmd ({"os":"Windows"}); on Linux/macOS the
# backslash is just a character, the path never exists, and the printf branch prints {"os":"Linux"}.
locals {
  windows_helper = "${abspath(path.module)}\\printf.cmd"
}

data "external" "detect_os" {
  working_dir = var.working_dir
  program     = fileexists(local.windows_helper) ? [local.windows_helper, "{\"os\":\"Windows\"}"] : ["printf", "{\"os\":\"Linux\"}"]
}

locals {
  os         = data.external.detect_os.result.os
  is_windows = lower(local.os) == "windows"
  is_linux   = lower(local.os) == "linux"
}

# Linux/macOS branch: format with date(1).
data "external" "generate_linux_timestamp" {
  count       = local.is_linux ? 1 : 0
  working_dir = var.working_dir == null ? path.module : var.working_dir

  program = [
    "bash",
    "-c",
    "DATE=$(date '${var.linux_timestamp_format}'); printf '{\"timestamp\":\"%s\"}' \"$DATE\""
  ]
}

# Windows branch: format with Get-Date.
data "external" "generate_windows_timestamp" {
  count       = local.is_windows ? 1 : 0
  working_dir = var.working_dir == null ? path.module : var.working_dir

  program = [
    "powershell",
    "-Command",
    "$date = Get-Date -Format '${var.windows_timestamp_format}'; @{ timestamp = $date } | ConvertTo-Json -Compress | Write-Output"
  ]
}

locals {
  timestamp = local.is_linux ? lower(data.external.generate_linux_timestamp[0].result.timestamp) : lower(data.external.generate_windows_timestamp[0].result.timestamp)
}
