resource "aws_iam_role" "otp_lambda_role" {
  name = "OTPLambdaRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })
}

resource "aws_iam_policy" "otp_lambda_policy" {
  name        = "OTPLambdaPolicy"
  description = "Policy for otp_function"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ]
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "otp_lambda_policy_attachment" {
  role       = aws_iam_role.otp_lambda_role.name
  policy_arn = aws_iam_policy.otp_lambda_policy.arn
}
