/'*******************************************************************************************
*
*   raylib [textures] example - sprite explosion
*
*   This example has been created using raylib 2.5 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Copyright (c) 2019 Anata and Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"

#define NUM_FRAMES_PER_LINE     5
#define NUM_LINES               5

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [textures] example - sprite explosion" )

InitAudioDevice()

'' Load explosion sound
dim as Sound fxBoom = LoadSound( "resources/boom.wav" )

'' Load explosion texture
dim as Texture2D explosion = LoadTexture( "resources/explosion.png" )

'' Init variables for animation
dim as long _
  frameWidth = explosion.width / NUM_FRAMES_PER_LINE, _   '' Sprite one frame rectangle width
  frameHeight = explosion.height / NUM_LINES, _           '' Sprite one frame rectangle height
  currentFrame = 0, _
  currentLine = 0

var frameRec = Rectangle( 0, 0, frameWidth, frameHeight )
dim as Vector2 position

dim as boolean active = false
dim as long framesCounter = 0

SetTargetFPS( 120 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  
  '' Check for mouse button pressed and activate explosion (if not active)
  if( IsMouseButtonPressed( MOUSE_LEFT_BUTTON ) andAlso not active ) then
    position = GetMousePosition()
    active = true
    
    position.x -= frameWidth / 2
    position.y -= frameHeight / 2
    
    PlaySound( fxBoom )
  end if
  
  '' Compute explosion animation frames
  if( active ) then
    framesCounter += 1
    
    if( framesCounter > 2 ) then
      currentFrame += 1
      
      if( currentFrame >= NUM_FRAMES_PER_LINE ) then
        currentFrame = 0
        currentLine += 1
        
        if( currentLine >= NUM_LINES ) then
          currentLine = 0
          active = false
        end if
      end if
      
      framesCounter = 0
    end if
  end if
  
  frameRec.x = frameWidth * currentFrame
  frameRec.y = frameHeight * currentLine
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    '' Draw explosion required frame rectangle
    if( active ) then DrawTextureRec( explosion, frameRec, position, WHITE )
  EndDrawing()
loop

'' De-Initialization
UnloadTexture( explosion )
UnloadSound( fxBoom )

CloseAudioDevice()

CloseWindow()
