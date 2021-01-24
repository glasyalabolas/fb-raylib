/'*******************************************************************************************
*
*   raylib [textures] example - Texture source and destination rectangles
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

InitWindow( screenWidth, screenHeight, "raylib [textures] examples - texture source and destination rectangles" )

dim as Texture2D scarfy = LoadTexture( "resources/scarfy.png" )

dim as long _
  frameWidth = scarfy.width / 6, _
  frameHeight = scarfy.height

'' Source rectangle (part of the texture to use for drawing)
var sourceRec = Rectangle( 0.0f, 0.0f, frameWidth, frameHeight )

'' Destination rectangle (screen rectangle where drawing part of texture)
var destRec = Rectangle( screenWidth / 2, screenHeight / 2, frameWidth * 2, frameHeight * 2 )

'' Origin of the texture (rotation/scale point), it's relative to destination rectangle size
var origin = Vector2( frameWidth, frameHeight )

dim as long rotation = 0

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  rotation += 1
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    '' NOTE: Using DrawTexturePro() we can easily rotate and scale the part of the texture we draw
    '' sourceRec defines the part of the texture we use for drawing
    '' destRec defines the rectangle where our texture part will fit (scaling it to fit)
    '' origin defines the point of the texture used as reference for rotation and scaling
    '' rotation defines the texture rotation (using origin as rotation point)
    DrawTexturePro( scarfy, sourceRec, destRec, origin, rotation, WHITE )
    
    DrawLine( destRec.x, 0, destRec.x, screenHeight, GRAY )
    DrawLine(0, destRec.y, screenWidth, destRec.y, GRAY )
    
    DrawText( "(c) Scarfy sprite by Eiden Marsal", screenWidth - 200, screenHeight - 20, 10, GRAY )
  EndDrawing()
loop

'' De-Initialization
UnloadTexture( scarfy )

CloseWindow()
