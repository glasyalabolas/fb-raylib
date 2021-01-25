/'*******************************************************************************************
*
*   raylib [shapes] example - easings ball anim
*
*   This example has been created using raylib 2.5 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Copyright (c) 2014-2019 Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"
#include once "../easings.bi"                '' Required for easing functions

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

SetConfigFlags( FLAG_MSAA_4X_HINT ) '' Enable anti-aliasing if available
InitWindow( screenWidth, screenHeight, "raylib [shapes] example - easings ball anim" )

'' Ball variable value to be animated with easings
dim as long _
  ballPositionX = 0, _
  ballRadius = 20
dim as single ballAlpha = 0.0f

dim as long _
  state = 0, _
  framesCounter = 0

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  if( state = 0 ) then             '' Move ball position X with easing
    framesCounter += 1
    ballPositionX = EaseElasticOut( framesCounter, 0, screenWidth / 2 - 100, 120 )
    
    if( framesCounter >= 120 ) then
      framesCounter = 0
      state = 1
    end if
  elseif( state = 1 ) then       '' Increase ball radius with easing
    framesCounter += 1
    ballRadius = EaseElasticIn( framesCounter, 20, 200, 120 )
    
    if( framesCounter >= 120 ) then
      framesCounter = 0
      state = 2
    end if
  elseif( state = 2 ) then       '' Change ball alpha with easing (background color blending)
    framesCounter += 1
    ballAlpha = EaseCubicOut( framesCounter, 0.0f, 1.0f, 200 )
    
    if( framesCounter >= 200 ) then
      framesCounter = 0
      state = 3
    end if
  elseif( state = 3 ) then        '' Reset state to play again
    if( IsKeyPressed( KEY_ENTER ) ) then
      '' Reset required variables to play again
      ballPositionX = -100
      ballRadius = 20
      ballAlpha = 0.0f
      state = 0
    end if
  end if
  
  if( IsKeyPressed( KEY_R ) ) then framesCounter = 0
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    if( state >= 2 ) then DrawRectangle( 0, 0, screenWidth, screenHeight, RAYGREEN )
    DrawCircle( ballPositionX, 200, ballRadius, Fade( RAYRED, 1.0f - ballAlpha ) )
    
    if( state = 3 ) then DrawText( "PRESS [ENTER] TO PLAY AGAIN!", 240, 200, 20, BLACK )
  EndDrawing()
loop

'' De-Initialization
CloseWindow()
