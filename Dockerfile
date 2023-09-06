FROM python:3.9-alpine3.13
LABEL maintainer="Sarantos Tzortzis"

ENV PYTHONBUFFERED 1

# copy the requirements from [path] to [path]
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./requirements.txt /tmp/requirements.txt
# copy the app from [path] to [path]   
COPY ./app /app
# setting the default working directory
WORKDIR /app
# from container to machine exposed port 
EXPOSE 8000

# Runs a command which is braked down "\"
    # ln_1: creates a new virtual enviroment
    # ln_2: install pip
    # ln_3: install requirements file 
    # ln_4: remove /tmp because we dont need them and we should keep only necessary file
    # ln_5: Add a new user inside our image because best practise = DONT USE ROOT USER cause he can do anything (no restrictions)
ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

# Updates enviroment variables - so every time we run any virtual command, it's running through our virtual enviroment
ENV PATH="/py/bin:$PATH"

# This line SHOULD BE THE LAST! It specifes our user
USER django-user