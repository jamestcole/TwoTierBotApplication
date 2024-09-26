# Use the official Python image from the Docker Hub
FROM python:3.9-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set working directory
WORKDIR /app

# Copy requirements.txt and install dependencies
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code
COPY . /app/

# Expose the port that the app runs on
EXPOSE 5000

# Set environment variables for the application
ENV DB_HOST=your_db_host
ENV DB_USER=your_db_user
ENV DB_PASSWORD=your_db_password
ENV DB_NAME=your_db_name

# Command to run the application
CMD ["python", "app.py"]
