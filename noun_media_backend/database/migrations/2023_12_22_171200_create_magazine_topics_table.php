<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{

    public function up(): void
    {
        Schema::create('magazine_topics', function (Blueprint $table) {

            $table->id();
            $table->string('title');
            $table->text('description');
            $table->string('cover_photo');
            $table->json('content_photos');
            $table->bigInteger("magazine_id")->unsigned();
            $table->integer("order")->default(0);

            $table->foreign("magazine_id")->references("id")->on("magazines");
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('magazine_topics');
    }
};