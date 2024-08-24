# SANS TOTP PoC

This is a proof of concept for the SANS TOTP project. It is a simple implementation of the TOTP algorithm in Python and deployed to AWS Lambda.

## Usage

1. Clone this repository.

2. In the `code/lambda_layer` directory, create a virtual environment, activate it, and install the dependencies with `pip install -r requirements.txt`.

    ```bash
    cd code/lambda_layer
    python3 -m venv venv
    source venv/bin/activate
    pip install -r requirements.txt
    deactivate
    ```

3. Gather the secret from the authentication service.

4. Deploy the Terraform code (updating the `otp_secret` variable value to match the secret from the auth vendor) and visit the URL to retrieve the TOTP code.

    ```bash
    terraform init
    terraform apply -var otp_secret="your_secret_here"
    ```
