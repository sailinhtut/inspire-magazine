<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Storage;

class Series extends Model
{
    use HasFactory;

    protected $table = "series";
    protected $primaryKey = "id";

    protected $fillable = [
        "name", "description", "cover_photo", "entertainment_id", "order"
    ];

    public function getRelatedEpisodes()
    {
        $related = Episode::where('series_id', $this->id)->orderBy("order", "desc")->orderBy("created_at", "desc")->get();
        return $related->map(fn ($episode) => $episode->toResponseJson());
    }

    public function removeEpisodes()
    {
        $related_episodes = Episode::where('series_id', $this->id)->get();
        foreach ($related_episodes as $episode) {
            Storage::deleteDirectory("episodes/{$episode->id}");
        }
    }

    public function toResponseJson()
    {
        $this->cover_photo = Storage::url($this->cover_photo);
        $this->episodes = $this->getRelatedEpisodes();
        return $this;
    }
}
