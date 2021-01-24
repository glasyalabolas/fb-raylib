/'*******************************************************************************************
*
*   raylib [textures] example - Mouse painting
*
*   This example has been created using raylib 2.5 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Example contributed by Chris Dill (@MysteriousSpace) and reviewed by Ramon Santamaria (@raysan5)
*
*   Copyright (c) 2019 Chris Dill (@MysteriousSpace) and Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"

#define MAX_COLORS_COUNT    23          '' Number of colors available

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [textures] example - mouse painting" )

'' Colours to choose from
dim as RayColor colors( 0 to MAX_COLORS_COUNT - 1 ) = { _
    RAYWHITE, YELLOW, GOLD, ORANGE, PINK, RAYRED, MAROON, RAYGREEN, LIME, DARKGREEN, _
    SKYBLUE, RAYBLUE, DARKBLUE, PURPLE, VIOLET, DARKPURPLE, BEIGE, BROWN, DARKBROWN, _
    LIGHTGRAY, GRAY, DARKGRAY, BLACK }
    
'' Define colorsRecs data (for every rectangle)
dim as Rectangle colorsRecs( 0 to MAX_COLORS_COUNT - 1 )

for i as integer = 0 to MAX_COLORS_COUNT - 1
  with colorsRecs( i )
    .x = 10 + 30 * i + 2 * i
    .y = 10
    .width = 30
    .height = 30
  end with
next

dim as long _
  colorSelected = 0, _
  colorSelectedPrev = colorSelected, _
  colorMouseHover = 0, _
  brushSize = 20, _
  saveMessageCounter = 0

var btnSaveRec = Rectangle( 750, 10, 40, 30 )

dim as boolean _
  btnSaveMouseHover = false, _
  showSaveMessage = false

'' Create a RenderTexture2D to use as a canvas
dim as RenderTexture2D target = LoadRenderTexture( screenWidth, screenHeight )

'' Clear render texture before entering the game loop
BeginTextureMode( target )
  ClearBackground( colors( 0 ) )
EndTextureMode()

