<?php

namespace App\Http\Requests;

use App\Enums\AdsType;
use Illuminate\Foundation\Http\FormRequest;

class AdvertisemetRequest extends FormRequest
{

    public function rules(): array
    {
        return [
            'image' => "required|image|mimes:jpeg,png,jpg,gif",
            'redirect' => "required|string",
            'ads_type' => "required|string|in:" . collect(AdsType::all())->implode(","),
        ];
    }

    public function messages(): array
    {
        return [];
    }
}
