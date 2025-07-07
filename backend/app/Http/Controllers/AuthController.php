<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
use Throwable;

class AuthController extends Controller
{

    public function getUsers()
    {
        return User::all();
    }

    public function register(Request $request)
    {
        $validation = Validator::make($request->all(), [
            "name" => "required|string",
            "email" => "required|email",
            "password" => "required|min:6",
        ]);

        if ($validation->fails()) {
            return response()->json([
                "message" => "Cannot create account",
                "erorr" => $validation->errors(),
            ]);
        }

        try {
            $user = User::create([
                "name" => $request->name,
                "email" => $request->email,
                "password" => $request->password
            ]);
            $token =  $user->createToken($user->name);
            $user->token = $token->plainTextToken;
            return response()->json($user, 201);
        } catch (Throwable $error) {
            return response()->json(
                [
                    "code" => 400,
                    "message" => "Cannot create account",
                    "error" => $error->getMessage(),
                ]
            );
        }
    }

    public function logIn(Request $request)
    {
        $validation = Validator::make($request->all(), [
            "email" => "required|email",
            "password" => "required|min:6",
        ]);

        if ($validation->fails()) {
            return response()->json([
                "message" => "Cannot create account",
                "erorr" => $validation->errors(),
            ]);
        }

        if (Auth::attempt($request->only('email', 'password'))) {
            $user = Auth::user();
            $token =  $user->createToken($user->name);
            $user->token = $token->plainTextToken;
            return response()->json($user);
        }

        return response("Cannot log in");
    }

    public function logout(Request $request, $id)
    {
        $user = User::find($id);
        $user->tokens()->delete();
        return response()->json(["message" => "Successfully Log Out"]);


        return response("Cannot log out");
    }

    public function update(Request $request, $id)
    {

        try {
            User::where('id', $id)->first()->update($request->all());
            return response("Updated User Information");
        } catch (Throwable $error) {
            return response()->json([
                "status" => false,
                "message" => "Unexpected Error Occured",
                "error" => $error->getMessage(),
            ], 400);
        }
    }

    public function show(Request $request, $id)
    {
        try {
            $user =  User::findOrFail($id);
            return response()->json($user);
        } catch (Throwable $error) {
            return response()->json([
                "status" => false,
                "message" => "Unexpected Error Occured",
                "error" => $error->getMessage(),
            ],);
        }
    }
}