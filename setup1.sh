#!/bin/bash

# setup_supervision.sh
# Ce script configure Prometheus et Grafana sur une machine Ubuntu (VM1) avec Docker.

# -------------------------
# 🔧 Configuration utilisateur (à modifier si besoin)
# -------------------------
VM2_IP="192.168.56.102"   # 👉 Remplace par l'adresse IP réelle de ta VM2

# -------------------------
# 📁 Préparation de l’environnement
# -------------------------
echo "📁 Création du dossier de supervision..."
mkdir -p ~/supervision && cd ~/supervision

echo "📝 Création du fichier prometheus.yml..."
cat <<EOF > prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'node_exporter'
    static_configs:
      - targets: ['$VM2_IP:9100']
EOF

echo "📝 Création du fichier docker-compose.yml..."
cat <<EOF > docker-compose.yml
version: '3'

services:
  prometheus:
    image: prom/prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
    restart: always

  grafana:
    image: grafana/grafana
    ports:
      - "3000:3000"
    volumes:
      - grafana-storage:/var/lib/grafana
    restart: always

volumes:
  grafana-storage:
EOF

# -------------------------
# 🚀 Lancement des services
# -------------------------
echo "🚀 Lancement de Prometheus et Grafana avec Docker Compose..."
docker compose up -d

echo "✅ Installation terminée."
echo "🌐 Accès Prometheus : http://$(hostname -I | awk '{print $1}'):9090"
echo "🌐 Accès Grafana    : http://$(hostname -I | awk '{print $1}'):3000"
