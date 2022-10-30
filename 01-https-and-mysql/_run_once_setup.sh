# generate a self-signed ssl cert
openssl req -subj '/CN=localhost' -x509 -newkey rsa:4096 -nodes -keyout ./key.pem -out ./cert.pem -days 365

# create some randomized security keys to store in environment vars
docker-compose run --rm --no-deps app php -r "echo('AUTH_SIMPLEAUTH_SALT=' . sodium_bin2hex(random_bytes(SODIUM_CRYPTO_STREAM_KEYBYTES)) . \"\n\");" >> .env
docker-compose run --rm --no-deps app php -r "echo('AUTH_SALT=' . sodium_bin2hex(random_bytes(SODIUM_CRYPTO_STREAM_KEYBYTES)) . \"\n\");" >> .env
docker-compose run --rm --no-deps app php -r "echo('CIPHER_KEY=' . sodium_bin2hex(random_bytes(SODIUM_CRYPTO_STREAM_KEYBYTES)) . \"\n\");" >> .env

# ask materia to run database migrations and set up initial users
# this is just running `composer oil-install-quiet` but using a script that will wait for the mysql container to become ready
docker-compose run --rm app /wait-for-it.sh db:3306 --timeout=120 --strict -- composer oil-install-quiet


# ask materia to install the widgets defined in the config file
docker-compose run --rm app bash -c 'php oil r widget:install_from_config'

echo "run 'docker compose up -d' to start Materia"
