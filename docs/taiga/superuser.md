# Creating a superuser

```bash
TAIGA_BACK=$(docker container ps | grep infra_taiga-back | awk '{print $1}')
docker exec -it ${TAIGA_BACK} python manage.py createsuperuser
```
