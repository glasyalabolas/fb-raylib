/'*******************************************************************************************
*
*   raylib [models] example - PBR material
*
*   NOTE: This example requires raylib OpenGL 3.3 for shaders support and only #version 330
*         is currently supported. OpenGL ES 2.0 platforms are not supported at the moment.
*
*   This example has been created using raylib 1.8 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Copyright (c) 2017 Ramon Santamaria (@raysan5)
*
********************************************************************************************'/
#include once "../raylib.bi"
#include once "../raymath.bi"

#define RLIGHTS_IMPLEMENTATION
#include once "../rlights.bi"

#define CUBEMAP_SIZE         512        '' Cubemap texture size
#define IRRADIANCE_SIZE       32        '' Irradiance texture size
#define PREFILTERED_SIZE     256        '' Prefiltered HDR environment texture size
#define BRDF_SIZE            512        '' BRDF LUT texture size

'' Load PBR material (Supports: ALBEDO, NORMAL, METALNESS, ROUGHNESS, AO, EMMISIVE, HEIGHT maps)
'' NOTE: PBR shader is loaded inside this function
function LoadMaterialPBR( albedo as RayColor, metalness as single, roughness as single ) as Material
  dim as Material mat = LoadMaterialDefault()
  
  #if defined( PLATFORM_DESKTOP )
    mat.shader = LoadShader( "resources/shaders/glsl330/pbr.vs", "resources/shaders/glsl330/pbr.fs" )
  #else   '' PLATFORM_RPI, PLATFORM_ANDROID, PLATFORM_WEB
    mat.shader = LoadShader( "resources/shaders/glsl100/pbr.vs", "resources/shaders/glsl100/pbr.fs" )
  #endif

  '' Get required locations points for PBR material
  '' NOTE: Those location names must be available and used in the shader code
  with mat.shader
    .locs[ LOC_MAP_ALBEDO ] = GetShaderLocation( mat.shader, "albedo.sampler" )
    .locs[ LOC_MAP_METALNESS ] = GetShaderLocation( mat.shader, "metalness.sampler" )
    .locs[ LOC_MAP_NORMAL ] = GetShaderLocation( mat.shader, "normals.sampler" )
    .locs[ LOC_MAP_ROUGHNESS ] = GetShaderLocation( mat.shader, "roughness.sampler" )
    .locs[ LOC_MAP_OCCLUSION ] = GetShaderLocation( mat.shader, "occlusion.sampler" )
    ''.locs[ LOC_MAP_EMISSION ] = GetShaderLocation( mat.shader, "emission.sampler" )
    ''.locs[ LOC_MAP_HEIGHT ] = GetShaderLocation( mat.shader, "height.sampler" )
    .locs[ LOC_MAP_IRRADIANCE ] = GetShaderLocation( mat.shader, "irradianceMap" )
    .locs[ LOC_MAP_PREFILTER ] = GetShaderLocation( mat.shader, "prefilterMap" )
    .locs[ LOC_MAP_BRDF ] = GetShaderLocation( mat.shader, "brdfLUT" )
    
    '' Set view matrix location
    .locs[ LOC_MATRIX_MODEL ] = GetShaderLocation( mat.shader, "matModel" )
    .locs[ LOC_VECTOR_VIEW ] = GetShaderLocation( mat.shader, "viewPos" )
  end with
  
  '' Set PBR standard maps
  mat.maps[ MAP_ALBEDO ].texture = LoadTexture( "resources/pbr/trooper_albedo.png" )
  mat.maps[ MAP_NORMAL ].texture = LoadTexture( "resources/pbr/trooper_normals.png" )
  mat.maps[ MAP_METALNESS ].texture = LoadTexture( "resources/pbr/trooper_metalness.png" )
  mat.maps[ MAP_ROUGHNESS ].texture = LoadTexture( "resources/pbr/trooper_roughness.png" )
  mat.maps[ MAP_OCCLUSION ].texture = LoadTexture( "resources/pbr/trooper_ao.png" )
  
  '' Load equirectangular to cubemap shader
  #if defined( PLATFORM_DESKTOP )
    dim as Shader shdrCubemap = LoadShader( "resources/shaders/glsl330/cubemap.vs", "resources/shaders/glsl330/cubemap.fs" )
  #else   '' PLATFORM_RPI, PLATFORM_ANDROID, PLATFORM_WEB
    dim as Shader shdrCubemap = LoadShader( "resources/shaders/glsl100/cubemap.vs", "resources/shaders/glsl100/cubemap.fs" )
  #endif
  
  '' Load irradiance (GI) calculation shader
  #if defined( PLATFORM_DESKTOP )
    dim as Shader shdrIrradiance = LoadShader( "resources/shaders/glsl330/skybox.vs", "resources/shaders/glsl330/irradiance.fs" )
  #else   '' PLATFORM_RPI, PLATFORM_ANDROID, PLATFORM_WEB
    dim as Shader shdrIrradiance = LoadShader( "resources/shaders/glsl100/skybox.vs", "resources/shaders/glsl100/irradiance.fs" )
  #endif
  
  '' Load reflection prefilter calculation shader
  #if defined( PLATFORM_DESKTOP )
    dim as Shader shdrPrefilter = LoadShader( "resources/shaders/glsl330/skybox.vs", "resources/shaders/glsl330/prefilter.fs" )
  #else
    dim as Shader shdrPrefilter = LoadShader( "resources/shaders/glsl100/skybox.vs", "resources/shaders/glsl100/prefilter.fs" )
  #endif
  
  '' Load bidirectional reflectance distribution function shader
  #if defined( PLATFORM_DESKTOP )
    dim as Shader shdrBRDF = LoadShader( "resources/shaders/glsl330/brdf.vs", "resources/shaders/glsl330/brdf.fs" )
  #else
    dim as Shader shdrBRDF = LoadShader( "resources/shaders/glsl100/brdf.vs", "resources/shaders/glsl100/brdf.fs" )
  #endif
  
  static as long _
    bEquirectangularMap = 0, _
    bEnvironmentMap = 0
  
  '' Setup required shader locations
  SetShaderValue( shdrCubemap, GetShaderLocation( shdrCubemap, "equirectangularMap" ), @bEquirectangularMap, UNIFORM_INT )
  SetShaderValue( shdrIrradiance, GetShaderLocation( shdrIrradiance, "environmentMap" ), @bEnvironmentMap, UNIFORM_INT )
  SetShaderValue( shdrPrefilter, GetShaderLocation( shdrPrefilter, "environmentMap" ), @bEnvironmentMap, UNIFORM_INT )
  
  dim as Texture2D _
    texHDR = LoadTexture( "resources/dresden_square_2k.hdr" ), _
    cubemap = GenTextureCubemap( shdrCubemap, texHDR, CUBEMAP_SIZE, UNCOMPRESSED_R8G8B8A8 )
  
  mat.maps[ MAP_IRRADIANCE ].texture = GenTextureIrradiance( shdrIrradiance, cubemap, IRRADIANCE_SIZE )
  mat.maps[ MAP_PREFILTER ].texture = GenTexturePrefilter( shdrPrefilter, cubemap, PREFILTERED_SIZE )
  mat.maps[ MAP_BRDF ].texture = GenTextureBRDF( shdrBRDF, BRDF_SIZE )
  
  UnloadTexture( cubemap )
  UnloadTexture( texHDR )
  
  '' Unload already used shaders (to create specific textures)
  UnloadShader( shdrCubemap )
  UnloadShader( shdrIrradiance )
  UnloadShader( shdrPrefilter )
  UnloadShader( shdrBRDF )
  
  '' Set textures filtering for better quality
  SetTextureFilter( mat.maps[ MAP_ALBEDO ].texture, FILTER_BILINEAR )
  SetTextureFilter( mat.maps[ MAP_NORMAL ].texture, FILTER_BILINEAR )
  SetTextureFilter( mat.maps[ MAP_METALNESS ].texture, FILTER_BILINEAR )
  SetTextureFilter( mat.maps[ MAP_ROUGHNESS ].texture, FILTER_BILINEAR )
  SetTextureFilter( mat.maps[ MAP_OCCLUSION ].texture, FILTER_BILINEAR )
  
  '' Enable sample usage in shader for assigned textures
  type Samplers
    as long albedo, normals, metalness, roughness, occlusion
  end type
  
  static as Samplers use = ( 1, 1, 1, 1, 1 )
  
  SetShaderValue( mat.shader, GetShaderLocation( mat.shader, "albedo.useSampler" ), @use.albedo, UNIFORM_INT )
  SetShaderValue( mat.shader, GetShaderLocation( mat.shader, "normals.useSampler" ), @use.normals, UNIFORM_INT )
  SetShaderValue( mat.shader, GetShaderLocation( mat.shader, "metalness.useSampler" ), @use.metalness, UNIFORM_INT )
  SetShaderValue( mat.shader, GetShaderLocation( mat.shader, "roughness.useSampler" ), @use.roughness, UNIFORM_INT )
  SetShaderValue( mat.shader, GetShaderLocation( mat.shader, "occlusion.useSampler" ), @use.occlusion, UNIFORM_INT )
  
  static as long _
    renderModeLoc, _
    bRenderMode = 0
  
  renderModeLoc = GetShaderLocation( mat.shader, "renderMode" )
  
  SetShaderValue( mat.shader, renderModeLoc, @bRenderMode, UNIFORM_INT )
  
  '' Set up material properties color
  mat.maps[ MAP_ALBEDO ].color = albedo
  mat.maps[ MAP_NORMAL ].color = RayColor( 128, 128, 255, 255 )
  mat.maps[ MAP_METALNESS ].value = metalness
  mat.maps[ MAP_ROUGHNESS ].value = roughness
  mat.maps[ MAP_OCCLUSION ].value = 1.0f
  mat.maps[ MAP_EMISSION ].value = 0.5f
  mat.maps[ MAP_HEIGHT ].value = 0.5f
  
  return( mat )
