# Use the official Ubuntu LTS (20.04) base image
FROM ubuntu:22.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Set a non-root user for the container
ARG USER=developer
ARG UID=1000
ARG GID=1000
ARG PW=developer

# Update the package repository and install dependencies
RUN apt-get update && \
    apt-get install -y \
    curl \
    git \
    gnupg \
    sudo \
    # Install Node.js (consider using the node version that matches your project requirements)
    nodejs \
    npm \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create a user for the container
RUN groupadd -g $GID -o $USER && \
    useradd -m -u $UID -g $GID -o -s /bin/bash $USER && \
    echo "$USER:$PW" | chpasswd && \
    adduser $USER sudo && \
    echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER $USER
WORKDIR /home/$USER

# Copy the existing Qwik project into the container
COPY . /home/$USER/app

# Expose the default Qwik port
EXPOSE 5173

# Set the environment to development
ENV NODE_ENV development

# Navigate to the app directory and install NPM packages
WORKDIR /home/$USER/app
RUN npm install

# CMD to start the Qwik app using 'npm run dev' when the container runs
CMD ["npm", "run", "dev"]

# Reset the frontend non-interactive frontend
ENV DEBIAN_FRONTEND=dialog

