/'*******************************************************************************************
*
*   raylib [audio] example - Module playing (streaming)
*
*   This example has been created using raylib 1.5 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Copyright (c) 2016 Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"

#define MAX_CIRCLES  64

type CircleWave
  as Vector2 position
  as single _
    radius, alpha, speed
  as Color color
end type

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

'' NOTE: Try to enable MSAA 4X
SetConfigFlags( FLAG_MSAA_4X_HINT )

InitWindow( screenWidth, screenHeight, "raylib [audio] example - module playing (streaming)" )

'' Initialize audio device
InitAudioDevice()                  

dim as Color colors( ... ) = { ORANGE, RAYRED, GOLD, LIME, RAYBLUE, VIOLET, BROWN, LIGHTGRAY, PINK, _
  YELLOW, RAYGREEN, SKYBLUE, PURPLE, BEIGE }

'' Creates ome circles for visual effect
dim as CircleWave circles( 0 to MAX_CIRCLES - 1 )

for i as integer = MAX_CIRCLES - 1 to 0 step -1
  with circles( i )
    .alpha = 0.0f
    .radius = GetRandomValue( 10, 40 )
    .position.x = GetRandomValue( .radius, screenWidth - .radius )
    .position.y = GetRandomValue( .radius, screenHeight - .radius )
    .speed = GetRandomValue( 1, 100 ) / 2000.0f
    .color = colors( GetRandomValue( 0, 13 ) )
  end with
next

dim as Music music = LoadMusicStream( "resources/audio/mini1111.xm" )

music.looping = false
dim as single pitch = 1.0f

PlayMusicStream( music )

dim as single timePlayed = 0.0f
dim as boolean pause = false

'' Set our game to run at 60 frames-per-second
SetTargetFPS( 60 )               

'' Main game loop
do while( not WindowShouldClose() )
  '' Update music buffer with new stream data
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
  
  if( IsKeyDown( KEY_DOWN ) ) then
    pitch -= 0.01f
  elseif( IsKeyDown( KEY_UP ) ) then
    pitch += 0.01f
  end if
  
  SetMusicPitch( music, pitch )
  
  '' Get timePlayed scaled to bar dimensions
  timePlayed = GetMusicTimePlayed( music ) / GetMusicTimeLength( music ) * ( screenWidth - 40 )
  
  ''Color circles animation
  if( not pause ) then
    for i as integer = MAX_CIRCLES - 1 to 0 step -1
      with circles( i )
        .alpha += .speed
        .radius += .speed * 10.0f
        
        if( .alpha > 1.0f ) then .speed *= -1
        
        if( .alpha <= 0.0f ) then
          .alpha = 0.0f
          .radius = GetRandomValue( 10, 40 )
          .position.x = GetRandomValue( .radius, screenWidth - .radius)
          .position.y = GetRandomValue( .radius, screenHeight - .radius)
          .color = colors( GetRandomValue( 0, 13 ) )
          .speed = GetRandomValue( 1, 100 ) / 2000.0f
        end if
      end with
    next
  end if
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    for i as integer = MAX_CIRCLES - 1 to 0 step -1
      with circles( i )
        DrawCircleV( .position, .radius, Fade( .color, .alpha ) )
      end with
    next
    
    '' Draw time bar
    DrawRectangle( 20, screenHeight - 20 - 12, screenWidth - 40, 12, LIGHTGRAY )
    DrawRectangle( 20, screenHeight - 20 - 12, timePlayed, 12, MAROON )
    DrawRectangleLines( 20, screenHeight - 20 - 12, screenWidth - 40, 12, GRAY )
  EndDrawing()
loop

'' De-Initialization
UnloadMusicStream(music)
CloseAudioDevice()
CloseWindow()
