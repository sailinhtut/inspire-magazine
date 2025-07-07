<?php

namespace App\Http\Controllers;

use App\Enums\AdsType;
use App\Models\Advertisements;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;
use Throwable;

use function App\Utils\basicResponse;

class AdvertisementsController extends Controller
{
    public function getAdvertisements()
    {
        return Advertisements::all()->map(fn ($e) => $e->toResponseJson());
    }

    // create entertainment 
    public function addAdvertisement(Request $request)
    {
        $validation = Validator::make(
            $request->all(),
            [
                'image' => "required|image|mimes:jpeg,png,jpg,gif",
                'redirect' => "required|string",
                'ads_type' => "required|string|in:" . collect(AdsType::all())->implode(","),
            ],
            [
                "in" => 'The advertisement type must be one of the following types: :values'
            ]
        );

        if ($validation->fails()) {
            return response()->json([
                "code" => 400,
                "message" => "Cannot create advertisement",
                "error" => $validation->errors(),
            ], 400);
        }


        try {
            $advertisement = Advertisements::create([
                "name" => $request->name,
                "description" => $request->description,
                "image_url" => "",
                "redirect" => $request->redirect,
                "ads_type" => $request->ads_type,
            ]);

            $image = $request->file("image");
            $path = $image->storePubliclyAs("advertisements", "{$advertisement->id}.{$image->extension()}");

            if ($path) {
                $advertisement->update([
                    "image_url" => $path,
                ]);

                return response()->json($advertisement->toResponseJson());
            }
            basicResponse(200, "Something went wrong");
        } catch (Throwable $error) {
            return response()->json(
                [
                    "code" => 400,
                    "message" => "Cannot create advertisement",
                    "error" => $error->getMessage(),
                ],
                400
            );
        }
    }

    public function updateAdvertisement(Request $request, $id)
    {
        try {
            $advertisement = Advertisements::findOrFail($id);
            $update_array = [];

            if ($request->has("name")) {
                $update_array["name"] = $request->name;
            }
            if ($request->has("description")) {
                $update_array["description"] = $request->description;
            }
            if ($request->has("redirect")) {
                $update_array["redirect"] = $request->redirect;
            }
            if ($request->has("ads_type")) {
                $is_valid_type = collect(AdsType::all())->contains($request->ads_type);
                if (!$is_valid_type) return basicResponse(400, "The advertisement type must be one of the following types:" . collect(AdsType::all())->implode(","));
                $update_array["ads_type"] = $request->ads_type;
            }

            if ($request->hasFile("image")) {
                $validation = Validator::make($request->all(), ['image' => "required|image|mimes:jpeg,png,jpg,gif"]);
                if ($validation->fails()) return basicResponse(400, $validation->errors());
                $image = $request->file("image");
                Storage::delete($advertisement->image_url);
                $path = $image->storePubliclyAs("advertisements", "{$advertisement->id}.{$image->extension()}");

                if ($path) {
                    $update_array["image_url"] = $path;
                }
            }

            $advertisement->update($update_array);
            return response()->json($advertisement->toResponseJson());
        } catch (Throwable $error) {
            return response()->json(
                [
                    "code" => 400,
                    "message" => "Cannot create advertisement",
                    "error" => $error->getMessage(),
                ],
                400
            );
        }
    }



    // delete episode
    public function deleteAdvertisement($id)
    {
        try {
            $advertisement = Advertisements::findOrFail($id);
            Storage::delete($advertisement->image_url);
            $advertisement->delete();

            return response()->json(
                [
                    "code" => 200,
                    "message" => "Deleted advertisement",
                ]
            );
        } catch (Throwable $error) {
            return response()->json(
                [
                    "code" => 400,
                    "message" => "Cannot delete advertisement",
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
