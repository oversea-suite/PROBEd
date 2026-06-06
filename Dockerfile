FROM python:3.11-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends bash \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/probed

# copy repository into image
COPY . /opt/probed

# ensure executables
RUN chmod +x /opt/probed/probed || true
RUN chmod +x /opt/probed/getinfo.sh || true

# python deps for the small web UI
COPY requirements.txt /opt/probed/requirements.txt
RUN pip install --no-cache-dir -r /opt/probed/requirements.txt

EXPOSE 8080

# Run the Flask app via gunicorn for production-like behavior
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "stats_server:app"]
