<?php

namespace App\Enums;

use JsonSerializable;

enum AdsType: string implements JsonSerializable
{
    case Magazine = 'magazine';
    case Entertainment = 'entertainment';
    case PopUp = 'popup';

    public function jsonSerialize(): mixed
    {
        return $this->value;
    }

    public static function all() :array
    {
        return array_map(fn($e)=> $e->value,self::cases());
    }
}