/'*******************************************************************************************
*
*   raylib [shapes] example - Cubic-bezier lines
*
*   This example has been created using raylib 1.7 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Copyright (c) 2017 Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

SetConfigFlags( FLAG_MSAA_4X_HINT )
InitWindow( screenWidth, screenHeight, "raylib [shapes] example - cubic-bezier lines" )

dim as Vector2 _
  start, end_ = Vector2( screenWidth, screenHeight )

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  if( IsMouseButtonDown( MOUSE_LEFT_BUTTON ) ) then
    start = GetMousePosition()
  elseif( IsMouseButtonDown( MOUSE_RIGHT_BUTTON ) ) then
    end_ = GetMousePosition()
  end if
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    DrawText( "USE MOUSE LEFT-RIGHT CLICK to DEFINE LINE START and END POINTS", 15, 20, 20, GRAY )
    DrawLineBezier( start, end_, 2.0f, RAYRED )
  EndDrawing()
loop

'' De-Initialization
CloseWindow()        '' Close window and OpenGL context
