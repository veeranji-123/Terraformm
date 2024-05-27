#!/bin/bash
sudo yum update -y
sudo yum install git -y
sudo yum install python3-pip -y
sudo git clone https://github.com/sumanthgangireddyGS/car-prediction.git
cd /
cd car-prediction/
pip3 install -r requirements.txt
python3 app.py
screen -d -m python3 app.py
