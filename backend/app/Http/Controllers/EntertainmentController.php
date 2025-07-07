<?php

namespace App\Http\Controllers;

use App\Models\Entertainment;
use App\Models\Episode;
use App\Models\Series;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;
use Throwable;

use function App\Utils\basicResponse;

class EntertainmentController extends Controller
{


    // get entertainments (without series json list) 
    public function getPublicEntertainments(Request $request)
    {
        // search by words 
        $searchKeyWord = $request->query("search");
        if ($searchKeyWord) {
            $isID = intval($searchKeyWord) != 0;
            $results = $isID ? Entertainment::find(intval($searchKeyWord)) :  Entertainment::where("name", "LIKE", "%{$searchKeyWord}%")->orWhere('description', "LIKE", "%{$searchKeyWord}%")->orderBy("order", "desc")->get();
            return response()->json($isID ? [$results->toPublicResponseJson()] : $results->map(fn ($entertainment) => $entertainment->toPublicResponseJson()));
        }

        // paginate 
        $paginationPage = $request->query("page");
        if ($paginationPage) {
            $entertainments = Entertainment::orderBy("order", "desc")->paginate(10);
            $response = $entertainments->map(fn ($magazine) => $magazine->toPublicResponseJson())->toArray();
            $entertainments->data = $response;
            return response()->json($entertainments);
        }

        $response = Entertainment::orderBy("order", "desc")->get()->map(fn ($entertainment) => $entertainment->toPublicResponseJson());
        return response()->json($response);
    }

    // get entertainmets 
    public function getEntertainments(Request $request)
    {
        // search by words 
        $searchKeyWord = $request->query("search");
        if ($searchKeyWord) {
            $isID = intval($searchKeyWord) != 0;
            $results = $isID ? Entertainment::find(intval($searchKeyWord)) :  Entertainment::where("name", "LIKE", "%{$searchKeyWord}%")->orWhere('description', "LIKE", "%{$searchKeyWord}%")->orderBy("order", "desc")->get();
            return response()->json($isID ? [$results->toResponseJson()] : $results->map(fn ($entertainment) => $entertainment->toResponseJson()));
        }

        // paginate 
        $paginationPage = $request->query("page");
        if ($paginationPage) {
            $entertainments = Entertainment::orderBy("order", "desc")->paginate(10);
            $response = $entertainments->map(fn ($magazine) => $magazine->toResponseJson())->toArray();
            $entertainments->data = $response;
            return response()->json($entertainments);
        }

        $response = Entertainment::orderBy("order", "desc")->get()->map(fn ($entertainment) => $entertainment->toResponseJson());
        return response()->json($response);
    }

    // get single entertainment
    public function getEntertainment($id)
    {
        try {
            $entertainment = Entertainment::findOrFail($id);
            return response()->json($entertainment->toResponseJson());
        } catch (Throwable $error) {
            return response()->json(
                [
                    "code" => 400,
                    "message" => "Cannot find entertainment",
                    "error" => $error->getMessage(),
                ],
                400
            );
        }
    }

    // create entertainment 
    public function createEntertainment(Request $request)
    {
        $validation = Validator::make($request->all(), [
            'name' => "required|string",
            'cover_photo' => "required|image|mimes:jpeg,png,jpg,gif|max:2048",
        ]);

        if ($validation->fails()) {
            return response()->json([
                "code" => 400,
                "message" => "Cannot create entertainment",
                "error" => $validation->errors(),
            ], 400);
        }


        try {
            $entertainment = Entertainment::create([
                "name" => $request->name,
                "description" => $request->description  ?? " ",
                "cover_photo" => "",
            ]);

            $cover_photo_file = $request->file("cover_photo");
            $cover_photo_path = $cover_photo_file->storePubliclyAs("entertainments/{$entertainment->id}", "cover_photo.{$cover_photo_file->extension()}");

            $entertainment->update([
                "cover_photo" => $cover_photo_path,
            ]);
            $entertainment->refresh();

            return response()->json($entertainment->toResponseJson());
        } catch (Throwable $error) {
            return response()->json(
                [
                    "code" => 400,
                    "message" => "Cannot create entertainment",
                    "error" => $error->getMessage(),
                ],
                400
            );
        }
    }

