###############################################################################
# Detect the OS
###############################################################################

# Full path to the helper that exists only on Windows
locals {
  windows_helper = "${abspath(path.module)}\\printf.cmd"
}

# If the helper file exists, we’re on Windows; otherwise assume Linux
data "external" "detect_os" {
  program = fileexists(local.windows_helper) ? [local.windows_helper, "{\"os\":\"Windows\"}"] : ["printf", "{\"os\":\"Linux\"}"]
}

locals {
  os         = data.external.detect_os.result.os
  is_windows = lower(local.os) == "windows"
  is_linux   = lower(local.os) == "linux"
}


# Linux branch
data "external" "generate_linux_timestamp" {
  count       = local.is_linux ? 1 : 0
  working_dir = var.working_dir == null ? path.module : var.working_dir

  program = [
    "bash",
    "-c",
    "DATE=$(date '${var.linux_timestamp_format}'); printf '{\"id\":\"%s\",\"timestamp\":\"%s\"}' \"$DATE\" \"$DATE\""
  ]
}


# Windows branch
data "external" "generate_windows_timestamp" {
  count       = local.is_windows ? 1 : 0
  working_dir = var.working_dir == null ? path.module : var.working_dir

  program = [
    "powershell",
    "-Command",
    "$date = Get-Date -Format '${var.windows_timestamp_format}'; $json = @{ id = $date; timestamp = $date } | ConvertTo-Json -Compress; Write-Output $json"
  ]

}


###############################################################################
# Normalise the result
###############################################################################

locals {
  timestamp = local.is_linux ? lower(data.external.generate_linux_timestamp[0].result.timestamp) : lower(data.external.generate_windows_timestamp[0].result.timestamp)
}
