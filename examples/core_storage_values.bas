/'*******************************************************************************************
*
*   raylib [core] example - Storage save/load values
*
*   This example has been created using raylib 1.4 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Copyright (c) 2015 Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"

'' NOTE: Storage positions must start with 0, directly related to file memory layout
enum StorageData
  STORAGE_POSITION_SCORE      = 0
  STORAGE_POSITION_HISCORE    = 1
end enum

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [core] example - storage save/load values" )

dim as long _
  score = 0, hiscore = 0, framesCounter = 0

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  if( IsKeyPressed( KEY_R ) ) then
    score = GetRandomValue( 1000, 2000 )
    hiscore = GetRandomValue( 2000, 4000 )
  end if
  
  if( IsKeyPressed( KEY_ENTER ) ) then
    SaveStorageValue( STORAGE_POSITION_SCORE, score )
    SaveStorageValue( STORAGE_POSITION_HISCORE, hiscore )
  elseif( IsKeyPressed( KEY_SPACE ) ) then
    '' NOTE: If requested position could not be found, value 0 is returned
    score = LoadStorageValue( STORAGE_POSITION_SCORE )
    hiscore = LoadStorageValue( STORAGE_POSITION_HISCORE )
  end if
  
  framesCounter += 1
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    DrawText( TextFormat( "SCORE: %i", score ), 280, 130, 40, MAROON )
    DrawText( TextFormat( "HI-SCORE: %i", hiscore ), 210, 200, 50, BLACK )
    
    DrawText( TextFormat( "frames: %i", framesCounter ), 10, 10, 20, LIME )
    
    DrawText( "Press R to generate random numbers", 220, 40, 20, LIGHTGRAY )
    DrawText( "Press ENTER to SAVE values", 250, 310, 20, LIGHTGRAY )
    DrawText( "Press SPACE to LOAD values", 252, 350, 20, LIGHTGRAY )
  EndDrawing()
loop

'' De-Initialization
CloseWindow()
