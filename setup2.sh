#!/bin/bash

# setup_node_exporter.sh
# Ce script configure Node Exporter sur la VM2 pour qu'elle soit supervisée via Prometheus.

# -------------------------
# 🐳 Vérification de Docker
# -------------------------
if ! command -v docker &> /dev/null
then
    echo "❌ Docker n'est pas installé. Veuillez l'installer avant de lancer ce script."
    exit 1
fi

# -------------------------
# 🚀 Lancement de Node Exporter
# -------------------------
echo "🚀 Lancement de Node Exporter avec Docker..."
docker run -d \
  --name=node-exporter \
  -p 9100:9100 \
  --restart=always \
  prom/node-exporter

# -------------------------
# ✅ Fin
# -------------------------
echo "✅ Node Exporter est lancé et écoute sur le port 9100."
echo "🌐 Vérifie via : http://$(hostname -I | awk '{print $1}'):9100/metrics"
