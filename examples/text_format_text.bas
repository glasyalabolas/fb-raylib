/'*******************************************************************************************
*
*   raylib [text] example - Text formatting
*
*   This example has been created using raylib 1.1 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Copyright (c) 2014 Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [text] example - text formatting" )

dim as long _
  score = 100020, _
  hiscore = 200450, _
  lives = 5

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  ''----------------------------------------------------------------------------------
  '' TODO: Update your variables here
  ''----------------------------------------------------------------------------------
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    DrawText( TextFormat( "Score: %08i", score ), 200, 80, 20, RAYRED )
    DrawText( TextFormat( "HiScore: %08i", hiscore ), 200, 120, 20, RAYGREEN )
    DrawText( TextFormat( "Lives: %02i", lives ), 200, 160, 40, RAYBLUE )
    DrawText( TextFormat( "Elapsed Time: %02.02f ms", GetFrameTime() * 1000 ), 200, 220, 20, BLACK )
  EndDrawing()
loop

'' De-Initialization
CloseWindow()
