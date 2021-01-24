/'*******************************************************************************************
*
*   raylib [textures] example - Draw part of the texture tiled
*
*   This example has been created using raylib 3.0 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Copyright (c) 2020 Vlad Adrian (@demizdor) and Ramon Santamaria (@raysan5)
*
********************************************************************************************'/
#include once "../raylib.bi"

#define SIZEOF_ARRAY( A ) ( ( ubound( A ) - lbound( A ) ) + 1 )
#define OPT_WIDTH       220       '' Max width for the options container
#define MARGIN_SIZE       8       '' Size for the margins
#define COLOR_SIZE       16       '' Size of the color select buttons

'' Initialization
dim as long _
  screenWidth = 800, screenHeight = 450

SetConfigFlags( FLAG_WINDOW_RESIZABLE )
InitWindow( screenWidth, screenHeight, "raylib [textures] example - Draw part of a texture tiled" )

'' NOTE: Textures MUST be loaded after Window initialization (OpenGL context is required)
dim as Texture texPattern = LoadTexture( "resources/patterns.png" )
SetTextureFilter( texPattern, FILTER_TRILINEAR )

'' Coordinates for all patterns inside the texture
dim as const Rectangle recPattern( ... ) = { _
  Rectangle( 3, 3, 66, 66 ), _
  Rectangle( 75, 3, 100, 100 ), _
  Rectangle( 3, 75, 66, 66 ), _
  Rectangle( 7, 156, 50, 50 ), _
  Rectangle( 85, 106, 90, 45 ), _
  Rectangle( 75, 154, 100, 60 ) }

'' Setup colors
dim as const RayColor colors( ... ) = { BLACK, MAROON, ORANGE, RAYBLUE, PURPLE, BEIGE, LIME, RAYRED, DARKGRAY, SKYBLUE }
dim as const long MAX_COLORS = SIZEOF_ARRAY( colors )

dim as Rectangle colorRec( 0 to MAX_COLORS - 1 )

'' Calculate rectangle for each color
dim as long x = 0, y = 0, i = 0

do while( i < MAX_COLORS )
  with colorRec( i )
    .x = 2 + MARGIN_SIZE + x
    .y = 22 + 256 + MARGIN_SIZE + y
    .width = COLOR_SIZE * 2
    .height = COLOR_SIZE
  end with
  
  if( i = ( MAX_COLORS / 2 - 1 ) ) then
    x = 0 
    y += COLOR_SIZE + MARGIN_SIZE
  else
    x += ( COLOR_SIZE * 2 + MARGIN_SIZE )
  end if
  
  i += 1 : x += 1 : y += 1
loop

dim as long activePattern = 0, activeCol = 0
dim as single scale = 1.0f, rotation = 0.0f

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  screenWidth = GetScreenWidth()
  screenHeight = GetScreenHeight()
  
  '' Handle mouse
  if( IsMouseButtonPressed( MOUSE_LEFT_BUTTON ) ) then
    dim as Vector2 mouse = GetMousePosition()
    
    '' Check which pattern was clicked and set it as the active pattern
    for i as integer = 0 to SIZEOF_ARRAY( recPattern ) - 1
      if( CheckCollisionPointRec( mouse, Rectangle( 2 + MARGIN_SIZE + recPattern( i ).x, 40 + MARGIN_SIZE + recPattern( i ).y, recPattern( i ).width, recPattern( i ).height ) ) ) then
        activePattern = i 
        exit for
      end if
    next
    
    '' Check to see which color was clicked and set it as the active color
    for i as integer = 0 to MAX_COLORS - 1
      if( CheckCollisionPointRec( mouse, colorRec( i ) ) ) then
        activeCol = i
        exit for
      end if
    next
  end if
  
  '' Handle keys
  '' Change scale
  if( IsKeyPressed( KEY_UP ) ) then scale += 0.25f
  if( IsKeyPressed( KEY_DOWN ) ) then scale -= 0.25f
  if( scale > 10.0f ) then
    scale = 10.0f
  elseif( scale <= 0.0f ) then
    scale = 0.25f
  end if
  
  '' Change rotation
  if( IsKeyPressed( KEY_LEFT ) ) then rotation -= 25.0f
  if( IsKeyPressed( KEY_RIGHT ) ) then rotation += 25.0f
  
  '' Reset
  if( IsKeyPressed( KEY_SPACE ) ) then
    rotation = 0.0f : scale = 1.0f
  end if
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    '' Draw the tiled area
    DrawTextureTiled( texPattern, recPattern( activePattern ), Rectangle( OPT_WIDTH + MARGIN_SIZE, MARGIN_SIZE, screenWidth - OPT_WIDTH - 2 * MARGIN_SIZE, screenHeight - 2 * MARGIN_SIZE ), _
      Vector2( 0.0f, 0.0f ), rotation, scale, colors( activeCol ) )
    
    '' Draw options
    DrawRectangle( MARGIN_SIZE, MARGIN_SIZE, OPT_WIDTH - MARGIN_SIZE, screenHeight - 2 * MARGIN_SIZE, ColorAlpha( LIGHTGRAY, 0.5f ) )
    
    DrawText( "Select Pattern", 2 + MARGIN_SIZE, 30 + MARGIN_SIZE, 10, BLACK )
    DrawTexture( texPattern, 2 + MARGIN_SIZE, 40 + MARGIN_SIZE, BLACK )
    DrawRectangle( 2 + MARGIN_SIZE + recPattern( activePattern ).x, 40 + MARGIN_SIZE + recPattern( activePattern ).y, recPattern( activePattern ).width, recPattern( activePattern ).height, ColorAlpha( DARKBLUE, 0.3f ) )
    
    DrawText( "Select Color", 2 + MARGIN_SIZE, 10 + 256 + MARGIN_SIZE, 10, BLACK )
    
    for i as integer = 0 to MAX_COLORS - 1
      DrawRectangleRec( colorRec( i ), colors( i ) )
      if( activeCol = i ) then DrawRectangleLinesEx( colorRec( i ), 3.0f, ColorAlpha( WHITE, 0.5f ) )
    next
    
    DrawText( "Scale (UP/DOWN to change)", 2 + MARGIN_SIZE, 80 + 256 + MARGIN_SIZE, 10, BLACK )
    DrawText( TextFormat( "%.2fx", scale ), 2 + MARGIN_SIZE, 92 + 256 + MARGIN_SIZE, 20, BLACK )
    
    DrawText( "Rotation (LEFT/RIGHT to change)", 2 + MARGIN_SIZE, 122 + 256 + MARGIN_SIZE, 10, BLACK )
    DrawText( TextFormat( "%.0f degrees", rotation ), 2 + MARGIN_SIZE, 134 + 256 + MARGIN_SIZE, 20, BLACK )
    
    DrawText( "Press [SPACE] to reset", 2 + MARGIN_SIZE, 164 + 256 + MARGIN_SIZE, 10, DARKBLUE )
    
    '' Draw FPS
    DrawText( TextFormat( "%i FPS", GetFPS() ), 2 + MARGIN_SIZE, 2 + MARGIN_SIZE, 20, BLACK )
  EndDrawing()
loop

'' De-Initialization
UnloadTexture( texPattern )

CloseWindow()
