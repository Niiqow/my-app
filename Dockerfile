# Use the official Nginx image as the base image
FROM nginx:latest

# Install necessary dependencies
RUN apt-get update && apt-get install -y curl gnupg2
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get update && apt-get install -y nodejs

# Install npm 8.19.2
RUN npm install -g npm@8.19.2

# Install Angular CLI 15.2.0
RUN npm install -g @angular/cli@latest

# Set the working directory
WORKDIR /app

# Copy the application code
COPY . .

# Build the Angular app for production




# Copy the nginx configuration file
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

# Expose the application port
EXPOSE 4200

# Start the Nginx server
CMD ["nginx", "-g", "daemon off;"]
