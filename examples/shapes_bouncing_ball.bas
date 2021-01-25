/'*******************************************************************************************
*
*   raylib [shapes] example - bouncing ball
*
*   This example has been created using raylib 1.0 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Copyright (c) 2013 Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [shapes] example - bouncing ball" )

var _
  ballPosition = Vector2( GetScreenWidth() / 2, GetScreenHeight() / 2 ), _
  ballSpeed = Vector2( 5.0f, 4.0f )

dim as long ballRadius = 20

dim as boolean pause = 0
dim as long framesCounter = 0

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  if( IsKeyPressed( KEY_SPACE ) ) then pause xor= true
  
  if( not pause ) then
    ballPosition.x += ballSpeed.x
    ballPosition.y += ballSpeed.y
    
    '' Check walls collision for bouncing
    if( ( ballPosition.x >= ( GetScreenWidth() - ballRadius ) ) orElse ( ballPosition.x <= ballRadius ) ) then ballSpeed.x *= -1.0f
    if( ( ballPosition.y >= ( GetScreenHeight() - ballRadius ) ) orElse ( ballPosition.y <= ballRadius ) ) then ballSpeed.y *= -1.0f
  else
    framesCounter += 1
  end if
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    DrawCircleV( ballPosition, ballRadius, MAROON )
    DrawText( "PRESS SPACE to PAUSE BALL MOVEMENT", 10, GetScreenHeight() - 25, 20, LIGHTGRAY )
    
    '' On pause, we draw a blinking message
    if( pause andAlso ( ( framesCounter / 30 ) mod 2 = 0 ) ) then DrawText( "PAUSED", 350, 200, 30, GRAY )
    
    DrawFPS( 10, 10 )
  EndDrawing()
loop

'' De-Initialization
CloseWindow()
