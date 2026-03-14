FROM python:3.12-slim

RUN apt-get update && apt-get install -y --no-install-recommends git

WORKDIR /orchestrator

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["bash"]
