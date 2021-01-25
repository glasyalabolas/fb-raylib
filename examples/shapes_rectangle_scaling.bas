/'*******************************************************************************************
*
*   raylib [shapes] example - rectangle scaling by mouse
*
*   This example has been created using raylib 2.5 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Example contributed by Vlad Adrian (@demizdor) and reviewed by Ramon Santamaria (@raysan5)
*
*   Copyright (c) 2018 Vlad Adrian (@demizdor) and Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"

#define MOUSE_SCALE_MARK_SIZE   12

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [shapes] example - rectangle scaling mouse" )

var rec = Rectangle( 100, 100, 200, 80 )

dim as Vector2 mousePosition

dim as boolean _
  mouseScaleReady = false, _
  mouseScaleMode = false

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  mousePosition = GetMousePosition()
  
  if(CheckCollisionPointRec( mousePosition, rec ) andAlso _
     CheckCollisionPointRec( mousePosition, Rectangle( rec.x + rec.width - MOUSE_SCALE_MARK_SIZE, rec.y + rec.height - MOUSE_SCALE_MARK_SIZE, MOUSE_SCALE_MARK_SIZE, MOUSE_SCALE_MARK_SIZE ) ) ) then
    
    mouseScaleReady = true
    if( IsMouseButtonPressed( MOUSE_LEFT_BUTTON ) ) then mouseScaleMode = true  
  else
    mouseScaleReady = false
  end if
  
  if( mouseScaleMode ) then
    mouseScaleReady = true
    
    rec.width = ( mousePosition.x - rec.x )
    rec.height = ( mousePosition.y - rec.y )
    
    if( rec.width < MOUSE_SCALE_MARK_SIZE ) then rec.width = MOUSE_SCALE_MARK_SIZE
    if( rec.height < MOUSE_SCALE_MARK_SIZE ) then rec.height = MOUSE_SCALE_MARK_SIZE
    
    if( IsMouseButtonReleased( MOUSE_LEFT_BUTTON ) ) then mouseScaleMode = false
  end if

  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    DrawText( "Scale rectangle dragging from bottom-right corner!", 10, 10, 20, GRAY )
    
    DrawRectangleRec( rec, Fade( RAYGREEN, 0.5f ) )
    
    if( mouseScaleReady ) then
      DrawRectangleLinesEx( rec, 1, RAYRED )
      DrawTriangle( Vector2( rec.x + rec.width - MOUSE_SCALE_MARK_SIZE, rec.y + rec.height ),_
                    Vector2( rec.x + rec.width, rec.y + rec.height ), _
                    Vector2( rec.x + rec.width, rec.y + rec.height - MOUSE_SCALE_MARK_SIZE ), RAYRED )
    end if
  EndDrawing()
loop

'' De-Initialization
CloseWindow()
