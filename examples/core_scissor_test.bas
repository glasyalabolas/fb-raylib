/'*******************************************************************************************
*
*   raylib [core] example - Scissor test
*
*   This example has been created using raylib 2.5 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Example contributed by Chris Dill (@MysteriousSpace) and reviewed by Ramon Santamaria (@raysan5)
*
*   Copyright (c) 2019 Chris Dill (@MysteriousSpace)
*
********************************************************************************************'/

#include once "../raylib.bi"

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [core] example - scissor test" )

var scissorArea = Rectangle( 0, 0, 300, 300 )
dim as boolean scissorMode = true

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  if( IsKeyPressed( KEY_S ) ) then scissorMode xor= true

  '' Centre the scissor area around the mouse position
  scissorArea.x = GetMouseX() - scissorArea.width / 2
  scissorArea.y = GetMouseY() - scissorArea.height / 2

  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    if( scissorMode ) then
      BeginScissorMode( scissorArea.x, scissorArea.y, scissorArea.width, scissorArea.height )
    end if
    
    '' Draw full screen rectangle and some text
    '' NOTE: Only part defined by scissor area will be rendered
    DrawRectangle( 0, 0, GetScreenWidth(), GetScreenHeight(), RAYRED )
    DrawText( "Move the mouse around to reveal this text!", 190, 200, 20, LIGHTGRAY )
    
    if( scissorMode ) then EndScissorMode()
    
    DrawRectangleLinesEx( scissorArea, 1, BLACK )
    DrawText( "Press S to toggle scissor test", 10, 10, 20, BLACK )
  EndDrawing()
loop

'' De-Initialization
CloseWindow()
