/'*******************************************************************************************
*
*   raylib [text] example - Draw text inside a rectangle
*
*   This example has been created using raylib 2.3 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Example contributed by Vlad Adrian (@demizdor) and reviewed by Ramon Santamaria (@raysan5)
*
*   Copyright (c) 2018 Vlad Adrian (@demizdor) and Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include "../raylib.bi"

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [text] example - draw text inside a rectangle" )

dim as const string text = _
  !"Text cannot escape\tthis container\t...word wrap also works when active so here's " + _
  !"a long text for testing.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod " + _
  !"tempor incididunt ut labore et dolore magna aliqua. Nec ullamcorper sit amet risus nullam eget felis eget."

dim as boolean _
  resizing = false, _
  wordWrap = true

var _
  container = Rectangle( 25, 25, screenWidth - 50, screenHeight - 250 ), _
  resizer = Rectangle( container.x + container.width - 17, container.y + container.height - 17, 14, 14 )

'' Minimum width and heigh for the container rectangle
dim as const long _
  minWidth = 60, _
  minHeight = 60, _
  maxWidth = screenWidth - 50, _
  maxHeight = screenHeight - 160

dim as Vector2 lastMouse               '' Stores last mouse coordinates
dim as RayColor borderColor = MAROON   '' Container border color
dim as Font font = GetFontDefault()    '' Get default system font

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  if( IsKeyPressed( KEY_SPACE ) ) then wordWrap xor= true
  
  dim as Vector2 mouse = GetMousePosition()
  
  '' Check if the mouse is inside the container and toggle border color
  if( CheckCollisionPointRec( mouse, container ) ) then
    borderColor = Fade( MAROON, 0.4f )
  elseif( not resizing ) then
    borderColor = MAROON
  end if
  
  '' Container resizing logic
  if( resizing ) then
    if( IsMouseButtonReleased( MOUSE_LEFT_BUTTON ) ) then resizing = false
    
    dim as long width_ = container.width + ( mouse.x - lastMouse.x )
    container.width = iif( width_ > minWidth, iif( width_ < maxWidth, width_, maxWidth ), minWidth )
    
    dim as long height = container.height + ( mouse.y - lastMouse.y )
    container.height = iif( height > minHeight, iif( height < maxHeight, height, maxHeight ), minHeight )
  else
    '' Check if we're resizing
    if( IsMouseButtonDown( MOUSE_LEFT_BUTTON ) andAlso CheckCollisionPointRec( mouse, resizer ) ) then resizing = true
  end if
  
  '' Move resizer rectangle properly
  resizer.x = container.x + container.width - 17
  resizer.y = container.y + container.height - 17
  
  lastMouse = mouse '' Update mouse
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    DrawRectangleLinesEx( container, 3, borderColor )
    
    '' Draw text in container (add some padding)
    DrawTextRec( font, text, _
                 Rectangle( container.x + 4, container.y + 4, container.width - 4, container.height - 4 ), _
                 20.0f, 2.0f, wordWrap, GRAY )
    DrawRectangleRec( resizer, borderColor )
    
    '' Draw bottom info
    DrawRectangle( 0, screenHeight - 54, screenWidth, 54, GRAY )
    DrawRectangleRec( Rectangle( 382, screenHeight - 34, 12, 12 ), MAROON)
    
    DrawText( "Word Wrap: ", 313, screenHeight-115, 20, BLACK )
    
    if( wordWrap ) then
      DrawText( "ON", 447, screenHeight - 115, 20, RAYRED )
    else
      DrawText("OFF", 447, screenHeight - 115, 20, BLACK )
    end if
    
    DrawText( "Press [SPACE] to toggle word wrap", 218, screenHeight - 86, 20, GRAY )
    DrawText( "Click hold & drag the    to resize the container", 155, screenHeight - 38, 20, RAYWHITE )
  EndDrawing()
loop

'' De-Initialization
CloseWindow()