SetTargetFPS( 120 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  dim as Vector2 mousePos = GetMousePosition()
  
  '' Move between colors with keys
  if( IsKeyPressed( KEY_RIGHT ) ) then
    colorSelected += 1
  elseif( IsKeyPressed( KEY_LEFT ) ) then
    colorSelected -= 1
  end if
  
  if( colorSelected >= MAX_COLORS_COUNT ) then
    colorSelected = MAX_COLORS_COUNT - 1
  elseif( colorSelected < 0 ) then
    colorSelected = 0
  end if
  
  '' Choose color with mouse
  for i as integer = 0 to MAX_COLORS_COUNT - 1
    if( CheckCollisionPointRec( mousePos, colorsRecs( i ) ) ) then
      colorMouseHover = i
      exit for
    else
      colorMouseHover = -1
    end if
  next
  
  if( ( colorMouseHover >= 0 ) andAlso IsMouseButtonPressed( MOUSE_LEFT_BUTTON ) ) then 
    colorSelected = colorMouseHover
    colorSelectedPrev = colorSelected
  end if
  
  '' Change brush size
  brushSize += GetMouseWheelMove() * 5
  
  if( brushSize < 2 ) then brushSize = 2
  if( brushSize > 50 ) then brushSize = 50
  
  if( IsKeyPressed( KEY_C ) ) then
    '' Clear render texture to clear color
    BeginTextureMode( target )
      ClearBackground( colors( 0 ) )
    EndTextureMode()
  end if
  
  if( IsMouseButtonDown( MOUSE_LEFT_BUTTON ) orElse ( GetGestureDetected() = GESTURE_DRAG ) ) then
    '' Paint circle into render texture
    '' NOTE: To avoid discontinuous circles, we could store
    '' previous-next mouse points and just draw a line using brush size
    BeginTextureMode( target )
      if( mousePos.y > 50 ) then DrawCircle( mousePos.x, mousePos.y, brushSize, colors( colorSelected ) )
    EndTextureMode()
  end if
  
  if( IsMouseButtonDown( MOUSE_RIGHT_BUTTON ) ) then
      colorSelected = 0
      
      '' Erase circle from render texture
      BeginTextureMode( target )
        if( mousePos.y > 50 ) then DrawCircle( mousePos.x, mousePos.y, brushSize, colors( 0 ) )
      EndTextureMode()
  else
    colorSelected = colorSelectedPrev
  end if
  
  '' Check mouse hover save button
  if( CheckCollisionPointRec( mousePos, btnSaveRec ) ) then
    btnSaveMouseHover = true
  else
    btnSaveMouseHover = false
  end if
  
  '' Image saving logic
  '' NOTE: Saving painted texture to a default named image
  if( ( btnSaveMouseHover andAlso IsMouseButtonReleased( MOUSE_LEFT_BUTTON ) ) orElse IsKeyPressed( KEY_S ) ) then
    dim as Image image = GetTextureData( target.texture )
    ImageFlipVertical( @image )
    ExportImage( image, "my_amazing_texture_painting.png" )
    UnloadImage( image )
    showSaveMessage = true
  end if
  
  if( showSaveMessage ) then
    '' On saving, show a full screen message for 2 seconds
    saveMessageCounter += 1
    
    if( saveMessageCounter > 240 ) then
      showSaveMessage = false
      saveMessageCounter = 0
    end if
  end if
  
  '' Draw
  BeginDrawing()
      ClearBackground( RAYWHITE )
      
      '' NOTE: Render texture must be y-flipped due to default OpenGL coordinates (left-bottom)
      DrawTextureRec( target.texture, Rectangle( 0, 0, target.texture.width, -target.texture.height ), Vector2( 0, 0 ), WHITE )
      
      '' Draw drawing circle for reference
      if( mousePos.y > 50 ) then 
        if( IsMouseButtonDown( MOUSE_RIGHT_BUTTON ) ) then
          DrawCircleLines( mousePos.x, mousePos.y, brushSize, GRAY )
        else
          DrawCircle( GetMouseX(), GetMouseY(), brushSize, colors( colorSelected ) )
        end if
      end if
      
      '' Draw top panel
      DrawRectangle( 0, 0, GetScreenWidth(), 50, RAYWHITE )
      DrawLine( 0, 50, GetScreenWidth(), 50, LIGHTGRAY )
      
      '' Draw color selection rectangles
      for i as integer = 0 to MAX_COLORS_COUNT - 1
        DrawRectangleRec( colorsRecs( i ), colors( i ) )
      next
      
      DrawRectangleLines( 10, 10, 30, 30, LIGHTGRAY )
      
      if( colorMouseHover >= 0 ) then DrawRectangleRec( colorsRecs( colorMouseHover ), Fade( WHITE, 0.6f ) )
      
      DrawRectangleLinesEx( Rectangle( colorsRecs( colorSelected ).x - 2, colorsRecs( colorSelected ).y - 2, _ 
                            colorsRecs( colorSelected ).width + 4, colorsRecs( colorSelected ).height + 4 ), 2, BLACK )
      
      '' Draw save image button
      DrawRectangleLinesEx( btnSaveRec, 2, iif( btnSaveMouseHover, RAYRED, BLACK ) )
      DrawText( "SAVE!", 755, 20, 10, iif( btnSaveMouseHover, RAYRED, BLACK ) )
      
      '' Draw save image message
      if( showSaveMessage ) then
        DrawRectangle( 0, 0, GetScreenWidth(), GetScreenHeight(), Fade( RAYWHITE, 0.8f ) )
        DrawRectangle( 0, 150, GetScreenWidth(), 80, BLACK )
        DrawText( "IMAGE SAVED:  my_amazing_texture_painting.png", 150, 180, 20, RAYWHITE )
      end if
  EndDrawing()
loop

'' De-Initialization
UnloadRenderTexture( target )

CloseWindow()
