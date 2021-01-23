/'*******************************************************************************************
*
*   raylib [textures] example - Background scrolling
*
*   This example has been created using raylib 2.0 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Copyright (c) 2019 Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [textures] example - background scrolling" )

'' NOTE: Be careful, background width must be equal or bigger than screen width
'' if not, texture should be draw more than two times for scrolling effect
dim as Texture2D _
  background = LoadTexture( "resources/cyberpunk_street_background.png" ), _
  midground = LoadTexture( "resources/cyberpunk_street_midground.png" ), _
  foreground = LoadTexture( "resources/cyberpunk_street_foreground.png" )

dim as single _
  scrollingBack = 0.0f, scrollingMid = 0.0f, scrollingFore = 0.0f

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  scrollingBack -= 0.1f
  scrollingMid -= 0.5f
  scrollingFore -= 1.0f

  '' NOTE: Texture is scaled twice its size, so it sould be considered on scrolling
  if( scrollingBack <= -background.width * 2) then scrollingBack = 0
  if( scrollingMid <= -midground.width * 2 ) then scrollingMid = 0
  if( scrollingFore <= -foreground.width * 2 ) then scrollingFore = 0
  
  '' Draw
  BeginDrawing()
    ClearBackground( GetColor( &h052c46ff ) )
    
    '' Draw background image twice
    '' NOTE: Texture is scaled twice its size
    DrawTextureEx( background, Vector2( scrollingBack, 20 ), 0.0f, 2.0f, WHITE )
    DrawTextureEx( background, Vector2( background.width * 2 + scrollingBack, 20 ), 0.0f, 2.0f, WHITE )
    
    '' Draw midground image twice
    DrawTextureEx( midground, Vector2( scrollingMid, 20 ), 0.0f, 2.0f, WHITE )
    DrawTextureEx( midground, Vector2( midground.width * 2 + scrollingMid, 20 ), 0.0f, 2.0f, WHITE )
    
    '' Draw foreground image twice
    DrawTextureEx( foreground, Vector2( scrollingFore, 70 ), 0.0f, 2.0f, WHITE )
    DrawTextureEx( foreground, Vector2( foreground.width * 2 + scrollingFore, 70 ), 0.0f, 2.0f, WHITE )
    
    DrawText( "BACKGROUND SCROLLING & PARALLAX", 10, 10, 20, RAYRED )
    DrawText( "(c) Cyberpunk Street Environment by Luis Zuno (@ansimuz)", screenWidth - 330, screenHeight - 20, 10, RAYWHITE )
  EndDrawing()
loop

'' De-Initialization
UnloadTexture( background )
UnloadTexture( midground )
UnloadTexture( foreground )

CloseWindow()
