# Plum Voice Backend Web Application Developer Quiz

## The goods
The answers to the **API Integration tests** section are located in [quiz_functions.php](./quiz_functions.php).

The answers to the **Database** section are located in [quiz_queries.sql](./quiz_queries.sql).

## Testing

Prerequisites:
* php-7.3 CLI
* The dom and json extensions for php-7.3.
* A recent version of composer.

To test the API layer, run `make test` from the root project directory 
to install composer dependencies & execute the test suite.

## Security

Normally the contents of the [env](./env) directory would not be checked in, 
but for the sake of exercise correctness they are included.
