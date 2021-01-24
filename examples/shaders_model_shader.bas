/'*******************************************************************************************
*
*   raylib [shaders] example - Apply a shader to a 3d model
*
*   NOTE: This example requires raylib OpenGL 3.3 or ES2 versions for shaders support,
*         OpenGL 1.1 does not support shaders, recompile raylib to OpenGL 3.3 version.
*
*   NOTE: Shaders used in this example are #version 330 (OpenGL 3.3), to test this example
*         on OpenGL ES 2.0 platforms (Android, Raspberry Pi, HTML5), use #version 100 shaders
*         raylib comes with shaders ready for both versions, check raylib/shaders install folder
*
*   This example has been created using raylib 1.3 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Copyright (c) 2014 Ramon Santamaria (@raysan5)
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

SetConfigFlags( FLAG_MSAA_4X_HINT )

InitWindow( screenWidth, screenHeight, "raylib [shaders] example - model shader" )

dim as Camera camera

with camera
  .position = Vector3( 4.0f, 4.0f, 4.0f )
  .target = Vector3( 0.0f, 1.0f, -1.0f )
  .up = Vector3( 0.0f, 1.0f, 0.0f )
  .fovy = 45.0f
  .type = CAMERA_PERSPECTIVE
end with

dim as Model model = LoadModel( "resources/models/watermill.obj" )
dim as Texture2D texture = LoadTexture( "resources/models/watermill_diffuse.png" )

'' Load shader for model
'' NOTE: Defining 0 (NULL) for vertex shader forces usage of internal default vertex shader
dim as Shader shader = LoadShader( 0, TextFormat( "resources/shaders/glsl%i/grayscale.fs", GLSL_VERSION ) )

model.materials[ 0 ].shader = shader                       '' Set shader effect to 3d model
model.materials[ 0 ].maps[ MAP_DIFFUSE ].texture = texture '' Bind texture to model

dim as Vector3 position

SetCameraMode( camera, CAMERA_FREE )

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  UpdateCamera( @camera )
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    BeginMode3D( camera )
      DrawModel( model, position, 0.2f, WHITE )
      DrawGrid( 10, 1.0f )
    EndMode3D()
    
    DrawText( "(c) Watermill 3D model by Alberto Cano", screenWidth - 210, screenHeight - 20, 10, GRAY )
    
    DrawFPS( 10, 10 )
  EndDrawing()
loop

'' De-Initialization
UnloadShader( shader )
UnloadTexture( texture )
UnloadModel( model )

CloseWindow()
