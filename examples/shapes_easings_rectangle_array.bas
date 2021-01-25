/'*******************************************************************************************
*
*   raylib [shapes] example - easings rectangle array
*
*   NOTE: This example requires 'easings.h' library, provided on raylib/src. Just copy
*   the library to same directory as example or make sure it's available on include path.
*
*   This example has been created using raylib 2.0 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Copyright (c) 2014-2019 Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"
#include once "../easings.bi"            '' Required for easing functions

#define RECS_WIDTH              50
#define RECS_HEIGHT             50

#define MAX_RECS_X              800 / RECS_WIDTH
#define MAX_RECS_Y              450 / RECS_HEIGHT

#define PLAY_TIME_IN_FRAMES     240                 '' At 60 fps = 4 seconds

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [shapes] example - easings rectangle array" )

dim as Rectangle recs( 0 to MAX_RECS_X * MAX_RECS_Y - 1 )

for y as integer = 0 to MAX_RECS_Y - 1
  for x as integer = 0 to MAX_RECS_X - 1
    with recs( y * MAX_RECS_X + x )
      .x = RECS_WIDTH / 2 + RECS_WIDTH * x
      .y = RECS_HEIGHT / 2 + RECS_HEIGHT * y
      .width = RECS_WIDTH
      .height = RECS_HEIGHT
    end with
  next
next

dim as single rotation = 0.0f
dim as long _
  framesCounter = 0, _
  state = 0                  '' Rectangles animation state: 0-Playing, 1-Finished

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
    '' Update
    if( state = 0 ) then
      framesCounter += 1
      
      for i as integer = 0 to ( MAX_RECS_X * MAX_RECS_Y ) - 1
        with recs( i )
          .height = EaseCircOut( framesCounter, RECS_HEIGHT, -RECS_HEIGHT, PLAY_TIME_IN_FRAMES )
          .width = EaseCircOut( framesCounter, RECS_WIDTH, -RECS_WIDTH, PLAY_TIME_IN_FRAMES )
          
          if( .height < 0 ) then .height = 0
          if( .width < 0 ) then .width = 0
          
          if( ( .height = 0 ) andAlso ( .width = 0 ) ) then state = 1   '' Finish playing
        end with
        
        rotation = EaseLinearIn( framesCounter, 0.0f, 360.0f, PLAY_TIME_IN_FRAMES )
      next
    elseif( ( state = 1 ) andAlso IsKeyPressed( KEY_SPACE ) ) then
      '' When animation has finished, press space to restart
      framesCounter = 0
      
      for i as integer = 0 to ( MAX_RECS_X * MAX_RECS_Y ) - 1
        recs( i ).height = RECS_HEIGHT
        recs( i ).width = RECS_WIDTH
      next
      
      state = 0
    end if

    '' Draw
    BeginDrawing()
      ClearBackground( RAYWHITE )
      
      if( state = 0 ) then
        for i as integer = 0 to ( MAX_RECS_X * MAX_RECS_Y ) - 1
          DrawRectanglePro( recs( i ), Vector2( recs( i ).width / 2, recs( i ).height / 2 ), rotation, RAYRED )
        next
      elseif( state = 1 ) then
        DrawText("PRESS [SPACE] TO PLAY AGAIN!", 240, 200, 20, GRAY)
      end if
    EndDrawing()
loop

'' De-Initialization
CloseWindow()
