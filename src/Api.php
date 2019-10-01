<?php
declare(strict_types=1);

namespace PlumVoice;

use Dotenv\Dotenv;
use GuzzleHttp\Client;
use GuzzleHttp\RequestOptions;

use Psr\Http\Message\ResponseInterface;

class Api {

    private $client;
    private $url;
    private $options;

    private static $instance;

    public function createUser(array $parameters):object
    {
        return self::decodeResponse(
            $this->client->post(
                $this->buildUrl("user"),
                $this->buildOptions([RequestOptions::JSON => $parameters])
            )
        );
    }

    public function deleteUser(int $user_id): object
    {
        $response = $this->client->delete(
            $this->buildUrl("user/{$user_id}"),
            $this->buildOptions([RequestOptions::JSON => ['user_id' => $user_id]])
        );
        if ($response->getStatusCode() == 204) {
            return (object)['result' => true];
        } else{
            return self::decodeResponse($response);
        }
    }

    public function getUser(int $user_id):object
    {
        return self::decodeResponse(
            $this->client->get(
                $this->buildUrl("user/{$user_id}"),
                $this->buildOptions()
            )
        );
    }

    public function updateUser(int $user_id, array $parameters):object
    {
        $response = $this->client->put(
            $this->buildUrl("user/{$user_id}"),
            $this->buildOptions([RequestOptions::JSON => $parameters])
        );
        if ($response->getStatusCode() == 204) {
            return (object)['result' => true];
        } else{
            return self::decodeResponse($response);
        }
    }

    private static function decodeResponse(ResponseInterface $response): object
    {
        return json_decode($response->getBody()->getContents());
    }

    private function buildOptions(array $extraOptions = []): array
    {
        return array_merge($this->options, $extraOptions);
    }

    private function buildUrl(string $relativeUrl): string
    {
        return "{$this->url}/{$relativeUrl}";
    }

    public static function getInstance():self
    {
        return self::$instance;
    }

    public static function setup(string $environment, Client $client = null): void
    {
        if ($client === null) {
            $client = new Client();
        }
        $dotenv = Dotenv::create(__DIR__, "../env/{$environment}.env");
        $env = $dotenv->load();
        self::$instance = new self($client, $env['URL'], $env['USERNAME'], $env['PASSWORD']);
    }

    private function __construct(Client $client, string $url, string $username, string $password)
    {
        $this->client = $client;
        $this->url = $url;
        $this->options = [
            RequestOptions::HTTP_ERRORS => false,
            RequestOptions::AUTH => [$username, $password]
        ];
    }
}