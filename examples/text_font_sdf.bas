/'*******************************************************************************************
*
*   raylib [text] example - TTF loading and usage
*
*   This example has been created using raylib 1.3.0 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Copyright (c) 2015 Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"

#if defined( PLATFORM_DESKTOP )
  #define GLSL_VERSION            330
#else   '' PLATFORM_RPI, PLATFORM_ANDROID, PLATFORM_WEB
  #define GLSL_VERSION            100
#endif

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [text] example - SDF fonts" )

'' NOTE: Textures/Fonts MUST be loaded after Window initialization (OpenGL context is required)

dim as string msg = "Signed Distance Fields"

'' Loading file to memory
dim as ulong fileSize = 0
dim as ubyte ptr fileData = LoadFileData( "resources/anonymouspro-bold.ttf", @fileSize )

'' Default font generation from TTF font
dim as Font fontDefault

fontDefault.baseSize = 16
fontDefault.charsCount = 95

'' Loading font data from memory data
'' Parameters > font size: 16, no chars array provided (0), chars count: 95 (autogenerate chars array)
fontDefault.chars = LoadFontData( fileData, fileSize, 16, 0, 95, FONT_DEFAULT )
'' Parameters > chars count: 95, font size: 16, chars padding in image: 4 px, pack method: 0 (default)
dim as Image atlas = GenImageFontAtlas( fontDefault.chars, @fontDefault.recs, 95, 16, 4, 0 )
fontDefault.texture = LoadTextureFromImage( atlas )
UnloadImage( atlas )

'' SDF font generation from TTF font
dim as Font fontSDF
fontSDF.baseSize = 16
fontSDF.charsCount = 95
'' Parameters > font size: 16, no chars array provided (0), chars count: 0 (defaults to 95)
fontSDF.chars = LoadFontData( fileData, fileSize, 16, 0, 0, FONT_SDF )
'' Parameters > chars count: 95, font size: 16, chars padding in image: 0 px, pack method: 1 (Skyline algorythm)
atlas = GenImageFontAtlas( fontSDF.chars, @fontSDF.recs, 95, 16, 0, 1 )
fontSDF.texture = LoadTextureFromImage( atlas )
UnloadImage( atlas )

UnloadFileData( fileData )

'' Load SDF required shader (we use default vertex shader)
dim as Shader shader = LoadShader( 0, TextFormat( "resources/shaders/glsl%i/sdf.fs", GLSL_VERSION ) )
SetTextureFilter( fontSDF.texture, FILTER_BILINEAR )    '' Required for SDF font

var fontPosition = Vector2( 40, screenHeight / 2 - 50 )
dim as Vector2 textSize
dim as single fontSize = 16.0f
dim as long currentFont = 0            '' 0 - fontDefault, 1 - fontSDF

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  fontSize += GetMouseWheelMove() * 8.0f
  
  if( fontSize < 6 ) then fontSize = 6
  
  if( IsKeyDown( KEY_SPACE ) ) then
    currentFont = 1
  else
    currentFont = 0
  end if
  
  if( currentFont = 0) then
    textSize = MeasureTextEx( fontDefault, msg, fontSize, 0 )
  else
    textSize = MeasureTextEx( fontSDF, msg, fontSize, 0 )
  end if
  
  fontPosition.x = GetScreenWidth() / 2 - textSize.x / 2
  fontPosition.y = GetScreenHeight() / 2 - textSize.y / 2 + 80
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    if( currentFont = 1 ) then
      '' NOTE: SDF fonts require a custom SDf shader to compute fragment color
      BeginShaderMode( shader )
        DrawTextEx( fontSDF, msg, fontPosition, fontSize, 0, BLACK )
      EndShaderMode()
      
      DrawTexture(fontSDF.texture, 10, 10, BLACK)
    else
      DrawTextEx( fontDefault, msg, fontPosition, fontSize, 0, BLACK )
      DrawTexture( fontDefault.texture, 10, 10, BLACK )
    end if
    
    if( currentFont = 1 ) then
      DrawText( "SDF!", 320, 20, 80, RAYRED )
    else
      DrawText( "default font", 315, 40, 30, GRAY )
    end if
    
    DrawText( "FONT SIZE: 16.0", GetScreenWidth() - 240, 20, 20, DARKGRAY )
    DrawText( TextFormat( "RENDER SIZE: %02.02f", fontSize ), GetScreenWidth() - 240, 50, 20, DARKGRAY )
    DrawText( "Use MOUSE WHEEL to SCALE TEXT!", GetScreenWidth() - 240, 90, 10, DARKGRAY )
    
    DrawText( "HOLD SPACE to USE SDF FONT VERSION!", 340, GetScreenHeight() - 30, 20, MAROON )
  EndDrawing()
loop

'' De-Initialization
UnloadFont( fontDefault )
UnloadFont( fontSDF )

UnloadShader( shader )

CloseWindow()
