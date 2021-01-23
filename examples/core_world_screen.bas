/'*******************************************************************************************
*
*   raylib [core] example - World to screen
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
dim as Camera camera

with camera
  .position = Vector3( 10.0f, 10.0f, 10.0f )
  .target = Vector3( 0.0f, 0.0f, 0.0f )
  .up = Vector3( 0.0f, 1.0f, 0.0f )
  .fovy = 45.0f
  .type = CAMERA_PERSPECTIVE
end with

var _
  cubePosition = Vector3( 0.0f, 0.0f, 0.0f ), _
  cubeScreenPosition = Vector2( 0.0f, 0.0f )

SetCameraMode( camera, CAMERA_FREE )

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  UpdateCamera( @camera )
  
  '' Calculate cube screen space position (with a little offset to be in top)
  cubeScreenPosition = GetWorldToScreen( Vector3( cubePosition.x, cubePosition.y + 2.5f, cubePosition.z ), camera )
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    BeginMode3D( camera )
        DrawCube( cubePosition, 2.0f, 2.0f, 2.0f, RAYRED )
        DrawCubeWires( cubePosition, 2.0f, 2.0f, 2.0f, MAROON )
        
        DrawGrid( 10, 1.0f )
    EndMode3D()
    
    DrawText( "Enemy: 100 / 100", cubeScreenPosition.x - MeasureText( "Enemy: 100/100", 20 ) / 2, cubeScreenPosition.y, 20, BLACK )
    DrawText( "Text is always on top of the cube", ( screenWidth - MeasureText( "Text is always on top of the cube", 20 ) ) / 2, 25, 20, GRAY )
  EndDrawing()
loop

'' De-Initialization
CloseWindow()
