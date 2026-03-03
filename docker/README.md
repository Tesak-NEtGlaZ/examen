## Запуск через Docker

### Требования
- Docker и Docker Compose

### Команды для запуска
```bash
# Запустить PostgreSQL в Docker
docker-compose up -d

# Подключиться к БД
docker exec -it exam_postgres psql -U postgres -d airline_db

# Остановить контейнер
docker-compose down