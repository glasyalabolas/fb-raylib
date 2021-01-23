/'*******************************************************************************************
*
*   raylib [audio] example - Raw audio streaming
*
*   This example has been created using raylib 1.6 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Example created by Ramon Santamaria (@raysan5) and reviewed by James Hofmann (@triplefox)
*
*   Copyright (c) 2015-2019 Ramon Santamaria (@raysan5) and James Hofmann (@triplefox)
*
********************************************************************************************'/

#include once "../raylib.bi"
#include once "crt.bi" '' Required for: memcpy()

#define MAX_SAMPLES               512
#define MAX_SAMPLES_PER_UPDATE   4096

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [audio] example - raw audio streaming" )

InitAudioDevice()

'' Init raw audio stream (sample rate: 22050, sample size: 16bit-short, channels: 1-mono)
dim as AudioStream stream = InitAudioStream( 22050, 16, 1 )

'' Buffer for the single cycle waveform we are synthesizing
dim as short ptr _data = allocate( sizeof( short ) * MAX_SAMPLES )

'' Frame buffer, describing the waveform when repeated over the course of a frame
dim as short ptr writeBuf = allocate( sizeof( short ) * MAX_SAMPLES_PER_UPDATE )

'' Start processing stream buffer (no data loaded currently)
PlayAudioStream( stream )

'' Position read in to determine next frequency
dim as Vector2 mousePosition = Vector2( -100.0f, -100.0f )

'' Cycles per second (hz)
dim as single frequency = 440.0f

'' Previous value, used to test if sine needs to be rewritten, and to smoothly modulate frequency
dim as single oldFrequency = 1.0f

'' Cursor to read and copy the samples of the sine wave buffer
dim as long readCursor = 0

'' Computed size in samples of the sine wave
dim as long waveLength = 1

dim as Vector2 position = Vector2( 0, 0 )

SetTargetFPS( 30 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  '' Sample mouse input.
  mousePosition = GetMousePosition()
  
  if( IsMouseButtonDown( MOUSE_LEFT_BUTTON ) ) then
    dim as single fp = mousePosition.y
    
    frequency = 40.0f + fp
  end if
  
  '' Rewrite the sine wave.
  '' Compute two cycles to allow the buffer padding, simplifying any modulation, resampling, etc.
  if( frequency <> oldFrequency ) then
    '' Compute wavelength. Limit size in both directions
    dim as long oldWavelength = waveLength
    
    waveLength = 22050 / frequency
    
    if( waveLength > MAX_SAMPLES / 2 ) then waveLength = MAX_SAMPLES / 2
    if( waveLength < 1 ) then waveLength = 1

    '' Write sine wave
    for i as long = 0 to ( waveLength * 2 ) - 1
    'for (int i = 0; i < waveLength*2; i++)
    
      _data[ i ] = sin( ( ( 2 * PI * i / waveLength ) ) ) * 32000
    next

    '' Scale read cursor's position to minimize transition artifacts
    readCursor = int( readCursor * ( waveLength / oldWavelength ) )
    oldFrequency = frequency
  end if
  
  '' Refill audio stream if required
  if( IsAudioStreamProcessed( stream ) ) then
    '' Synthesize a buffer that is exactly the requested size
    dim as long writeCursor = 0

    do while( writeCursor < MAX_SAMPLES_PER_UPDATE )
      '' Start by trying to write the whole chunk at once
      dim as long writeLength = MAX_SAMPLES_PER_UPDATE - writeCursor
      
      '' Limit to the maximum readable size
      dim as long readLength = waveLength - readCursor
      
      if( writeLength > readLength ) then writeLength = readLength
      
      '' Write the slice
      memcpy( writeBuf + writeCursor, _data + readCursor, writeLength * sizeof( short ) )
      
      '' Update cursors and loop audio
      readCursor = ( readCursor + writeLength ) mod waveLength
      
      writeCursor += writeLength
    loop
    
    '' Copy finished frame to audio stream
    UpdateAudioStream( stream, writeBuf, MAX_SAMPLES_PER_UPDATE )
  end if
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    DrawText( TextFormat( "sine frequency: %i", frequency ), GetScreenWidth() - 220, 10, 20, RAYRED )
    DrawText( "click mouse button to change frequency", 10, 10, 20, DARKGRAY )
    
    '' Draw the current buffer state proportionate to the screen
    for i as long = 0 to screenWidth - 1
      position.x = i
      position.y = 250 + 50 * _data[ i * MAX_SAMPLES / screenWidth ] / 32000
      
      DrawPixelV( position, RAYRED )
    next
  EndDrawing()
loop

'' De-Initialization
deallocate( _data )
deallocate( writeBuf )

CloseAudioStream( stream )
CloseAudioDevice()

CloseWindow()
