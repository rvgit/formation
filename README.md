**🎓 Exercice OpenShift complet : Build, Push et Démarrage d'une Application Python sans Exposer le Service**

🔥 **Contexte de l'exercice**
Dans cet exercice, nous allons pratiquer toutes les étapes essentielles nécessaires pour travailler avec **OpenShift et son registre Quay.io**. L'objectif est de construire, pousser, et déployer une application **Python** sans utiliser de privilèges root.


🎯 **Objectifs**
1. **Créer une application Python** à partir d'un Dockerfile (sans privilèges root) 
2. **Créer un dépôt sur le registre Quay.io** (ou via le registre OpenShift si possible)
3. **Créer un compte Robot sur Quay.io** et **pousser l'image**
4. **Déployer l'application sur OpenShift**
5. **Vérifier l'état du déploiement**

🛠️ **Prérequis**
- Accès à **OpenShift Sandbox** ou une instance OpenShift locale.
- Accès à **Quay.io** (ou le registre intégré OpenShift Registry si vous y avez accès).
- **Podman** ou **Docker** installé localement.
- **CLI OpenShift (oc)** configurée pour pointer vers votre cluster OpenShift.

🔥 **Étape 1 : Création de l'Application Python**

Créez la structure suivante sur votre poste de travail :

```
📁 demo-app
 ├── 📄 app.py
 ├── 📄 requirements.txt
 └── 📄 Dockerfile
```


📄 **Contenu de `app.py`**

Ce fichier **app.py** sera une simple application **Flask** qui écoute sur le port **8080** mais qui **n'affiche rien à l'extérieur**.

```python
from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
    return "Hello from OpenShift, without expose!"

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080)
```

📄 **Contenu de `requirements.txt`**

Ce fichier déclare les dépendances nécessaires pour l'application. Ici, nous avons besoin de **Flask**.

```
Flask==2.1.1
```

📄 **Contenu de `Dockerfile`**

Ce Dockerfile suit les **principes OCI** et **n'exécute pas en tant que root**. Il utilise **un utilisateur non-root** et la base d'image **python:3.9-slim**.

```dockerfile
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
```

🔥 **Étape 2 : Construire et Pousser l'Image vers le Registre**


🔥 **Étape 3 : Déploiement de l'application sur OpenShift**

🔥 **Étape 4 : Vérification du déploiement**

🔥 **Étape 5 : Test de l'Application**
