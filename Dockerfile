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

WORKDIR /app

COPY package*.json ./

COPY . .

RUN npm run build --prod

FROM nginx:1.21-alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/dist/my-angular-app /usr/share/nginx/html
# Expose the application port
EXPOSE 4200
CMD ["nginx", "-g", "daemon off;"]
