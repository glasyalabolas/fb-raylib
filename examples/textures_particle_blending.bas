/'*******************************************************************************************
*
*   raylib example - particles blending
*
*   This example has been created using raylib 1.7 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Copyright (c) 2017 Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"

#define MAX_PARTICLES 200

'' Particle structure with basic data
type Particle
  as Vector2 position
  as RayColor color
  as single alpha
  as single size
  as single rotation
  as boolean active        '' NOTE: Use it to activate/deactive particle
end type

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [textures] example - particles blending" )

'' Particles pool, reuse them!
dim as Particle mouseTail( 0 to MAX_PARTICLES - 1 )

'' Initialize particles
for i as integer = 0 to MAX_PARTICLES - 1
  with mouseTail( i )
    .position = Vector2( 0, 0 )
    .color = RayColor( GetRandomValue( 0, 255 ), GetRandomValue( 0, 255 ), GetRandomValue( 0, 255 ), 255 )
    .alpha = 1.0f
    .size = GetRandomValue( 1, 30 ) / 20.0f
    .rotation = GetRandomValue( 0, 360 )
    .active = false
  end with
next

dim as single gravity = 3.0f

dim as Texture2D smoke = LoadTexture( "resources/spark_flame.png" )

dim as long blending = BLEND_ALPHA

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update

  '' Activate one particle every frame and Update active particles
  '' NOTE: Particles initial position should be mouse position when activated
  '' NOTE: Particles fall down with gravity and rotation... and disappear after 2 seconds (alpha = 0)
  '' NOTE: When a particle disappears, active = false and it can be reused.
  for i as integer = 0 to MAX_PARTICLES - 1
    with mouseTail( i )
      if( not .active ) then
        .active = true
        .alpha = 1.0f
        .position = GetMousePosition()
        i = MAX_PARTICLES
      end if
    end with
  next

  for i as integer = 0 to MAX_PARTICLES - 1
    with mouseTail( i )
      if( .active ) then
        .position.y += gravity / 2
        .alpha -= 0.005f
        
        if( .alpha <= 0.0f ) then .active = false
        
        .rotation += 2.0f
      end if
    end with
  next

  if( IsKeyPressed( KEY_SPACE ) ) then
    if( blending = BLEND_ALPHA ) then
      blending = BLEND_ADDITIVE
    else
      blending = BLEND_ALPHA
    end if
  end if

  '' Draw
  BeginDrawing()
    ClearBackground( DARKGRAY )
    
    BeginBlendMode( blending )
      '' Draw active particles
      for i as integer = 0 to MAX_PARTICLES - 1
        with mouseTail( i )
          if( .active ) then
            DrawTexturePro( smoke, Rectangle( 0.0f, 0.0f, smoke.width, smoke.height ), _
                            Rectangle( .position.x, .position.y, smoke.width * .size, smoke.height * .size ), _
                            Vector2( ( smoke.width * .size / 2.0f ), ( smoke.height * .size / 2.0f ) ), .rotation, _
                            Fade( .color, .alpha ) )
          end if
        end with
      next
    EndBlendMode()
    
    DrawText( "PRESS SPACE to CHANGE BLENDING MODE", 180, 20, 20, BLACK )
    
    if( blending = BLEND_ALPHA ) then
      DrawText( "ALPHA BLENDING", 290, screenHeight - 40, 20, BLACK )
    else
      DrawText( "ADDITIVE BLENDING", 280, screenHeight - 40, 20, RAYWHITE )
    end if
  EndDrawing()
loop

'' De-Initialization
UnloadTexture( smoke )

CloseWindow()
