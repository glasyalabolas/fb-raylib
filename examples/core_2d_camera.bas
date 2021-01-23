/'*******************************************************************************************
*
*   raylib [core] example - 2d camera
*
*   This example has been created using raylib 1.5 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Copyright (c) 2016 Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"

#define MAX_BUILDINGS   100

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [core] example - 2d camera" )

dim as Rectangle player = Rectangle( 400, 280, 40, 40 )
dim as Rectangle buildings( 0 to MAX_BUILDINGS - 1 )
dim as Color buildColors( 0 to MAX_BUILDINGS - 1 )

dim as long spacing = 0

for i as integer = 0 to MAX_BUILDINGS - 1
  with buildings( i )
    .width = GetRandomValue( 50, 200 )
    .height = GetRandomValue( 100, 800 )
    .y = screenHeight - 130 - .height
    .x = -6000 + spacing
    
    spacing += .width
  end with
  
  buildColors( i ) = Color( GetRandomValue( 200, 240 ), GetRandomValue( 200, 240 ), GetRandomValue( 200, 250 ), 255 )
next

dim as Camera2D camera

with camera
  .target = Vector2( player.x + 20, player.y + 20 )
  .offset = Vector2( screenWidth / 2, screenHeight / 2 )
  .rotation = 0.0f
  .zoom = 1.0f
end with

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  '' Player movement
  if( IsKeyDown( KEY_RIGHT ) ) then
    player.x += 2
  elseif( IsKeyDown( KEY_LEFT ) ) then
    player.x -= 2
  end if
  
  '' Camera target follows player
  camera.target = Vector2( player.x + 20, player.y + 20 )

  '' Camera rotation controls
  if( IsKeyDown( KEY_A ) ) then
    camera.rotation -= 1
  elseif( IsKeyDown( KEY_S ) ) then
    camera.rotation += 1
  end if
  
  '' Limit camera rotation to 80 degrees (-40 to 40)
  if( camera.rotation > 40 ) then 
    camera.rotation = 40
  elseif( camera.rotation < -40 ) then
    camera.rotation = -40
  end if
  
  '' Camera zoom controls
  camera.zoom += GetMouseWheelMove() * 0.05f
  
  if( camera.zoom > 3.0f ) then
    camera.zoom = 3.0f
  elseif( camera.zoom < 0.1f ) then
    camera.zoom = 0.1f
  end if
  
  '' Camera reset (zoom and rotation)
  if( IsKeyPressed( KEY_R ) ) then
    camera.zoom = 1.0f
    camera.rotation = 0.0f
  end if
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    BeginMode2D( camera )
      DrawRectangle( -6000, 320, 13000, 8000, DARKGRAY )
      
      for i as integer = 0 to MAX_BUILDINGS - 1
        DrawRectangleRec( buildings( i ), buildColors( i ) )
      next
      
      DrawRectangleRec( player, RAYRED )
      
      DrawLine( camera.target.x, -screenHeight * 10, camera.target.x, screenHeight * 10, RAYGREEN )
      DrawLine( -screenWidth * 10, camera.target.y, screenWidth * 10, camera.target.y, RAYGREEN )
    EndMode2D()
    
    DrawText( "SCREEN AREA", 640, 10, 20, RAYRED )

    DrawRectangle( 0, 0, screenWidth, 5, RAYRED )
    DrawRectangle( 0, 5, 5, screenHeight - 10, RAYRED )
    DrawRectangle( screenWidth - 5, 5, 5, screenHeight - 10, RAYRED )
    DrawRectangle( 0, screenHeight - 5, screenWidth, 5, RAYRED )

    DrawRectangle( 10, 10, 250, 113, Fade( SKYBLUE, 0.5f ) )
    DrawRectangleLines( 10, 10, 250, 113, RAYBLUE )

    DrawText( "Free 2d camera controls:", 20, 20, 10, BLACK )
    DrawText( "- Right/Left to move Offset", 40, 40, 10, DARKGRAY )
    DrawText( "- Mouse Wheel to Zoom in-out", 40, 60, 10, DARKGRAY )
    DrawText( "- A / S to Rotate", 40, 80, 10, DARKGRAY )
    DrawText( "- R to reset Zoom and Rotation", 40, 100, 10, DARKGRAY )
  EndDrawing()
loop

'' De-Initialization
CloseWindow()
