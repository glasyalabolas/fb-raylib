/'*******************************************************************************************
*
*   raylib [textures] example - Image loading and texture creation
*
*   NOTE: Images are loaded in CPU memory (RAM); textures are loaded in GPU memory (VRAM)
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

InitWindow( screenWidth, screenHeight, "raylib [textures] example - image loading" )

dim as Image image = LoadImage( "resources/raylib_logo.png" )
dim as Texture2D texture = LoadTextureFromImage( image )

UnloadImage( image )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  ''----------------------------------------------------------------------------------
  '' TODO: Update your variables here
  ''----------------------------------------------------------------------------------

  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    DrawTexture( texture, screenWidth / 2 - texture.width / 2, screenHeight / 2 - texture.height / 2, WHITE )
    DrawText( "this IS a texture loaded from an image!", 300, 370, 10, GRAY )
  EndDrawing()
loop

'' De-Initialization
UnloadTexture( texture )

CloseWindow()
