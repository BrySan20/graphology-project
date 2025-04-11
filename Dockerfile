# Usar una imagen base con Python
FROM python:3.11-slim

# Instalar dependencias del sistema, incluido Tesseract
RUN apt-get update && apt-get install -y \
    tesseract-ocr \
    libtesseract-dev \
    build-essential \
    libpoppler-cpp-dev \
    tesseract-ocr-eng \
    libgl1 \
    && apt-get clean

# Crear y configurar el directorio de trabajo
WORKDIR /app

# Copiar los archivos del proyecto al contenedor
COPY . /app

# Instalar las dependencias de Python
RUN pip install --no-cache-dir -r requirements.txt

# Configurar la variable de entorno para Flask
ENV FLASK_APP=LetterLens.py
ENV FLASK_RUN_HOST=0.0.0.0
ENV PYTHONUNBUFFERED=1
# Asegurar que los datos de idioma de Tesseract estén correctamente instalados
ENV TESSDATA_PREFIX=/usr/share/tesseract-ocr/4.00/tessdata/

# Asegurarse que los directorios temporales existan
RUN mkdir -p /app/static/temp_letters

# Exponer el puerto para Flask
EXPOSE 5000

# Comando para iniciar la aplicación
CMD ["python", "LetterLens.py"]