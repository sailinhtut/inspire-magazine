<?php

namespace App\Utils;

function basicResponse($code, $message, $error = null)
{
    $response = [
        "code" => $code,
        "message" => $message,

    ];

    if ($error != null) $response["error"] = $error;
    return response()->json($response,$code);
}