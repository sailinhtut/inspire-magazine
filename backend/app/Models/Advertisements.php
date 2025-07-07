<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Storage;

class Advertisements extends Model
{
    use HasFactory;

    // $table->id();
    // $table->string("name")->nullable();
    // $table->string("description")->nullable();
    // $table->string("image_url");
    // $table->string("redirect");
    // $table->string("ads_type")->default(AdsType::Entertainment->value)->nullable();
    // $table->timestamps(); 

    protected $fillable = [
        "name",
        "description",
        "image_url",
        "redirect",
        "ads_type"
    ];

    public function toResponseJson()
    {
        $this->image_url = Storage::url($this->image_url);
        return $this;
    }
}