cd terraform
terraform init
terraform apply -auto-approve

# Install Python dependencies
cd ../app
pip install -r requirements.txt

# Run the Python app locally (or build the Docker image for ECS)
python main.py