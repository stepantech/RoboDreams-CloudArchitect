# Stage 1: Build the React application
FROM node:20 AS build

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the React application
RUN npm run build

# Stage 2: Serve the React application with nginx
FROM nginx:alpine

# Copy the build output to the nginx html directory
COPY --from=build /app/build /usr/share/nginx/html

# Copy the configuration template and script
COPY public/config.template.js /usr/share/nginx/html/config.template.js
COPY start.sh /start.sh

# Make the script executable
RUN chmod +x /start.sh

# Expose port 80
EXPOSE 80

# Start NGINX
CMD ["/start.sh"]