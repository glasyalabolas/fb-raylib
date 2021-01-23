/'*******************************************************************************************
*
*   raylib [core] example - Mouse input
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

InitWindow( screenWidth, screenHeight, "raylib [core] example - mouse input" )

var ballPosition = Vector2( -100.0f, -100.0f )
dim as RayColor ballColor = DARKBLUE

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  ballPosition = GetMousePosition()

  if( IsMouseButtonPressed( MOUSE_LEFT_BUTTON ) ) then
    ballColor = MAROON
  elseif( IsMouseButtonPressed( MOUSE_MIDDLE_BUTTON ) ) then
    ballColor = LIME
  elseif( IsMouseButtonPressed( MOUSE_RIGHT_BUTTON ) ) then
    ballColor = DARKBLUE
  end if
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    DrawCircleV( ballPosition, 40, ballColor)
    DrawText( "move ball with mouse and click mouse button to change color", 10, 10, 20, DARKGRAY )
  EndDrawing()
loop

'' De-Initialization
CloseWindow()
