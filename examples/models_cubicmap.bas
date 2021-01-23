/'*******************************************************************************************
*
*   raylib [models] example - Cubicmap loading and drawing
*
*   This example has been created using raylib 1.8 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Copyright (c) 2015 Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [models] example - cubesmap loading and drawing" )

dim as Camera camera

with Camera
  .position = Vector3( 16.0f, 14.0f, 16.0f )
  .target = Vector3( 0.0f, 0.0f, 0.0f )
  .up = Vector3( 0.0f, 1.0f, 0.0f )
  .fovy = 45.0f
  .type = CAMERA_PERSPECTIVE
end with

dim as Image image = LoadImage( "resources/cubicmap.png" )
dim as Texture2D cubicmap = LoadTextureFromImage( image )

dim as Mesh mesh = GenMeshCubicmap( image, Vector3( 1.0f, 1.0f, 1.0f ) )
dim as Model model = LoadModelFromMesh( mesh )

'' NOTE: By default each cube is mapped to one part of texture atlas
dim as Texture2D texture = LoadTexture( "resources/cubicmap_atlas.png" )
model.materials[ 0 ].maps[ MAP_DIFFUSE ].texture = texture

var mapPosition = Vector3( -16.0f, 0.0f, -8.0f )

UnloadImage( image ) '' Unload cubesmap image from RAM, already uploaded to VRAM

SetCameraMode( camera, CAMERA_ORBITAL )

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  UpdateCamera( @camera )
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    BeginMode3D( camera )
      DrawModel( model, mapPosition, 1.0f, WHITE )
    EndMode3D()
    
    DrawTextureEx( cubicmap, Vector2( screenWidth - cubicmap.width * 4 - 20, 20 ), 0.0f, 4.0f, WHITE )
    DrawRectangleLines( screenWidth - cubicmap.width * 4 - 20, 20, cubicmap.width * 4, cubicmap.height * 4, RAYGREEN )
    
    DrawText( "cubicmap image used to", 658, 90, 10, GRAY )
    DrawText( "generate map 3d model", 658, 104, 10, GRAY )
    
    DrawFPS( 10, 10 )
  EndDrawing()
loop

'' De-Initialization
UnloadTexture( cubicmap )
UnloadTexture( texture )
UnloadModel( model )

CloseWindow()
