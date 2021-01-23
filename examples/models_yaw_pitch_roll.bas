/'*******************************************************************************************
*
*   raylib [models] example - Plane rotations (yaw, pitch, roll)
*
*   This example has been created using raylib 1.8 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Example contributed by Berni (@Berni8k) and reviewed by Ramon Santamaria (@raysan5)
*
*   Copyright (c) 2017 Berni (@Berni8k) and Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"
#include once "../raymath.bi"

'' Draw angle gauge controls
declare sub DrawAngleGauge( angleGauge as Texture2D, x as long, y as long, angle as single, title as string, color_ as RayColor )

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [models] example - plane rotations (yaw, pitch, roll)" )

dim as Texture2D _
  texAngleGauge = LoadTexture( "resources/angle_gauge.png" ), _
  texBackground = LoadTexture( "resources/background.png" ), _
  texPitch = LoadTexture( "resources/pitch.png" ), _
  texPlane = LoadTexture( "resources/plane.png" )

dim as RenderTexture2D framebuffer = LoadRenderTexture( 192, 192 )

'' Model loading
dim as Model model = LoadModel( "resources/plane.obj" )
model.materials[ 0 ].maps[ MAP_DIFFUSE ].texture = LoadTexture( "resources/plane_diffuse.png" )

GenTextureMipmaps( @model.materials[ 0 ].maps[ MAP_DIFFUSE ].texture )

dim as Camera camera

with camera
  .position = Vector3( 0.0f, 60.0f, -120.0f )
  .target = Vector3( 0.0f, 12.0f, 0.0f )
  .up = Vector3( 0.0f, 1.0f, 0.0f )
  .fovy = 30.0f
  .type = CAMERA_PERSPECTIVE
end with

