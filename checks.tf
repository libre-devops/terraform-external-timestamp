# Guard against the detection returning something we do not understand (for example if the helper
# is tampered with), so downstream is_windows / is_linux switches are never silently both false.
check "os_is_recognised" {
  assert {
    condition     = local.is_windows || local.is_linux
    error_message = "OS detection returned '${local.os}', expected 'Windows' or 'Linux'."
  }
}

# The generated timestamp should never be empty; an empty string means the date/Get-Date call failed
# or the format produced nothing, which would silently poison anything downstream that uses it.
check "timestamp_is_present" {
  assert {
    condition     = length(local.timestamp) > 0
    error_message = "Generated timestamp is empty."
  }
}
