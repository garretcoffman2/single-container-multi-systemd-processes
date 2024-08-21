# Use an appropriate base image
FROM ubuntu:20.04

# Set environment variables for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

# Install necessary packages
RUN apt-get update && apt-get install -y \
    nginx \
    apache2 \
    supervisor \
    && apt-get clean

# Enable MPM module
RUN a2enmod mpm_prefork

# Create directories for supervisor configurations
RUN mkdir -p /etc/supervisor/conf.d

# Copy supervisor configuration file
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Copy Nginx and Apache configuration files
COPY nginx.conf /etc/nginx/nginx.conf
COPY apache2.conf /etc/apache2/apache2.conf

# Create the HTML files for Apache
RUN mkdir -p /var/www/html/ && \
    echo "Apache Working!" > /var/www/html/index.html

# Create the HTML files for Nginx
RUN mkdir -p /usr/share/nginx/html && \
    echo "Nginx Working!" > /usr/share/nginx/html/index.html

# Expose ports
EXPOSE 80 8080

# Start both Nginx and Apache services using supervisor
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]