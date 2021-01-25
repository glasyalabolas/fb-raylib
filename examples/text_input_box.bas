/'*******************************************************************************************
*
*   raylib [text] example - Input Box
*
*   This example has been created using raylib 3.5 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Copyright (c) 2017 Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"

#define MAX_INPUT_CHARS     9

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [text] example - input box" )

dim as string name_     '' NOTE: One extra space required for line ending char '\0'
dim as long letterCount = 0

var textBox = Rectangle( screenWidth / 2 - 100, 180, 225, 50 )
dim as boolean mouseOnText = false

dim as long framesCounter = 0

SetTargetFPS( 10 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  if( CheckCollisionPointRec( GetMousePosition(), textBox ) ) then
    mouseOnText = true
  else
    mouseOnText = false
  end if
  
  if( mouseOnText ) then
    '' Set the window's cursor to the I-Beam
    SetMouseCursor( MOUSE_CURSOR_IBEAM )
    
    '' Get char pressed (unicode character) on the queue
    dim as long key = GetCharPressed()
    
    '' Check if more characters have been pressed on the same frame
    do while( key > 0 )
        '' NOTE: Only allow keys in range [32..125]
      if( ( key >= 32 ) andAlso ( key <= 125 ) andAlso ( letterCount < MAX_INPUT_CHARS ) ) then
        name_ += chr( key )
        letterCount += 1
      end if
      
      key = GetCharPressed()  '' Check next character in the queue
    loop
    
    if( IsKeyPressed( KEY_BACKSPACE ) ) then
      letterCount -= 1
      if( letterCount < 0 ) then letterCount = 0
      name_ = left( name_, letterCount )
    end if
  elseif( GetMouseCursor() <> MOUSE_CURSOR_DEFAULT ) then
    SetMouseCursor( MOUSE_CURSOR_DEFAULT )
  end if
  
  if( mouseOnText ) then
    framesCounter += 1
  else
    framesCounter = 0
  end if
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    DrawText( "PLACE MOUSE OVER INPUT BOX!", 240, 140, 20, GRAY )
    
    DrawRectangleRec( textBox, LIGHTGRAY )
    if( mouseOnText ) then
      DrawRectangleLines( textBox.x, textBox.y, textBox.width, textBox.height, RAYRED )
    else
      DrawRectangleLines( textBox.x, textBox.y, textBox.width, textBox.height, DARKGRAY )
    end if
    
    DrawText( name_, textBox.x + 5, textBox.y + 8, 40, MAROON )
    DrawText( TextFormat( "INPUT CHARS: %i/%i", letterCount, MAX_INPUT_CHARS ), 315, 250, 20, DARKGRAY )
    
    if( mouseOnText ) then
      if( letterCount < MAX_INPUT_CHARS ) then
        '' Draw blinking underscore char
        if( ( ( framesCounter / 20 ) mod 2 ) = 0 ) then
          DrawText( "_", textBox.x + 8 + MeasureText( name_, 40 ), textBox.y + 12, 40, MAROON )
        end if
      else
        DrawText( "Press BACKSPACE to delete chars...", 230, 300, 20, GRAY )
      end if
    end if
  EndDrawing()
loop

'' De-Initialization
CloseWindow()

'' Check if any key is pressed
'' NOTE: We limit keys check to keys between 32 (KEY_SPACE) and 126
function IsAnyKeyPressed() as boolean
  dim as boolean keyPressed = false
  dim as long key = GetKeyPressed()
  
  if( ( key >= 32 ) andAlso ( key <= 126 ) ) then keyPressed = true
  
  return( keyPressed )
end function