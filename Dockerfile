FROM python:3.12.1-slim-bookworm

WORKDIR /code

COPY ./requirements.txt /code/requirements.txt

RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt

COPY ./ /code/app

COPY ./version.txt /code/version.txt

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]