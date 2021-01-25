/'*******************************************************************************************
*
*   raylib [shapes] example - raylib logo animation
*
*   This example has been created using raylib 2.3 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Copyright (c) 2014 Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [shapes] example - raylib logo animation" )

dim as long _
  logoPositionX = screenWidth / 2 - 128, _
  logoPositionY = screenHeight / 2 - 128, _
  framesCounter = 0, _
  lettersCount = 0, _
  topSideRecWidth = 16, _
  leftSideRecHeight = 16, _
  bottomSideRecWidth = 16, _
  rightSideRecHeight = 16

dim as long state = 0                  '' Tracking animation states (State Machine)
dim as single alpha = 1.0f             '' Useful for fading

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  if( state = 0 ) then               '' State 0: Small box blinking
    framesCounter += 1
    
    if( framesCounter = 120 ) then
      state = 1
      framesCounter = 0            '' Reset counter... will be used later...
    end if
  elseif( state = 1) then            '' State 1: Top and left bars growing
    topSideRecWidth += 4
    leftSideRecHeight += 4
    
    if( topSideRecWidth = 256 ) then state = 2
  elseif( state = 2 ) then           '' State 2: Bottom and right bars growing
    bottomSideRecWidth += 4
    rightSideRecHeight += 4
    
    if( bottomSideRecWidth = 256 ) then state = 3
  elseif( state = 3 ) then           '' State 3: Letters appearing (one by one)
    framesCounter += 1
    
    if( framesCounter / 12 ) then    '' Every 12 frames, one more letter!
      lettersCount += 1
      framesCounter = 0
    end if
    
    if( lettersCount >= 10 ) then    '' When all letters have appeared, just fade out everything
      alpha -= 0.02f
      
      if( alpha <= 0.0f ) then
        alpha = 0.0f
        state = 4
      end if
    end if
  elseif( state = 4 ) then           '' State 4: Reset and Replay
    if( IsKeyPressed( asc( "R" ) ) ) then
      framesCounter = 0
      lettersCount = 0
      
      topSideRecWidth = 16
      leftSideRecHeight = 16
      
      bottomSideRecWidth = 16
      rightSideRecHeight = 16
      
      alpha = 1.0f
      state = 0                      '' Return to State 0
    end if
  end if
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    if( state = 0 ) then
      if( ( framesCounter / 15 ) mod 2 ) then
        DrawRectangle( logoPositionX, logoPositionY, 16, 16, BLACK )
      end if
    elseif( state = 1 ) then
      DrawRectangle( logoPositionX, logoPositionY, topSideRecWidth, 16, BLACK )
      DrawRectangle( logoPositionX, logoPositionY, 16, leftSideRecHeight, BLACK )
    elseif( state = 2 ) then
      DrawRectangle( logoPositionX, logoPositionY, topSideRecWidth, 16, BLACK )
      DrawRectangle( logoPositionX, logoPositionY, 16, leftSideRecHeight, BLACK )
      
      DrawRectangle( logoPositionX + 240, logoPositionY, 16, rightSideRecHeight, BLACK )
      DrawRectangle( logoPositionX, logoPositionY + 240, bottomSideRecWidth, 16, BLACK )
    elseif( state = 3 ) then
      DrawRectangle( logoPositionX, logoPositionY, topSideRecWidth, 16, Fade( BLACK, alpha ) )
      DrawRectangle( logoPositionX, logoPositionY + 16, 16, leftSideRecHeight - 32, Fade( BLACK, alpha ) )
      
      DrawRectangle( logoPositionX + 240, logoPositionY + 16, 16, rightSideRecHeight - 32, Fade( BLACK, alpha ) )
      DrawRectangle( logoPositionX, logoPositionY + 240, bottomSideRecWidth, 16, Fade( BLACK, alpha ) )
      
      DrawRectangle( screenWidth / 2 - 112, screenHeight / 2 - 112, 224, 224, Fade( RAYWHITE, alpha ) )
      
      DrawText( TextSubtext( "raylib", 0, lettersCount ), screenWidth / 2 - 44, screenHeight / 2 + 48, 50, Fade( BLACK, alpha ) )
    elseif( state = 4 ) then
      DrawText( "[R] REPLAY", 340, 200, 20, GRAY )
    end if
  EndDrawing()
loop

'' De-Initialization
CloseWindow()
