<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        // "title","description","video_url","series_id"
        Schema::create('episodes', function (Blueprint $table) {
            $table->id();
            $table->string("title");
            $table->text("description");
            $table->string("video_url");
            $table->bigInteger("series_id")->unsigned();
            $table->string('video_thumbnail');
            $table->integer("order")->default(0);

            $table->foreign("series_id")->references("id")->on("series")->onUpdate("cascade")->onDelete("cascade");
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('episodes');
    }
};