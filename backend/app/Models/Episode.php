<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Storage;

class Episode extends Model
{
    use HasFactory;

    protected $table = "episodes";
    protected $primaryKey = "id";
    
    protected $fillable = [
        "title","description","video_url","series_id","video_thumbnail","order"
    ]; 

    public function toResponseJson(){   
       $this->video_thumbnail = Storage::url($this->video_thumbnail);
       return $this;
    }
}