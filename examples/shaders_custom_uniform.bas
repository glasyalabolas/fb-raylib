/'*******************************************************************************************
*
*   raylib [shaders] example - Apply a postprocessing shader and connect a custom uniform variable
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

SetConfigFlags( FLAG_MSAA_4X_HINT )

InitWindow( screenWidth, screenHeight, "raylib [shaders] example - custom uniform variable" )

dim as Camera camera

with camera
  .position = Vector3( 8.0f, 8.0f, 8.0f )
  .target = Vector3( 0.0f, 1.5f, 0.0f )
  .up = Vector3( 0.0f, 1.0f, 0.0f )
  .fovy = 45.0f
  .type = CAMERA_PERSPECTIVE
end with

dim as Model model = LoadModel( "resources/models/barracks.obj" )
dim as Texture2D texture = LoadTexture( "resources/models/barracks_diffuse.png" )
model.materials[ 0 ].maps[ MAP_DIFFUSE ].texture = texture

dim as Vector3 position

'' Load postprocessing shader
'' NOTE: Defining 0 (NULL) for vertex shader forces usage of internal default vertex shader
dim as Shader shader = LoadShader( 0, TextFormat("resources/shaders/glsl%i/swirl.fs", GLSL_VERSION ) )

'' Get variable (uniform) location on the shader to connect with the program
'' NOTE: If uniform variable could not be found in the shader, function returns -1
dim as long swirlCenterLoc = GetShaderLocation( shader, "center" )

dim as single swirlCenter( 0 to 1 ) = { screenWidth / 2, screenHeight / 2 }

'' Create a RenderTexture2D to be used for render to texture
dim as RenderTexture2D target = LoadRenderTexture( screenWidth, screenHeight )

'' Setup orbital camera
SetCameraMode( camera, CAMERA_ORBITAL )

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  dim as Vector2 mousePosition = GetMousePosition()
  
  swirlCenter( 0 ) = mousePosition.x
  swirlCenter( 1 ) = screenHeight - mousePosition.y
  
  '' Send new value to the shader to be used on drawing
  SetShaderValue( shader, swirlCenterLoc, @swirlCenter( 0 ), UNIFORM_VEC2 )
  
  UpdateCamera( @camera )
  
  '' Draw
  BeginDrawing()
      ClearBackground( RAYWHITE )
      
      BeginTextureMode( target )
        ClearBackground( RAYWHITE )
        
        BeginMode3D( camera )
          DrawModel( model, position, 0.5f, WHITE )
          DrawGrid( 10, 1.0f )
        EndMode3D()
        
        DrawText( "TEXT DRAWN IN RENDER TEXTURE", 200, 10, 30, RAYRED )
      EndTextureMode() '' End drawing to texture (now we have a texture available for next passes)
      
      BeginShaderMode( shader )
        '' NOTE: Render texture must be y-flipped due to default OpenGL coordinates (left-bottom)
        DrawTextureRec( target.texture, Rectangle( 0, 0, target.texture.width, -target.texture.height ), Vector2( 0, 0 ), WHITE )
      EndShaderMode()
      
      '' Draw some 2d text over drawn texture
      DrawText( "(c) Barracks 3D model by Alberto Cano", screenWidth - 220, screenHeight - 20, 10, GRAY )
      
      DrawFPS( 10, 10 )
  EndDrawing()
loop

'' De-Initialization
UnloadShader( shader )
UnloadTexture( texture )
UnloadModel( model )
UnloadRenderTexture( target )

CloseWindow()
