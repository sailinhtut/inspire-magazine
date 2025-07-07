<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Storage;

class MagazineTopic extends Model
{
    use HasFactory;

    protected $fillable = [
        "title",
        "description",
        "cover_photo",
        "content_photos",
        "magazine_id",
        "order"
    ];

    public function toResponseJson()
    {
        $this->cover_photo = Storage::url($this->cover_photo);
        $this->content_photos = json_decode($this->content_photos);

        $resovled_paths = [];
        foreach ($this->content_photos as $photo) {
            $resovled_paths[] = Storage::url($photo);
        }
        $this->content_photos = $resovled_paths;
        return $this;
    }



    public function removeContentPhotos($id_array)
    {
        $id_array = collect($id_array)->map(fn ($id) => intval($id));

        $content_photos = collect(json_decode($this->content_photos));
        foreach ($id_array as $photo_id) {
            $matched = $content_photos->first(fn ($element) => extractFilename($element) === $photo_id);
            if ($matched) {
                Storage::delete($matched);
                $content_photos =  $content_photos->reject(fn ($element) => $element === $matched);
            }
        }

        $this->content_photos = $content_photos;
        $this->save();
    }
}

function extractFilename($needle)
{
    $splited = explode("/", $needle);
    $filename = end($splited);
    $filename_only = pathinfo($filename, PATHINFO_FILENAME);
    return intval($filename_only) ?? -1;
}
