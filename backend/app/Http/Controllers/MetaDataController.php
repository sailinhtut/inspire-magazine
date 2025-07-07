<?php

namespace App\Http\Controllers;

use App\Models\MetaData;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

use function App\Utils\basicResponse;

class MetaDataController extends Controller
{

    public function getAllMeta()
    {
        return MetaData::all();
    }

    public  function getMeta($name)
    {
        $meta = MetaData::where("name", $name)->first();
        return response()->json($meta);
    }

    public function setMeta(Request $request, $name)
    {
        $validation = Validator::make($request->all(), [
            "content" => "required",
        ]);

        if ($validation->fails()) return basicResponse(400, $validation->errors());

        $meta = new MetaData();
        $meta->name = $name;
        $meta->content = $request->content;
        $meta->save();
        return response()->json($meta);
    }

    public function removeMeta($name)
    {
        $meta = MetaData::where("name", $name)->first();
        $meta->delete();
        return basicResponse(200, "{$meta->name} is deleted successfully");
    }
}
