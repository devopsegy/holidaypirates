FROM python:3.7-slim
COPY requirements.txt src/* /app/
WORKDIR /app
RUN pip install -r requirements.txt
EXPOSE 80
CMD python3 hello.py
