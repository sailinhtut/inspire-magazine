<?php

namespace App\Http\Controllers;

use App\Models\Magazine;
use App\Models\MagazineTopic;
use Aws\Multipart\UploadState;
use Illuminate\Container\RewindableGenerator;
use Illuminate\Database\Eloquent\JsonEncodingException;
use Illuminate\Http\Request;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;
use Throwable;

use function App\Utils\basicResponse;

class MagazineController extends Controller
{

    // get public magazines (without topics json list)
    public function getPublicMagazines(Request $request)
    {
        // search by words 
        $searchKeyWord = $request->query("search");
        if ($searchKeyWord) {
            $isID = intval($searchKeyWord) != 0;
            $results = $isID ? Magazine::find(intval($searchKeyWord)) :  Magazine::where("name", "LIKE", "%{$searchKeyWord}%")->orWhere('description', "LIKE", "%{$searchKeyWord}%")->orderBy("order", "desc")->orderBy("created_at", "desc")->get();
            if (!$isID) {
                $results->sortByDesc("order");
            }
            return response()->json($isID ? [$results->toPublicResponseJson()] : $results->map(fn ($magazine) => $magazine->toPublicResponseJson()));
        }

        // paginate 
        $paginationPage = $request->query("page");
        if ($paginationPage) {
            $magazines = Magazine::orderBy("created_at", "desc")->orderBy("order", "desc")->paginate(12);
            $response = $magazines->map(fn ($magazine) => $magazine->toPublicResponseJson())->toArray();
            $magazines->data = $response;
            return response()->json($magazines);
        }

        $response = Magazine::orderBy("created_at", "desc")->orderBy("order", "desc")->get()->map(fn ($magazine) => $magazine->toPublicResponseJson());
        $response->sortByDesc("order");
        return response()->json($response);
    }

    // get magazines 
    public function getMagazines(Request $request)
    {
        // search by words 
        $searchKeyWord = $request->query("search");
        if ($searchKeyWord) {
            $isID = intval($searchKeyWord) != 0;
            $results = $isID ? Magazine::find(intval($searchKeyWord)) :  Magazine::where("name", "LIKE", "%{$searchKeyWord}%")->orWhere('description', "LIKE", "%{$searchKeyWord}%")->orderBy("order", "desc")->orderBy("created_at", "desc")->get();
            if (!$isID) {
                $results->sortByDesc("order");
            }
            return response()->json($isID ? [$results->toResponseJson()] : $results->map(fn ($magazine) => $magazine->toResponseJson()));
        }

        // paginate 
        $paginationPage = $request->query("page");
        if ($paginationPage) {
            $magazines = Magazine::orderBy("created_at", "desc")->orderBy("order", "desc")->paginate(12);
            $response = $magazines->map(fn ($magazine) => $magazine->toResponseJson())->toArray();
            $magazines->data = $response;
            return response()->json($magazines);
        }

        $response = Magazine::orderBy("created_at", "desc")->orderBy("order", "desc")->get()->map(fn ($magazine) => $magazine->toResponseJson());
        $response->sortByDesc("order");
        return response()->json($response);
    }

    // get single magazine
    public function getMagazine($id)
    {
        try {
            $magazine = Magazine::findOrFail($id);
            return response()->json($magazine->toResponseJson());
        } catch (Throwable $error) {
            return response()->json(
                [
                    "code" => 400,
                    "message" => "Cannot create magazine",
                    "error" => $error->getMessage(),
                ],
                400
            );
        }
    }

    // create magazine
    public function createMagazine(Request $request)
    {
        $validation = Validator::make($request->all(), [
            'name' => "required|string",
            'cover_photo' => "required|image|mimes:jpeg,png,jpg,gif",
        ]);

        if ($validation->fails()) {
            return response()->json([
                "code" => 400,
                "message" => "Cannot create magazine",
                "error" => $validation->errors(),
            ], 400);
        }

        try {
            $magazine = Magazine::create([
                "name" => $request->name,
                "description" => $request->description ?? " ",
                "cover_photo" => "",
            ]);

            $cover_photo_file = $request->file("cover_photo");
            $cover_photo_path = $cover_photo_file->storePubliclyAs("magazines/{$magazine->id}", "cover_photo.{$cover_photo_file->extension()}");

            $magazine->update([
                "cover_photo" => $cover_photo_path,
            ]);

            $magazine->refresh();

            return response()->json($magazine->toResponseJson());
        } catch (Throwable $error) {
            return response()->json(
                [
                    "code" => 400,
                    "message" => "Cannot create magazine",
                    "error" => $error->getMessage(),
                ],
                400
            );
        }
    }

