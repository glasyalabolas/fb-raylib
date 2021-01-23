/'*******************************************************************************************
*
*   raylib [models] example - Waving cubes
*
*   This example has been created using raylib 2.5 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Example contributed by Codecat (@codecat) and reviewed by Ramon Santamaria (@raysan5)
*
*   Copyright (c) 2019 Codecat (@codecat) and Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [models] example - waving cubes" )

'' Initialize the camera
dim as Camera3D camera

with camera
  .position = Vector3( 30.0f, 20.0f, 30.0f )
  .target = Vector3( 0.0f, 0.0f, 0.0f )
  .up = Vector3( 0.0f, 1.0f, 0.0f )
  .fovy = 70.0f
  .type = CAMERA_PERSPECTIVE
end with

'' Specify the amount of blocks in each direction
const as long numBlocks = 15

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  dim as double time_ = GetTime()
  
  '' Calculate time scale for cube position and size
  dim as single scale = ( 2.0f + sin( time_ ) ) * 0.7f
  
  '' Move camera around the scene
  dim as double cameraTime = time_ * 0.3
  
  camera.position.x = cos( cameraTime ) * 40.0f
  camera.position.z = sin( cameraTime ) * 40.0f
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    BeginMode3D( camera )
      DrawGrid( 10, 5.0f )
      
      for x as integer = 0 to numBlocks - 1 
        for y as integer = 0 to numBlocks - 1 
          for z as integer = 0 to numBlocks - 1 
            '' Scale of the blocks depends on x/y/z positions
            dim as single blockScale = ( x + y + z ) / 30.0f
            
            '' Scatter makes the waving effect by adding blockScale over time
            dim as single scatter = sin( blockScale * 20.0f + ( time_ * 4.0f ) )
            
            '' Calculate the cube position
            var cubePos = Vector3( _
                ( x - numBlocks / 2 ) * ( scale * 3.0f ) + scatter, _
                ( y - numBlocks / 2 ) * ( scale * 2.0f ) + scatter, _
                ( z - numBlocks / 2 ) * ( scale * 3.0f ) + scatter )
            
            '' Pick a color with a hue depending on cube position for the rainbow color effect
            dim as RayColor cubeColor = ColorFromHSV( ( ( ( x + y + z ) * 18 ) mod 360 ), 0.75f, 0.9f )
            
            '' Calculate cube size
            dim as single cubeSize = ( 2.4f - scale ) * blockScale
            
            '' And finally, draw the cube!
            DrawCube( cubePos, cubeSize, cubeSize, cubeSize, cubeColor )
          next
        next
      next
    EndMode3D()
    
    DrawFPS( 10, 10 )
  EndDrawing()
loop

'' De-Initialization
CloseWindow()
