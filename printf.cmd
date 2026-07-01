:: Windows-only helper. Terraform runs this only when the module path resolves on Windows;
:: it prints the JSON the external data source parses. See main.tf for the mechanism.
@echo off
echo {"os": "Windows"}