    // update entertainment
    public function updateEntertainment(Request $request, $id)
    {

        $updated_cover_photo = $request->hasFile("cover_photo") ? $request->file("cover_photo") : null;

        try {
            $entertainment = Entertainment::findOrFail($id);
            $update_array = [];


            if ($request->has("name")) {
                $update_array["name"] = $request->name;
            }

            if ($request->has("description")) {
                $update_array["description"] = $request->description  ?? " ";;
            }

            if ($request->has("order")) {
                $update_array["order"] = $request->integer("order");
            }


            if ($updated_cover_photo) {
                Storage::delete($entertainment->cover_photo);
                $cover_photo_path = $updated_cover_photo->storePubliclyAs("entertainments/{$entertainment->id}", "cover_photo.{$updated_cover_photo->extension()}");
                $update_array["cover_photo"] = $cover_photo_path;
            }


            $entertainment->update($update_array);

            return response()->json($entertainment->toResponseJson());
        } catch (Throwable $error) {
            return response()->json(
                [
                    "code" => 400,
                    "message" => "Cannot update entertainment",
                    "error" => $error->getMessage(),
                ],
                400
            );
        }
    }

    // delete entertainment
    public function deleteEntertainment($id)
    {
        try {

            $entertainment = Entertainment::findOrFail($id);
            $entertainment->removeSeries();
            $result = $entertainment->delete();
            Storage::deleteDirectory("entertainments/{$id}");

            if ($result) {
                return basicResponse(200, "Entertainment (#$id) is deleted successfully.");
            }

            return basicResponse(400, "Something went wrong");
        } catch (Throwable $error) {
            return response()->json(
                [
                    "code" => 400,
                    "message" => "Cannot create entertainment",
                    "error" => $error->getMessage(),
                ],
                400
            );
        }
    }

    // create series
    public function createSeries(Request $request)
    {
        $validation = Validator::make($request->all(), [
            "name" => "required|string",
            "entertainment_id" => "required|exists:entertainments,id",
            "cover_photo" => "required|image|mimes:png,jpg,jpeg,gif",
        ]);

        if ($validation->fails()) {
            return basicResponse(400, $validation->errors());
        }

        try {
            $series = new Series;
            $series->name = $request->name;
            $series->entertainment_id = $request->entertainment_id;
            $series->description = $request->description  ?? " ";
            $series->save();

            $cover_photo = $request->file("cover_photo");
            $path = $cover_photo->storePubliclyAs("series/{$series->id}", "cover_photo." . $cover_photo->getClientOriginalExtension());
            $series->cover_photo = $path;
            $series->save();
            $series->refresh();

            return response()->json($series->toResponseJson());
        } catch (Throwable $error) {
            return response()->json(
                [
                    "code" => 400,
                    "message" => "Cannot create series",
                    "error" => $error->getMessage(),
                ]
            );
        }
    }

    // update series 
    public function updateSeries(Request $request, $id)
    {

        try {

            $series = Series::findOrFail($id);
            $update_array = [];

            if ($request->has("name")) {
                $update_array["name"] = $request->name;
            }

            if ($request->has("description")) {
                $update_array["description"] = $request->description  ?? " ";
            }

            if ($request->has("entertainment_id")) {
                $update_array["entertainment_id"] = $request->id;
            }

            if ($request->has("order")) {
                $update_array["order"] = $request->integer("order");
            }

            if ($request->hasFile("cover_photo")) {
                $cover_photo = $request->file("cover_photo");
                Storage::delete($series->cover_photo);
                $path = $cover_photo->storePubliclyAs("series/{$series->id}", "cover_photo." . $cover_photo->getClientOriginalExtension());
                $update_array["cover_photo"] = $path;
            }

            $series->update($update_array);
            return response()->json($series->toResponseJson());
        } catch (Throwable $error) {
            return response()->json(
                [
                    "code" => 400,
                    "message" => "Cannot update series",
                    "error" => $error->getMessage(),
                ],
                400
            );
        }
    }

