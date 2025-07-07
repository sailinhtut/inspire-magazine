<?php

namespace App\Http\Controllers;

use App\Models\HeaderImage;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Throwable;

use function App\Utils\basicResponse;

class HeaderImageController extends Controller
{
    public function getHeaderImages()
    {
        return HeaderImage::all()->map(fn ($element) => $element->toResponseJson());
    }

    public function addHeaderImage(Request $request)
    {
        $validation = Validator::make($request->all(), [
            'image' => "required|image|mimes:png,jpg,jpeg,gif",
            'redirect' => "required|string",
        ]);

        if ($validation->fails()) {
            return response()->json([
                "code" => 400,
                "message" => "Cannot add header image",
                "error" => $validation->errors(),
            ], 400);
        }

        try {

            $image = $request->file("image");
            $path = $image->storePublicly("header_images");

            if ($path) {
                $header_image = new HeaderImage;
                $header_image->name = $request->input("name", "");
                $header_image->image_url = $path;
                $header_image->redirect = $request->redirect;
                $header_image->order = $request->integer("order", 0);
                $header_image->save();

                return response()->json($header_image->toResponseJson());
            }
            return basicResponse(400, "Something went wrong");
        } catch (Throwable $error) {
            return basicResponse(400, "Cannot add header image", $error->getMessage());
        }
    }

    public function deleteHeaderImage($id)
    {
        try {
            $header_image = HeaderImage::findOrFail($id);
            $header_image->removeImage();
            $name = $header_image->name ?? 'Image';
            return basicResponse(200, "$name is successfully Deleted");
        } catch (Throwable $error) {
            return basicResponse(400, "Cannot add header image", $error->getMessage());
        }
    }
}
