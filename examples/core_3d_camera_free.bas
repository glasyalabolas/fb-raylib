/'*******************************************************************************************
*
*   raylib [core] example - Initialize 3d camera free
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

InitWindow( screenWidth, screenHeight, "raylib [core] example - 3d camera free" )

'' Define the camera to look into our 3d world
dim as Camera3D camera

with camera
  .position = Vector3( 10.0f, 10.0f, 10.0f )
  .target = Vector3( 0.0f, 0.0f, 0.0f )
  .up = Vector3( 0.0f, 1.0f, 0.0f )
  .fovy = 45.0f
  .type = CAMERA_PERSPECTIVE
end with

var cubePosition = Vector3( 0.0f, 0.0f, 0.0f )

SetCameraMode( camera, CAMERA_FREE )

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  UpdateCamera( @camera )
  
  if( IsKeyDown( asc( "Z" ) ) ) then camera.target = Vector3( 0.0f, 0.0f, 0.0f )
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    BeginMode3D( camera )
      DrawCube( cubePosition, 2.0f, 2.0f, 2.0f, RAYRED )
      DrawCubeWires( cubePosition, 2.0f, 2.0f, 2.0f, MAROON )
      DrawGrid( 10, 1.0f )
    EndMode3D()
    
    DrawRectangle( 10, 10, 320, 133, Fade( SKYBLUE, 0.5f ) )
    DrawRectangleLines( 10, 10, 320, 133, RAYBLUE )
    
    DrawText( "Free camera default controls:", 20, 20, 10, BLACK )
    DrawText( "- Mouse Wheel to Zoom in-out", 40, 40, 10, DARKGRAY )
    DrawText( "- Mouse Wheel Pressed to Pan", 40, 60, 10, DARKGRAY )
    DrawText( "- Alt + Mouse Wheel Pressed to Rotate", 40, 80, 10, DARKGRAY )
    DrawText( "- Alt + Ctrl + Mouse Wheel Pressed for Smooth Zoom", 40, 100, 10, DARKGRAY )
    DrawText( "- Z to zoom to (0, 0, 0)", 40, 120, 10, DARKGRAY )
  EndDrawing()
loop

'' De-Initialization
CloseWindow()
