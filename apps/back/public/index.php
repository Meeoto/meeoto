<?php

use App\Kernel;

require_once dirname(__DIR__).'/vendor/autoload_runtime.php';

return function (array $context): Kernel {
    /** @var string $env */
    $env = $context['APP_ENV'] ?? 'dev';
    /** @var bool $env */
    $debug = (bool) ($context['APP_DEBUG'] ?? false);

    return new Kernel($env, $debug);
};
