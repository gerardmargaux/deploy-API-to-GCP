# For more information, please refer to https://aka.ms/vscode-docker-python
FROM python:3.8-slim-buster

# Copy the source files into the container
WORKDIR /python-docker
COPY . /python-docker

# Install pip requirements
RUN pip3 install virtualenv
RUN python3 -m venv web-app 
RUN . web-app/bin/activate
RUN pip3 install -r requirements.txt

# Define the command to be run when the container is started
CMD ["env", "FLASK_APP=app/main.py", "python3", "-m", "flask", "run", "--host=0.0.0.0"]