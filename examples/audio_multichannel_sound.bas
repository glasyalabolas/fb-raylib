/'*******************************************************************************************
*
*   raylib [audio] example - Multichannel sound playing
*
*   This example has been created using raylib 2.6 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Example contributed by Chris Camacho (@chriscamacho) and reviewed by Ramon Santamaria (@raysan5)
*
*   Copyright (c) 2019 Chris Camacho (@chriscamacho) and Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [audio] example - Multichannel sound playing" )

InitAudioDevice()

dim as Sound _
  fxWav = LoadSound( "resources/audio/sound.wav" ), _
  fxOgg = LoadSound( "resources/audio/target.ogg" )
  
SetSoundVolume( fxWav, 0.2 )

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  if( IsKeyPressed( KEY_ENTER ) ) then PlaySoundMulti( fxWav )
  if( IsKeyPressed( KEY_SPACE ) ) then PlaySoundMulti( fxOgg )
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    DrawText( "MULTICHANNEL SOUND PLAYING", 20, 20, 20, GRAY )
    DrawText( "Press SPACE to play new ogg instance!", 200, 120, 20, LIGHTGRAY )
    DrawText( "Press ENTER to play new wav instance!", 200, 180, 20, LIGHTGRAY )

    DrawText( TextFormat( "CONCURRENT SOUNDS PLAYING: %02i", GetSoundsPlaying() ), 220, 280, 20, RAYRED )
  EndDrawing()
loop

'' De-Initialization
StopSoundMulti() '' We must stop the buffer pool before unloading

UnloadSound( fxWav )
UnloadSound( fxOgg )

CloseAudioDevice()

CloseWindow()
