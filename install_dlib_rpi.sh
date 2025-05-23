#!/bin/bash

echo "[1/7] Mise à jour du système..."
sudo apt update && sudo apt upgrade -y

echo "[2/7] Installation des dépendances nécessaires..."
sudo apt install -y build-essential cmake gfortran \
    libatlas-base-dev libopenblas-dev liblapack-dev \
    libx11-dev libgtk-3-dev libboost-python-dev \
    python3-dev python3-pip git

echo "[3/7] Augmentation temporaire du swapfile à 2048 Mo..."
sudo dphys-swapfile swapoff
sudo sed -i 's/^CONF_SWAPSIZE=.*/CONF_SWAPSIZE=2048/' /etc/dphys-swapfile
sudo dphys-swapfile setup
sudo dphys-swapfile swapon

echo "[4/7] Clonage de dlib depuis GitHub..."
cd ~
git clone https://github.com/davisking/dlib.git
cd dlib

echo "[5/7] Compilation de dlib (peut prendre beaucoup de temps)..."
mkdir build && cd build
cmake ..
cmake --build .

echo "[6/7] Installation de dlib pour Python 3..."
cd ..
sudo python3 setup.py install

echo "[7/7] Réduction du swapfile à 100 Mo (recommandé après installation)..."
sudo dphys-swapfile swapoff
sudo sed -i 's/^CONF_SWAPSIZE=.*/CONF_SWAPSIZE=100/' /etc/dphys-swapfile
sudo dphys-swapfile setup
sudo dphys-swapfile swapon

echo "✅ Installation terminée. Tu peux vérifier avec : python3 -c 'import dlib; print(dlib.__version__)'"
