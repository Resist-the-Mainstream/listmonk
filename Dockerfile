FROM alpine:latest

# Install dependencies
RUN apk --no-cache add ca-certificates tzdata shadow su-exec

# Set the working directory
WORKDIR /listmonk

# Copy only the necessary files
COPY listmonk .

# Expose the application port
EXPOSE 9000

# Define the command to run the application
CMD ["sh", "-c", "./listmonk --config='' --install --yes --idempotent && ./listmonk --config='' --upgrade --yes && ./listmonk --config=''"]
