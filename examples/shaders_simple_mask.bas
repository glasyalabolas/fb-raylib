/'*******************************************************************************************
*
*   raylib [shaders] example - Simple shader mask
*
*   This example has been created using raylib 2.5 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Example contributed by Chris Camacho (@chriscamacho) and reviewed by Ramon Santamaria (@raysan5)
*
*   Copyright (c) 2019 Chris Camacho (@chriscamacho) and Ramon Santamaria (@raysan5)
*
********************************************************************************************
*
*   After a model is loaded it has a default material, this material can be
*   modified in place rather than creating one from scratch...
*   While all of the maps have particular names, they can be used for any purpose
*   except for three maps that are applied as cubic maps (see below)
*
********************************************************************************************'/

#include once "../raylib.bi"
#include once "../raymath.bi"

#if defined( PLATFORM_DESKTOP )
  #define GLSL_VERSION            330
#else   '' PLATFORM_RPI, PLATFORM_ANDROID, PLATFORM_WEB
  #define GLSL_VERSION            100
#endif

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib - simple shader mask" )

'' Define the camera to look into our 3d world
dim as Camera camera

with camera
  .position = Vector3( 0.0f, 1.0f, 2.0f )
  .target = Vector3( 0.0f, 0.0f, 0.0f )
  .up = Vector3( 0.0f, 1.0f, 0.0f )
  .fovy = 45.0f
  .type = CAMERA_PERSPECTIVE
end with

'' Define our three models to show the shader on
dim as Mesh _
  torus = GenMeshTorus( .3, 1, 16, 32 ), _
  cube = GenMeshCube( .8, .8, .8 ), _
  sphere = GenMeshSphere( 1, 16, 16 )

dim as Model _
  model1 = LoadModelFromMesh( torus ), _
  model2 = LoadModelFromMesh( cube ), _
  model3 = LoadModelFromMesh( sphere )

'' Load the shader
dim as Shader shader = LoadShader( 0, TextFormat("resources/shaders/glsl%i/mask.fs", GLSL_VERSION ) )

'' Load and apply the diffuse texture (colour map)
dim as Texture texDiffuse = LoadTexture( "resources/plasma.png" )
model1.materials[ 0 ].maps[ MAP_DIFFUSE ].texture = texDiffuse
model2.materials[ 0 ].maps[ MAP_DIFFUSE ].texture = texDiffuse

'' Using MAP_EMISSION as a spare slot to use for 2nd texture
'' NOTE: Don't use MAP_IRRADIANCE, MAP_PREFILTER or  MAP_CUBEMAP as they are bound as cube maps
dim as Texture texMask = LoadTexture( "resources/mask.png" )
model1.materials[ 0 ].maps[ MAP_EMISSION ].texture = texMask
model2.materials[ 0 ].maps[ MAP_EMISSION ].texture = texMask
shader.locs[ LOC_MAP_EMISSION ] = GetShaderLocation( shader, "mask" )

'' Frame is incremented each frame to animate the shader
dim as long shaderFrame = GetShaderLocation( shader, "frame" )

'' Apply the shader to the two models
model1.materials[ 0 ].shader = shader
model2.materials[ 0 ].shader = shader

dim as long framesCounter = 0
dim as Vector3 rotation

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  framesCounter += 1
  rotation.x += 0.01f
  rotation.y += 0.005f
  rotation.z -= 0.0025f
  
  '' Send frames counter to shader for animation
  SetShaderValue( shader, shaderFrame, @framesCounter, UNIFORM_INT )
  
  '' Rotate one of the models
  model1.transform = MatrixRotateXYZ( rotation )

  UpdateCamera( @camera )
  
  '' Draw
  BeginDrawing()
    ClearBackground( DARKBLUE )
    
    BeginMode3D( camera )          
      DrawModel( model1, Vector3( 0.5, 0, 0 ), 1, WHITE )
      DrawModelEx( model2, Vector3( -.5,0,0 ), Vector3( 1, 1, 0 ), 50, Vector3( 1, 1, 1 ), WHITE )
      DrawModel( model3, Vector3( 0,0,-1.5 ), 1, WHITE )
      DrawGrid( 10, 1.0f )
    EndMode3D()
    
    DrawRectangle( 16, 698, MeasureText( TextFormat("Frame: %i", framesCounter ), 20 ) + 8, 42, RAYBLUE )
    DrawText( TextFormat( "Frame: %i", framesCounter ), 20, 700, 20, WHITE )
    
    DrawFPS( 10, 10 )
  EndDrawing()
loop

'' De-Initialization
UnloadModel( model1 )
UnloadModel( model2 )
UnloadModel( model3 )

UnloadTexture( texDiffuse )
UnloadTexture( texMask )

UnloadShader( shader )

CloseWindow()
