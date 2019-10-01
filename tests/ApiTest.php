<?php
declare(strict_types=1);

namespace PlumVoice\Tests;

use GuzzleHttp\Client;
use GuzzleHttp\Handler\MockHandler;
use GuzzleHttp\HandlerStack;
use GuzzleHttp\Psr7\Response;
use PHPUnit\Framework\TestCase;
use PlumVoice\Api;

class ApiTest extends TestCase
{
    private static function setupGuzzleMock(int $status, string $body)
    {
        $mock = new MockHandler([
            new Response($status, ['Content-Type' => 'application/json'], $body)
        ]);

        $handler = HandlerStack::create($mock);
        $client = new Client(['handler' => $handler]);
        Api::setup('test', $client);
    }

    public function testUpdateUser_Valid()
    {
        self::setupGuzzleMock(204, '');
        $response = Api::getInstance()->updateUser(23234, []);
        self::assertTrue($response->result);
    }

    public function testUpdateUser_Invalid()
    {
        $statusErrorMap = [
            400 => "invalid parameters supplied, do not submit with the same parameters",
            401 => "permission denied, invalid http basic credentials",
            404 => "user not found",
            500 => "internal server error",
        ];

        foreach ($statusErrorMap as $status => $error) {
            self::setupGuzzleMock($status, '{"error" : "'. $error .'"}');
            $response = Api::getInstance()->updateUser(23234, []);
            self::assertEquals($error, $response->error);
        }
    }

    public function testDeleteUser_Valid()
    {
        self::setupGuzzleMock(204, '');
        $response = Api::getInstance()->deleteUser(23234);
        self::assertTrue($response->result);
    }

    public function testDeleteUser_Invalid()
    {
        $statusErrorMap = [
            401 => "permission denied, invalid http basic credentials",
            404 => "user not found",
            500 => "internal server error",
        ];

        foreach ($statusErrorMap as $status => $error) {
            self::setupGuzzleMock($status, '{"error" : "'. $error .'"}');
            $response = Api::getInstance()->deleteUser(23234);
            self::assertEquals($error, $response->error);
        }
    }

    public function testGetUser_Valid()
    {
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

        self::setupGuzzleMock(200, json_encode($parameters));
        $response = Api::getInstance()->getUser(23234);
        self::assertEquals((object)$parameters, $response);
    }

    public function testGetUser_Invalid()
    {
        $statusErrorMap = [
            401 => "permission denied, invalid http basic credentials",
            404 => "user not found",
            500 => "internal server error",
        ];

        foreach ($statusErrorMap as $status => $error) {
            self::setupGuzzleMock($status, '{"error" : "'. $error .'"}');
            $response = Api::getInstance()->getUser(23234);
            self::assertEquals($error, $response->error);
        }
    }

    public function testCreateUser_Valid()
    {
        self::setupGuzzleMock(201, '{"user_id":23234}');
        $response = Api::getInstance()->createUser([]);
        self::assertEquals(23234, $response->user_id);
    }

    public function testCreateUser_Invalid()
    {
        $statusErrorMap = [
            400 => "invalid parameters supplied, do not submit with the same parameters",
            401 => "permission denied, invalid http basic credentials",
            409 => "user already exists",
            500 => "internal server error",
        ];

        foreach ($statusErrorMap as $status => $error) {
            self::setupGuzzleMock($status, '{"error" : "'. $error .'"}');
            $response = Api::getInstance()->createUser([]);
            self::assertEquals($error, $response->error);
        }
    }
}
