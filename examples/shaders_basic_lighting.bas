/'*******************************************************************************************
*
*   raylib [shaders] example - basic lighting
*
*   NOTE: This example requires raylib OpenGL 3.3 or ES2 versions for shaders support,
*         OpenGL 1.1 does not support shaders, recompile raylib to OpenGL 3.3 version.
*
*   NOTE: Shaders used in this example are #version 330 (OpenGL 3.3).
*
*   This example has been created using raylib 2.5 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Example contributed by Chris Camacho (@codifies) and reviewed by Ramon Santamaria (@raysan5)
*
*   Chris Camacho (@codifies -  http://bedroomcoders.co.uk/) notes:
*
*   This is based on the PBR lighting example, but greatly simplified to aid learning...
*   actually there is very little of the PBR example left!
*   When I first looked at the bewildering complexity of the PBR example I feared
*   I would never understand how I could do simple lighting with raylib however its
*   a testement to the authors of raylib (including rlights.h) that the example
*   came together fairly quickly.
*
*   Copyright (c) 2019 Chris Camacho (@codifies) and Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"
#include once "../raymath.bi"

#define RLIGHTS_IMPLEMENTATION
#include once "../rlights.bi"

#if defined( PLATFORM_DESKTOP )
  #define GLSL_VERSION            330
#else   '' PLATFORM_RPI, PLATFORM_ANDROID, PLATFORM_WEB
  #define GLSL_VERSION            100
#endif

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

SetConfigFlags( FLAG_MSAA_4X_HINT )
InitWindow( screenWidth, screenHeight, "raylib [shaders] example - basic lighting" )

'' Define the camera to look into our 3d world
dim as Camera camera

with camera
  .position = Vector3( 2.0f, 2.0f, 6.0f )
  .target = Vector3( 0.0f, 0.5f, 0.0f )
  .up = Vector3( 0.0f, 1.0f, 0.0f )
  .fovy = 45.0f
  .type = CAMERA_PERSPECTIVE
end with

'' Load models
dim as Model _
  modelA = LoadModelFromMesh( GenMeshTorus( 0.4f, 1.0f, 16, 32 ) ), _
  modelB = LoadModelFromMesh( GenMeshCube( 1.0f, 1.0f, 1.0f ) ), _
  modelC = LoadModelFromMesh( GenMeshSphere( 0.5f, 32, 32 ) )

'' Load models texture
dim as Texture texture = LoadTexture( "resources/texel_checker.png" )

'' Assign texture to default model material
modelA.materials[ 0 ].maps[ MAP_DIFFUSE ].texture = texture
modelB.materials[ 0 ].maps[ MAP_DIFFUSE ].texture = texture
modelC.materials[ 0 ].maps[ MAP_DIFFUSE ].texture = texture

dim as Shader shader = LoadShader( _
  TextFormat( "resources/shaders/glsl%i/base_lighting.vs", GLSL_VERSION ), _ 
  TextFormat( "resources/shaders/glsl%i/lighting.fs", GLSL_VERSION ) )

'' Get some shader loactions
shader.locs[ LOC_MATRIX_MODEL ] = GetShaderLocation( shader, "matModel" )
shader.locs[ LOC_VECTOR_VIEW ] = GetShaderLocation( shader, "viewPos" )

'' Ambient light level
dim as long ambientLoc = GetShaderLocation( shader, "ambient" )
dim as single ambientValues( ... ) = { 0.2f, 0.2f, 0.2f, 1.0f }
SetShaderValue( shader, ambientLoc, @ambientValues( 0 ), UNIFORM_VEC4 )

dim as single angle = 6.282f

'' All models use the same shader
modelA.materials[ 0 ].shader = shader
modelB.materials[ 0 ].shader = shader
modelC.materials[ 0 ].shader = shader

'' Using 4 point lights, white, red, green and blue
'dim as Light lights_( 0 to MAX_LIGHTS - 1 )
'lights( 0 ) = CreateLight( LIGHT_POINT, Vector3( 4, 2, 4 ), Vector3Zero(), WHITE, shader )
'lights( 1 ) = CreateLight( LIGHT_POINT, Vector3( 4, 2, 4 ), Vector3Zero(), RAYRED, shader )
'lights( 2 ) = CreateLight( LIGHT_POINT, Vector3( 0, 4, 2 ), Vector3Zero(), RAYGREEN, shader )
'lights( 3 ) = CreateLight( LIGHT_POINT, Vector3( 0, 4, 2 ), Vector3Zero(), RAYBLUE, shader )
CreateLight( LIGHT_POINT, Vector3( 4, 2, 4 ), Vector3Zero(), WHITE, shader )
CreateLight( LIGHT_POINT, Vector3( 4, 2, 4 ), Vector3Zero(), RAYRED, shader )
CreateLight( LIGHT_POINT, Vector3( 0, 4, 2 ), Vector3Zero(), RAYGREEN, shader )
CreateLight( LIGHT_POINT, Vector3( 0, 4, 2 ), Vector3Zero(), RAYBLUE, shader )

SetCameraMode( camera, CAMERA_ORBITAL )

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  if( IsKeyPressed( KEY_W ) ) then lights( 0 ).enabled xor= true
  if( IsKeyPressed( KEY_R ) ) then lights( 1 ).enabled xor= true
  if( IsKeyPressed( KEY_G ) ) then lights( 2 ).enabled xor= true
  if( IsKeyPressed( KEY_B ) ) then lights( 3 ).enabled xor= true
  
  UpdateCamera( @camera )
  
  '' Make the lights do differing orbits
  angle -= 0.02f
  
  lights( 0 ).position.x = cos( angle ) *4.0f
  lights( 0 ).position.z = sin( angle )* 4.0f
  lights( 1 ).position.x = cos( -angle * 0.6f) * 4.0f
  lights( 1 ).position.z = sin( -angle * 0.6f) * 4.0f
  lights( 2 ).position.y = cos( angle * 0.2f) * 4.0f
  lights( 2 ).position.z = sin( angle * 0.2f) * 4.0f
  lights( 3 ).position.y = cos( -angle * 0.35f) * 4.0f
  lights( 3 ).position.z = sin( -angle * 0.35f) * 4.0f
  
  UpdateLightValues( shader, lights( 0 ) )
  UpdateLightValues( shader, lights( 1 ) )
  UpdateLightValues( shader, lights( 2 ) )
  UpdateLightValues( shader, lights( 3 ) )

  '' Rotate the torus
  modelA.transform = MatrixMultiply( modelA.transform, MatrixRotateX( -0.025f ) )
  modelA.transform = MatrixMultiply( modelA.transform, MatrixRotateZ( 0.012f ) )

  '' Update the light shader with the camera view position
  dim as single cameraPos( 0 to 2 ) = { camera.position.x, camera.position.y, camera.position.z }
  SetShaderValue( shader, shader.locs[ LOC_VECTOR_VIEW ], @cameraPos( 0 ), UNIFORM_VEC3 )

  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    BeginMode3D( camera )
      '' Draw the three models
      DrawModel( modelA, Vector3Zero(), 1.0f, WHITE )
      DrawModel( modelB, Vector3( -1.6, 0, 0 ), 1.0f, WHITE )
      DrawModel( modelC, Vector3(  1.6, 0, 0 ), 1.0f, WHITE )
      
      '' Draw markers to show where the lights are
      if( lights( 0 ).enabled) then DrawSphereEx( lights( 0 ).position, 0.2f, 8, 8, WHITE )
      if( lights( 1 ).enabled) then DrawSphereEx( lights( 1 ).position, 0.2f, 8, 8, RAYRED )
      if( lights( 2 ).enabled) then DrawSphereEx( lights( 2 ).position, 0.2f, 8, 8, RAYGREEN )
      if( lights( 3 ).enabled) then DrawSphereEx( lights( 3 ).position, 0.2f, 8, 8, RAYBLUE )
      
      DrawGrid( 10, 1.0f )
    EndMode3D()
    
    DrawFPS( 10, 10 )
    
    DrawText( "Use keys RGBW to toggle lights", 10, 30, 20, DARKGRAY )
  EndDrawing()
loop

'' De-Initialization
UnloadModel( modelA )
UnloadModel( modelB )
UnloadModel( modelC )

UnloadTexture( texture )
UnloadShader( shader )

CloseWindow()
