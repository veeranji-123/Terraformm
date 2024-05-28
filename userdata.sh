#!/bin/bash
sudo yum install git -y
sudo git clone https://github.com/sumanthgangireddyGS/car-prediction.git
cd /
cd car-prediction/
sudo yum install python3 python3-pip -y
pip3 install -r requirements.txt
screen -m -d python3 app.py
