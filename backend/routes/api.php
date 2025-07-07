<?php

use App\Enums\AdsType;
use App\Http\Controllers\AdvertisementsController;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\EntertainmentController;
use App\Http\Controllers\HeaderImageController;
use App\Http\Controllers\MagazineController;
use App\Http\Controllers\MetaDataController;
use App\Models\Advertisements;
use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

// log in & sign up
Route::post("/login", [AuthController::class, 'login']);
Route::post("/register", [AuthController::class, 'register']);
Route::get("/logout/{id}", [AuthController::class, 'logout']);
Route::get("/unauthorized", fn() => response("Unauthorized", 403))->name('unauthorized');


// auth sanctum 
Route::middleware('auth:sanctum')->group(function () {
    Route::prefix('/users')->group(function () {
        Route::put('/{id}', [AuthController::class, 'update']);
        Route::get('/{id}', [AuthController::class, 'show']);
        Route::get('/', [AuthController::class, 'getUsers']);
    });

    // magazine control
    Route::controller(MagazineController::class)->group(function () {
        // magazines 
        Route::post('/magazines', 'createMagazine');
        Route::post('/magazines/{id}', 'updateMagazine');
        Route::delete('/magazines/{id}', 'deleteMagazine');

        // topics 
        Route::post('/topics', 'createTopic');
        Route::post('/topics/{id}', 'updateTopic');
        Route::delete('/topics/{id}', 'deleteTopic');
        Route::post('/topics/{id}/add-content-photo', 'addContentPhoto');
        Route::post('/topics/{id}/remove-content-photo', 'removeContentPhoto');
    });

    // entertainment control
    Route::controller(EntertainmentController::class)->group(function () {
        // entertainments 
        Route::post('/entertainments', 'createEntertainment');
        Route::post('/entertainments/{id}', 'updateEntertainment');
        Route::delete('/entertainments/{id}', 'deleteEntertainment');

        // series 
        Route::post('/series', 'createSeries');
        Route::post('/series/{id}', 'updateSeries');
        Route::delete('/series/{id}', 'deleteSeries');

        // episodes 
        Route::post('/episodes', 'createEpisode');
        Route::post('/episodes/{id}', 'updateEpisode');
        Route::delete('/episodes/{id}', 'deleteEpisode');
    });

    // header images control
    Route::controller(HeaderImageController::class)->group(function () {
        Route::post('/header-images', 'addHeaderImage');
        Route::delete('/header-images/{id}', 'deleteHeaderImage');
    });

    // advertisement control
    Route::controller(AdvertisementsController::class)->group(function () {
        Route::post('/advertisements', 'addAdvertisement');
        Route::post('/advertisements/{id}', 'updateAdvertisement');
        Route::delete('/advertisements/{id}', 'deleteAdvertisement');
    });

    // meta 
    Route::controller(MetaDataController::class)->group(function () {
        Route::post('/meta-data/{name}', 'setMeta');
        Route::delete('/meta-data/{name}', 'removeMeta');
    });
});


Route::controller(MagazineController::class)->group(function () {
    Route::get('/public/magazines', 'getPublicMagazines');
    Route::get('/magazines', 'getMagazines');
    Route::get('/magazines/{id}', 'getMagazine');
});

Route::controller(EntertainmentController::class)->group(function () {
    Route::get('/public/entertainments', 'getPublicEntertainments');
    Route::get('/entertainments', 'getEntertainments');
    Route::get('/entertainments/{id}', 'getEntertainment');
});

Route::controller(HeaderImageController::class)->group(function () {
    Route::get('/header-images', 'getHeaderImages');
});

Route::controller(AdvertisementsController::class)->group(function () {
    Route::get('/advertisements', 'getAdvertisements');
});

Route::controller(MetaDataController::class)->group(function () {
    Route::get('/meta-data', 'getAllMeta');
    Route::get('/meta-data/{name}', 'getMeta');
});

// artisan command runner 
// block this in production mode
Route::get('/artisan/{name_of_command}', function (Request $request, $command) {
    $params = $request->all();
    Artisan::call($command, $params);
    $output = Artisan::output();
    return response($output);
});
