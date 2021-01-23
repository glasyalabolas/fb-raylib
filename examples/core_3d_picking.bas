/'*******************************************************************************************
*
*   raylib [core] example - Picking in 3d mode
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

InitWindow( screenWidth, screenHeight, "raylib [core] example - 3d picking" )

dim as Camera camera

with camera
  .position = Vector3( 10.0f, 10.0f, 10.0f )
  .target = Vector3( 0.0f, 0.0f, 0.0f )
  .up = Vector3( 0.0f, 1.0f, 0.0f )
  .fovy = 45.0f
  .type = CAMERA_PERSPECTIVE
end with

var _
  cubePosition = Vector3( 0.0f, 1.0f, 0.0f ), _
  cubeSize = Vector3( 2.0f, 2.0f, 2.0f )

dim as Ray ray '' Picking line ray

dim as boolean collision = false

SetCameraMode( camera, CAMERA_FREE )

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  UpdateCamera( @camera )
  
  if( IsMouseButtonPressed( MOUSE_LEFT_BUTTON ) ) then
    if( not collision ) then
      ray = GetMouseRay( GetMousePosition(), camera )
      
      '' Check collision between ray and box
      collision = CheckCollisionRayBox( ray, BoundingBox( _
        Vector3( cubePosition.x - cubeSize.x / 2, cubePosition.y - cubeSize.y / 2, cubePosition.z - cubeSize.z / 2 ), _
        Vector3( cubePosition.x + cubeSize.x / 2, cubePosition.y + cubeSize.y / 2, cubePosition.z + cubeSize.z / 2 ) ) )
    else
      collision = false
    end if
  end if
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    BeginMode3D( camera )
    
    if( collision ) then
      DrawCube( cubePosition, cubeSize.x, cubeSize.y, cubeSize.z, RAYRED )
      DrawCubeWires( cubePosition, cubeSize.x, cubeSize.y, cubeSize.z, MAROON )
      
      DrawCubeWires(cubePosition, cubeSize.x + 0.2f, cubeSize.y + 0.2f, cubeSize.z + 0.2f, RAYGREEN )
    else
      DrawCube( cubePosition, cubeSize.x, cubeSize.y, cubeSize.z, GRAY )
      DrawCubeWires( cubePosition, cubeSize.x, cubeSize.y, cubeSize.z, DARKGRAY )
    end if
    
    DrawRay( ray, MAROON )
    DrawGrid( 10, 1.0f )
    
    EndMode3D()
    
    DrawText( "Try selecting the box with mouse!", 240, 10, 20, DARKGRAY )
    
    if( collision ) then
      DrawText( "BOX SELECTED", ( screenWidth - MeasureText( "BOX SELECTED", 30 ) ) / 2, screenHeight * 0.1f, 30, RAYGREEN )
    end if
    
    DrawFPS( 10, 10 )
  EndDrawing()
loop

'' De-Initialization
CloseWindow()
