/'*******************************************************************************************
*
*   raylib [models] example - Draw some basic geometric shapes (cube, sphere, cylinder...)
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

InitWindow( screenWidth, screenHeight, "raylib [models] example - geometric shapes" )

'' Define the camera to look into our 3d world
dim as Camera camera

with camera
  .position = Vector3( 0.0f, 10.0f, 10.0f )
  .target = Vector3( 0.0f, 0.0f, 0.0f )
  .up = Vector3( 0.0f, 1.0f, 0.0f )
  .fovy = 45.0f
  .type = CAMERA_PERSPECTIVE
end with

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  '' ...
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    BeginMode3D( camera )
      DrawCube( Vector3( -4.0f, 0.0f, 2.0f ), 2.0f, 5.0f, 2.0f, RAYRED )
      DrawCubeWires( Vector3( -4.0f, 0.0f, 2.0f ), 2.0f, 5.0f, 2.0f, GOLD )
      DrawCubeWires( Vector3( -4.0f, 0.0f, -2.0f ), 3.0f, 6.0f, 2.0f, MAROON )
      
      DrawSphere( Vector3( -1.0f, 0.0f, -2.0f ), 1.0f, RAYGREEN )
      DrawSphereWires( Vector3( 1.0f, 0.0f, 2.0f ), 2.0f, 16, 16, LIME )
      
      DrawCylinder( Vector3( 4.0f, 0.0f, -2.0f ), 1.0f, 2.0f, 3.0f, 4, SKYBLUE )
      DrawCylinderWires( Vector3( 4.0f, 0.0f, -2.0f ), 1.0f, 2.0f, 3.0f, 4, DARKBLUE )
      DrawCylinderWires( Vector3( 4.5f, -1.0f, 2.0f ), 1.0f, 1.0f, 2.0f, 6, BROWN )
      
      DrawCylinder( Vector3( 1.0f, 0.0f, -4.0f ), 0.0f, 1.5f, 3.0f, 8, GOLD )
      DrawCylinderWires( Vector3( 1.0f, 0.0f, -4.0f ), 0.0f, 1.5f, 3.0f, 8, PINK )
      
      DrawGrid( 10, 1.0f )
    EndMode3D()

    DrawFPS( 10, 10 )
  EndDrawing()
loop

'' De-Initialization
CloseWindow()
