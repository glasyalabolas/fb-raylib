/'*******************************************************************************************
*
*   raylib [text] example - Text Writing Animation
*
*   This example has been created using raylib 2.3 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Copyright (c) 2016 Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [text] example - text writing anim" )

dim as const string message = !"This sample illustrates a text writing\nanimation effect! Check it out! ;)"

dim as long framesCounter = 0

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  if( IsKeyDown( KEY_SPACE ) ) then
    framesCounter += 8
  else
    framesCounter += 1
  end if
  
  if( IsKeyPressed( KEY_ENTER ) ) then framesCounter = 0
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    DrawText( TextSubtext( message, 0, framesCounter / 10 ), 210, 160, 20, MAROON )
    
    DrawText( "PRESS [ENTER] to RESTART!", 240, 260, 20, LIGHTGRAY )
    DrawText( "PRESS [SPACE] to SPEED UP!", 239, 300, 20, LIGHTGRAY )
  EndDrawing()
loop

'' De-Initialization
CloseWindow()
