/'*******************************************************************************************
*
*   raylib [shaders] example - Hot reloading
*
*   NOTE: This example requires raylib OpenGL 3.3 for shaders support and only #version 330
*         is currently supported. OpenGL ES 2.0 platforms are not supported at the moment.
*
*   This example has been created using raylib 3.0 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Copyright (c) 2020 Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"

#include once "crt.bi"'<time.h>       // Required for: localtime(), asctime()

#if defined( PLATFORM_DESKTOP )
  #define GLSL_VERSION            330
#else   '' PLATFORM_RPI, PLATFORM_ANDROID, PLATFORM_WEB
  #define GLSL_VERSION            100
#endif

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [shaders] example - hot reloading" )

dim as string fragShaderFileName = "resources/shaders/glsl%i/reload.fs"
dim as time_t fragShaderFileModTime = GetFileModTime( TextFormat( fragShaderFileName, GLSL_VERSION ) )

'' Load raymarching shader
'' NOTE: Defining 0 (NULL) for vertex shader forces usage of internal default vertex shader
dim as Shader shader = LoadShader( 0, TextFormat( fragShaderFileName, GLSL_VERSION ) )

'' Get shader locations for required uniforms
dim as long _
  resolutionLoc = GetShaderLocation( shader, "resolution" ), _
  mouseLoc = GetShaderLocation( shader, "mouse" ), _
  timeLoc = GetShaderLocation( shader, "time" )

dim as single resolution( 0 to 1 ) = { screenWidth, screenHeight }
SetShaderValue( shader, resolutionLoc, @resolution( 0 ), UNIFORM_VEC2 )

dim as single totalTime = 0.0f
dim as boolean shaderAutoReloading = false

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  totalTime += GetFrameTime()
  dim as Vector2 mouse = GetMousePosition()
  dim as single mousePos( 0 to 1 ) = { mouse.x, mouse.y }
  
  '' Set shader required uniform values
  SetShaderValue( shader, timeLoc, @totalTime, UNIFORM_FLOAT )
  SetShaderValue( shader, mouseLoc, @mousePos( 0 ), UNIFORM_VEC2 )
  
  '' Hot shader reloading
  if( shaderAutoReloading orElse ( IsMouseButtonPressed( MOUSE_LEFT_BUTTON ) ) ) then
    dim as time_t currentFragShaderModTime = GetFileModTime( TextFormat( fragShaderFileName, GLSL_VERSION ) )
    
    '' Check if shader file has been modified
    if( currentFragShaderModTime <> fragShaderFileModTime ) then
      '' Try reloading updated shader
      dim as Shader updatedShader = LoadShader( 0, TextFormat( fragShaderFileName, GLSL_VERSION ) )
      
      if( updatedShader.id <> GetShaderDefault().id ) then     '' It was correctly loaded
        UnloadShader( shader )
        shader = updatedShader
        
        '' Get shader locations for required uniforms
        resolutionLoc = GetShaderLocation( shader, "resolution" )
        mouseLoc = GetShaderLocation( shader, "mouse" )
        timeLoc = GetShaderLocation( shader, "time" )
        
        '' Reset required uniforms
        SetShaderValue( shader, resolutionLoc, @resolution( 0 ), UNIFORM_VEC2 )
      end if
      
      fragShaderFileModTime = currentFragShaderModTime
    end if
  end if
  
  if( IsKeyPressed( KEY_A ) ) then shaderAutoReloading xor= true
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    '' We only draw a white full-screen rectangle, frame is generated in shader
    BeginShaderMode( shader )
      DrawRectangle( 0, 0, screenWidth, screenHeight, WHITE )
    EndShaderMode()
    
    DrawText( TextFormat( "PRESS [A] to TOGGLE SHADER AUTOLOADING: %s", _
              iif( shaderAutoReloading, "AUTO", "MANUAL" ) ), 10, 10, 10, iif( shaderAutoReloading, RAYRED, BLACK ) )
    if( not shaderAutoReloading ) then DrawText( "MOUSE CLICK to SHADER RE-LOADING", 10, 30, 10, BLACK )
    
    DrawText( TextFormat( "Shader last modification: %s", asctime( localtime( @fragShaderFileModTime ) ) ), 10, 430, 10, BLACK )
  EndDrawing()
loop

'' De-Initialization
UnloadShader( shader )

CloseWindow()
