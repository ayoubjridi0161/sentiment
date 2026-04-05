# Use official Flutter image as base
FROM cirrusci/flutter:latest

# Set working directory
WORKDIR /app

# Copy the project files
COPY . .

# Install dependencies
RUN flutter pub get

# Generate code (build_runner, freezed, etc.)
RUN flutter pub run build_runner build --delete-conflicting-outputs

# Build APK for Android
RUN flutter build apk --flavor=prod --dart-define=flavor=prod --release

# Create a simple web server to serve the built app info
FROM nginx:alpine

# Copy build artifacts  
COPY --from=0 /app/build/app/outputs/flutter-apk/app-prod-release.apk /usr/share/nginx/html/

# Copy nginx config
COPY <<EOF /etc/nginx/conf.d/default.conf
server {
    listen 80;
    location / {
        root /usr/share/nginx/html;
        autoindex on;
    }
}
EOF

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
