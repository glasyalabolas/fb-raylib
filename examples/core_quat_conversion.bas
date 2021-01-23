/'*******************************************************************************************
*
*   raylib [core] example - quat conversions
*
*   Generally you should really stick to eulers OR quats...
*   This tests that various conversions are equivalent.
*
*   This example has been created using raylib 3.5 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Example contributed by Chris Camacho (@chriscamacho) and reviewed by Ramon Santamaria (@raysan5)
*
*   Copyright (c) 2020 Chris Camacho (@chriscamacho) and Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"
#include once "../raymath.bi"

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [core] example - quat conversions" )

dim as Camera3D camera

with camera
  .position = Vector3( 0.0f, 10.0f, 10.0f )
  .target = Vector3( 0.0f, 0.0f, 0.0f )
  .up = Vector3( 0.0f, 1.0f, 0.0f )
  .fovy = 45.0f
  .type = CAMERA_PERSPECTIVE
end with

dim as Mesh mesh = GenMeshCylinder( 0.2f, 1.0f, 32 ) 
dim as Model model = LoadModelFromMesh( mesh )

'' Some required variables
dim as Quaternion q1
dim as Matrix m1, m2, m3, m4
dim as Vector3 v1, v2

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  if( not IsKeyDown( KEY_SPACE ) ) then
    v1.x += 0.01f
    v1.y += 0.03f
    v1.z += 0.05f
  end if
  
  if( v1.x > PI * 2 ) then v1.x -= PI * 2
  if( v1.y > PI * 2 ) then v1.y -= PI * 2
  if( v1.z > PI * 2 ) then v1.z -= PI * 2
  
  q1 = QuaternionFromEuler( v1.x, v1.y, v1.z )
  m1 = MatrixRotateXYZ( v1 )
  m2 = QuaternionToMatrix( q1 )
  
  q1 = QuaternionFromMatrix( m1 )
  m3 = QuaternionToMatrix( q1 )
  
  v2 = QuaternionToEuler( q1 )
  
  v2.x *= DEG2RAD
  v2.y *= DEG2RAD
  v2.z *= DEG2RAD
  
  m4 = MatrixRotateXYZ( v2 )
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    BeginMode3D( camera )
      model.transform = m1
      DrawModel( model, Vector3( -1, 0, 0 ), 1.0f, RAYRED )
      model.transform = m2
      DrawModel( model, Vector3( 1, 0, 0 ), 1.0f, RAYRED )
      model.transform = m3
      DrawModel( model, Vector3( 0, 0, 0 ), 1.0f, RAYRED )
      model.transform = m4
      DrawModel( model, Vector3( 0, 0, -1 ), 1.0f, RAYRED )
      
      DrawGrid( 10, 1.0f )
    EndMode3D()
    
    if( v2.x < 0 ) then v2.x += PI * 2
    if( v2.y < 0 ) then v2.y += PI * 2
    if( v2.z < 0 ) then v2.z += PI * 2
    
    dim as RayColor cx,cy,cz
    
    cx = BLACK : cy = BLACK : cz = BLACK
    
    if( v1.x = v2.x ) then cx = RAYGREEN
    if( v1.y = v2.y ) then cy = RAYGREEN
    if( v1.z = v2.z ) then cz = RAYGREEN
    
    DrawText( TextFormat( "%2.3f", v1.x ), 20, 20, 20, cx )
    DrawText( TextFormat( "%2.3f", v1.y ), 20, 40, 20, cy )
    DrawText( TextFormat( "%2.3f", v1.z ), 20, 60, 20, cz )
    
    DrawText( TextFormat( "%2.3f", v2.x ), 200, 20, 20, cx )
    DrawText( TextFormat( "%2.3f", v2.y ), 200, 40, 20, cy )
    DrawText( TextFormat( "%2.3f", v2.z ), 200, 60, 20, cz )
  EndDrawing()
loop

'' De-Initialization
UnloadModel( model )
CloseWindow()
