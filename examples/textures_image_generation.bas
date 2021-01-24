/'*******************************************************************************************
*
*   raylib [textures] example - Procedural images generation
*
*   This example has been created using raylib 1.8 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Copyright (c) 2O17 Wilhem Barbier (@nounoursheureux)
*
********************************************************************************************'/

#include once "../raylib.bi"

#define NUM_TEXTURES  7      '' Currently we have 7 generation algorithms

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [textures] example - procedural images generation" )

dim as Image _
  verticalGradient = GenImageGradientV( screenWidth, screenHeight, RAYRED, RAYBLUE ), _
  horizontalGradient = GenImageGradientH( screenWidth, screenHeight, RAYRED, RAYBLUE ), _
  radialGradient = GenImageGradientRadial( screenWidth, screenHeight, 0.0f, WHITE, BLACK ), _
  checked = GenImageChecked( screenWidth, screenHeight, 32, 32, RAYRED, RAYBLUE ), _
  whiteNoise = GenImageWhiteNoise( screenWidth, screenHeight, 0.5f ), _
  perlinNoise = GenImagePerlinNoise( screenWidth, screenHeight, 50, 50, 4.0f ), _
  cellular = GenImageCellular( screenWidth, screenHeight, 32 )

dim as Texture2D textures( 0 to NUM_TEXTURES - 1 )

textures( 0 ) = LoadTextureFromImage( verticalGradient )
textures( 1 ) = LoadTextureFromImage( horizontalGradient )
textures( 2 ) = LoadTextureFromImage( radialGradient )
textures( 3 ) = LoadTextureFromImage( checked )
textures( 4 ) = LoadTextureFromImage( whiteNoise )
textures( 5 ) = LoadTextureFromImage( perlinNoise )
textures( 6 ) = LoadTextureFromImage( cellular )

'' Unload image data (CPU RAM)
UnloadImage( verticalGradient )
UnloadImage( horizontalGradient )
UnloadImage( radialGradient )
UnloadImage( checked )
UnloadImage( whiteNoise )
UnloadImage( perlinNoise )
UnloadImage( cellular )

dim as long currentTexture = 0

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  if( IsMouseButtonPressed( MOUSE_LEFT_BUTTON ) orElse IsKeyPressed( KEY_RIGHT ) ) then
    currentTexture = ( currentTexture + 1 ) mod NUM_TEXTURES '' Cycle between the textures
  end if

  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    DrawTexture( textures( currentTexture ), 0, 0, WHITE )
    
    DrawRectangle( 30, 400, 325, 30, Fade( SKYBLUE, 0.5f ) )
    DrawRectangleLines( 30, 400, 325, 30, Fade( WHITE, 0.5f ) )
    DrawText( "MOUSE LEFT BUTTON to CYCLE PROCEDURAL TEXTURES", 40, 410, 10, WHITE )
    
    select case as const( currentTexture )
        case 0 : DrawText( "VERTICAL GRADIENT", 560, 10, 20, RAYWHITE )
        case 1 : DrawText( "HORIZONTAL GRADIENT", 540, 10, 20, RAYWHITE )
        case 2 : DrawText( "RADIAL GRADIENT", 580, 10, 20, LIGHTGRAY )
        case 3 : DrawText( "CHECKED", 680, 10, 20, RAYWHITE )
        case 4 : DrawText( "WHITE NOISE", 640, 10, 20, RAYRED )
        case 5 : DrawText( "PERLIN NOISE", 630, 10, 20, RAYWHITE )
        case 6 : DrawText( "CELLULAR", 670, 10, 20, RAYWHITE )
    end select
  EndDrawing()
loop

'' De-Initialization

'' Unload textures data (GPU VRAM)
for i as integer = 0 to NUM_TEXTURES - 1
  UnloadTexture( textures( i ) )
next

CloseWindow()
