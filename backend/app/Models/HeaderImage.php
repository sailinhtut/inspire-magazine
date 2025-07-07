<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Storage;

class HeaderImage extends Model
{
    use HasFactory;

    protected $table = "header_images";
    protected $primaryKey = "id";
    protected $fillable = [
        "id", "name", "image_url", "redirect","order"
    ];


    public function removeImage()
    {
        Storage::delete($this->image_url);
        return $this->delete();
    }
    
    public function toResponseJson(){
        $this->image_url = Storage::url($this->image_url);
        return $this;
    }
}