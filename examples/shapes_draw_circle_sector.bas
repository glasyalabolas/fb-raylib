/'*******************************************************************************************
*
*   raylib [shapes] example - draw circle sector (with gui options)
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

#define RAYGUI_IMPLEMENTATION
#include once "../raygui.bi"                 '' Required for GUI controls

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

SetConfigFlags( FLAG_MSAA_4X_HINT ) '' Enable anti-aliasing if available
InitWindow( screenWidth, screenHeight, "raylib [shapes] example - draw circle sector" )

var center = Vector2( ( GetScreenWidth() - 300 ) / 2, GetScreenHeight() / 2 )

dim as single outerRadius = 180.0f

dim as long _
  startAngle = 0, endAngle = 180, segments = 0

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  ''----------------------------------------------------------------------------------
  '' NOTE: All variables update happens inside GUI control functions
  ''----------------------------------------------------------------------------------
  
  '' Draw
  BeginDrawing()    
    ClearBackground( RAYWHITE )
    
    DrawLine( 500, 0, 500, GetScreenHeight(), Fade(LIGHTGRAY, 0.6f ) )
    DrawRectangle( 500, 0, GetScreenWidth() - 500, GetScreenHeight(), Fade( LIGHTGRAY, 0.3f ) )
    
    DrawCircleSector( center, outerRadius, startAngle, endAngle, segments, Fade( MAROON, 0.3 ) )
    DrawCircleSectorLines( center, outerRadius, startAngle, endAngle, segments, Fade( MAROON, 0.6 ) )
    
    '' Draw GUI controls
    startAngle = GuiSliderBar( Rectangle( 600, 40, 120, 20 ), "StartAngle", NULL, startAngle, 0, 720 )
    endAngle = GuiSliderBar( Rectangle( 600, 70, 120, 20 ), "EndAngle", NULL, endAngle, 0, 720 )
    
    outerRadius = GuiSliderBar( Rectangle( 600, 140, 120, 20 ), "Radius", NULL, outerRadius, 0, 200 )
    segments = GuiSliderBar ( Rectangle( 600, 170, 120, 20 ), "Segments", NULL, segments, 0, 100 )
    
    DrawText( TextFormat( "MODE: %s", iif( segments >= 4, "MANUAL", "AUTO" ) ), 600, 200, 10, iif( segments >= 4, MAROON, DARKGRAY ) )
    
    DrawFPS( 10, 10 )
  EndDrawing()
loop

'' De-Initialization
CloseWindow()
