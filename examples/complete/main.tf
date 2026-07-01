# Complete call: exercise every input. Custom OS-specific formats and an explicit working_dir
# (defaults to the module directory when null).
module "timestamp" {
  source = "../../"

  linux_timestamp_format   = "+%Y-%m-%dt%H:%M:%S"
  windows_timestamp_format = "yyyy-MM-ddTHH:mm:ss"
  working_dir              = path.root
}
