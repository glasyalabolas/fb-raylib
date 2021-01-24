/'*******************************************************************************************
*
*   raylib [textures] example - Image loading and drawing on it
*
*   NOTE: Images are loaded in CPU memory (RAM); textures are loaded in GPU memory (VRAM)
*
*   This example has been created using raylib 1.4 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Copyright (c) 2016 Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [textures] example - image drawing" )

dim as Image cat = LoadImage( "resources/cat.png" )
ImageCrop( @cat, Rectangle( 100, 10, 280, 380 ) )      '' Crop an image piece
ImageFlipHorizontal( @cat )                            '' Flip cropped image horizontally
ImageResize( @cat, 150, 200 )                          '' Resize flipped-cropped image

dim as Image parrots = LoadImage( "resources/parrots.png" )

'' Draw one image over the other with a scaling of 1.5f
ImageDraw( @parrots, cat, Rectangle( 0, 0, cat.width, cat.height ), Rectangle( 30, 40, cat.width * 1.5f, cat.height * 1.5f ), WHITE )
ImageCrop( @parrots, Rectangle( 0, 50, parrots.width, parrots.height - 100 ) ) '' Crop resulting image

'' Draw on the image with a few image draw methods
ImageDrawPixel( @parrots, 10, 10, RAYWHITE )
ImageDrawCircle( @parrots, 10, 10, 5, RAYWHITE )
ImageDrawRectangle( @parrots, 5, 20, 10, 10, RAYWHITE )

UnloadImage( cat )

'' Load custom font for frawing on image
dim as Font font = LoadFont("resources/custom_jupiter_crash.png" )

'' Draw over image using custom font
ImageDrawTextEx( @parrots, font, "PARROTS & CAT", Vector2( 300, 230 ), font.baseSize, -2, WHITE )

UnloadFont( font )

dim as Texture2D texture = LoadTextureFromImage( parrots )
UnloadImage( parrots )

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
      
      DrawTexture( texture, screenWidth / 2 - texture.width / 2, screenHeight / 2 - texture.height / 2 - 40, WHITE )
      DrawRectangleLines( screenWidth / 2 - texture.width / 2, screenHeight / 2 - texture.height / 2 - 40, texture.width, texture.height, DARKGRAY )
      
      DrawText( "We are drawing only one texture from various images composed!", 240, 350, 10, DARKGRAY )
      DrawText( "Source images have been cropped, scaled, flipped and copied one over the other.", 190, 370, 10, DARKGRAY )
  EndDrawing()
loop

'' De-Initialization
UnloadTexture( texture )

CloseWindow()
