/'*******************************************************************************************
*
*   raygui - image raw importer
*
*   DEPENDENCIES:
*       raylib 2.1  - Windowing/input management and drawing.
*       raygui 2.0  - Immediate-mode GUI controls.
*
*   COMPILATION (Windows - MinGW):
*       gcc -o $(NAME_PART).exe $(FILE_NAME) -I../../src -lraylib -lopengl32 -lgdi32 -std=c99
*
*   LICENSE: zlib/libpng
*
*   Copyright (c) 2020 Ramon Santamaria (@raysan5)
*
**********************************************************************************************'/

#include once "../raylib.bi"

#define RAYGUI_IMPLEMENTATION
#define RAYGUI_SUPPORT_RICONS
#include "../raygui.bi"

#include once "crt.bi"

'#include <string.h>             // Required for: strcpy()
'#include <stdlib.h>             // Required for: atoi()
'#include <math.h>               // Required for: round()

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 600

InitWindow( screenWidth, screenHeight, "raygui - image raw importer" )

dim as Texture2D texture

'' GUI controls initialization
var windowOffset = Vector2( screenWidth / 2 - 200 / 2, screenHeight / 2 - 465 / 2 )

dim as bool importWindowActive = false

dim as long widthValue = 0
dim as bool widthEditMode = false
dim as long heightValue = 0
dim as bool heightEditMode = false

dim as long pixelFormatActive = 0
dim as string pixelFormatTextList( 0 to 7 ) = { "CUSTOM", "GRAYSCALE", "GRAY ALPHA", "R5G6B5", "R8G8B8", "R5G5B5A1", "R4G4B4A4", "R8G8B8A8" }

dim as long channelsActive = 3
dim as string channelsTextList( 0 to 3 ) = { "1", "2", "3", "4" }
dim as long bitDepthActive = 0
dim as string bitDepthTextList( 0 to 3 ) = { "8", "16", "32" }

dim as long headerSizeValue = 0
dim as bool headerSizeEditMode = false

'' Image file info
dim as long dataSize = 0
dim as string fileNamePath
dim as string fileName

dim as bool btnLoadPressed = false

