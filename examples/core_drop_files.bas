/'*******************************************************************************************
*
*   raylib [core] example - Windows drop files
*
*   This example only works on platforms that support drag & drop (Windows, Linux, OSX, Html5?)
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

InitWindow( screenWidth, screenHeight, "raylib [core] example - drop files" )

dim as long count = 0
dim as zstring ptr ptr droppedFiles

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  if( IsFileDropped() ) then
    droppedFiles = GetDroppedFiles( @count )
  end if
  
  '' Draw
  BeginDrawing()
    ClearBackground(RAYWHITE)
    
    if( count = 0 ) then
      DrawText( "Drop your files to this window!", 100, 40, 20, DARKGRAY )
    else
      DrawText( "Dropped files:", 100, 40, 20, DARKGRAY )
      
      for i as integer = 0 to count - 1
        if( i mod 2 = 0 ) then
          DrawRectangle( 0, 85 + 40 * i, screenWidth, 40, Fade( LIGHTGRAY, 0.5f ) )
        else
          DrawRectangle( 0, 85 + 40 * i, screenWidth, 40, Fade( LIGHTGRAY, 0.3f ) )
        end if
        
        DrawText( *droppedFiles[ i ], 120, 100 + 40 * i, 10, GRAY )
      next
      
      DrawText( "Drop new files...", 100, 110 + 40 * count, 20, DARKGRAY )
    end if
  EndDrawing()
loop

'' De-Initialization
ClearDroppedFiles()
CloseWindow()
