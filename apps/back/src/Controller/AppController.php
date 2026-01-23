<?php

declare(strict_types=1);

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\Routing\Attribute\Route;

class AppController extends AbstractController
{
    #[Route('/founders', name: 'founders.index', methods: ['GET'])]
    public function index(): JsonResponse
    {
        return $this->json([
            'status' => 'success',
            'data' => [
                ['name' => 'Bizeul Hugo'],
                ['name' => 'Champy Nicolas'],
                ['name' => 'Piton Léandre'],
                ['name' => 'Quéméré Gaël'],
            ],
        ]);
    }
}
