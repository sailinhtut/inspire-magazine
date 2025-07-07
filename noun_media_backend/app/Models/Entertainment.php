<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Storage;

class Entertainment extends Model
{
    use HasFactory;

    protected $table = "entertainments";
    protected $primaryKey = "id";

    protected $fillable = [
        "name", "description", "cover_photo", "order"
    ];

    public function getRelatedSeries()
    {
        $related = Series::where('entertainment_id', $this->id)->orderBy("order", "desc")->orderBy("created_at", "desc")->get();
        return $related->map(fn ($series) => $series->toResponseJson());
    }

    public function removeSeries()
    {
        $related_series = Series::where('entertainment_id', $this->id)->get();
        foreach ($related_series as $series) {
            $series->removeEpisodes();
            Storage::deleteDirectory("series/{$series->id}");
        }
    }

    public function toResponseJson()
    {
        $this->cover_photo = Storage::url($this->cover_photo);
        $this->series = $this->getRelatedSeries();
        return $this;
    }
    
    public function toPublicResponseJson()
    {
        $this->cover_photo = Storage::url($this->cover_photo);
        return $this;
    }
}