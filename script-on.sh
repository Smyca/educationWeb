#!/bin/bash


#Detectar python -v
PYTHON=$(command -v python3 || command -v python) 
# echo "usando python: $PYTHON"

echo "Instalando requerimientos..."
$PYTHON install-requeriments.py >/dev/null 2>&1




if grep -q 'DEBUG = True' settings/settings.py; then

    sed -i 's/DEBUG = True/DEBUG = False/g' settings/settings.py
    sed -i 's/# "whitenoise.runserver_nostatic",/"whitenoise.runserver_nostatic",/g' settings/settings.py
    sed -i 's/"livereload",/# "livereload",/g' settings/settings.py
    sed -i 's/"livereload.middleware.LiveReloadScript",/# "livereload.middleware.LiveReloadScript",/g' settings/settings.py
    sed -i 's/# "whitenoise.middleware.WhiteNoiseMiddleware",/"whitenoise.middleware.WhiteNoiseMiddleware",/g' settings/settings.py
    echo "ARCHIVOS LISTO PARA PRODUCCION!"
    pkill -f "$PYTHON manage.py"
    echo "procesos de python detenidos!"

else

    sed -i 's/DEBUG = False/DEBUG = True/g' settings/settings.py
    sed -i 's/"whitenoise.runserver_nostatic",/# "whitenoise.runserver_nostatic",/g' settings/settings.py
    sed -i 's/# "livereload",/"livereload",/g' settings/settings.py
    sed -i 's/# "livereload.middleware.LiveReloadScript",/"livereload.middleware.LiveReloadScript",/g' settings/settings.py
    sed -i 's/"whitenoise.middleware.WhiteNoiseMiddleware",/# "whitenoise.middleware.WhiteNoiseMiddleware",/g' settings/settings.py
    

    echo "Archivos preparados para Desarrollo!"
    $PYTHON manage.py runserver & 
    $PYTHON manage.py livereload 



fi


echo "Ejecutando Django collectstatic..."
$PYTHON manage.py collectstatic --noinput