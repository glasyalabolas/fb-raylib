/'*******************************************************************************************
*
*   raylib [core] example - 2d camera platformer
*
*   This example has been created using raylib 2.5 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Example contributed by arvyy (@arvyy) and reviewed by Ramon Santamaria (@raysan5)
*
*   Copyright (c) 2019 arvyy (@arvyy)
*
********************************************************************************************'/

#include once "../raylib.bi"
#include once "../raymath.bi"

#define G 400
#define PLAYER_JUMP_SPD 350.0f
#define PLAYER_HOR_SPD 200.0f

type Player
  as Vector2 position
  as single speed
  as boolean canJump
end type

type EnvItem
  declare constructor()
  declare constructor( as Rectangle, as long, as RayColor )
  
  as Rectangle rect
  as long blocking
  as Color color
end type

constructor EnvItem() : end constructor
constructor EnvItem( _r as Rectangle, _bl as long, _c as RayColor )
  rect = _r : blocking = _bl : color = _c
end constructor

declare sub UpdatePlayer( as Player ptr, envItems() as EnvItem, as long, as single )

declare sub UpdateCameraCenter( as Camera2D ptr, as Player ptr, envItems() as EnvItem, as long, as single, as long, as long )
declare sub UpdateCameraCenterInsideMap( as Camera2D ptr, as Player ptr, envItems() as EnvItem, as long, as single, as long, as long )
declare sub UpdateCameraCenterSmoothFollow( as Camera2D ptr, as Player ptr, envItems() as EnvItem, as long, as single, as long, as long )
declare sub UpdateCameraEvenOutOnLanding( as Camera2D ptr, as Player ptr, envItems() as EnvItem, as long, as single, as long, as long )
declare sub UpdateCameraPlayerBoundsPush( as Camera2D ptr, as Player ptr, envItems() as EnvItem, as long, as single, as long, as long )

type UpdateFunc as sub( as Camera2D ptr, as Player ptr, envItems() as EnvItem, as long, as single, as long, as long )

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [core] example - 2d camera" )

dim as Player player

with player
  .position = Vector2( 400, 280 )
  .speed = 0
  .canJump = false
end with

dim as EnvItem envItems( ... ) = { _
  EnvItem( Rectangle( 0, 0, 1000, 400 ), 0, LIGHTGRAY ), _
  EnvItem( Rectangle( 0, 400, 1000, 200 ), 1, GRAY ), _
  EnvItem( Rectangle( 300, 200, 400, 10 ), 1, GRAY ), _
  EnvItem( Rectangle( 250, 300, 100, 10 ), 1, GRAY ), _
  EnvItem( Rectangle( 650, 300, 100, 10 ), 1, GRAY ) }

dim as long envItemsLength = ( ubound( envItems ) - lbound( envItems ) ) + 1

dim as Camera2D camera

with camera
  .target = player.position
  .offset = Vector2( screenWidth / 2, screenHeight / 2 )
  .rotation = 0.0f
  .zoom = 1.0f
end with

'' Store pointers to the multiple update camera functions
dim as UpdateFunc cameraUpdaters( ... ) = { _
  @UpdateCameraCenter, _
  @UpdateCameraCenterInsideMap, _
  @UpdateCameraCenterSmoothFollow, _
  @UpdateCameraEvenOutOnLanding, _
  @UpdateCameraPlayerBoundsPush }

dim as long _
  cameraOption = 0, _
  cameraUpdatersLength = ( ubound( cameraUpdaters ) - lbound( cameraUpdaters ) ) + 1

