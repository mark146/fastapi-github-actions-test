FROM python:3-slim as python


RUN apt-get update && \
    apt-get install -y gcc

COPY . /app
COPY pyproject.toml /app
COPY poetry.lock /app


# set work directory
WORKDIR /app

# set environment variables
ENV POETRY_VIRTUALENVS_CREATE=false
ENV POETRY_HOME="/opt/poetry"
ENV PATH="$POETRY_HOME/bin:$PATH"


RUN python -c 'from urllib.request import urlopen; print(urlopen("https://install.python-poetry.org").read().decode())' | python - && \
    poetry install --no-root

EXPOSE 8000

CMD ["poetry", "run", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000","--reload"]
