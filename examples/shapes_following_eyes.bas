/'*******************************************************************************************
*
*   raylib [shapes] example - following eyes
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

SetConfigFlags( FLAG_MSAA_4X_HINT )
InitWindow( screenWidth, screenHeight, "raylib [shapes] example - following eyes" )

var _
  scleraLeftPosition = Vector2( GetScreenWidth() / 2 - 100, GetScreenHeight() / 2 ), _
  scleraRightPosition = Vector2( GetScreenWidth() / 2 + 100, GetScreenHeight() / 2 )
dim as single scleraRadius = 80

var _
  irisLeftPosition = Vector2( GetScreenWidth() / 2 - 100, GetScreenHeight() / 2 ), _
  irisRightPosition = Vector2( GetScreenWidth() / 2 + 100, GetScreenHeight() / 2 )
dim as single irisRadius = 24

dim as single _
  angle = 0.0f, _
  dx = 0.0f, dy = 0.0f, dxx = 0.0f, dyy = 0.0f

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  irisLeftPosition = GetMousePosition()
  irisRightPosition = GetMousePosition()

  '' Check not inside the left eye sclera
  if( not CheckCollisionPointCircle(irisLeftPosition, scleraLeftPosition, scleraRadius - 20 ) ) then
    dx = irisLeftPosition.x - scleraLeftPosition.x
    dy = irisLeftPosition.y - scleraLeftPosition.y
    
    angle = atan2( dy, dx )
    
    dxx = ( scleraRadius - irisRadius ) * cos( angle )
    dyy = ( scleraRadius - irisRadius ) * sin( angle )
    
    irisLeftPosition.x = scleraLeftPosition.x + dxx
    irisLeftPosition.y = scleraLeftPosition.y + dyy
  end if
  
  '' Check not inside the right eye sclera
  if( not CheckCollisionPointCircle(irisRightPosition, scleraRightPosition, scleraRadius - 20 ) ) then
    dx = irisRightPosition.x - scleraRightPosition.x
    dy = irisRightPosition.y - scleraRightPosition.y
    
    angle = atan2( dy, dx )
    
    dxx = ( scleraRadius - irisRadius ) * cos( angle )
    dyy = ( scleraRadius - irisRadius ) * sin( angle )
    
    irisRightPosition.x = scleraRightPosition.x + dxx
    irisRightPosition.y = scleraRightPosition.y + dyy
  end if
  
  '' Draw
  BeginDrawing()
    ClearBackground(RAYWHITE)

    DrawCircleV( scleraLeftPosition, scleraRadius, LIGHTGRAY )
    DrawCircleV( irisLeftPosition, irisRadius, BROWN )
    DrawCircleV( irisLeftPosition, 10, BLACK )

    DrawCircleV( scleraRightPosition, scleraRadius, LIGHTGRAY )
    DrawCircleV( irisRightPosition, irisRadius, DARKGREEN )
    DrawCircleV( irisRightPosition, 10, BLACK )

    DrawFPS( 10, 10 )
  EndDrawing()
loop

'' De-Initialization
CloseWindow()
