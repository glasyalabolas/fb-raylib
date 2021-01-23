/'*******************************************************************************************
*
*   raylib [models] example - Detect basic 3d collisions (box vs sphere vs box)
*
*   This example has been created using raylib 1.3 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Copyright (c) 2015 Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [models] example - box collisions" )

'' Define the camera to look into our 3d world
dim as Camera camera

with camera
  .position = Vector3( 0.0f, 10.0f, 10.0f )
  .target = Vector3( 0.0f, 0.0f, 0.0f )
  .up = Vector3( 0.0f, 1.0f, 0.0f )
  .fovy = 45.0f
  .type = CAMERA_PERSPECTIVE
end with

var _
  playerPosition = Vector3( 0.0f, 1.0f, 2.0f ), _
  playerSize = Vector3( 1.0f, 2.0f, 1.0f )

dim as RayColor playerColor = RAYGREEN

var _
  enemyBoxPos = Vector3( -4.0f, 1.0f, 0.0f ), _
  enemyBoxSize = Vector3( 2.0f, 2.0f, 2.0f ), _
  enemySpherePos = Vector3( 4.0f, 0.0f, 0.0f )

dim as single enemySphereSize = 1.5f

dim as boolean collision = false

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  
  '' Move player
  if( IsKeyDown( KEY_RIGHT ) ) then
    playerPosition.x += 0.2f
  elseif( IsKeyDown( KEY_LEFT ) ) then
    playerPosition.x -= 0.2f
  elseif( IsKeyDown( KEY_DOWN ) ) then
    playerPosition.z += 0.2f
  elseif( IsKeyDown( KEY_UP ) ) then
    playerPosition.z -= 0.2f
  end if
  
  collision = false
  
  '' Check collisions player vs enemy-box
  if( CheckCollisionBoxes( _
    BoundingBox( Vector3( playerPosition.x - playerSize.x / 2, _
                          playerPosition.y - playerSize.y / 2, _
                          playerPosition.z - playerSize.z / 2 ), _
                 Vector3( playerPosition.x + playerSize.x / 2, _
                          playerPosition.y + playerSize.y / 2, _
                          playerPosition.z + playerSize.z / 2 ) ), _
    BoundingBox( Vector3( enemyBoxPos.x - enemyBoxSize.x / 2, _
                          enemyBoxPos.y - enemyBoxSize.y / 2, _
                          enemyBoxPos.z - enemyBoxSize.z / 2 ), _
                 Vector3( enemyBoxPos.x + enemyBoxSize.x / 2, _
                          enemyBoxPos.y + enemyBoxSize.y / 2, _
                          enemyBoxPos.z + enemyBoxSize.z / 2 ) ) ) ) then collision = true
  
  '' Check collisions player vs enemy-sphere
  if( CheckCollisionBoxSphere( _
    BoundingBox( Vector3( playerPosition.x - playerSize.x / 2, _
                          playerPosition.y - playerSize.y / 2, _
                          playerPosition.z - playerSize.z / 2 ), _
                 Vector3( playerPosition.x + playerSize.x / 2, _
                          playerPosition.y + playerSize.y / 2, _
                          playerPosition.z + playerSize.z / 2 ) ), _
      enemySpherePos, enemySphereSize) ) then collision = true
  
  if( collision ) then
    playerColor = RAYRED
  else
    playerColor = RAYGREEN
  end if
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    BeginMode3D( camera )
      '' Draw enemy-box
      DrawCube( enemyBoxPos, enemyBoxSize.x, enemyBoxSize.y, enemyBoxSize.z, GRAY )
      DrawCubeWires( enemyBoxPos, enemyBoxSize.x, enemyBoxSize.y, enemyBoxSize.z, DARKGRAY )
      
      '' Draw enemy-sphere
      DrawSphere( enemySpherePos, enemySphereSize, GRAY )
      DrawSphereWires( enemySpherePos, enemySphereSize, 16, 16, DARKGRAY )
      
      '' Draw player
      DrawCubeV( playerPosition, playerSize, playerColor )
      
      DrawGrid( 10, 1.0f )
    EndMode3D()
    
    DrawText( "Move player with cursors to collide", 220, 40, 20, GRAY )
    
    DrawFPS( 10, 10 )
  EndDrawing()
loop

'' De-Initialization
CloseWindow()
