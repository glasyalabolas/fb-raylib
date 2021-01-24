/'*******************************************************************************************
*
*   raylib [texture] example - Image text drawing using TTF generated spritefont
*
*   This example has been created using raylib 1.8 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Copyright (c) 2017 Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [texture] example - image text drawing" )

dim as Image parrots = LoadImage( "resources/parrots.png" )

'' TTF Font loading with custom generation parameters
dim as Font font = LoadFontEx( "resources/KAISG.ttf", 64, 0, 0 )

'' Draw over image using custom font
ImageDrawTextEx( @parrots, font, "[Parrots font drawing]", Vector2( 20.0f, 20.0f ), font.baseSize, 0.0f, RAYRED )

dim as Texture2D texture = LoadTextureFromImage( parrots )
UnloadImage( parrots )

var position = Vector2( ( screenWidth / 2 - texture.width / 2 ), ( screenHeight / 2 - texture.height / 2 - 20 ) )

dim as boolean showFont = false

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  if( IsKeyDown( KEY_SPACE ) ) then
    showFont = true
  else
    showFont = false
  end if
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    if( not showFont ) then
      '' Draw texture with text already drawn inside
      DrawTextureV( texture, position, WHITE )
      
      '' Draw text directly using sprite font
      DrawTextEx( font, "[Parrots font drawing]", Vector2( position.x + 20, _
                 position.y + 20 + 280 ), font.baseSize, 0.0f, WHITE )
    else
      DrawTexture( font.texture, screenWidth / 2 - font.texture.width / 2, 50, BLACK )
    end if
    
    DrawText( "PRESS SPACE to SEE USED SPRITEFONT ", 290, 420, 10, DARKGRAY )
  EndDrawing()
loop

'' De-Initialization
UnloadTexture( texture )
UnloadFont( font )

CloseWindow()
