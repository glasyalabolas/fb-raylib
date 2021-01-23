/'*******************************************************************************************
*
*   raylib [models] example - Drawing billboards
*
*   This example has been created using raylib 1.3 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Copyright (c) 2015 Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [models] example - drawing billboards" )

dim as Camera camera

with camera
  .position = Vector3( 5.0f, 4.0f, 5.0f )
  .target = Vector3( 0.0f, 2.0f, 0.0f )
  .up = Vector3( 0.0f, 1.0f, 0.0f )
  .fovy = 45.0f
  .type = CAMERA_PERSPECTIVE
end with

dim as Texture2D bill = LoadTexture( "resources/billboard.png" )
var billPosition = Vector3( 0.0f, 2.0f, 0.0f )

SetCameraMode( camera, CAMERA_ORBITAL )

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  UpdateCamera( @camera )
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    BeginMode3D( camera )
      DrawGrid( 10, 1.0f )
      DrawBillboard( camera, bill, billPosition, 2.0f, WHITE )
    EndMode3D()

    DrawFPS( 10, 10 )
  EndDrawing()
loop

'' De-Initialization
UnloadTexture( bill )

CloseWindow()