    // update magazine
    public function updateMagazine(Request $request, $id)
    {

        $updated_cover_photo = $request->hasFile("cover_photo") ? $request->file("cover_photo") : null;

        try {
            $magazine = Magazine::findOrFail($id);
            $update_array = [];


            if ($request->has("name")) {
                $update_array["name"] = $request->name;
            }

            if ($request->has("description")) {
                $update_array["description"] = $request->description ?? "";
            }

            if ($request->has("order")) {
                $update_array["order"] = $request->integer("order");
            }


            if ($updated_cover_photo) {
                Storage::delete($magazine->cover_photo);
                $cover_photo_path = $updated_cover_photo->storePubliclyAs("magazines/{$magazine->id}", "cover_photo.{$updated_cover_photo->extension()}");
                $update_array["cover_photo"] = $cover_photo_path;
            }
            $magazine->update($update_array);

            return response()->json($magazine->toResponseJson());
        } catch (Throwable $error) {
            return response()->json(
                [
                    "code" => 400,
                    "message" => "Cannot update magazine",
                    "error" => $error->getMessage(),
                ],
                400
            );
        }
    }

    // delete magazine
    public function deleteMagazine($id)
    {
        try {
            $magazine = Magazine::findOrFail($id);
            $magazine->removeTopics();
            $result = $magazine->delete();
            Storage::deleteDirectory("magazines/{$id}");

            if ($result) {
                return basicResponse(200, "Magazine (#$id) is deleted successfully.");
            }

            return basicResponse(400, "Something went wrong");
        } catch (Throwable $error) {
            return response()->json(
                [
                    "code" => 400,
                    "message" => "Cannot create magazine",
                    "error" => $error->getMessage(),
                ],
                400
            );
        }
    }

    // create topic
    public function createTopic(Request $request)
    {
        $validation = Validator::make($request->all(), [
            'title' => "required|string",
            'magazine_id' => "required|exists:magazines,id",
            'cover_photo' => "required|image|mimes:jpeg,png,jpg,gif|max:2048",
            // 'content_photos' => "required|array",
            // 'content_photos.*' => "required|image|mimes:jpeg,png,jpg,gif|max:2048"
        ]);

        if ($validation->fails()) {
            return response()->json([
                "code" => 400,
                "message" => "Cannot create topics",
                "error" => $validation->errors(),
            ], 400);
        }

        try {
            $topic = MagazineTopic::create([
                'title' => $request->title,
                'description' => $request->description ?? " ",
                'magazine_id' => $request->magazine_id,
                'cover_photo' => '',
                'content_photos' => json_encode([]),
            ]);

            $cover_photo_file = $request->file('cover_photo');
            $content_photos = $request->file('content_photos') ?? [];
            $cover_photo_path = $cover_photo_file->storePubliclyAs("topics/{$topic->id}", "cover_photo.{$cover_photo_file->extension()}");

            $saved_paths = collect([]);
            foreach ($content_photos as $index => $photo) {
                $saved_paths[] =  $photo->storePubliclyAs("topics/{$topic->id}/contents", ($index + 1) . "." . $photo->extension());
            }

            $topic->update([
                'cover_photo' => $cover_photo_path,
                'content_photos' => $saved_paths,
            ]);

            $topic->refresh();

            return response()->json($topic->toResponseJson());
        } catch (Throwable $error) {
            return response()->json(
                [
                    "code" => 400,
                    "message" => "Cannot create magazine",
                    "error" => $error->getMessage(),
                ]
            );
        }
    }

