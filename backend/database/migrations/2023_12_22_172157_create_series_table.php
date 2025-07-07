<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{

    public function up(): void
    {
        Schema::create('series', function (Blueprint $table) {
            $table->id();
            $table->string("name");
            $table->text("description");
            $table->bigInteger("entertainment_id")->unsigned();
            $table->string("cover_photo")->nullable();
            $table->integer("order")->default(0);

            $table->foreign("entertainment_id")->references("id")->on("entertainments");
            $table->timestamps();
        });
    }


    public function down(): void
    {
        Schema::dropIfExists('series');
    }
};