dim as string cameraDescriptions( ... ) = { _
  "Follow player center", _
  "Follow player center, but clamp to map edges", _
  "Follow player center; smoothed", _
  "Follow player center horizontally; updateplayer center vertically after landing", _
  "Player push camera on getting too close to screen edge" }

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() ) 
  '' Update
  dim as single deltaTime = GetFrameTime()
  
  UpdatePlayer( @player, envItems(), envItemsLength, deltaTime )
  
  camera.zoom += GetMouseWheelMove() * 0.05f
  
  if( camera.zoom > 3.0f ) then
    camera.zoom = 3.0f
  elseif( camera.zoom < 0.25f ) then
    camera.zoom = 0.25f
  end if
  
  if( IsKeyPressed( KEY_R ) ) then
    camera.zoom = 1.0f
    player.position = Vector2( 400, 280 )
  end if
  
  if( IsKeyPressed( KEY_C ) ) then
    cameraOption = ( cameraOption + 1 ) mod cameraUpdatersLength
  end if
  
  '' Call update camera function by its pointer
  cameraUpdaters( cameraOption ) _
    ( @camera, @player, envItems(), envItemsLength, deltaTime, screenWidth, screenHeight )
  
  '' Draw
  BeginDrawing()
    ClearBackground( LIGHTGRAY )
    
    BeginMode2D( camera )
      for i as integer = 0 to envItemsLength - 1
        DrawRectangleRec( envItems( i ).rect, envItems( i ).color )
      next
      
      var playerRect = Rectangle( player.position.x - 20, player.position.y - 40, 40, 40 )
      DrawRectangleRec( playerRect, RAYRED )
    EndMode2D()
    
    DrawText( "Controls:", 20, 20, 10, BLACK )
    DrawText( "- Right/Left to move", 40, 40, 10, DARKGRAY )
    DrawText( "- Space to jump", 40, 60, 10, DARKGRAY )
    DrawText( "- Mouse Wheel to Zoom in-out, R to reset zoom", 40, 80, 10, DARKGRAY )
    DrawText( "- C to change camera mode", 40, 100, 10, DARKGRAY )
    DrawText( "Current camera mode:", 20, 120, 10, BLACK )
    DrawText( cameraDescriptions( cameraOption ), 40, 140, 10, DARKGRAY )
  EndDrawing()
loop

'' De-Initialization
CloseWindow()

sub UpdatePlayer( player as Player ptr, envItems() as EnvItem, envItemsLength as long, delta as single )
  if( IsKeyDown( KEY_LEFT ) ) then player->position.x -= PLAYER_HOR_SPD * delta
  if( IsKeyDown( KEY_RIGHT ) ) then player->position.x += PLAYER_HOR_SPD * delta
  if( IsKeyDown( KEY_SPACE ) andAlso player->canJump ) then
    player->speed = -PLAYER_JUMP_SPD
    player->canJump = false
  end if
  
  dim as boolean hitObstacle
  
  for i as integer = 0 to envItemsLength - 1 
      dim as EnvItem ptr ei = @envItems( i )
      dim as Vector2 ptr p = @player->position
      if( ei->blocking andAlso _
          ei->rect.x <= p->x andAlso _
          ei->rect.x + ei->rect.width >= p->x andAlso _
          ei->rect.y >= p->y andAlso _
          ei->rect.y < p->y + player->speed * delta ) then
          
        hitObstacle = true
        player->speed = 0.0f
        p->y = ei->rect.y
      end if
  next
  
  if( not hitObstacle ) then
    player->position.y += player->speed * delta
    player->speed += G * delta
    player->canJump = false
  else
    player->canJump = true
  end if
end sub

sub UpdateCameraCenter( camera as Camera2D ptr, player as Player ptr, envItems() as EnvItem, envItemsLength as long, delta as single, w as long, h as long )
  camera->offset = Vector2( w / 2, h / 2 )
  camera->target = player->position
end sub

