/'*******************************************************************************************
*
*   raylib [core] example - window scale letterbox (and virtual mouse)
*
*   This example has been created using raylib 2.5 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Example contributed by Anata (@anatagawa) and reviewed by Ramon Santamaria (@raysan5)
*
*   Copyright (c) 2019 Anata (@anatagawa) and Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"

#define max( a, b ) iif( ( a ) > ( b ), ( a ), ( b ) )
#define min( a, b ) iif( ( a ) < ( b ), ( a ), ( b ) )

'' Clamp Vector2 value with min and max and return a new vector2
'' NOTE: Required for virtual mouse, to clamp inside virtual game size
function ClampValue( value as Vector2, min_ as Vector2, max_ as Vector2 ) as Vector2
  dim as Vector2 result = value
  
  with result
    .x = iif( .x > max_.x, max_.x, .x )
    .x = iif( .x < min_.x, min_.x, .x )
    .y = iif( .y > max_.y, max_.y, .y )
    .y = iif( .y < min_.y, min_.y, .y )
  end with
  
  return( result )
end function

const as long _
  windowWidth = 800, windowHeight = 450

'' Enable config flags for resizable window and vertical synchro
SetConfigFlags( FLAG_WINDOW_RESIZABLE or FLAG_VSYNC_HINT )
InitWindow( windowWidth, windowHeight, "raylib [core] example - window scale letterbox" )
SetWindowMinSize( 320, 240 )

dim as long _
  gameScreenWidth = 640, gameScreenHeight = 480

'' Render texture initialization, used to hold the rendering result so we can easily resize it
dim as RenderTexture2D target = LoadRenderTexture( gameScreenWidth, gameScreenHeight )
SetTextureFilter( target.texture, FILTER_BILINEAR ) '' Texture scale filter to use

dim as RayColor colors( 0 to 9 )

for i as integer = 0 to 9
  colors( i ) = RayColor( GetRandomValue( 100, 250 ), GetRandomValue( 50, 150 ), GetRandomValue( 10, 100 ), 255 )
next

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  '' Compute required framebuffer scaling
  dim as single scale = min( GetScreenWidth() / gameScreenWidth, GetScreenHeight() / gameScreenHeight )
  
  if( IsKeyPressed( KEY_SPACE ) ) then
    '' Recalculate random colors for the bars
    for i as integer = 0 to 9
      colors( i ) = RayColor( GetRandomValue( 100, 250 ), GetRandomValue( 50, 150 ), GetRandomValue( 10, 100 ), 255 )
    next
  end if
  
  '' Update virtual mouse (clamped mouse value behind game screen)
  dim as Vector2 _
    mouse = GetMousePosition(), _
    virtualMouse
  
  virtualMouse.x = ( mouse.x - ( GetScreenWidth() - ( gameScreenWidth * scale ) ) * 0.5f ) / scale
  virtualMouse.y = ( mouse.y - ( GetScreenHeight() - ( gameScreenHeight * scale ) ) * 0.5f ) / scale
  virtualMouse = ClampValue( virtualMouse, Vector2( 0, 0 ), Vector2( gameScreenWidth, gameScreenHeight ) )
  
  '' Draw
  BeginDrawing()
    ClearBackground( BLACK )
    
    '' Draw everything in the render texture, note this will not be rendered on screen, yet
    BeginTextureMode( target )
      ClearBackground( RAYWHITE )
      
      for i as integer = 0 to 9
        DrawRectangle( 0, ( gameScreenHeight / 10 ) * i, gameScreenWidth, gameScreenHeight / 10, colors( i ) )
      next
      
      DrawText( !"If executed inside a window,\nyou can resize the window,\nand see the screen scaling!", 10, 25, 20, WHITE )
      
      DrawText( TextFormat( "Default Mouse: [%i , %i]", clng( mouse.x ), clng( mouse.y ) ), 350, 25, 20, RAYGREEN )
      DrawText( TextFormat( "Virtual Mouse: [%i , %i]", clng( virtualMouse.x ), clng( virtualMouse.y ) ), 350, 55, 20, YELLOW )
    EndTextureMode()
    
    '' Draw RenderTexture2D to window, properly scaled
    DrawTexturePro(_
      target.texture, Rectangle( 0.0f, 0.0f, target.texture.width, -target.texture.height ), _
      Rectangle( ( GetScreenWidth() - ( gameScreenWidth * scale ) ) * 0.5, ( GetScreenHeight() - ( gameScreenHeight * scale ) ) * 0.5, _
      gameScreenWidth * scale, gameScreenHeight * scale ), Vector2( 0, 0 ), 0.0f, WHITE )
  EndDrawing()
loop

'' De-Initialization
UnloadRenderTexture( target )
CloseWindow()
