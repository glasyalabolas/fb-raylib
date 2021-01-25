/'*******************************************************************************************
*
*   raylib [shaders] example - Texture Waves
*
*   NOTE: This example requires raylib OpenGL 3.3 or ES2 versions for shaders support,
*         OpenGL 1.1 does not support shaders, recompile raylib to OpenGL 3.3 version.
*
*   NOTE: Shaders used in this example are #version 330 (OpenGL 3.3), to test this example
*         on OpenGL ES 2.0 platforms (Android, Raspberry Pi, HTML5), use #version 100 shaders
*         raylib comes with shaders ready for both versions, check raylib/shaders install folder
*
*   This example has been created using raylib 2.5 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Example contributed by Anata (@anatagawa) and reviewed by Ramon Santamaria (@raysan5)
*
*   Copyright (c) 2019 Anata (@anatagawa) and Ramon Santamaria (@raysan5)
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

InitWindow( screenWidth, screenHeight, "raylib [shaders] example - texture waves" )

'' Load texture texture to apply shaders
dim as Texture2D texture = LoadTexture( "resources/space.png" )

'' Load shader and setup location points and values
dim as Shader shader = LoadShader( 0, TextFormat( "resources/shaders/glsl%i/wave.fs", GLSL_VERSION ) )

dim as long _
  secondsLoc = GetShaderLocation( shader, "secondes" ), _
  freqXLoc = GetShaderLocation( shader, "freqX" ), _
  freqYLoc = GetShaderLocation( shader, "freqY" ), _
  ampXLoc = GetShaderLocation( shader, "ampX" ), _
  ampYLoc = GetShaderLocation( shader, "ampY" ), _
  speedXLoc = GetShaderLocation( shader, "speedX" ), _
  speedYLoc = GetShaderLocation( shader, "speedY" )

'' Shader uniform values that can be updated at any time
dim as single _
  freqX = 25.0f, freqY = 25.0f, ampX = 5.0f, ampY = 5.0f, speedX = 8.0f, speedY = 8.0f

dim as single screenSize( ... ) = { GetScreenWidth(), GetScreenHeight() }

SetShaderValue( shader, GetShaderLocation( shader, "size" ), @screenSize( 0 ), UNIFORM_VEC2 )
SetShaderValue( shader, freqXLoc, @freqX, UNIFORM_FLOAT )
SetShaderValue( shader, freqYLoc, @freqY, UNIFORM_FLOAT )
SetShaderValue( shader, ampXLoc, @ampX, UNIFORM_FLOAT )
SetShaderValue( shader, ampYLoc, @ampY, UNIFORM_FLOAT )
SetShaderValue( shader, speedXLoc, @speedX, UNIFORM_FLOAT )
SetShaderValue( shader, speedYLoc, @speedY, UNIFORM_FLOAT )

dim as single seconds = 0.0f

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  seconds += GetFrameTime()
  
  SetShaderValue( shader, secondsLoc, @seconds, UNIFORM_FLOAT )
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    BeginShaderMode( shader )
      DrawTexture( texture, 0, 0, WHITE )
      DrawTexture( texture, texture.width, 0, WHITE )
    EndShaderMode()
  EndDrawing()
loop

'' De-Initialization
UnloadShader( shader )
UnloadTexture( texture )

CloseWindow()
