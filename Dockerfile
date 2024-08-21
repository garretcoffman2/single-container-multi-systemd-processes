# Use an official Ubuntu base image
FROM ubuntu:20.04

# Set environment variables for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Et

# Install systemd and other necessary packages
RUN apt-get update && \
    apt-get install -y \
    systemd \
    systemd-sysv \
    curl \
    nginx \
    apache2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create necessary directories for systemd
RUN mkdir -p /etc/systemd/system

# Add your custom service files
COPY my-nginx.service /etc/systemd/system/
COPY my-apache.service /etc/systemd/system/

# Add custom HTML pages
COPY index-nginx.html /var/www/html/index.html
COPY index-apache.html /var/www/apache2-default/index.html

# Configure Apache to listen on port 8080
COPY my-apache.conf /etc/apache2/ports.conf

# Enable systemd services
RUN systemctl enable my-nginx.service
RUN systemctl enable my-apache.service

# Expose ports for the services
EXPOSE 80 8080

# Set the default command to start systemd
CMD ["/lib/systemd/systemd"]