end function

'' Initialization
''--------------------------------------------------------------------------------------
dim as long _
  screenWidth = 800, screenHeight = 450

SetConfigFlags( FLAG_MSAA_4X_HINT ) '' Enable Multi Sampling Anti Aliasing 4x (if available)

InitWindow( screenWidth, screenHeight, "raylib [models] example - pbr material" )

'' Define the camera to look into our 3d world
dim as Camera camera

with camera
  .position = Vector3( 4.0f, 4.0f, 4.0f )
  .target = Vector3( 0.0f, 0.5f, 0.0f )
  .up = Vector3( 0.0f, 1.0f, 0.0f )
  .fovy = 45.0f
  .type = CAMERA_PERSPECTIVE
end with

'' Load model and PBR material
dim as Model model = LoadModel( "resources/pbr/trooper.obj" )

'' Mesh tangents are generated... and uploaded to GPU
'' NOTE: New VBO for tangents is generated at default location and also binded to mesh VAO
MeshTangents( @model.meshes[ 0 ] )

UnloadMaterial( model.materials[ 0 ] ) '' get rid of default material

model.materials[ 0 ] = LoadMaterialPBR( RayColor( 255, 255, 255, 255 ), 1.0f, 1.0f )

'' Create lights
'' NOTE: Lights are added to an internal lights pool automatically
CreateLight( LIGHT_POINT, Vector3( LIGHT_DISTANCE, LIGHT_HEIGHT, 0.0f ), Vector3( 0.0f, 0.0f, 0.0f ), RayColor( 255, 0, 0, 255 ), model.materials[ 0 ].shader )
CreateLight( LIGHT_POINT, Vector3( 0.0f, LIGHT_HEIGHT, LIGHT_DISTANCE ), Vector3( 0.0f, 0.0f, 0.0f ), RayColor( 0, 255, 0, 255 ), model.materials[ 0 ].shader )
CreateLight( LIGHT_POINT, Vector3( -LIGHT_DISTANCE, LIGHT_HEIGHT, 0.0f ), Vector3( 0.0f, 0.0f, 0.0f ), RayColor( 0, 0, 255, 255 ), model.materials[ 0 ].shader )
CreateLight( LIGHT_DIRECTIONAL, Vector3( 0.0f, LIGHT_HEIGHT * 2.0f, -LIGHT_DISTANCE ), Vector3( 0.0f, 0.0f, 0.0f ), RayColor( 255, 0, 255, 255 ), model.materials[ 0 ].shader )

