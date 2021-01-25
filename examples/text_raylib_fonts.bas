/'*******************************************************************************************
*
*   raylib [text] example - raylib font loading and usage
*
*   NOTE: raylib is distributed with some free to use fonts (even for commercial pourposes!)
*         To view details and credits for those fonts, check raylib license file
*
*   This example has been created using raylib 1.7 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Copyright (c) 2017 Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"

#define MAX_FONTS   8

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [text] example - raylib fonts" )

'' NOTE: Textures MUST be loaded after Window initialization (OpenGL context is required)
dim as Font fonts( 0 to MAX_FONTS - 1 )

fonts( 0 ) = LoadFont( "resources/fonts/alagard.png" )
fonts( 1 ) = LoadFont( "resources/fonts/pixelplay.png" )
fonts( 2 ) = LoadFont( "resources/fonts/mecha.png" )
fonts( 3 ) = LoadFont( "resources/fonts/setback.png" )
fonts( 4 ) = LoadFont( "resources/fonts/romulus.png" )
fonts( 5 ) = LoadFont( "resources/fonts/pixantiqua.png" )
fonts( 6 ) = LoadFont( "resources/fonts/alpha_beta.png" )
fonts( 7 ) = LoadFont( "resources/fonts/jupiter_crash.png" )

dim as const string messages( 0 to MAX_FONTS - 1 ) = _
  { "ALAGARD FONT designed by Hewett Tsoi", _
    "PIXELPLAY FONT designed by Aleksander Shevchuk", _
    "MECHA FONT designed by Captain Falcon", _
    "SETBACK FONT designed by Brian Kent (AEnigma)", _
    "ROMULUS FONT designed by Hewett Tsoi", _
    "PIXANTIQUA FONT designed by Gerhard Grossmann", _
    "ALPHA_BETA FONT designed by Brian Kent (AEnigma)", _
    "JUPITER_CRASH FONT designed by Brian Kent (AEnigma)" }

dim as const long spacings( 0 to MAX_FONTS - 1 ) = { 2, 4, 8, 4, 3, 4, 4, 1 }

dim as Vector2 positions( 0 to MAX_FONTS - 1 )

for i as integer = 0 to MAX_FONTS - 1
  positions( i ).x = screenWidth / 2 - MeasureTextEx( fonts( i ), messages( i ), fonts( i ).baseSize * 2, spacings( i ) ).x / 2
  positions( i ).y = 60 + fonts( i ).baseSize + 45 * i
next

'' Small Y position corrections
positions( 3 ).y += 8
positions( 4 ).y += 2
positions( 7 ).y -= 8

dim as RayColor colors( ... ) = { MAROON, ORANGE, DARKGREEN, DARKBLUE, DARKPURPLE, LIME, GOLD, RAYRED }

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  ''----------------------------------------------------------------------------------
  '' TODO: Update your variables here
  ''----------------------------------------------------------------------------------
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    DrawText( "free fonts included with raylib", 250, 20, 20, DARKGRAY )
    DrawLine( 220, 50, 590, 50, DARKGRAY )
    
    for i as integer = 0 to MAX_FONTS - 1
      DrawTextEx( fonts( i ), messages( i ), positions( i ), fonts( i ).baseSize * 2, spacings( i ), colors( i ) )
    next
  EndDrawing()
loop

'' De-Initialization

'' Fonts unloading
for i as integer = 0 to MAX_FONTS - 1
  UnloadFont( fonts( i ) )
next

CloseWindow()
