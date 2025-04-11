# Usar una imagen base con Python
FROM python:3.11-slim

# Instalar dependencias del sistema, incluido Tesseract
RUN apt-get update && apt-get install -y \
    tesseract-ocr \
    libtesseract-dev \
    build-essential \
    libpoppler-cpp-dev \
    tesseract-ocr-eng \
    wget \
    libgl1 \
    && apt-get clean

# Crear y configurar el directorio de trabajo
WORKDIR /app

# Verificar y crear directorio tessdata si no existe
RUN mkdir -p /usr/share/tesseract-ocr/tessdata

# Descargar archivo de idioma español directamente
RUN wget -O /usr/share/tesseract-ocr/tessdata/spa.traineddata https://github.com/tesseract-ocr/tessdata/blob/main/spa.traineddata

# Copiar los archivos del proyecto al contenedor
COPY . /app

# Instalar las dependencias de Python
RUN pip install --no-cache-dir -r requirements.txt

# Configurar la variable de entorno para Flask
ENV FLASK_APP=LetterLens.py
ENV FLASK_RUN_HOST=0.0.0.0
ENV PYTHONUNBUFFERED=1
# Asegurar que los datos de idioma de Tesseract estén correctamente instalados
ENV TESSDATA_PREFIX=/usr/share/tesseract-ocr/tessdata/

# Asegurarse que los directorios temporales existan
RUN mkdir -p /app/static/temp_letters
RUN chmod -R 777 /app/static/temp_letters

# Verificar que el archivo de idioma está en su lugar
RUN ls -la /usr/share/tesseract-ocr/tessdata/

# Exponer el puerto para Flask
EXPOSE 5000

# Comando para iniciar la aplicación
CMD ["python", "LetterLens.py"]