FROM python:3.9  


# Create non-root user (note : this user should also exists in the host machine : you must create it in your droplet)
# RUN useradd --create-home --shell /bin/bash kuroro

# Set working directory and app folder
ENV APP_FOLDER=/home/app/webapp
RUN mkdir -p $APP_FOLDER  
WORKDIR $APP_FOLDER  

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1  

# Update pip version
RUN pip install --upgrade pip 
COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install -r requirements.txt && \
    pip install openpyxl gunicorn

# Copy application code
COPY . .

#  Copy the entrypoint
COPY entrypoint.sh .

# make entrypoint.sh executable
RUN chmod +x entrypoint.sh

COPY wait-for-it.sh /wait-for-it.sh
RUN chmod +x /wait-for-it.sh

# Expose port
EXPOSE 8000  

# change ownership of the app to the non-root user
# RUN chown -R kuroro:kuroro $APP_FOLDER
# USER kuroro

# set entrypoint
ENTRYPOINT ["./entrypoint.sh"]