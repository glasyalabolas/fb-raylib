/'*******************************************************************************************
*
*   raylib [textures] example - Texture drawing
*
*   This example illustrates how to draw on a blank texture using a shader
*
*   This example has been created using raylib 2.0 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Example contributed by Michal Ciesielski and reviewed by Ramon Santamaria (@raysan5)
*
*   Copyright (c) 2019 Michal Ciesielski and Ramon Santamaria (@raysan5)
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

InitWindow( screenWidth, screenHeight, "raylib [shaders] example - texture drawing" )

dim as Image imBlank = GenImageColor( 1024, 1024, BLANK )
dim as Texture2D texture = LoadTextureFromImage( imBlank )
UnloadImage( imBlank )

'' NOTE: Using GLSL 330 shader version, on OpenGL ES 2.0 use GLSL 100 shader version
dim as Shader shader = LoadShader( 0, TextFormat( "resources/shaders/glsl%i/cubes_panning.fs", GLSL_VERSION ) )

dim as single time_ = 0.0f
dim as long timeLoc = GetShaderLocation( shader, "uTime" )
SetShaderValue( shader, timeLoc, @time_, UNIFORM_FLOAT )

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  time_ = GetTime()
  SetShaderValue( shader, timeLoc, @time_, UNIFORM_FLOAT )

  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    BeginShaderMode( shader )
      DrawTexture( texture, 0, 0, WHITE )
    EndShaderMode()
    
    DrawText( "BACKGROUND is PAINTED and ANIMATED on SHADER!", 10, 10, 20, MAROON )
  EndDrawing()
loop

'' De-Initialization
UnloadShader( shader )

CloseWindow()