SetCameraMode( camera, CAMERA_ORBITAL )

SetTargetFPS( 60 )

do while( not WindowShouldClose() )
  UpdateCamera( @camera )

  '' Send to material PBR shader camera view position
  dim as single cameraPos( 0 to 2 ) = { _
    camera.position.x, camera.position.y, camera.position.z }
  
  SetShaderValue( model.materials[ 0 ].shader, model.materials[ 0 ].shader.locs[ LOC_VECTOR_VIEW ], @cameraPos( 0 ), UNIFORM_VEC3 )
  
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    BeginMode3D( camera )
      DrawModel( model, Vector3Zero(), 1.0f, RAYRED )
      DrawGrid( 10, 1.0f )
    EndMode3D()
    
    DrawFPS( 10, 10 )
  EndDrawing()
loop

'' Shaders and textures must be unloaded by user, 
'' they could be in use by other models
UnloadTexture( model.materials[ 0 ].maps[ MAP_ALBEDO ].texture )
UnloadTexture( model.materials[ 0 ].maps[ MAP_NORMAL ].texture )
UnloadTexture( model.materials[ 0 ].maps[ MAP_METALNESS ].texture )
UnloadTexture( model.materials[ 0 ].maps[ MAP_ROUGHNESS ].texture )
UnloadTexture( model.materials[ 0 ].maps[ MAP_OCCLUSION ].texture )
UnloadTexture( model.materials[ 0 ].maps[ MAP_IRRADIANCE ].texture )
UnloadTexture( model.materials[ 0 ].maps[ MAP_PREFILTER ].texture )
UnloadTexture( model.materials[ 0 ].maps[ MAP_BRDF ].texture )
UnloadShader( model.materials[ 0 ].shader )

UnloadModel( model )

CloseWindow()
