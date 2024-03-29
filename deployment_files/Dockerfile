FROM postgis/postgis:latest

# Install the pg_similarity extension
RUN apt-get update && apt-get install -y postgresql-16-similarity && apt-get install -y postgresql-client

# Copy the init script
COPY ./init-scripts/ /docker-entrypoint-initdb.d/

# Set execute permissions for all scripts in the init directory
RUN chmod +x /docker-entrypoint-initdb.d/*
