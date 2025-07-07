<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Storage;

class Magazine extends Model
{
    use HasFactory;

    protected $fillable = [
        "name",
        "description",
        "cover_photo",
        "order"
    ];

    public function getTopics()
    {
        $related = MagazineTopic::where('magazine_id', $this->id)->orderBy("order", "desc")->orderBy("created_at", "desc")->get();
        return $related->map(fn ($topic) => $topic->toResponseJson());
    }


    // delete image data from storage 
    public function removeTopics()
    {
        $related_topics = MagazineTopic::where('magazine_id', $this->id)->get();
        foreach ($related_topics as $topic) {
            Storage::deleteDirectory("topics/{$topic->id}");
        }
    }

    public function toResponseJson()
    {
        $this->cover_photo = Storage::url($this->cover_photo);
      
        $this->topics = $this->getTopics();
        return $this;
    }

    public function toPublicResponseJson()
    {
        $this->cover_photo = Storage::url($this->cover_photo);
        return $this;
    }
}