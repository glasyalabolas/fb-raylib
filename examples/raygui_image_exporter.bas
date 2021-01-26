/'*******************************************************************************************
*
*   raygui - image exporter
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
********************************************************************************************'/

#include once "../raylib.bi"

#define RAYGUI_IMPLEMENTATION
#define RAYGUI_SUPPORT_RICONS
#include "../raygui.bi"

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raygui - image exporter" )

'' GUI controls initialization
var windowBoxRec = Rectangle( screenWidth / 2 - 110, screenHeight / 2 - 100, 220, 190 )
dim as bool windowBoxActive = false

dim as long fileFormatActive = 0
dim as string fileFormatTextList( ... ) = { "IMAGE (.png)", "DATA (.raw)", "CODE (.h)" }

dim as long pixelFormatActive = 0
dim as string pixelFormatTextList( ... ) = { "GRAYSCALE", "GRAY ALPHA", "R5G6B5", "R8G8B8", "R5G5B5A1", "R4G4B4A4", "R8G8B8A8" }

dim as bool textBoxEditMode = false
dim as string fileName = "untitled"

dim as Image image
dim as Texture2D texture

dim as bool imageLoaded = false
dim as single imageScale = 1.0f
dim as Rectangle imageRec

dim as bool btnExport = false

dim as string msg = ""

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  if( IsFileDropped() ) then
    dim as long fileCount = 0
    dim as zstring ptr ptr droppedFiles = GetDroppedFiles( @fileCount )
    
    if( fileCount = 1 ) then
      dim as Image imTemp = LoadImage( droppedFiles[ 0 ] )
      
      if( imTemp.data <> NULL ) then
        UnloadImage( image )
        image = imTemp
        
        UnloadTexture( texture )
        texture = LoadTextureFromImage( image )
        
        imageLoaded = true
        pixelFormatActive = image.format - 1
        
        if( texture.height > texture.width ) then
          imageScale = ( screenHeight - 100 ) / texture.height
        else
          imageScale = ( screenWidth - 100 ) / texture.width
        end if
      end if
    end if
    
    ClearDroppedFiles()
  end if
  
  if( btnExport ) then
    if( imageLoaded ) then
      ImageFormat( @image, pixelFormatActive + 1 )
      
      if( fileFormatActive = 0 ) then        '' PNG
        if( ( GetExtension( fileName ) = NULL ) orElse ( not IsFileExtension( fileName, ".png" ) ) ) then
          strcat( fileName, !".png\0" )     '' No extension provided
        end if
        ExportImage( image, fileName )
      elseif( fileFormatActive = 1 ) then    '' RAW
        if( ( GetExtension( fileName ) = NULL) orElse ( not IsFileExtension( fileName, ".raw" ) ) ) then
          strcat( fileName, !".raw\0" )     '' No extension provided
        end if
        
        dim as long dataSize = GetPixelDataSize( image.width, image.height, image.format )
        
        dim as FILE ptr rawFile = fopen( fileName, "wb" )  
        fwrite( image.data, dataSize, 1, rawFile )
        fclose( rawFile )
      elseif( fileFormatActive = 2 ) then    '' CODE
        ExportImageAsCode( image, fileName )
      end if
    end if
    
    windowBoxActive = false
  end if
    
  if( imageLoaded ) then
      imageScale += GetMouseWheelMove() * 0.05f   '' Image scale control
      if( imageScale <= 0.1f ) then
        imageScale = 0.1f
      elseif( imageScale >= 5 ) then
        imageScale = 5
      end if
      
      imageRec = Rectangle( screenWidth / 2 - image.width * imageScale / 2, _ 
                            screenHeight / 2 - image.height * imageScale / 2, _
                            image.width * imageScale, image.height * imageScale )
  end if
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    if( texture.id > 0 ) then
      DrawTextureEx( texture, Vector2( screenWidth / 2 - texture.width * imageScale / 2, screenHeight / 2 - texture.height * imageScale / 2 ), 0.0f, imageScale, WHITE )
      
      DrawRectangleLinesEx( imageRec, 1, iif( CheckCollisionPointRec( GetMousePosition(), imageRec ), RAYRED, DARKGRAY ) )
      DrawText( FormatText( "SCALE: %.2f%%", imageScale * 100.0f ), 20, screenHeight - 40, 20, GetColor( GuiGetStyle( DEFAULT, LINE_COLOR ) ) )
    else
      DrawText( "DRAG & DROP YOUR IMAGE!", 350, 200, 10, DARKGRAY )
      GuiDisable()
    end if
    
    if( GuiButton( Rectangle( screenWidth - 170, screenHeight - 50, 150, 30 ), "Image Export" ) ) then
      windowBoxActive = true
    end if
    
    GuiEnable()
    
    '' Draw window box: windowBoxName
    if( windowBoxActive ) then
      DrawRectangle( 0, 0, screenWidth, screenHeight, Fade( GetColor( GuiGetStyle( DEFAULT, BACKGROUND_COLOR ) ), 0.7f ) )
      windowBoxActive = not GuiWindowBox( Rectangle( windowBoxRec.x, windowBoxRec.y, 220, 190 ), "Image Export Options" )
      
      GuiLabel( Rectangle( windowBoxRec.x + 10, windowBoxRec.y + 35, 60, 25 ), "File format:" )
      fileFormatActive = GuiComboBox( Rectangle( windowBoxRec.x + 80, windowBoxRec.y + 35, 130, 25 ), TextJoin( toPtrArray( fileFormatTextList() ), 3, ";" ), fileFormatActive ) 
      GuiLabel( Rectangle( windowBoxRec.x + 10, windowBoxRec.y + 70, 63, 25 ), "Pixel format:" )
      pixelFormatActive = GuiComboBox( Rectangle( windowBoxRec.x + 80, windowBoxRec.y + 70, 130, 25 ), TextJoin( toPtrArray( pixelFormatTextList() ), 7, ";" ), pixelFormatActive )
      GuiLabel( Rectangle( windowBoxRec.x + 10, windowBoxRec.y + 105, 50, 25 ), "File name:" )
      
      if( GuiTextBox( Rectangle( windowBoxRec.x + 80, windowBoxRec.y + 105, 130, 25 ), fileName, 64, textBoxEditMode)) then
        textBoxEditMode xor= true
      end if
      
      btnExport = GuiButton( Rectangle( windowBoxRec.x + 10, windowBoxRec.y + 145, 200, 30 ), "Export Image" )
    else
      btnExport = false
    end if
    
    if( btnExport ) then msg = "Image exported!"
    
    if( len( msg ) ) then
      DrawText( msg, 20, screenHeight - 20, 20, RAYRED )
    end if
  EndDrawing()
loop

'' De-Initialization
UnloadImage( image )
UnloadTexture( texture )

CloseWindow()
