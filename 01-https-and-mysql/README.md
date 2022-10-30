### Setup Script

The step by step instructions below can be run just by executing the included script.

```
./_run_once_setup.sh
```

### Step by step
1. Generate a few random keys
   FuelPHP asks for some randomized seeds to do some of it's internal hashing and encryption.  Set these by providing values for AUTH_SALT, AUTH_SIMPLEAUTH_SALT, and CIPHER_KEY defined in the docker-compose file.

   Generate your 3 random id using the output from:
	```bash
	docker-compose run --rm --no-deps app php -r "echo('AUTH_SIMPLEAUTH_SALT=' . sodium_bin2hex(random_bytes(SODIUM_CRYPTO_STREAM_KEYBYTES)) . \"\n\");" >> .env
	docker-compose run --rm --no-deps app php -r "echo('AUTH_SALT=' . sodium_bin2hex(random_bytes(SODIUM_CRYPTO_STREAM_KEYBYTES)) . \"\n\");" >> .env
	docker-compose run --rm --no-deps app php -r "echo('CIPHER_KEY=' . sodium_bin2hex(random_bytes(SODIUM_CRYPTO_STREAM_KEYBYTES)) . \"\n\");" >> .env
	```

2. Migrate Database and Initialize.
   Set up the database so that it has the required tables and data.  Materia uses database migration files handled by our PHP framework for this.  This command will also initialize a few settings and users to get you started. Watch the output so you can log in with a randomized password!
   ```bash
   docker-compose run --rm app composer oil-install-quiet
   ```

3. Run Materia
   Now we can rely on docker compose to download a few containers and start Materia.
   ```
   docker-compose up
   ```

4. Install Widgets
   There are no widgets installed in Materia yet, so we'll want to do that now. To get started, it probably makes sense to install the default widgets.
   ```bash
   docker-compose exec app bash -c 'php oil r widget:install_from_config'
   ```

5. Run everything, visit https://localhost
   ```bash
   docker-compose up
   ```