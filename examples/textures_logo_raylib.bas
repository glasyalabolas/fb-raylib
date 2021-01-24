/'*******************************************************************************************
*
*   raylib [textures] example - Texture loading and drawing
*
*   This example has been created using raylib 1.0 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Copyright (c) 2014 Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [textures] example - texture loading and drawing" )

dim as Texture2D texture = LoadTexture( "resources/raylib_logo.png" )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  ''----------------------------------------------------------------------------------
  '' TODO: Update your variables here
  ''----------------------------------------------------------------------------------
  
  '' Draw
  BeginDrawing()
    ClearBackground(RAYWHITE)
    
    DrawTexture( texture, screenWidth / 2 - texture.width / 2, screenHeight / 2 - texture.height / 2, WHITE )
    DrawText( "this IS a texture!", 360, 370, 10, GRAY )
  EndDrawing()
loop

'' De-Initialization
UnloadTexture( texture )

CloseWindow()
