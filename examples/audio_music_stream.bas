/'*******************************************************************************************
*
*   raylib [audio] example - Music playing (streaming)
*
*   This example has been created using raylib 1.3 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Copyright (c) 2015 Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [audio] example - music playing (streaming)" )

'' Initialize audio device
InitAudioDevice()

dim as Music music = LoadMusicStream( "resources/audio/country.mp3" )

PlayMusicStream( music )

dim as single timePlayed = 0.0f
dim as boolean pause = false

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  UpdateMusicStream( music )
  
  '' Restart music playing (stop and play)
  if( IsKeyPressed( KEY_SPACE ) ) then
    StopMusicStream( music )
    PlayMusicStream( music )
  end if

  '' Pause/Resume music playing
  if( IsKeyPressed( KEY_P ) ) then
    pause xor= true
    
    if( pause ) then
      PauseMusicStream( music )
    else
      ResumeMusicStream( music )
    end if
  end if

  '' Get timePlayed scaled to bar dimensions (400 pixels)
  timePlayed = GetMusicTimePlayed( music ) / GetMusicTimeLength( music ) * 400
  
  if (timePlayed > 400) then StopMusicStream( music )
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    DrawText( "MUSIC SHOULD BE PLAYING!", 255, 150, 20, LIGHTGRAY )
    
    DrawRectangle( 200, 200, 400, 12, LIGHTGRAY )
    DrawRectangle( 200, 200, timePlayed, 12, MAROON )
    DrawRectangleLines( 200, 200, 400, 12, GRAY )
    
    DrawText( "PRESS SPACE TO RESTART MUSIC", 215, 250, 20, LIGHTGRAY )
    DrawText( "PRESS P TO PAUSE/RESUME MUSIC", 208, 280, 20, LIGHTGRAY )
  EndDrawing()
loop

'' De-Initialization
UnloadMusicStream( music )
CloseAudioDevice()
CloseWindow()
