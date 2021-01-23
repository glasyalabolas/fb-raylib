/'*******************************************************************************************
*
*   raylib [models] example - Show the difference between perspective and orthographic projection
*
*   This program is heavily based on the geometric objects example
*
*   This example has been created using raylib 2.0 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Example contributed by Max Danielsson (@autious) and reviewed by Ramon Santamaria (@raysan5)
*
*   Copyright (c) 2018 Max Danielsson (@autious) and Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"

#define FOVY_PERSPECTIVE    45.0f
#define WIDTH_ORTHOGRAPHIC  10.0f

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
  .fovy = FOVY_PERSPECTIVE
  .type = CAMERA_PERSPECTIVE
end with

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  if( IsKeyPressed( KEY_SPACE ) ) then
    if( camera.type = CAMERA_PERSPECTIVE ) then
      camera.fovy = WIDTH_ORTHOGRAPHIC
      camera.type = CAMERA_ORTHOGRAPHIC
    else
      camera.fovy = FOVY_PERSPECTIVE
      camera.type = CAMERA_PERSPECTIVE
    end if
  end if
  
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
    
    DrawText( "Press Spacebar to switch camera type", 10, GetScreenHeight() - 30, 20, DARKGRAY )
    
    if( camera.type = CAMERA_ORTHOGRAPHIC ) then
      DrawText( "ORTHOGRAPHIC", 10, 40, 20, BLACK )
    elseif( camera.type = CAMERA_PERSPECTIVE ) then
      DrawText( "PERSPECTIVE", 10, 40, 20, BLACK )
    end if
    
    DrawFPS( 10, 10 )
  EndDrawing()
loop

'' De-Initialization
CloseWindow()
