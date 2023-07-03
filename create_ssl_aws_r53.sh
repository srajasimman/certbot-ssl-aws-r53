#!/bin/bash

DOMAIN=$1
LETSENCRYPT_DIR=".letsencrypt"

if [[ -z "${DOMAIN}" ]]; then
  echo "Enter a Domain Name to Generate SSL" && exit
fi

if [ -f ".venv/bin/activate" ]; then
  source ".venv/bin/activate"
else
  if command -v python3 &> /dev/null; then
    python3 -m venv .venv && source ".venv/bin/activate" && pip install certbot certbot-dns-route53
  elif command -v python &> /dev/null; then
    python -m venv .venv && source ".venv/bin/activate" && pip install certbot certbot-dns-route53
  fi
fi

if [ ! -d "${LETSENCRYPT_DIR}" ]; then
  mkdir -pv "${LETSENCRYPT_DIR}"
fi

certbot certonly \
  --domain "${DOMAIN}" \
  --dns-route53 \
  --noninteractive \
  --agree-tos \
  --key-type rsa \
  --rsa-key-size 2048 \
  --email rajasimmman.s@optit.in \
  --config-dir "${LETSENCRYPT_DIR}/config" \
  --work-dir "${LETSENCRYPT_DIR}" \
  --logs-dir "${LETSENCRYPT_DIR}/logs" \
  -v

rsync -avhP ".letsencrypt/config/archive/${DOMAIN}" ./
zip -r "${DOMAIN}.zip" "${DOMAIN}" && rm -rf "${DOMAIN}"
