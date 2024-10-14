FROM python:3.9-slim
WORKDIR /usr/src/app
COPY . .
RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 5000
ENV FLASK_ENV=development
CMD ["python", "rick_and_morty_script.py"]
