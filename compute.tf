data "archive_file" "otp_lambda_layer" {
  type        = "zip"
  source_dir  = "${path.module}/code/lambda_layer"
  output_path = "${path.module}/code/lambda_layer.zip"
  excludes = [
    "${path.module}/code/lambda_layer/.venv",
    "${path.module}/code/lambda_layer/**dist-info"
  ]
}

data "archive_file" "otp_lambda_function" {
  type        = "zip"
  source_dir  = "${path.module}/code/lambda_function"
  output_path = "${path.module}/code/lambda_function.zip"
  excludes    = ["${path.module}/code/lambda_function/.venv"]
}

resource "aws_lambda_layer_version" "otp_lambda_layer" {
  filename   = data.archive_file.otp_lambda_layer.output_path
  layer_name = "otp_layer"

  compatible_runtimes = ["python3.8"]
}

resource "aws_lambda_function" "otp_lambda_function" {
  filename         = data.archive_file.otp_lambda_function.output_path
  function_name    = "otp_function"
  role             = aws_iam_role.otp_lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.8"
  layers           = [aws_lambda_layer_version.otp_lambda_layer.arn]
  source_code_hash = filebase64sha256(data.archive_file.otp_lambda_function.output_path)
  environment {
    variables = {
      TOTP_SECRET = var.otp_secret
    }
  }
}

resource "aws_lambda_alias" "otp_lambda_alias" {
  function_name    = aws_lambda_function.otp_lambda_function.function_name
  function_version = "$LATEST"
  name             = "prod"
}

resource "aws_lambda_function_url" "otp_url" {
  function_name      = aws_lambda_function.otp_lambda_function.function_name
  authorization_type = "NONE"
}

resource "aws_lambda_function_url" "test_live" {
  function_name      = aws_lambda_function.otp_lambda_function.function_name
  qualifier          = "prod"
  authorization_type = "NONE"
}
