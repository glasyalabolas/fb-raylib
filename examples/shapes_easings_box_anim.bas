/'*******************************************************************************************
*
*   raylib [shapes] example - easings box anim
*
*   This example has been created using raylib 2.5 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Copyright (c) 2014-2019 Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"
#include once "../easings.bi"            '' Required for easing functions

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [shapes] example - easings box anim" )

'' Box variables to be animated with easings
var rec = Rectangle( GetScreenWidth() / 2, -100, 100, 100 )

dim as single _
  rotation = 0.0f, _
  alpha = 1.0f

dim as long _
  state = 0, _
  framesCounter = 0

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  select case as const( state )
    case 0     '' Move box down to center of screen
      framesCounter += 1
      
      '' NOTE: Remember that 3rd parameter of easing function refers to
      '' desired value variation, do not confuse it with expected final value!
      rec.y = EaseElasticOut( framesCounter, -100, GetScreenHeight() / 2 + 100, 120 )
      
      if( framesCounter >= 120 ) then
        framesCounter = 0
        state = 1
      end if
    case 1     '' Scale box to an horizontal bar
      framesCounter += 1
      rec.height = EaseBounceOut( framesCounter, 100, -90, 120 )
      rec.width = EaseBounceOut( framesCounter, 100, GetScreenWidth(), 120 )
      
      if( framesCounter >= 120 ) then
        framesCounter = 0
        state = 2
      end if
    case 2     '' Rotate horizontal bar rectangle
      framesCounter += 1
      rotation = EaseQuadOut( framesCounter, 0.0f, 270.0f, 240 )
      
      if( framesCounter >= 240 ) then
        framesCounter = 0
        state = 3
      end if
    case 3     '' Increase bar size to fill all screen
      framesCounter += 1
      rec.height = EaseCircOut( framesCounter, 10, GetScreenWidth(), 120 )
      
      if( framesCounter >= 120 ) then
        framesCounter = 0
        state = 4
      end if
    case 4     '' Fade out animation
      framesCounter += 1
      alpha = EaseSineOut( framesCounter, 1.0f, -1.0f, 160 )
      
      if( framesCounter >= 160 ) then
        framesCounter = 0
        state = 5
      end if
  end select
  
  '' Reset animation at any moment
  if( IsKeyPressed( KEY_SPACE ) ) then
    rec = Rectangle( GetScreenWidth() / 2, -100, 100, 100 )
    rotation = 0.0f
    alpha = 1.0f
    state = 0
    framesCounter = 0
  end if
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    DrawRectanglePro( rec, Vector2( rec.width / 2, rec.height / 2 ), rotation, Fade( BLACK, alpha ) )
    DrawText( "PRESS [SPACE] TO RESET BOX ANIMATION!", 10, GetScreenHeight() - 25, 20, LIGHTGRAY )
  EndDrawing()
loop

'' De-Initialization
CloseWindow()
