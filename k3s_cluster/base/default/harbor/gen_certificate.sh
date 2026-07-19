set -ex
# Token-signing keypair — core signs, registry verifies
openssl genrsa -out private_key.pem 4096
openssl req -new -x509 -key private_key.pem -out root.crt -days 3650 -subj "/CN=harbor-token-issuer"
# openssl genrsa -out ca.key 2048
# openssl req -x509 -new -nodes -key ca.key -sha256 -days 365 -out ca.crt -subj "/CN=harbor-https-issuer"

# Core's own encryption key (for stored credentials, robot secrets, etc.)
openssl rand -base64 16 | tr -d '\n' > secretkey

## verify

ls private_key.pem root.crt secretkey # ca.crt ca.key
openssl rsa -in private_key.pem -check -noout      # confirms it's a valid key
openssl x509 -in root.crt -noout -subject -dates   # confirms cert content/expiry
# openssl x509 -in ca.crt -noout -subject -dates