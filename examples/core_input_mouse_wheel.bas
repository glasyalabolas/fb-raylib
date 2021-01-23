/'*******************************************************************************************
*
*   raylib [core] examples - Mouse wheel input
*
*   This test has been created using raylib 1.1 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Copyright (c) 2014 Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [core] example - input mouse wheel" )

dim as long _
  boxPositionY = screenHeight / 2 - 40, _
  scrollSpeed = 4            '' Scrolling speed in pixels

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  boxPositionY -= ( GetMouseWheelMove() * scrollSpeed )
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    DrawRectangle( screenWidth / 2 - 40, boxPositionY, 80, 80, MAROON )
    DrawText( "Use mouse wheel to move the cube up and down!", 10, 10, 20, GRAY )
    DrawText( TextFormat("Box position Y: %03i", boxPositionY ), 10, 40, 20, LIGHTGRAY )
  EndDrawing()
loop

'' De-Initialization
CloseWindow()