    // delete series
    public function deleteSeries($id)
    {
        try {

            $series = Series::findOrFail($id);
            $series->removeEpisodes();
            $result = $series->delete();
            Storage::deleteDirectory("series/{$id}");

            if ($result) {
                return basicResponse(200, "Series (#$id) is deleted successfully.");
            }

            return basicResponse(400, "Something went wrong");
        } catch (Throwable $error) {
            return response()->json(
                [
                    "code" => 400,
                    "message" => "Cannot delete series",
                    "error" => $error->getMessage(),
                ],
                400
            );
        }
    }

    public function createEpisode(Request $request)
    {

        $validation = Validator::make($request->all(), [
            "title" => "required|string",
            "video_url" => "required|string",
            "series_id" => "required|exists:series,id",
            "video_thumbnail" => "required|image|mimes:png,jpeg,jgp,gif|max:2048"
        ]);

        if ($validation->fails()) {
            return basicResponse(400, $validation->errors());
        }

        try {
            $episode = new Episode;
            $episode->title = $request->title;
            $episode->video_url = $request->title;
            $episode->description = $request->description ?? " ";
            $episode->video_url = $request->video_url;
            $episode->series_id = $request->series_id;
            $episode->video_thumbnail = "";
            $episode->save();


            $video_thumbnail = $request->file("video_thumbnail");
            $path = $video_thumbnail->storePubliclyAs("episodes/{$episode->id}", "video_thumbnail." . $video_thumbnail->getClientOriginalExtension());
            $episode->video_thumbnail = $path;
            $episode->save();

            $episode->refresh();

            return response()->json($episode->toResponseJson(), 200);
        } catch (Throwable $error) {
            return basicResponse(400, "Cannot create episode", $error->getMessage());
        }
    }

    public function updateEpisode(Request $request, $id)
    {
        try {

            $episode = Episode::findOrFail($id);
            $update_array = [];

            if ($request->has("title")) {
                $update_array["title"] = $request->title;
            }

            if ($request->has("description")) {
                $update_array["description"] = $request->description ?? " ";;
            }

            if ($request->has("order")) {
                $update_array["order"] = $request->integer("order");
            }

            if ($request->has("series_id")) {
                $update_array["series_id"] = $request->id;
            }

            if ($request->has("video_url")) {
                $update_array["video_url"] = $request->video_url;
            }

            if ($request->hasFile("video_thumbnail")) {
                $video_thumbnail = $request->file("video_thumbnail");
                Storage::delete($episode->video_thumbnail);
                $path = $video_thumbnail->storePubliclyAs("episodes/{$episode->id}", "video_thumbnail." . $video_thumbnail->getClientOriginalExtension());
                $update_array["video_thumbnail"] = $path;
            }

            $episode->update($update_array);
            return response()->json($episode->toResponseJson());
        } catch (Throwable $error) {
            return response()->json(
                [
                    "code" => 400,
                    "message" => "Cannot update episode",
                    "error" => $error->getMessage(),
                ],
                400
            );
        }
    }


    // delete episode
    public function deleteEpisode($id)
    {
        try {

            $result = Episode::destroy($id);
            Storage::deleteDirectory("episodes/{$id}");

            return response()->json(
                [
                    "code" => 200,
                    "message" => "Deleted episoded",
                ]
            );
        } catch (Throwable $error) {
            return response()->json(
                [
                    "code" => 400,
                    "message" => "Cannot delete series",
                    "error" => $error->getMessage(),
                ],
                400
            );
        }
    }


    public function basicResponse($code, $message, $error = null)
    {
        $response = [
            "code" => $code,
            "message" => $message,
        ];

        if ($error) {
            $response["error"] = $error;
        }
        return response()->json(
            $response,
            400
        );
    }
}