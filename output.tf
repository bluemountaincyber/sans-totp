output "totp_code_url" {
  value = "${aws_lambda_function_url.otp_url.function_url}?secret=$herl0ckHolm3s"
}