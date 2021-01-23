/'*******************************************************************************************
*
*   raylib [models] example - Skybox loading and drawing
*
*   This example has been created using raylib 3.5 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Copyright (c) 2017-2020 Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [models] example - skybox loading and drawing" )

'' Define the camera to look into our 3d world
dim as Camera camera

with camera
  .position = Vector3( 1.0f, 1.0f, 1.0f )
  .target = Vector3( 4.0f, 1.0f, 4.0f )
  .up = Vector3( 0.0f, 1.0f, 0.0f )
  .fovy = 45.0f
  .type = CAMERA_PERSPECTIVE
end with

'' Load skybox model
dim as Mesh cube = GenMeshCube( 1.0f, 1.0f, 1.0f )
dim as Model skybox = LoadModelFromMesh( cube )

'' Load skybox shader and set required locations
'' NOTE: Some locations are automatically set at shader loading
#if defined( PLATFORM_DESKTOP )
  skybox.materials[ 0 ].shader = LoadShader( "resources/shaders/glsl330/skybox.vs", "resources/shaders/glsl330/skybox.fs" )
#else   '' PLATFORM_RPI, PLATFORM_ANDROID, PLATFORM_WEB
  skybox.materials[ 0 ].shader = LoadShader( "resources/shaders/glsl100/skybox.vs", "resources/shaders/glsl100/skybox.fs" )
#endif

dim as long _
  environmentMap = MAP_CUBEMAP, _
  vflipped = 1

SetShaderValue( skybox.materials[ 0 ].shader, GetShaderLocation( skybox.materials[ 0 ].shader, "environmentMap" ), @environmentMap, UNIFORM_INT )
SetShaderValue( skybox.materials[ 0 ].shader, GetShaderLocation( skybox.materials[ 0 ].shader, "vflipped" ), @vflipped, UNIFORM_INT )

'' Load cubemap shader and setup required shader locations
#if defined( PLATFORM_DESKTOP )
  dim as Shader shdrCubemap = LoadShader( "resources/shaders/glsl330/cubemap.vs", "resources/shaders/glsl330/cubemap.fs" )
#else   '' PLATFORM_RPI, PLATFORM_ANDROID, PLATFORM_WEB
  dim as Shader shdrCubemap = LoadShader( "resources/shaders/glsl100/cubemap.vs", "resources/shaders/glsl100/cubemap.fs" )
#endif

dim as long equirectangularMap = 0

SetShaderValue( shdrCubemap, GetShaderLocation( shdrCubemap, "equirectangularMap"), @equirectangularMap, UNIFORM_INT )

'' Load HDR panorama (sphere) texture
dim as string panoFileName = space( 255 )
TextCopy( panoFileName, "resources/dresden_square_2k.hdr" )

dim as Texture2D panorama = LoadTexture( panoFileName )

'' Generate cubemap (texture with 6 quads-cube-mapping) from panorama HDR texture
'' NOTE 1: New texture is generated rendering to texture, shader calculates the sphere->cube coordinates mapping
'' NOTE 2: It seems on some Android devices WebGL, fbo does not properly support a FLOAT-based attachment,
'' despite texture can be successfully created.. so using UNCOMPRESSED_R8G8B8A8 instead of UNCOMPRESSED_R32G32B32A32
skybox.materials[ 0 ].maps[ MAP_CUBEMAP ].texture = GenTextureCubemap( shdrCubemap, panorama, 1024, UNCOMPRESSED_R8G8B8A8 )

UnloadTexture( panorama )    '' Texture not required anymore, cubemap already generated

SetCameraMode( camera, CAMERA_FIRST_PERSON )

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  UpdateCamera( @camera )
  
  '' Load new cubemap texture on drag&drop
  if( IsFileDropped() ) then
    dim as long count = 0
    dim as zstring ptr ptr droppedFiles = GetDroppedFiles( @count )
    
    if( count = 1 ) then         '' Only support one file dropped
      if( IsFileExtension( droppedFiles[ 0 ], ".png;.jpg;.hdr;.bmp;.tga" ) ) then
        '' Unload current cubemap texture and load new one
        UnloadTexture( skybox.materials[ 0 ].maps[ MAP_CUBEMAP ].texture )
        panorama = LoadTexture( droppedFiles[ 0 ] )
        TextCopy( panoFileName, droppedFiles[ 0 ] )
        
        '' Generate cubemap from panorama texture
        skybox.materials[ 0 ].maps[ MAP_CUBEMAP ].texture = GenTextureCubemap( shdrCubemap, panorama, 1024, UNCOMPRESSED_R8G8B8A8 )
        UnloadTexture( panorama )
      end if
    end if

    ClearDroppedFiles()    '' Clear internal buffers
  end if

  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    BeginMode3D( camera )
      DrawModel( skybox, Vector3( 0, 0, 0 ), 1.0f, WHITE )
      DrawGrid( 10, 1.0f )
    EndMode3D()
    
    DrawText( TextFormat( "Panorama image from hdrihaven.com: %s", GetFileName( panoFileName ) ), 10, GetScreenHeight() - 20, 10, BLACK )
    DrawFPS( 10, 10 )
  EndDrawing()
loop

'' De-Initialization
UnloadShader( skybox.materials[ 0 ].shader )
UnloadTexture( skybox.materials[ 0 ].maps[ MAP_CUBEMAP ].texture )

UnloadModel( skybox )

CloseWindow()
