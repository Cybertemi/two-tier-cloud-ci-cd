FROM python:3.11-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libpq-dev \
    python3-dev \
    libjpeg-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir --default-timeout=100 -r requirements.txt

# Copy project
COPY . .

# Expose Django port
EXPOSE 8000

# Use Django dev server 
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
