FROM htk:latest

WORKDIR /app

COPY . .

CMD ["/app/train.sh"]