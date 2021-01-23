/'*******************************************************************************************
*
*   raylib [core] example - Keyboard input
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

InitWindow( screenWidth, screenHeight, "raylib [core] example - keyboard input" )

var ballPosition = Vector2( screenWidth / 2, screenHeight / 2 )

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  if( IsKeyDown( KEY_RIGHT ) ) then ballPosition.x += 2.0f
  if( IsKeyDown( KEY_LEFT ) ) then ballPosition.x -= 2.0f
  if( IsKeyDown( KEY_UP ) ) then ballPosition.y -= 2.0f
  if( IsKeyDown( KEY_DOWN ) ) then ballPosition.y += 2.0f
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    DrawText( "move the ball with arrow keys", 10, 10, 20, DARKGRAY )
    DrawCircleV( ballPosition, 50, MAROON)
  EndDrawing()
loop

'' De-Initialization
CloseWindow()
