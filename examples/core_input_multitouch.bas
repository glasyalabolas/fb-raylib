/'*******************************************************************************************
*
*   raylib [core] example - Input multitouch
*
*   This example has been created using raylib 2.1 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Example contributed by Berni (@Berni8k) and reviewed by Ramon Santamaria (@raysan5)
*
*   Copyright (c) 2019 Berni (@Berni8k) and Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"

#define MAX_TOUCH_POINTS 10

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [core] example - input multitouch" )

var ballPosition = Vector2( -100.0f, -100.0f )
dim as RayColor ballColor = BEIGE

dim as long touchCounter = 0
dim as Vector2 touchPosition

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  ballPosition = GetMousePosition()
  
  ballColor = BEIGE
  
  if( IsMouseButtonDown( MOUSE_LEFT_BUTTON ) ) then ballColor = MAROON
  if( IsMouseButtonDown( MOUSE_MIDDLE_BUTTON ) ) then ballColor = LIME
  if( IsMouseButtonDown( MOUSE_RIGHT_BUTTON ) ) then ballColor = DARKBLUE
  
  if( IsMouseButtonPressed( MOUSE_LEFT_BUTTON ) ) then touchCounter = 10
  if( IsMouseButtonPressed( MOUSE_MIDDLE_BUTTON ) ) then touchCounter = 10
  if( IsMouseButtonPressed( MOUSE_RIGHT_BUTTON ) ) then touchCounter = 10
  
  if( touchCounter > 0 ) then touchCounter -= 1
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    '' Multitouch
    for i as long = 0 to MAX_TOUCH_POINTS - 1
      touchPosition = GetTouchPosition( i ) '' Get the touch point
      
      '' Make sure point is not (-1,-1) as this means there is no touch for it
      if( ( touchPosition.x >= 0 ) andAlso ( touchPosition.y >= 0 ) ) then
        '' Draw circle and touch index number
        DrawCircleV( touchPosition, 34, ORANGE )
        DrawText( TextFormat( "%d", i ), touchPosition.x - 10, touchPosition.y - 70, 40, BLACK )
      end if
    next
    
    '' Draw the normal mouse location
    DrawCircleV( ballPosition, 30 + ( touchCounter * 3 ), ballColor )
    
    DrawText( "move ball with mouse and click mouse button to change color", 10, 10, 20, DARKGRAY )
    DrawText( "touch the screen at multiple locations to get multiple balls", 10, 30, 20, DARKGRAY )
  EndDrawing()
loop

'' De-Initialization
CloseWindow()
