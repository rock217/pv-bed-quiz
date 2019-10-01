test: composer_install
	vendor/bin/phpunit tests --fail-on-warning

composer_install:
	composer install
