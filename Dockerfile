FROM python:3.12 AS build
COPY requirements.txt .
RUN pip install --prefix=/install -r requirements.txt
FROM python:3.12-slim
COPY --from=build /install /usr/local
COPY app/ app/
COPY models/ models/

RUN useradd --uid 10001 --no-create-home app

USER 10001

ENV MODEL_VERSION=v1
ENV MODELS_DIR=./models
ENV DATABASE_URL=sqlite:///./predictions.db
ENV FAULT_ERROR_RATE=0
ENV FAULT_LATENCY_MS=0

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]