/'*******************************************************************************************
*
*   raylib [models] example - Mesh picking in 3d mode, ground plane, triangle, mesh
*
*   This example has been created using raylib 1.7 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Example contributed by Joel Davis (@joeld42) and reviewed by Ramon Santamaria (@raysan5)
*
*   Copyright (c) 2017 Joel Davis (@joeld42) and Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"
#include once "../raymath.bi"

#define FLT_MAX     340282346638528859811704183484516925440.0f     '' Maximum value of a float, from bit pattern 01111111011111111111111111111111

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [models] example - mesh picking" )

'' Define the camera to look into our 3d world
dim as Camera camera

with camera
  .position = Vector3( 20.0f, 20.0f, 20.0f )
  .target = Vector3( 0.0f, 8.0f, 0.0f )
  .up = Vector3( 0.0f, 1.6f, 0.0f )
  .fovy = 45.0f
  .type = CAMERA_PERSPECTIVE
end with

dim as Ray ray '' Picking ray

dim as Model tower = LoadModel( "resources/models/turret.obj" )
dim as Texture2D texture = LoadTexture( "resources/models/turret_diffuse.png" )
tower.materials[ 0 ].maps[ MAP_DIFFUSE ].texture = texture

var towerPos = Vector3( 0.0f, 0.0f, 0.0f )
dim as BoundingBox towerBBox = MeshBoundingBox( tower.meshes[ 0 ] )

dim as boolean _
  hitMeshBBox = false, hitTriangle = false

'' Test triangle
var _
  ta = Vector3( -25.0, 0.5, 0.0 ), _
  tb = Vector3( -4.0, 2.5, 1.0 ), _
  tc = Vector3( -8.0, 6.5, 0.0 ), _
  bary = Vector3( 0.0f, 0.0f, 0.0f )

SetCameraMode( camera, CAMERA_FREE )

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  UpdateCamera( @camera )
  
  '' Display information about closest hit
  dim as RayHitInfo nearestHit
  
  dim as string hitObjectName = "None"
  
  nearestHit.distance = FLT_MAX
  nearestHit.hit = false
  
  dim as RayColor cursorColor = WHITE
  
  '' Get ray and test against ground, triangle, and mesh
  ray = GetMouseRay( GetMousePosition(), camera )
  
  '' Check ray collision aginst ground plane
  dim as RayHitInfo groundHitInfo = GetCollisionRayGround( ray, 0.0f )
  
  if( ( groundHitInfo.hit ) andAlso ( groundHitInfo.distance < nearestHit.distance ) ) then
    nearestHit = groundHitInfo
    cursorColor = RAYGREEN
    hitObjectName = "Ground"
  end if
  
  '' Check ray collision against test triangle
  dim as RayHitInfo triHitInfo = GetCollisionRayTriangle( ray, ta, tb, tc )
  
  if( ( triHitInfo.hit ) andAlso ( triHitInfo.distance < nearestHit.distance ) ) then
    nearestHit = triHitInfo
    cursorColor = PURPLE
    hitObjectName = "Triangle"
    
    bary = Vector3Barycenter( nearestHit.position, ta, tb, tc )
    hitTriangle = true
  else
    hitTriangle = false
  end if
  
  dim as RayHitInfo meshHitInfo
  
  '' Check ray collision against bounding box first, before trying the full ray-mesh test
  if( CheckCollisionRayBox( ray, towerBBox ) ) then
    hitMeshBBox = true
    
    '' Check ray collision against model
    '' NOTE: It considers model.transform matrix!
    meshHitInfo = GetCollisionRayModel( ray, tower )
    
    if( ( meshHitInfo.hit ) andAlso ( meshHitInfo.distance < nearestHit.distance ) ) then
      nearestHit = meshHitInfo
      cursorColor = ORANGE
      hitObjectName = "Mesh"
    end if
  end if
  
  hitMeshBBox = false
  
  '' Draw
  BeginDrawing()
      ClearBackground( RAYWHITE )
      
      BeginMode3D( camera )
          '' Draw the tower
          '' WARNING: If scale is different than 1.0f,
          '' not considered by GetCollisionRayModel()
          DrawModel( tower, towerPos, 1.0f, WHITE )
          
          '' Draw the test triangle
          DrawLine3D( ta, tb, PURPLE )
          DrawLine3D( tb, tc, PURPLE )
          DrawLine3D( tc, ta, PURPLE )
          
          '' Draw the mesh bbox if we hit it
          if( hitMeshBBox ) then DrawBoundingBox( towerBBox, LIME )
          
          '' If we hit something, draw the cursor at the hit point
          if( nearestHit.hit ) then
            DrawCube( nearestHit.position, 0.3, 0.3, 0.3, cursorColor )
            DrawCubeWires( nearestHit.position, 0.3, 0.3, 0.3, RAYRED )
            
            dim as Vector3 normalEnd
            
            normalEnd.x = nearestHit.position.x + nearestHit.normal.x
            normalEnd.y = nearestHit.position.y + nearestHit.normal.y
            normalEnd.z = nearestHit.position.z + nearestHit.normal.z
            
            DrawLine3D(nearestHit.position, normalEnd, RAYRED )
          end if
          
          DrawRay( ray, MAROON )
          DrawGrid( 10, 10.0f )
      EndMode3D()
      
      '' Draw some debug GUI text
      DrawText( TextFormat( "Hit Object: %s", hitObjectName ), 10, 50, 10, BLACK )
      
      if( nearestHit.hit ) then
        dim as long ypos = 70
        
        DrawText( TextFormat( "Distance: %3.2f", nearestHit.distance ), 10, ypos, 10, BLACK )
        DrawText( TextFormat( "Hit Pos: %3.2f %3.2f %3.2f", _
          nearestHit.position.x, _
          nearestHit.position.y, _
          nearestHit.position.z ), 10, ypos + 15, 10, BLACK )
        
        DrawText( TextFormat( "Hit Norm: %3.2f %3.2f %3.2f", _
          nearestHit.normal.x, _
          nearestHit.normal.y, _
          nearestHit.normal.z ), 10, ypos + 30, 10, BLACK )
        
        if( hitTriangle ) then DrawText( TextFormat( "Barycenter: %3.2f %3.2f %3.2f", bary.x, bary.y, bary.z ), 10, ypos + 45, 10, BLACK )
      end if
      
      DrawText( "Use Mouse to Move Camera", 10, 430, 10, GRAY )
      DrawText( "(c) Turret 3D model by Alberto Cano", screenWidth - 200, screenHeight - 20, 10, GRAY )
      
      DrawFPS( 10, 10 )
  EndDrawing()
loop

'' De-Initialization
UnloadModel( tower )
UnloadTexture( texture )

CloseWindow()