sub UpdateCameraCenterInsideMap( camera as Camera2D ptr, player as Player ptr, envItems() as EnvItem, envItemsLength as long, delta as single, w as long, h as long )
  camera->target = player->position
  camera->offset = Vector2( w / 2, h / 2 )
  dim as single _
    minX = 1000, minY = 1000, maxX = -1000, maxY = -1000
  
  for i as integer = 0 to envItemsLength - 1
    dim as EnvItem ptr ei = @envItems( i )
    
    minX = fminf( ei->rect.x, minX )
    maxX = fmaxf( ei->rect.x + ei->rect.width, maxX )
    minY = fminf( ei->rect.y, minY )
    maxY = fmaxf( ei->rect.y + ei->rect.height, maxY )
  next
  
  dim as Vector2 _
    max = GetWorldToScreen2D( Vector2( maxX, maxY ), *camera ), _
    min = GetWorldToScreen2D( Vector2( minX, minY ), *camera )
  
  if( max.x < w ) then camera->offset.x = w - ( max.x - w / 2 )
  if( max.y < h ) then camera->offset.y = h - ( max.y - h / 2 )
  if( min.x > 0 ) then camera->offset.x = w / 2 - min.x
  if( min.y > 0 ) then camera->offset.y = h / 2 - min.y
end sub

sub UpdateCameraCenterSmoothFollow( camera as Camera2D ptr, player as Player ptr, envItems() as EnvItem, envItemsLength as long, delta as single, w as long, h as long )
  static as single _
    minSpeed = 30, _
    minEffectLength = 10, _
    fractionSpeed = 0.8f
  
  camera->offset = Vector2( w / 2, h / 2 )
  
  dim as Vector2 diff = Vector2Subtract( player->position, camera->target )
  dim as single length = Vector2Length( diff )
  
  if( length > minEffectLength ) then
    dim as single speed = fmaxf( fractionSpeed * length, minSpeed )
    camera->target = Vector2Add( camera->target, Vector2Scale( diff, speed * delta / length ) )
  end if
end sub

sub UpdateCameraEvenOutOnLanding( camera as Camera2D ptr, player as Player ptr, envItems() as EnvItem, envItemsLength as long, delta as single, w as long, h as long )
  static as single _
    evenOutSpeed = 700, _
    evenOutTarget
  static as boolean eveningOut = false
  
  camera->offset = Vector2( w / 2, h / 2 )
  camera->target.x = player->position.x
  
  if( eveningOut ) then
    if( evenOutTarget > camera->target.y ) then 
      camera->target.y += evenOutSpeed * delta
      
      if( camera->target.y > evenOutTarget ) then 
        camera->target.y = evenOutTarget
        eveningOut = 0
      end if
    else 
      camera->target.y -= evenOutSpeed * delta
      
      if( camera->target.y < evenOutTarget ) then 
        camera->target.y = evenOutTarget
        eveningOut = 0
      end if
    end if
  else 
    if( player->canJump andAlso ( player->speed = 0 ) andAlso ( player->position.y <> camera->target.y ) ) then
      eveningOut = true
      evenOutTarget = player->position.y
    end if
  end if
end sub

sub UpdateCameraPlayerBoundsPush( camera as Camera2D ptr, player as Player ptr, envItems() as EnvItem, envItemsLength as long, delta as single, w as long, h as long ) 
  static as Vector2 bbox = Vector2( 0.2f, 0.2f )
  
  dim as Vector2 _
    bboxWorldMin = GetScreenToWorld2D( Vector2( ( 1 - bbox.x ) * 0.5f * w, ( 1 - bbox.y ) * 0.5f * h ), *camera ), _
    bboxWorldMax = GetScreenToWorld2D( Vector2( ( 1 + bbox.x ) * 0.5f * w, ( 1 + bbox.y ) * 0.5f * h ), *camera )
  camera->offset = Vector2( ( 1 - bbox.x ) * 0.5f * w, ( 1 - bbox.y ) * 0.5f * h )
  
  if( player->position.x < bboxWorldMin.x ) then camera->target.x = player->position.x
  if( player->position.y < bboxWorldMin.y ) then camera->target.y = player->position.y
  if( player->position.x > bboxWorldMax.x ) then camera->target.x = bboxWorldMin.x + ( player->position.x - bboxWorldMax.x )
  if( player->position.y > bboxWorldMax.y ) then camera->target.y = bboxWorldMin.y + ( player->position.y - bboxWorldMax.y )
end sub
