/'*******************************************************************************************
*
*   raylib [core] example - Initialize 3d camera mode
*
*   This example has been created using raylib 1.0 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Copyright (c) 2014 Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [core] example - 3d camera mode" )

dim as Camera3D camera

with camera
  .position = Vector3( 0.0f, 10.0f, 10.0f )
  .target = Vector3( 0.0f, 0.0f, 0.0f )
  .up = Vector3( 0.0f, 1.0f, 0.0f )
  .fovy = 45.0f
  .type = CAMERA_PERSPECTIVE
end with

var cubePosition = Vector3( 0.0f, 0.0f, 0.0f )

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  ''----------------------------------------------------------------------------------
  '' TODO: Update your variables here
  ''----------------------------------------------------------------------------------
  
  '' Draw
  BeginDrawing()
    ClearBackground(RAYWHITE)
    
    BeginMode3D( camera )
      DrawCube( cubePosition, 2.0f, 2.0f, 2.0f, RAYRED )
      DrawCubeWires( cubePosition, 2.0f, 2.0f, 2.0f, MAROON )
      
      DrawGrid( 10, 1.0f )
    EndMode3D()
    
    DrawText( "Welcome to the third dimension!", 10, 40, 20, DARKGRAY )
    
    DrawFPS( 10, 10 )
  EndDrawing()
loop

'' De-Initialization
CloseWindow()
