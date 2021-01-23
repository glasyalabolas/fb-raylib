/'*******************************************************************************************
*
*   raylib [core] example - window flags
*
*   This example has been created using raylib 3.5 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Copyright (c) 2020 Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

'' Possible window flags
/'
  FLAG_VSYNC_HINT
  FLAG_FULLSCREEN_MODE    -> not working properly -> wrong scaling!
  FLAG_WINDOW_RESIZABLE
  FLAG_WINDOW_UNDECORATED
  FLAG_WINDOW_TRANSPARENT
  FLAG_WINDOW_HIDDEN
  FLAG_WINDOW_MINIMIZED   -> Not supported on window creation
  FLAG_WINDOW_MAXIMIZED   -> Not supported on window creation
  FLAG_WINDOW_UNFOCUSED
  FLAG_WINDOW_TOPMOST
  FLAG_WINDOW_HIGHDPI     -> errors after minimize-resize, fb size is recalculated
  FLAG_WINDOW_ALWAYS_RUN
  FLAG_MSAA_4X_HINT
'/

'' Set configuration flags for window creation
SetConfigFlags( FLAG_VSYNC_HINT or FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI )
InitWindow( screenWidth, screenHeight, "raylib [core] example - window flags" )

var _
  ballPosition = Vector2( GetScreenWidth() / 2, GetScreenHeight() / 2 ), _
  ballSpeed = Vector2( 5.0f, 4.0f )

