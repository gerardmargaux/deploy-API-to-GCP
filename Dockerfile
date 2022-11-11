# For more information, please refer to https://aka.ms/vscode-docker-python
FROM python:3.8-slim-buster

# Copy the source files into the container
WORKDIR /flask-docker
COPY . /flask-docker

# Install pip requirements
RUN python -m pip install -r requirements.txt

EXPOSE 5000
ENV PORT 5000

# Define the command to be run when the container is started
CMD exec gunicorn --bind :$PORT app.main:app --workers 1 --threads 1 --timeout 0