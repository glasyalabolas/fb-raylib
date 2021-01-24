/'*******************************************************************************************
*
*   raylib [textures] example - Image processing
*
*   NOTE: Images are loaded in CPU memory (RAM); textures are loaded in GPU memory (VRAM)
*
*   This example has been created using raylib 1.4 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Copyright (c) 2016 Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"
#include once "crt.bi"

#define NUM_PROCESSES    8

enum ImageProcess
  NONE = 0
  COLOR_GRAYSCALE
  COLOR_TINT
  COLOR_INVERT
  COLOR_CONTRAST
  COLOR_BRIGHTNESS
  FLIP_VERTICAL
  FLIP_HORIZONTAL
end enum

dim as const string processText( ... ) = { _
  "NO PROCESSING", _
  "COLOR GRAYSCALE", _
  "COLOR TINT", _
  "COLOR INVERT", _
  "COLOR CONTRAST", _
  "COLOR BRIGHTNESS", _
  "FLIP VERTICAL", _
  "FLIP HORIZONTAL" }

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [textures] example - image processing" )

dim as Image image = LoadImage( "resources/parrots.png" )
ImageFormat( @image, UNCOMPRESSED_R8G8B8A8 )        '' Format image to RGBA 32bit (required for texture update) <-- ISSUE
dim as Texture2D texture = LoadTextureFromImage( image )

dim as long currentProcess = NONE
dim as boolean textureReload = false

dim as Rectangle toggleRecs( 0 to NUM_PROCESSES - 1 )
dim as long mouseHoverRec = -1

for i as integer = 0 to NUM_PROCESSES - 1
  toggleRecs( i ) = Rectangle( 40.0f, ( 50 + 32 * i ), 150.0f, 30.0f )
next

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  
  '' Mouse toggle group logic
  for i as integer = 0 to NUM_PROCESSES - 1
    if( CheckCollisionPointRec( GetMousePosition(), toggleRecs( i ) ) ) then
      mouseHoverRec = i
      
      if( IsMouseButtonReleased( MOUSE_LEFT_BUTTON ) ) then
        currentProcess = i
        textureReload = true
      end if
      
      exit for
    else
      mouseHoverRec = -1
    end if
  next
  
  '' Keyboard toggle group logic
  if( IsKeyPressed( KEY_DOWN ) ) then
    currentProcess += 1
    if( currentProcess > 7 ) then currentProcess = 0
    textureReload = true
  elseif( IsKeyPressed( KEY_UP ) ) then
    currentProcess -= 1
    if( currentProcess < 0 ) then currentProcess = 7
    textureReload = true
  end if
  
  '' Reload texture when required
  if( textureReload ) then
    UnloadImage( image )
    image = LoadImage( "resources/parrots.png" )
    
    '' NOTE: Image processing is a costly CPU process to be done every frame,
    '' If image processing is required in a frame-basis, it should be done
    '' with a texture and by shaders
    select case as const( currentProcess )
      case COLOR_GRAYSCALE : ImageColorGrayscale( @image )
      case COLOR_TINT : ImageColorTint( @image, RAYGREEN )
      case COLOR_INVERT : ImageColorInvert( @image )
      case COLOR_CONTRAST : ImageColorContrast( @image, -40 )
      case COLOR_BRIGHTNESS : ImageColorBrightness( @image, -80 )
      case FLIP_VERTICAL : ImageFlipVertical( @image )
      case FLIP_HORIZONTAL : ImageFlipHorizontal( @image )
    end select
    
    dim as RayColor ptr pixels = GetImageData( image ) '' Get pixel data from image (RGBA 32bit)
    UpdateTexture( texture, pixels )                   '' Update texture with new image data
    MemFree( pixels )                                  '' Unload pixels data from RAM
    
    textureReload = false
  end if
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    DrawText( "IMAGE PROCESSING:", 40, 30, 10, DARKGRAY )
    
    '' Draw rectangles
    for i as integer = 0 to NUM_PROCESSES - 1
      DrawRectangleRec( toggleRecs( i ), iif( ( ( i = currentProcess ) orElse ( i = mouseHoverRec ) ), SKYBLUE, LIGHTGRAY ) )
      DrawRectangleLines( toggleRecs( i ).x, toggleRecs( i ).y, toggleRecs( i ).width, toggleRecs( i ).height, iif( ( ( i = currentProcess) orElse ( i = mouseHoverRec ) ), RAYBLUE, GRAY ) )
      DrawText( processText( i ), clng( toggleRecs( i ).x + toggleRecs( i ).width / 2 - MeasureText( processText( i ), 10 ) / 2 ), clng( toggleRecs( i ).y + 11 ), 10, iif( ( ( i = currentProcess ) orElse ( i = mouseHoverRec ) ), DARKBLUE, DARKGRAY ) )
    next
    
    DrawTexture( texture, screenWidth - texture.width - 60, screenHeight / 2 - texture.height / 2, WHITE )
    DrawRectangleLines( screenWidth - texture.width - 60, screenHeight / 2 - texture.height / 2, texture.width, texture.height, BLACK )
  EndDrawing()
loop

'' De-Initialization
UnloadTexture( texture )
UnloadImage( image )

CloseWindow()