dim as long _
  ballRadius = 20, _
  framesCounter = 0

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  if( IsKeyPressed( KEY_F ) ) then ToggleFullscreen()  '' modifies window size when scaling!
  
  if( IsKeyPressed( KEY_R ) ) then
    if( IsWindowState( FLAG_WINDOW_RESIZABLE ) ) then
      ClearWindowState( FLAG_WINDOW_RESIZABLE )
    else
      SetWindowState( FLAG_WINDOW_RESIZABLE )
    end if
  end if
  
  if( IsKeyPressed( KEY_D ) ) then
    if( IsWindowState( FLAG_WINDOW_UNDECORATED ) ) then
      ClearWindowState( FLAG_WINDOW_UNDECORATED )
    else
      SetWindowState( FLAG_WINDOW_UNDECORATED )
    end if
  end if
  
  if( IsKeyPressed( KEY_H ) ) then
    if( not IsWindowState( FLAG_WINDOW_HIDDEN ) ) then SetWindowState( FLAG_WINDOW_HIDDEN )
    
    framesCounter = 0
  end if
  
  if( IsWindowState( FLAG_WINDOW_HIDDEN ) ) then
    framesCounter += 1
    if( framesCounter >= 240 ) then ClearWindowState( FLAG_WINDOW_HIDDEN ) '' Show window after 3 seconds
  end if
  
  if( IsKeyPressed( KEY_N ) ) then
    if( not IsWindowState( FLAG_WINDOW_MINIMIZED ) ) then MinimizeWindow()
    
    framesCounter = 0
  end if
  
  if( IsWindowState( FLAG_WINDOW_MINIMIZED ) ) then
    framesCounter += 1
    if( framesCounter >= 240 ) then RestoreWindow() '' Restore window after 3 seconds
  end if
  
  if( IsKeyPressed( KEY_M ) ) then
    '' NOTE: Requires FLAG_WINDOW_RESIZABLE enabled!
    if( IsWindowState( FLAG_WINDOW_MAXIMIZED ) ) then
      RestoreWindow()
    else
      MaximizeWindow()
    end if
  end if
  
  if( IsKeyPressed( KEY_U ) ) then
    if( IsWindowState( FLAG_WINDOW_UNFOCUSED ) ) then
      ClearWindowState( FLAG_WINDOW_UNFOCUSED )
    else
      SetWindowState( FLAG_WINDOW_UNFOCUSED )
    end if
  end if
  
  if( IsKeyPressed( KEY_T ) ) then
    if( IsWindowState( FLAG_WINDOW_TOPMOST ) ) then
      ClearWindowState( FLAG_WINDOW_TOPMOST )
    else
      SetWindowState( FLAG_WINDOW_TOPMOST )
    end if
  end if
  
  if( IsKeyPressed( KEY_A ) ) then
    if( IsWindowState( FLAG_WINDOW_ALWAYS_RUN ) ) then
      ClearWindowState( FLAG_WINDOW_ALWAYS_RUN )
    else
      SetWindowState( FLAG_WINDOW_ALWAYS_RUN )
    end if
  end if
  
  if( IsKeyPressed( KEY_V ) ) then
    if( IsWindowState( FLAG_VSYNC_HINT ) ) then
      ClearWindowState( FLAG_VSYNC_HINT )
    else
      SetWindowState( FLAG_VSYNC_HINT )
    end if
  end if
  
  '' Bouncing ball logic
  with ballPosition
    .x += ballSpeed.x
    .y += ballSpeed.y
    if( ( .x >= ( GetScreenWidth() - ballRadius ) ) orElse ( ballPosition.x <= ballRadius ) ) then ballSpeed.x *= -1.0f
    if( ( .y >= ( GetScreenHeight() - ballRadius ) ) orElse ( ballPosition.y <= ballRadius ) ) then ballSpeed.y *= -1.0f
  end with
  
  '' Draw
  BeginDrawing()
    if( IsWindowState( FLAG_WINDOW_TRANSPARENT ) ) then
      ClearBackground( BLANK )
    else
      ClearBackground( RAYWHITE )
    end if
    
    DrawCircleV( ballPosition, ballRadius, MAROON )
    DrawRectangleLinesEx( Rectangle( 0, 0, GetScreenWidth(), GetScreenHeight() ), 4, RAYWHITE )
    
    DrawCircleV( GetMousePosition(), 10, DARKBLUE )
    
    DrawFPS( 10, 10 )
    
    DrawText( TextFormat( "Screen Size: [%i, %i]", GetScreenWidth(), GetScreenHeight()), 10, 40, 10, RAYGREEN )
    
    '' Draw window state info
    DrawText( "Following flags can be set after window creation:", 10, 60, 10, GRAY )
    
    if( IsWindowState( FLAG_FULLSCREEN_MODE ) ) then
      DrawText( "[F] FLAG_FULLSCREEN_MODE: on", 10, 80, 10, LIME )
    else
      DrawText( "[F] FLAG_FULLSCREEN_MODE: off", 10, 80, 10, MAROON )
    end if
    
    if( IsWindowState( FLAG_WINDOW_RESIZABLE ) ) then
      DrawText( "[R] FLAG_WINDOW_RESIZABLE: on", 10, 100, 10, LIME )
    else
      DrawText( "[R] FLAG_WINDOW_RESIZABLE: off", 10, 100, 10, MAROON )
    end if
    
    if( IsWindowState( FLAG_WINDOW_UNDECORATED ) ) then
      DrawText( "[D] FLAG_WINDOW_UNDECORATED: on", 10, 120, 10, LIME )
    else
      DrawText( "[D] FLAG_WINDOW_UNDECORATED: off", 10, 120, 10, MAROON )
    end if
    
    if( IsWindowState( FLAG_WINDOW_HIDDEN ) ) then
      DrawText( "[H] FLAG_WINDOW_HIDDEN: on", 10, 140, 10, LIME )
    else
      DrawText( "[H] FLAG_WINDOW_HIDDEN: off", 10, 140, 10, MAROON )
    end if
    
    if( IsWindowState( FLAG_WINDOW_MINIMIZED ) ) then
      DrawText( "[N] FLAG_WINDOW_MINIMIZED: on", 10, 160, 10, LIME )
    else
      DrawText( "[N] FLAG_WINDOW_MINIMIZED: off", 10, 160, 10, MAROON )
    end if
    
    if( IsWindowState( FLAG_WINDOW_MAXIMIZED ) ) then
      DrawText( "[M] FLAG_WINDOW_MAXIMIZED: on", 10, 180, 10, LIME )
    else
      DrawText( "[M] FLAG_WINDOW_MAXIMIZED: off", 10, 180, 10, MAROON )
    end if
    
    if( IsWindowState( FLAG_WINDOW_UNFOCUSED ) ) then
      DrawText( "[G] FLAG_WINDOW_UNFOCUSED: on", 10, 200, 10, LIME )
    else
      DrawText( "[U] FLAG_WINDOW_UNFOCUSED: off", 10, 200, 10, MAROON )
    end if
    
    if( IsWindowState( FLAG_WINDOW_TOPMOST ) ) then
      DrawText( "[T] FLAG_WINDOW_TOPMOST: on", 10, 220, 10, LIME )
    else
      DrawText( "[T] FLAG_WINDOW_TOPMOST: off", 10, 220, 10, MAROON )
    end if
    
    if( IsWindowState( FLAG_WINDOW_ALWAYS_RUN ) ) then
      DrawText( "[A] FLAG_WINDOW_ALWAYS_RUN: on", 10, 240, 10, LIME )
    else
      DrawText( "[A] FLAG_WINDOW_ALWAYS_RUN: off", 10, 240, 10, MAROON )
    end if
    
    if( IsWindowState( FLAG_VSYNC_HINT ) ) then
      DrawText( "[V] FLAG_VSYNC_HINT: on", 10, 260, 10, LIME )
    else
      DrawText( "[V] FLAG_VSYNC_HINT: off", 10, 260, 10, MAROON )
    end if
    
    DrawText( "Following flags can only be set before window creation:", 10, 300, 10, GRAY )
    
    if( IsWindowState( FLAG_WINDOW_HIGHDPI ) ) then
      DrawText( "FLAG_WINDOW_HIGHDPI: on", 10, 320, 10, LIME )
    else
      DrawText( "FLAG_WINDOW_HIGHDPI: off", 10, 320, 10, MAROON )
    end if
    
    if( IsWindowState( FLAG_WINDOW_TRANSPARENT ) ) then
      DrawText( "FLAG_WINDOW_TRANSPARENT: on", 10, 340, 10, LIME )
    else
      DrawText( "FLAG_WINDOW_TRANSPARENT: off", 10, 340, 10, MAROON )
    end if
    
    if( IsWindowState( FLAG_MSAA_4X_HINT ) ) then
      DrawText( "FLAG_MSAA_4X_HINT: on", 10, 360, 10, LIME )
    else
      DrawText( "FLAG_MSAA_4X_HINT: off", 10, 360, 10, MAROON )
    end if
  EndDrawing()
loop

'' De-Initialization
CloseWindow()
