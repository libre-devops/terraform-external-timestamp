# Runs the real detection and timestamp generation on the host executing the test (CI runners are
# Linux). Asserts the contract rather than a specific value.

run "generates_a_timestamp" {
  assert {
    condition     = output.is_windows != output.is_linux
    error_message = "Exactly one of is_windows / is_linux must be true."
  }

  assert {
    condition     = length(output.timestamp) > 0
    error_message = "timestamp output must be non-empty."
  }
}

run "honours_a_custom_linux_format" {
  variables {
    # A plain year, so the output is deterministic and easy to assert on the Linux runner.
    linux_timestamp_format = "+%Y"
  }

  assert {
    condition     = output.is_linux ? can(regex("^[0-9]{4}$", output.timestamp)) : true
    error_message = "With format +%Y the Linux timestamp should be a four digit year."
  }
}
