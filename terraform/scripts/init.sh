#!/bin/bash
set -e

# Update system
apt-get update -y
apt-get install -y docker.io docker-compose nginx certbot python3-certbot-nginx

# Start Docker
systemctl enable docker
systemctl start docker

# Write environment file
cat > /etc/nutrisnap.env << EOF
OPENAI_API_KEY=${openai_api_key}
NUTRISNAP_SECRET=${nutrisnap_secret}
ALLOWED_ORIGIN=https://${domain}
EOF
chmod 600 /etc/nutrisnap.env

# Write systemd service for backend
cat > /etc/systemd/system/nutrisnap-backend.service << EOF
[Unit]
Description=NutriSnap Backend
After=docker.service
Requires=docker.service

[Service]
Restart=always
EnvironmentFile=/etc/nutrisnap.env
ExecStart=/usr/bin/docker run --rm \
  --env-file /etc/nutrisnap.env \
  -p 8766:8766 \
  --name nutrisnap-backend \
  nutrisnap-backend:latest
ExecStop=/usr/bin/docker stop nutrisnap-backend

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable nutrisnap-backend

echo "Init complete. Deploy backend image and start service."
