/'*******************************************************************************************
*
*   raylib [shapes] example - collision area
*
*   This example has been created using raylib 2.5 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Copyright (c) 2013-2019 Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [shapes] example - collision area" )

'' Box A: Moving box
var boxA = Rectangle( 10, GetScreenHeight() / 2 - 50, 200, 100 )
dim as long boxASpeedX = 4

'' Box B: Mouse moved box
var _
  boxB = Rectangle( GetScreenWidth() / 2 - 30, GetScreenHeight() / 2 - 30, 60, 60 )

dim as Rectangle boxCollision '' Collision rectangle

dim as long screenUpperLimit = 40      '' Top menu limits

dim as boolean _
  pause = false, _          '' Movement pause
  collision = false         '' Collision detection

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  '' Move box if not paused
  if( not pause ) then boxA.x += boxASpeedX
  
  '' Bounce box on x screen limits
  if( ( ( boxA.x + boxA.width ) >= GetScreenWidth() ) orElse ( boxA.x <= 0 ) ) then boxASpeedX *= -1
  
  '' Update player-controlled-box (box02)
  boxB.x = GetMouseX() - boxB.width / 2
  boxB.y = GetMouseY() - boxB.height / 2
  
  '' Make sure Box B does not go out of move area limits
  if( ( boxB.x + boxB.width ) >= GetScreenWidth() ) then
    boxB.x = GetScreenWidth() - boxB.width
  elseif( boxB.x <= 0 ) then
    boxB.x = 0
  end if
  
  if( ( boxB.y + boxB.height ) >= GetScreenHeight() ) then
    boxB.y = GetScreenHeight() - boxB.height
  elseif( boxB.y <= screenUpperLimit ) then
    boxB.y = screenUpperLimit
  end if
  
  '' Check boxes collision
  collision = CheckCollisionRecs( boxA, boxB )
  
  '' Get collision rectangle (only on collision)
  if( collision ) then boxCollision = GetCollisionRec( boxA, boxB )
  
  '' Pause Box A movement
  if( IsKeyPressed( KEY_SPACE ) ) then pause xor= true
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    DrawRectangle(0, 0, screenWidth, screenUpperLimit, iif( collision, RAYRED, BLACK ) )
    
    DrawRectangleRec( boxA, GOLD )
    DrawRectangleRec( boxB, RAYBLUE )
    
    if( collision ) then
      '' Draw collision area
      DrawRectangleRec( boxCollision, LIME )
      
      '' Draw collision message
      DrawText( "COLLISION!", GetScreenWidth() / 2 - MeasureText( "COLLISION!", 20 ) / 2, screenUpperLimit / 2 - 10, 20, BLACK )
      
      '' Draw collision area
      DrawText( TextFormat( "Collision Area: %i", clng( boxCollision.width * boxCollision.height ) ), GetScreenWidth() / 2 - 100, screenUpperLimit + 10, 20, BLACK )
    end if
    
    DrawFPS( 10, 10 )
  EndDrawing()
loop

'' De-Initialization
CloseWindow()
