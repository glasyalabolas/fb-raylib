/'*******************************************************************************************
*
*   raylib [core] example - Generate random values
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

InitWindow( screenWidth, screenHeight, "raylib [core] example - generate random values" )

dim as long _
  framesCounter = 0, _
  randValue = GetRandomValue( -8, 5 )

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
    '' Update
  framesCounter += 1

  '' Every two seconds (120 frames) a new random value is generated
  if( ( ( framesCounter / 120 ) mod 2 ) = 1 ) then
    randValue = GetRandomValue( -8, 5 )
    framesCounter = 0
  end if

  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    DrawText( "Every 2 seconds a new random value is generated:", 130, 100, 20, MAROON )
    DrawText( TextFormat( "%i", randValue ), 360, 180, 80, LIGHTGRAY )
  EndDrawing()
loop

'' De-Initialization
CloseWindow()
