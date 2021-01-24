/'*******************************************************************************************
*
*   raylib [shaders] example - Sieve of Eratosthenes
*
*   Sieve of Eratosthenes, the earliest known (ancient Greek) prime number sieve.
*
*   "Sift the twos and sift the threes,
*    The Sieve of Eratosthenes.
*    When the multiples sublime,
*    the numbers that are left are prime."
*
*   NOTE: This example requires raylib OpenGL 3.3 or ES2 versions for shaders support,
*         OpenGL 1.1 does not support shaders, recompile raylib to OpenGL 3.3 version.
*
*   NOTE: Shaders used in this example are #version 330 (OpenGL 3.3).
*
*   This example has been created using raylib 2.5 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Example contributed by ProfJski and reviewed by Ramon Santamaria (@raysan5)
*
*   Copyright (c) 2019 ProfJski and Ramon Santamaria (@raysan5)
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

InitWindow( screenWidth, screenHeight, "raylib [shaders] example - Sieve of Eratosthenes" )

dim as RenderTexture2D target = LoadRenderTexture( screenWidth, screenHeight )

'' Load Eratosthenes shader
'' NOTE: Defining 0 (NULL) for vertex shader forces usage of internal default vertex shader
dim as Shader shader = LoadShader( 0, TextFormat( "resources/shaders/glsl%i/eratosthenes.fs", GLSL_VERSION ) )

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  ''----------------------------------------------------------------------------------
  '' Nothing to do here, everything is happening in the shader
  ''----------------------------------------------------------------------------------

  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    BeginTextureMode( target )
      ClearBackground( BLACK )
      
      '' Draw a rectangle in shader mode to be used as shader canvas
      '' NOTE: Rectangle uses font white character texture coordinates,
      '' so shader can not be applied here directly because input vertexTexCoord
      '' do not represent full screen coordinates (space where want to apply shader)
      DrawRectangle( 0, 0, GetScreenWidth(), GetScreenHeight(), BLACK )
    EndTextureMode()
    
    BeginShaderMode( shader )
      '' NOTE: Render texture must be y-flipped due to default OpenGL coordinates (left-bottom)
      DrawTextureRec( target.texture, Rectangle( 0, 0, target.texture.width, -target.texture.height ), Vector2( 0.0f, 0.0f ), WHITE )
    EndShaderMode()
  EndDrawing()
loop

'' De-Initialization
UnloadShader( shader )
UnloadRenderTexture( target )

CloseWindow()
