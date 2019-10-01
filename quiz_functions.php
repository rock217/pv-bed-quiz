<?php
declare(strict_types=1);

require_once 'vendor/autoload.php';

function call_create_user(): object
{
    PlumVoice\Api::setup('production');

    $parameters = [
        'email' => 'test@example.com',
        'password' => 'password',
        'confirm_password' => 'password',
        'first_name' => 'test',
        'last_name' => 'user',
        'street_number' => 123,
        'street_name' => 'fake street',
        'city' => 'boston',
        'state' => 'ma',
    ];

    return PlumVoice\Api::getInstance()->createUser($parameters);
}

function call_get_user(): object
{
    PlumVoice\Api::setup('development');
    return PlumVoice\Api::getInstance()->getUser(23234);
}

function call_delete_user(): object
{
    PlumVoice\Api::setup('production');
    return PlumVoice\Api::getInstance()->deleteUser(23234);
}

function call_update_user(): object
{
    PlumVoice\Api::setup('production');

    // "...write a function that calls the production update user API
    // method that updates the user’s address information and password..."
    // The author assumes this requirement corresponds to email address,
    // not physical, as it is the closest parameter string match.
    $parameters = [
        'email' => 'test2@example.com',
        'password' => 'password2',
        'confirm_password' => 'password2',
    ];

    return PlumVoice\Api::getInstance()->updateUser(23234, $parameters);
}
