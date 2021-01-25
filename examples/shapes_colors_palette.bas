/'*******************************************************************************************
*
*   raylib [shapes] example - Colors palette
*
*   This example has been created using raylib 2.5 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Copyright (c) 2014-2019 Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"

#define MAX_COLORS_COUNT    21          '' Number of colors available

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 600

SetConfigFlags( FLAG_MSAA_4X_HINT ) '' Enable anti-aliasing if available
InitWindow( screenWidth, screenHeight, "raylib [shapes] example - colors palette" )

dim as RayColor colors( 0 to MAX_COLORS_COUNT - 1 ) = { _
  DARKGRAY, MAROON, ORANGE, DARKGREEN, DARKBLUE, DARKPURPLE, DARKBROWN, _
  GRAY, RAYRED, GOLD, LIME, RAYBLUE, VIOLET, BROWN, LIGHTGRAY, PINK, YELLOW, _
  RAYGREEN, SKYBLUE, PURPLE, BEIGE }

dim as const string colorNames( 0 to MAX_COLORS_COUNT - 1 ) = { _
  "DARKGRAY", "MAROON", "ORANGE", "DARKGREEN", "DARKBLUE", "DARKPURPLE", _
  "DARKBROWN", "GRAY", "RED", "GOLD", "LIME", "BLUE", "VIOLET", "BROWN", _
  "LIGHTGRAY", "PINK", "YELLOW", "GREEN", "SKYBLUE", "PURPLE", "BEIGE" }

dim as Rectangle colorsRecs( 0 to MAX_COLORS_COUNT - 1 ) '' Rectangles array

'' Fills colorsRecs data (for every rectangle)
for i as integer = 0 to MAX_COLORS_COUNT - 1
  with colorsRecs( i )
    .x = 20 + 100 * ( i mod 7 ) + 10 * ( i mod 7 )
    .y = 80 + 100 * ( i / 7 ) + 10 * ( i / 7 )
    .width = 100
    .height = 100
  end with
next

dim as long colorState( 0 to MAX_COLORS_COUNT - 1 ) '' Color state: 0-DEFAULT, 1-MOUSE_HOVER

dim as Vector2 mousePoint

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  mousePoint = GetMousePosition()
  
  for i as integer = 0 to MAX_COLORS_COUNT - 1
    if( CheckCollisionPointRec( mousePoint, colorsRecs( i ) ) ) then
      colorState( i ) = 1
    else
      colorState( i ) = 0
    end if
  next
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    DrawText( "raylib colors palette", 28, 42, 20, BLACK )
    DrawText( "press SPACE to see all colors", GetScreenWidth() - 180, GetScreenHeight() - 40, 10, GRAY )
    
    for i as integer = 0 to MAX_COLORS_COUNT - 1
      DrawRectangleRec( colorsRecs( i ), Fade( colors( i ), iif( colorState( i ), 0.6f,  1.0f ) ) )
      
      if( IsKeyDown( KEY_SPACE ) orElse colorState( i ) = 1 ) then
        DrawRectangle( colorsRecs( i ).x, colorsRecs( i ).y + colorsRecs( i ).height - 26, colorsRecs( i ).width, 20, BLACK )
        DrawRectangleLinesEx( colorsRecs( i ), 6, Fade( BLACK, 0.3f ) )
        DrawText( colorNames( i ), colorsRecs( i ).x + colorsRecs( i ).width - MeasureText( colorNames( i ), 10 ) - 12, _
                  colorsRecs( i ).y + colorsRecs( i ).height - 20, 10, colors( i ) )
      end if
    next
  EndDrawing()
loop

'' De-Initialization
CloseWindow()
