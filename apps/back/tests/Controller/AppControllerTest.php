<?php

declare(strict_types=1);

namespace App\Tests\Controller;

use Symfony\Bundle\FrameworkBundle\Test\WebTestCase;
use Symfony\Component\HttpKernel\Client;

class AppControllerTest extends WebTestCase
{
    public function testFoundersRouteReturnsListOfNames(): void
    {
        /** @var Client $client */
        $client = static::createClient();
        $client->request('GET', '/api/founders');

        $this->assertResponseIsSuccessful();
        $this->assertResponseHeaderSame('Content-Type', 'application/json');

        $responseContent = json_decode($client->getResponse()->getContent(), true);

        $this->assertIsArray($responseContent);
        $this->assertArrayHasKey('status', $responseContent);
        $this->assertEquals('success', $responseContent['status']);

        $this->assertArrayHasKey('data', $responseContent);
        $this->assertIsArray($responseContent['data']);
        $this->assertGreaterThan(0, count($responseContent['data']));

        foreach ($responseContent['data'] as $founder) {
            $this->assertIsArray($founder);
            $this->assertArrayHasKey('name', $founder);
            $this->assertIsString($founder['name']);
            $this->assertNotEmpty($founder['name']);
        }
    }
}