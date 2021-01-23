/'*******************************************************************************************
*
*   raylib [audio] example - Sound loading and playing
*
*   This example has been created using raylib 1.0 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Copyright (c) 2014 Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [audio] example - sound loading and playing" )

InitAudioDevice()

dim as Sound _
  fxWav = LoadSound( "resources/audio/sound.wav" ), _
  fxOgg = LoadSound( "resources/audio/target.ogg" )

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  if( IsKeyPressed( KEY_SPACE ) ) then PlaySound( fxWav )
  if( IsKeyPressed( KEY_ENTER ) ) then PlaySound( fxOgg )
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    DrawText( "Press SPACE to PLAY the WAV sound!", 200, 180, 20, LIGHTGRAY )
    DrawText( "Press ENTER to PLAY the OGG sound!", 200, 220, 20, LIGHTGRAY )
  EndDrawing()
loop

'' De-Initialization
UnloadSound( fxWav )
UnloadSound( fxOgg )

CloseAudioDevice()

CloseWindow()