dim as bool imageLoaded = false
dim as single imageScale = 1.0f

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  '' Check if a file is dropped
  if( IsFileDropped() ) then
    dim as long fileCount = 0
    dim as zstring ptr ptr droppedFiles = GetDroppedFiles( @fileCount )
    
    '' Check file extensions for drag-and-drop
    if( ( fileCount = 1 ) andAlso IsFileExtension( droppedFiles[ 0 ], ".raw" ) ) then
      dim as FILE ptr imageFile = fopen( droppedFiles[ 0 ], "rb" )
      fseek( imageFile, 0L, SEEK_END )
      dataSize = ftell( imageFile )
      fclose( imageFile )
      
      '' NOTE: Returned string is just a pointer to droppedFiles[0],
      '' we need to make a copy of that data somewhere else: fileName
      fileNamePath = *droppedFiles[ 0 ] 
      fileName = *GetFileName( droppedFiles[ 0 ] )
      
      '' Try to guess possible raw values
      '' Let's assume image is square, RGBA, 8 bit per channel
      widthValue = round( sqr( dataSize / 4 ) )
      heightValue = widthValue
      headerSizeValue = dataSize - widthValue * heightValue * 4
      if( headerSizeValue < 0 ) then headerSizeValue = 0
      
      importWindowActive = true
    end if
    
    ClearDroppedFiles()
  end if
  
  '' Check if load button has been pressed
  if( btnLoadPressed ) then
    '' Depending on channels and bit depth, select correct pixel format
    if( ( widthValue <> 0 ) andAlso ( heightValue <> 0 ) ) then
      dim as long format_ = -1
      
      if( pixelFormatActive = 0 ) then
        dim as long channels = atoi( channelsTextList( channelsActive ) )
        dim as long bpp = atoi( bitDepthTextList( bitDepthActive ) )
        
        '' Select correct format depending on channels and bpp
        if( bpp = 8 ) then
          if( channels = 1 ) then format_ = UNCOMPRESSED_GRAYSCALE
          elseif( channels = 2 ) then format_ = UNCOMPRESSED_GRAY_ALPHA
          elseif( channels = 3 ) then format_ = UNCOMPRESSED_R8G8B8
          elseif( channels = 4 ) then format_ = UNCOMPRESSED_R8G8B8A8
        elseif( bpp = 32 ) then
          if( channels = 1 ) then format_ = UNCOMPRESSED_R32
          elseif( channels = 2 ) then TraceLog( LOG_WARNING, "Channel bit-depth not supported!" )
          elseif( channels = 3 ) then format_ = UNCOMPRESSED_R32G32B32
          elseif( channels = 4 ) then format_ = UNCOMPRESSED_R32G32B32A32
        elseif( bpp = 16 ) then
          TraceLog( LOG_WARNING, "Channel bit-depth not supported!" )
        end if
      else
        format_ = pixelFormatActive
      end if
      
      if( format_ <> -1 ) then
        dim as Image image = LoadImageRaw( fileNamePath, widthValue, heightValue, format_, headerSizeValue )
        dim as Texture2D texture = LoadTextureFromImage( image )
        UnloadImage( image )
        
        importWindowActive = false
        btnLoadPressed = false
        
        if( texture.id > 0 ) then
          imageLoaded = true
          imageScale = ( screenHeight - 100 ) / texture.height
        end if
      end if
    end if
  end if
  
  if( imageLoaded ) then imageScale += GetMouseWheelMove()   '' Image scale control
  
  '' Draw
  BeginDrawing()
    ClearBackground( GetColor( GuiGetStyle( DEFAULT, BACKGROUND_COLOR ) ) )
    
    if( imageLoaded ) then 
      DrawTextureEx( texture, Vector2( screenWidth / 2 - texture.width * imageScale / 2, screenHeight / 2 - texture.height * imageScale / 2 ), 0, imageScale, WHITE )
      DrawText( FormatText( "SCALE x%.0f", imageScale ), 20, screenHeight - 40, 20, GetColor( GuiGetStyle( DEFAULT, LINE_COLOR ) ) )
    else
      DrawText( "drag & drop RAW image file", 320, 180, 10, GetColor( GuiGetStyle( DEFAULT, LINE_COLOR ) ) )
    end if
    
    '' raygui: controls drawing
    if( importWindowActive ) then
      importWindowActive = not GuiWindowBox( Rectangle( windowOffset.x + 0, windowOffset.y + 0, 200, 465 ), "Image RAW Import Options" )
      
      GuiLabel( Rectangle( windowOffset.x + 10, windowOffset.y + 30, 65, 20 ), "Import file:" )
      GuiLabel( Rectangle( windowOffset.x + 85, windowOffset.y + 30, 75, 20 ), fileName )
      GuiLabel( Rectangle( windowOffset.x + 10, windowOffset.y + 50, 65, 20 ), "File size:" )
      GuiLabel( Rectangle( windowOffset.x + 85, windowOffset.y + 50, 75, 20 ), FormatText( "%i bytes", dataSize ) )
      GuiGroupBox( Rectangle( windowOffset.x + 10, windowOffset.y + 85, 180, 80 ), "Resolution" )
      GuiLabel( Rectangle( windowOffset.x + 20, windowOffset.y + 100, 33, 25 ), "Width:" )
      
      if( GuiValueBox( Rectangle( windowOffset.x + 60, windowOffset.y + 100, 80, 25 ), NULL, @widthValue, 0, 8192, widthEditMode ) ) then widthEditMode xor= true 
      
      GuiLabel( Rectangle( windowOffset.x + 145, windowOffset.y + 100, 30, 25 ), "pixels" )
      GuiLabel( Rectangle( windowOffset.x + 20, windowOffset.y + 130, 33, 25 ), "Height:" )
      
      if( GuiValueBox( Rectangle( windowOffset.x + 60, windowOffset.y + 130, 80, 25 ), NULL, @heightValue, 0, 8192, heightEditMode ) ) then heightEditMode xor= true 
      
      GuiLabel( Rectangle( windowOffset.x + 145, windowOffset.y + 130, 30, 25 ), "pixels" )
      GuiGroupBox( Rectangle( windowOffset.x + 10, windowOffset.y + 180, 180, 160 ), "Pixel Format" )
      pixelFormatActive = GuiComboBox( Rectangle( windowOffset.x + 20, windowOffset.y + 195, 160, 25 ), TextJoin( toPtrArray( pixelFormatTextList() ), 8, ";" ), pixelFormatActive )
      GuiLine( Rectangle( windowOffset.x + 20, windowOffset.y + 220, 160, 20 ), NULL )
      
      if( pixelFormatActive <> 0 ) then GuiDisable()
      
      GuiLabel( Rectangle( windowOffset.x + 20, windowOffset.y + 235, 50, 20 ), "Channels:" )
      channelsActive = GuiToggleGroup( Rectangle( windowOffset.x + 20, windowOffset.y + 255, 156 / 4, 25 ), TextJoin( toPtrArray( channelsTextList() ), 4, ";" ), channelsActive )
      GuiLabel( Rectangle( windowOffset.x + 20, windowOffset.y + 285, 50, 20 ), "Bit Depth:" )
      bitDepthActive = GuiToggleGroup( Rectangle( windowOffset.x + 20, windowOffset.y + 305, 160 / 3, 25 ), TextJoin( toPtrArray( bitDepthTextList() ), 3, ";" ), bitDepthActive )
      
      GuiEnable()
      
      GuiGroupBox( Rectangle( windowOffset.x + 10, windowOffset.y + 355, 180, 50 ), "Header" )
      GuiLabel( Rectangle( windowOffset.x + 25, windowOffset.y + 370, 27, 25 ), "Size:" )
      if( GuiValueBox( Rectangle( windowOffset.x + 55, windowOffset.y + 370, 85, 25 ), NULL, @headerSizeValue, 0, 10000, headerSizeEditMode ) ) then headerSizeEditMode xor= true 
      GuiLabel( Rectangle( windowOffset.x + 145, windowOffset.y + 370, 30, 25 ), "bytes" )
      
      btnLoadPressed = GuiButton( Rectangle( windowOffset.x + 10, windowOffset.y + 420, 180, 30 ), "Import RAW" )
    end if
  EndDrawing()
loop

'' De-Initialization
if( texture.id <> 0 ) then UnloadTexture( texture )

CloseWindow()
