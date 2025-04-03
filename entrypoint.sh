python manage.py collectstatic --noinput
python manage.py migrate
# python manage.py runserver
gunicorn -b  0.0.0.0:8000 settings.wsgi:application
