FROM htk:latest

WORKDIR /app

COPY . .

CMD ["/app/train.sh", "chess", "train.txt", "/app/model/dict.txt"]
ENTRYPOINT bash