dim as single _
  pitch = 0.0f, roll = 0.0f, yaw = 0.0f

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  
  '' Plane roll (x-axis) controls
  if( IsKeyDown( KEY_LEFT ) ) then
    roll += 1.0f
  elseif( IsKeyDown( KEY_RIGHT ) ) then
    roll -= 1.0f
  else
    if( roll > 0.0f ) then
      roll -= 0.5f
    elseif( roll < 0.0f ) then
      roll += 0.5f
    end if
  end if
  
  '' Plane yaw (y-axis) controls
  if( IsKeyDown( KEY_S ) ) then
    yaw += 1.0f
  elseif( IsKeyDown( KEY_A ) ) then
    yaw -= 1.0f
  else
    if( yaw > 0.0f ) then
      yaw -= 0.5f
    elseif( yaw < 0.0f ) then
      yaw += 0.5f
    end if
  end if
  
  '' Plane pitch (z-axis) controls
  if( IsKeyDown( KEY_DOWN ) ) then
    pitch += 0.6f
  elseif( IsKeyDown( KEY_UP ) ) then
    pitch -= 0.6f
  else
    if( pitch > 0.3f ) then
      pitch -= 0.3f
    elseif( pitch < -0.3f ) then
      pitch += 0.3f
    end if
  endif
  
  '' Wraps the phase of an angle to fit between -180 and +180 degrees
  dim as long pitchOffset = pitch
  
  do while( pitchOffset > 180 ) : pitchOffset -= 360 : loop
  do while( pitchOffset < -180) : pitchOffset += 360 : loop
  pitchOffset *= 10
  
  '' matrix created from multiple axes at once
  model.transform = MatrixRotateXYZ( Vector3( DEG2RAD * pitch, DEG2RAD * yaw, DEG2RAD * roll ) )
  
  '' Draw
  BeginDrawing()
      ClearBackground( RAYWHITE )
      
      '' Draw framebuffer texture (Ahrs Display)
      dim as long _
        centerX = framebuffer.texture.width / 2, _
        centerY = framebuffer.texture.height / 2
      
      BeginTextureMode( framebuffer )
          ClearBackground( RAYWHITE )
          BeginBlendMode( BLEND_ALPHA )
          
          DrawTexturePro( texBackground, Rectangle( 0, 0, texBackground.width, texBackground.height ), _
                          Rectangle( centerX, centerY, texBackground.width, texBackground.height ), _
                          Vector2( texBackground.width / 2, texBackground.height / 2 + pitchOffset ), roll, WHITE )
          
          DrawTexturePro( texPitch, Rectangle( 0, 0, texPitch.width, texPitch.height ), _
                          Rectangle( centerX, centerY, texPitch.width, texPitch.height ), _
                          Vector2( texPitch.width / 2, texPitch.height / 2 + pitchOffset ), roll, WHITE )
          
          DrawTexturePro( texPlane, Rectangle( 0, 0, texPlane.width, texPlane.height ), _
                          Rectangle( centerX, centerY, texPlane.width, texPlane.height ), _
                          Vector2( texPlane.width / 2, texPlane.height / 2 ), 0, WHITE )
          
          EndBlendMode()
      EndTextureMode()
      
      '' Draw 3D model (recomended to draw 3D always before 2D)
      BeginMode3D( camera )
        DrawModel( model, Vector3( 0, 6.0f, 0 ), 1.0f, WHITE )
        DrawGrid( 10, 10.0f )
      EndMode3D()
      
      '' Draw 2D GUI stuff
      DrawAngleGauge( texAngleGauge, 80, 70, roll, "roll", RAYRED )
      DrawAngleGauge( texAngleGauge, 190, 70, pitch, "pitch", RAYGREEN )
      DrawAngleGauge( texAngleGauge, 300, 70, yaw, "yaw", SKYBLUE )
      
      DrawRectangle( 30, 360, 260, 70, Fade( SKYBLUE, 0.5f ) )
      DrawRectangleLines( 30, 360, 260, 70, Fade( DARKBLUE, 0.5f ) )
      DrawText( "Pitch controlled with: KEY_UP / KEY_DOWN", 40, 370, 10, DARKGRAY )
      DrawText( "Roll controlled with: KEY_LEFT / KEY_RIGHT", 40, 390, 10, DARKGRAY )
      DrawText( "Yaw controlled with: KEY_A / KEY_S", 40, 410, 10, DARKGRAY )
      
      '' Draw framebuffer texture
      DrawTextureRec( framebuffer.texture, Rectangle( 0, 0, framebuffer.texture.width, -framebuffer.texture.height ), _
                      Vector2( screenWidth - framebuffer.texture.width - 20, 20 ), Fade( WHITE, 0.8f ) )
      
      DrawRectangleLines( screenWidth - framebuffer.texture.width - 20, 20, framebuffer.texture.width, framebuffer.texture.height, DARKGRAY )
  EndDrawing()
loop

'' De-Initialization

'' Unload all loaded data
UnloadTexture( model.materials[ 0 ].maps[ MAP_DIFFUSE ].texture )
UnloadModel( model )

UnloadRenderTexture( framebuffer )

UnloadTexture( texAngleGauge )
UnloadTexture( texBackground )
UnloadTexture( texPitch )
UnloadTexture( texPlane )

CloseWindow()

'' Draw angle gauge controls
sub DrawAngleGauge( angleGauge as Texture2D, x as long, y as long, angle as single, title as string, color_ as RayColor )
  var _
    srcRec = Rectangle( 0, 0, angleGauge.width, angleGauge.height ), _
    dstRec = Rectangle( x, y, angleGauge.width, angleGauge.height ), _
    origin = Vector2( angleGauge.width / 2, angleGauge.height / 2 )
  
  dim as long textSize = 20
  
  DrawTexturePro( angleGauge, srcRec, dstRec, origin, angle, color_ )
  
  DrawText( TextFormat( "%5.1f", angle ), x - MeasureText( TextFormat( "%5.1f", angle ), textSize) / 2, y + 10, textSize, DARKGRAY )
  DrawText( title, x - MeasureText( title, textSize ) / 2, y + 60, textSize, DARKGRAY )
end sub
