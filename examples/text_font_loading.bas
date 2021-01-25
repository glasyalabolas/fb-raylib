/'*******************************************************************************************
*
*   raylib [text] example - Font loading
*
*   raylib can load fonts from multiple file formats:
*
*     - TTF/OTF > Sprite font atlas is generated on loading, user can configure
*                 some of the generation parameters (size, characters to include)
*     - BMFonts > Angel code font fileformat, sprite font image must be provided
*                 together with the .fnt file, font generation cna not be configured
*     - XNA Spritefont > Sprite font image, following XNA Spritefont conventions,
*                 Characters in image must follow some spacing and order rules 
*
*   This example has been created using raylib 2.6 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Copyright (c) 2016-2019 Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [text] example - font loading" )

'' Define characters to draw
'' NOTE: raylib supports UTF-8 encoding, following list is actually codified as UTF8 internally
dim as string msg = "!\""#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHI\nJKLMNOPQRSTUVWXYZ[]^_`abcdefghijklmn\nopqrstuvwxyz{|}~¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏĞÑÒÓ\nÔÕÖ×ØÙÚÛÜİŞßàáâãäåæçèéêëìíîïğñòóôõö÷\nøùúûüışÿ"

'' NOTE: Textures/Fonts MUST be loaded after Window initialization (OpenGL context is required)

'' BMFont (AngelCode) : Font data and image atlas have been generated using external program
dim as Font fontBm = LoadFont( "resources/pixantiqua.fnt" )

'' TTF font : Font data and atlas are generated directly from TTF
'' NOTE: We define a font base size of 32 pixels tall and up-to 250 characters
dim as Font fontTtf = LoadFontEx( "resources/pixantiqua.ttf", 32, 0, 250 )

dim as boolean useTtf = false

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  if( IsKeyDown( KEY_SPACE ) ) then
    useTtf = true
  else
    useTtf = false
  end if
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    DrawText( "Hold SPACE to use TTF generated font", 20, 20, 20, LIGHTGRAY )
    
    if( not useTtf ) then
      DrawTextEx( fontBm, msg, Vector2( 20.0f, 100.0f ), fontBm.baseSize, 2, MAROON )
      DrawText( "Using BMFont (Angelcode) imported", 20, GetScreenHeight() - 30, 20, GRAY )
    else
      DrawTextEx( fontTtf, msg, Vector2( 20.0f, 100.0f ), fontTtf.baseSize, 2, LIME )
      DrawText( "Using TTF font generated", 20, GetScreenHeight() - 30, 20, GRAY )
    end if
  EndDrawing()
loop

'' De-Initialization
UnloadFont( fontBm )
UnloadFont( fontTtf )

CloseWindow()
