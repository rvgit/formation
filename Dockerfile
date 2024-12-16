# Étape 1 : Utilisation d'une image Python légère
FROM python:3.9-slim

# Création du groupe et de l'utilisateur non-root
RUN groupadd -r appgroup && \
    useradd -r -g appgroup -d /app -s /sbin/nologin appuser

# Définir le répertoire de travail de l'utilisateur
WORKDIR /app

# Copier les fichiers nécessaires au projet
COPY requirements.txt .

# Installation des dépendances
RUN pip install --no-cache-dir -r requirements.txt

# Copier l'application Python dans le conteneur
COPY app.py .

# Changer le propriétaire des fichiers vers l'utilisateur "appuser"
RUN chown -R appuser:appgroup /app

# Changement de l'utilisateur pour éviter l'exécution en tant que root
USER appuser

# Définir le port exposé (interne uniquement)
EXPOSE 8080

# Commande par défaut pour démarrer l'application
CMD ["python", "app.py"]
