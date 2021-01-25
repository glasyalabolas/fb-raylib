/'*******************************************************************************************
*
*   raylib [shaders] example - Raymarching shapes generation
*
*   NOTE: This example requires raylib OpenGL 3.3 for shaders support and only #version 330
*         is currently supported. OpenGL ES 2.0 platforms are not supported at the moment.
*
*   This example has been created using raylib 2.0 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Copyright (c) 2018 Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"

#if defined( PLATFORM_DESKTOP )
  #define GLSL_VERSION            330
#else   '' PLATFORM_RPI, PLATFORM_ANDROID, PLATFORM_WEB -> Not supported at this moment
  #define GLSL_VERSION            100
#endif

'' Initialization
dim as long _
  screenWidth = 800, screenHeight = 450

SetConfigFlags( FLAG_WINDOW_RESIZABLE )
InitWindow( screenWidth, screenHeight, "raylib [shaders] example - raymarching shapes" )

dim as Camera camera

with camera
  .position = Vector3( 2.5f, 2.5f, 3.0f )
  .target = Vector3( 0.0f, 0.0f, 0.7f )
  .up = Vector3( 0.0f, 1.0f, 0.0f )
  .fovy = 65.0f
end with

SetCameraMode( camera, CAMERA_FREE )

'' Load raymarching shader
dim as Shader shader = LoadShader( 0, TextFormat( "resources/shaders/glsl%i/raymarching.fs", GLSL_VERSION ) )

'' Get shader locations for required uniforms
dim as long _
  viewEyeLoc = GetShaderLocation( shader, "viewEye" ), _
  viewCenterLoc = GetShaderLocation( shader, "viewCenter" ), _
  runTimeLoc = GetShaderLocation( shader, "runTime" ), _
  resolutionLoc = GetShaderLocation( shader, "resolution" )

dim as single resolution( ... ) = { screenWidth, screenHeight }
SetShaderValue( shader, resolutionLoc, @resolution( 0 ), UNIFORM_VEC2 )

dim as single runTime = 0.0f

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  UpdateCamera( @camera )

  dim as single _
    cameraPos( ... ) = { camera.position.x, camera.position.y, camera.position.z }, _
    cameraTarget( ... ) = { camera.target.x, camera.target.y, camera.target.z }
  
  dim as single deltaTime = GetFrameTime()
  runTime += deltaTime
  
  '' Set shader required uniform values
  SetShaderValue( shader, viewEyeLoc, @cameraPos( 0 ), UNIFORM_VEC3 )
  SetShaderValue( shader, viewCenterLoc, @cameraTarget( 0 ), UNIFORM_VEC3 )
  SetShaderValue( shader, runTimeLoc, @runTime, UNIFORM_FLOAT )
  
  '' Check if screen is resized
  if( IsWindowResized() ) then
    screenWidth = GetScreenWidth()
    screenHeight = GetScreenHeight()
    dim as single resolution( ... ) = { screenWidth, screenHeight }
    SetShaderValue( shader, resolutionLoc, @resolution( 0 ), UNIFORM_VEC2)
  end if
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    '' We only draw a white full-screen rectangle,
    '' frame is generated in shader using raymarching
    BeginShaderMode( shader )
      DrawRectangle( 0, 0, screenWidth, screenHeight, WHITE )
    EndShaderMode()
    
    DrawText( "(c) Raymarching shader by Iñigo Quilez. MIT License.", screenWidth - 280, screenHeight - 20, 10, BLACK )
  EndDrawing()
loop

'' De-Initialization
UnloadShader( shader )

CloseWindow()