    // update topic 
    public function updateTopic(Request $request, $id)
    {
        $allow_mimes = ["jpeg", "png", "jpg", "gif"];

        $updated_cover_photo = $request->hasFile("cover_photo") ? $request->file("cover_photo") : null;
        $updated_content_photos = $request->hasFile("content_photos") ? $request->file("content_photos") : null;

        try {

            $topic = MagazineTopic::findOrFail($id);
            $update_array = [];

            // validate images are acceptable mimes types
            if ($updated_cover_photo) {

                $uploaded_extension = $updated_cover_photo->getClientOriginalExtension();
                if (!in_array($uploaded_extension, $allow_mimes)) {
                    return  $this->basicResponse(400, "Wrong file type is provided", "Cover photo should be one of these file types jpeg, png, jpg, gif.");
                }
            }

            if ($request->has("order")) {
                $update_array["order"] = $request->integer("order");
            }

            // validate images are acceptable mimes types
            if ($updated_content_photos) {

                foreach ($updated_content_photos as $file) {
                    $file_extension = $file->getClientOriginalExtension();
                    $uploaded_name = $file->getClientOriginalName();

                    if (!in_array($file_extension, $allow_mimes)) {
                        return $this->basicResponse(400, "Wrong file type is provided for {$uploaded_name} in content photos.", "Photo should be one of these file types jpeg, png, jpg, gif.");
                    }
                }
            }



            if ($request->has("title")) {
                $update_array["title"] = $request->title;
            }

            if ($request->has("description")) {
                $update_array["description"] = $request->description ?? " ";
            }

            if ($updated_cover_photo) {
                Storage::delete($topic->cover_photo);
                $cover_photo_path = $updated_cover_photo->storePubliclyAs("topics/{$topic->id}", "cover_photo.{$updated_cover_photo->extension()}");
                $update_array["cover_photo"] = $cover_photo_path;
            }


            if ($updated_content_photos) {
                $saved_paths = collect([]);
                Storage::deleteDirectory("topics/{$topic->id}/contents");
                foreach ($updated_content_photos as $index => $photo) {
                    $saved_paths[] =  $photo->storePubliclyAs("topics/{$topic->id}/contents", ($index + 1) . "." . $photo->extension());
                }
                $update_array["content_photos"] = $saved_paths;
            }

            $topic->update($update_array);
            return response()->json($topic->toResponseJson());
        } catch (Throwable $error) {
            return response()->json(
                [
                    "code" => 400,
                    "message" => "Cannot update magazine",
                    "error" => $error->getMessage(),
                ],
                400
            );
        }
    }

    public function addContentPhoto(Request $request, $topicId)
    {
        $validation = Validator::make($request->all(), [
            'content_photos' => "required|array",
            'content_photos.*' => "required|image|mimes:jpeg,png,jpg,gif|max:2048"
        ]);

        if ($validation->fails()) {
            return response()->json([
                "code" => 400,
                "message" => "Cannot add content photos",
                "error" => $validation->errors(),
            ], 400);
        }

        try {
            $topic = MagazineTopic::find($topicId);

            if ($topic) {

                $content_photos = collect(json_decode($topic->content_photos));
                $last_index = $content_photos->count();
                $uploaded_photos = $request->content_photos;



                foreach ($uploaded_photos as $key => $file) {
                    $last_index = $last_index + 1;
                    $path = $file->storePubliclyAs("topics/{$topic->id}/contents", "{$last_index}." . $file->getClientOriginalExtension());
                    if ($path) {
                        $content_photos->add($path);
                    }
                }

                $topic->content_photos = $content_photos->toJson();
                $topic->save();


                return response()->json($topic->toResponseJson());
            }
            return basicResponse(400, "Cannot find magazine");
        } catch (Throwable $error) {
            return response()->json(
                [
                    "code" => 400,
                    "message" => "Cannot add topic",
                    "error" => $error->getMessage(),
                ],
                400
            );
        }
    }

    public function removeContentPhoto(Request $request, $topicId)
    {
        $validation = Validator::make($request->all(), [
            'content_photo_ids' => "required|array",
            'content_photo_ids.*' => "required|numeric"
        ]);

        if ($validation->fails()) {
            return response()->json([
                "code" => 400,
                "message" => "Cannot remove content photos",
                "error" => $validation->errors(),
            ], 400);
        }

        try {
            $topic = MagazineTopic::find($topicId);
            if ($topic) {
                $topic->removeContentPhotos($request->content_photo_ids);
                return response()->json($topic->toResponseJson());
            }
            return basicResponse(400, "Cannot find magazine");
        } catch (Throwable $error) {
            return response()->json(
                [
                    "code" => 400,
                    "message" => "Cannot remove content photos",
                    "error" => $error->getMessage(),
                ],
                400
            );
        }
    }

    // delete topic
    public function deleteTopic($id)
    {
        try {
            $result = MagazineTopic::destroy($id);
            Storage::deleteDirectory("topics/{$id}");
            return response()->json(
                [
                    "code" => 200,
                    "message" => "Deleted Topic",
                ]
            );
        } catch (Throwable $error) {
            return response()->json(
                [
                    "code" => 400,
                    "message" => "Cannot delete topic",
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