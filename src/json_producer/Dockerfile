# Use an official Python runtime as a parent image
FROM python:3.12-slim

# Create a non-root user
RUN useradd -m appuser

# Set the working directory in the container
WORKDIR /home/appuser

# Copy only main.py and requirements.txt into the container
COPY main.py requirements.txt ./

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Switch to non-root user
USER appuser

# Run main.py when the container launches
CMD ["python", "./main.py"]