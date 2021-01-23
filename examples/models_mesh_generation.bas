/'*******************************************************************************************
*
*   raylib example - procedural mesh generation
*
*   This example has been created using raylib 1.8 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Copyright (c) 2017 Ramon Santamaria (Ray San)
*
********************************************************************************************'/

#include once "../raylib.bi"

#define NUM_MODELS  8      '' Parametric 3d shapes to generate

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [models] example - mesh generation" )

'' We generate a checked image for texturing
dim as Image checked = GenImageChecked( 2, 2, 1, 1, RAYRED, RAYGREEN )
dim as Texture2D texture = LoadTextureFromImage( checked )
UnloadImage( checked )

dim as Model models( 0 to NUM_MODELS - 1 ) = { _
  LoadModelFromMesh( GenMeshPlane( 2, 2, 5, 5 ) ), _
  LoadModelFromMesh( GenMeshCube( 2.0f, 1.0f, 2.0f ) ), _
  LoadModelFromMesh( GenMeshSphere( 2, 32, 32 ) ), _
  LoadModelFromMesh( GenMeshHemiSphere( 2, 16, 16 ) ), _
  LoadModelFromMesh( GenMeshCylinder( 1, 2, 16 ) ), _
  LoadModelFromMesh( GenMeshTorus( 0.25f, 4.0f, 16, 32 ) ), _
  LoadModelFromMesh( GenMeshKnot( 1.0f, 2.0f, 16, 128 ) ), _
  LoadModelFromMesh( GenMeshPoly( 5, 2.0f ) ) }

'' Set checked texture as default diffuse component for all models material
for i as integer = 0 to NUM_MODELS - 1
  models( i ).materials[ 0 ].maps[ MAP_DIFFUSE ].texture = texture
next

'' Define the camera to look into our 3d world
dim as Camera camera

with camera
  .position = Vector3( 5.0f, 5.0f, 5.0f )
  .target = Vector3( 0.0f, 0.0f, 0.0f )
  .up = Vector3( 0.0f, 1.0f, 0.0f )
  .fovy = 45.0f
  .type = CAMERA_PERSPECTIVE
end with

'' Model drawing position
var position = Vector3( 0.0f, 0.0f, 0.0f )

dim as long currentModel = 0

SetCameraMode( camera, CAMERA_ORBITAL )

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  UpdateCamera( @camera )
  
  if( IsMouseButtonPressed( MOUSE_LEFT_BUTTON ) ) then
    currentModel = ( currentModel + 1 ) mod NUM_MODELS '' Cycle between the textures
  end if
  
  if( IsKeyPressed( KEY_RIGHT ) ) then
    currentModel += 1
    if( currentModel >= NUM_MODELS ) then currentModel = 0
  elseif( IsKeyPressed( KEY_LEFT ) ) then
    currentModel -= 1
    if( currentModel < 0 ) then currentModel = NUM_MODELS - 1
  end if
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    BeginMode3D( camera )
      DrawModel( models( currentModel ), position, 1.0f, WHITE )
      DrawGrid( 10, 1.0 )
    EndMode3D()
    
    DrawRectangle( 30, 400, 310, 30, Fade( SKYBLUE, 0.5f ) )
    DrawRectangleLines( 30, 400, 310, 30, Fade( DARKBLUE, 0.5f ) )
    DrawText( "MOUSE LEFT BUTTON to CYCLE PROCEDURAL MODELS", 40, 410, 10, RAYBLUE )
    
    select case as const( currentModel )
        case 0: DrawText( "PLANE", 680, 10, 20, DARKBLUE )
        case 1: DrawText( "CUBE", 680, 10, 20, DARKBLUE )
        case 2: DrawText( "SPHERE", 680, 10, 20, DARKBLUE )
        case 3: DrawText( "HEMISPHERE", 640, 10, 20, DARKBLUE )
        case 4: DrawText( "CYLINDER", 680, 10, 20, DARKBLUE )
        case 5: DrawText( "TORUS", 680, 10, 20, DARKBLUE )
        case 6: DrawText( "KNOT", 680, 10, 20, DARKBLUE )
        case 7: DrawText( "POLY", 680, 10, 20, DARKBLUE )
    end select
  EndDrawing()
loop

'' De-Initialization
UnloadTexture( texture )

'' Unload models data (GPU VRAM)
for i as integer = 0 to NUM_MODELS - 1
  UnloadModel( models( i ) )
next

CloseWindow()
