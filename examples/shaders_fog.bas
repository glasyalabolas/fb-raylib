/'*******************************************************************************************
*
*   raylib [shaders] example - fog
*
*   NOTE: This example requires raylib OpenGL 3.3 or ES2 versions for shaders support,
*         OpenGL 1.1 does not support shaders, recompile raylib to OpenGL 3.3 version.
*
*   NOTE: Shaders used in this example are #version 330 (OpenGL 3.3).
*
*   This example has been created using raylib 2.5 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Example contributed by Chris Camacho (@chriscamacho) and reviewed by Ramon Santamaria (@raysan5)
*
*   Chris Camacho (@chriscamacho -  http://bedroomcoders.co.uk/) notes:
*
*   This is based on the PBR lighting example, but greatly simplified to aid learning...
*   actually there is very little of the PBR example left!
*   When I first looked at the bewildering complexity of the PBR example I feared
*   I would never understand how I could do simple lighting with raylib however its
*   a testement to the authors of raylib (including rlights.h) that the example
*   came together fairly quickly.
*
*   Copyright (c) 2019 Chris Camacho (@chriscamacho) and Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"
#include once "../raymath.bi"

#define RLIGHTS_IMPLEMENTATION
#include "../rlights.bi"

#if defined( PLATFORM_DESKTOP )
  #define GLSL_VERSION            330
#else   '' PLATFORM_RPI, PLATFORM_ANDROID, PLATFORM_WEB
  #define GLSL_VERSION            100
#endif

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

SetConfigFlags( FLAG_MSAA_4X_HINT )
InitWindow( screenWidth, screenHeight, "raylib [shaders] example - fog" )

'' Define the camera to look into our 3d world
dim as Camera camera

with camera
  .position = Vector3( 2.0f, 2.0f, 6.0f )
  .target = Vector3( 0.0f, 0.5f, 0.0f )
  .up = Vector3( 0.0f, 1.0f, 0.0f )
  .fovy = 45.0f
  .type = CAMERA_PERSPECTIVE
end with

'' Load models and texture
dim as Model _
  modelA = LoadModelFromMesh( GenMeshTorus( 0.4f, 1.0f, 16, 32 ) ), _
  modelB = LoadModelFromMesh( GenMeshCube( 1.0f, 1.0f, 1.0f ) ), _
  modelC = LoadModelFromMesh( GenMeshSphere( 0.5f, 32, 32 ) )

dim as Texture texture = LoadTexture( "resources/texel_checker.png" )

'' Assign texture to default model material
modelA.materials[ 0 ].maps[ MAP_DIFFUSE ].texture = texture
modelB.materials[ 0 ].maps[ MAP_DIFFUSE ].texture = texture
modelC.materials[ 0 ].maps[ MAP_DIFFUSE ].texture = texture

'' Load shader and set up some uniforms
dim as Shader shader = LoadShader( _
  TextFormat( "resources/shaders/glsl%i/base_lighting.vs", GLSL_VERSION ), _ 
  TextFormat( "resources/shaders/glsl%i/fog.fs", GLSL_VERSION ) )

shader.locs[ LOC_MATRIX_MODEL ] = GetShaderLocation( shader, "matModel" )
shader.locs[ LOC_VECTOR_VIEW ] = GetShaderLocation( shader, "viewPos" )

'' Ambient light level
dim as long ambientLoc = GetShaderLocation( shader, "ambient" )
dim as single ambientValues( ... ) = { 0.2f, 0.2f, 0.2f, 1.0f }
SetShaderValue(shader, ambientLoc, @ambientValues( 0 ), UNIFORM_VEC4 )

dim as single fogDensity = 0.15f
dim as long fogDensityLoc = GetShaderLocation( shader, "fogDensity" )
SetShaderValue( shader, fogDensityLoc, @fogDensity, UNIFORM_FLOAT )

'' NOTE: All models share the same shader
modelA.materials[ 0 ].shader = shader
modelB.materials[ 0 ].shader = shader
modelC.materials[ 0 ].shader = shader

'' Using just 1 point lights
CreateLight( LIGHT_POINT, Vector3( 0, 2, 6 ), Vector3Zero(), WHITE, shader )

SetCameraMode( camera, CAMERA_ORBITAL )

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
    '' Update
    UpdateCamera( @camera )
    
    if( IsKeyDown( KEY_UP ) ) then
      fogDensity += 0.001
      if( fogDensity > 1.0 ) then fogDensity = 1.0
    end if
    
    if( IsKeyDown( KEY_DOWN ) ) then
      fogDensity -= 0.001
      if( fogDensity < 0.0 ) then fogDensity = 0.0
    end if
    
    SetShaderValue( shader, fogDensityLoc, @fogDensity, UNIFORM_FLOAT )
    
    '' Rotate the torus
    modelA.transform = MatrixMultiply( modelA.transform, MatrixRotateX( -0.025 ) )
    modelA.transform = MatrixMultiply( modelA.transform, MatrixRotateZ( 0.012 ) )
    
    '' Update the light shader with the camera view position
    SetShaderValue( shader, shader.locs[ LOC_VECTOR_VIEW ], @camera.position.x, UNIFORM_VEC3 )
    
    '' Draw
    BeginDrawing()
      ClearBackground( GRAY )
      
      BeginMode3D( camera )
        '' Draw the three models
        DrawModel( modelA, Vector3Zero(), 1.0f, WHITE )
        DrawModel( modelB, Vector3( -2.6, 0, 0 ), 1.0f, WHITE )
        DrawModel( modelC, Vector3( 2.6, 0, 0 ), 1.0f, WHITE )
        
        for i as integer = -20 to 19 step 2
          DrawModel( modelA, Vector3( i, 0, 2 ), 1.0f, WHITE )
        next
      EndMode3D()
      
      DrawText( TextFormat( "Use KEY_UP/KEY_DOWN to change fog density [%.2f]", fogDensity ), 10, 10, 20, RAYWHITE )
    EndDrawing()
loop

'' De-Initialization
UnloadModel( modelA )
UnloadModel( modelB )
UnloadModel( modelC )
UnloadTexture( texture )
UnloadShader( shader )

CloseWindow()
