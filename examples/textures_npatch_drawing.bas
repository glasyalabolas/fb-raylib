/'*******************************************************************************************
*
*   raylib [textures] example - N-patch drawing
*
*   NOTE: Images are loaded in CPU memory (RAM); textures are loaded in GPU memory (VRAM)
*
*   This example has been created using raylib 2.0 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Example contributed by Jorge A. Gomes (@overdev) and reviewed by Ramon Santamaria (@raysan5)
*
*   Copyright (c) 2018 Jorge A. Gomes (@overdev) and Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include "../raylib.bi"

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [textures] example - N-patch drawing" )

dim as Texture2D nPatchTexture = LoadTexture( "resources/ninepatch_button.png" )

dim as Vector2 _
  mousePosition, origin

'' Position and size of the n-patches
var _
  dstRec1 = Rectangle( 480.0f, 160.0f, 32.0f, 32.0f ), _
  dstRec2 = Rectangle( 160.0f, 160.0f, 32.0f, 32.0f ), _
  dstRecH = Rectangle( 160.0f, 93.0f, 32.0f, 32.0f ), _
  dstRecV = Rectangle( 92.0f, 160.0f, 32.0f, 32.0f )

'' A 9-patch (NPT_9PATCH) changes its sizes in both axis
var _
  ninePatchInfo1 = NPatchInfo( Rectangle( 0.0f, 0.0f, 64.0f, 64.0f ), 12, 40, 12, 12, NPT_9PATCH ), _
  ninePatchInfo2 = NPatchInfo( Rectangle( 0.0f, 128.0f, 64.0f, 64.0f ), 16, 16, 16, 16, NPT_9PATCH )

'' A horizontal 3-patch (NPT_3PATCH_HORIZONTAL) changes its sizes along the x axis only
var h3PatchInfo = NPatchInfo( Rectangle( 0.0f, 64.0f, 64.0f, 64.0f ), 8, 8, 8, 8, NPT_3PATCH_HORIZONTAL )

'' A vertical 3-patch (NPT_3PATCH_VERTICAL) changes its sizes along the y axis only
var v3PatchInfo = NPatchInfo( Rectangle( 0.0f, 192.0f, 64.0f, 64.0f ), 6, 6, 6, 6, NPT_3PATCH_VERTICAL )

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  mousePosition = GetMousePosition()
  
  '' Resize the n-patches based on mouse position
  dstRec1.width = mousePosition.x - dstRec1.x
  dstRec1.height = mousePosition.y - dstRec1.y
  dstRec2.width = mousePosition.x - dstRec2.x
  dstRec2.height = mousePosition.y - dstRec2.y
  dstRecH.width = mousePosition.x - dstRecH.x
  dstRecV.height = mousePosition.y - dstRecV.y
  
  '' Set a minimum width and/or height
  if( dstRec1.width < 1.0f ) then dstRec1.width = 1.0f
  if( dstRec1.width > 300.0f ) then dstRec1.width = 300.0f
  if( dstRec1.height < 1.0f ) then dstRec1.height = 1.0f
  if( dstRec2.width < 1.0f ) then dstRec2.width = 1.0f
  if( dstRec2.width > 300.0f ) then dstRec2.width = 300.0f
  if( dstRec2.height < 1.0f ) then dstRec2.height = 1.0f
  if( dstRecH.width < 1.0f ) then dstRecH.width = 1.0f
  if( dstRecV.height < 1.0f ) then dstRecV.height = 1.0f
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    '' Draw the n-patches
    DrawTextureNPatch( nPatchTexture, ninePatchInfo2, dstRec2, origin, 0.0f, WHITE )
    DrawTextureNPatch( nPatchTexture, ninePatchInfo1, dstRec1, origin, 0.0f, WHITE )
    DrawTextureNPatch( nPatchTexture, h3PatchInfo, dstRecH, origin, 0.0f, WHITE )
    DrawTextureNPatch( nPatchTexture, v3PatchInfo, dstRecV, origin, 0.0f, WHITE )
    
    '' Draw the source texture
    DrawRectangleLines( 5, 88, 74, 266, RAYBLUE )
    DrawTexture( nPatchTexture, 10, 93, WHITE )
    DrawText( "TEXTURE", 15, 360, 10, DARKGRAY )
    
    DrawText( "Move the mouse to stretch or shrink the n-patches", 10, 20, 20, DARKGRAY )
  EndDrawing()
loop

'' De-Initialization
UnloadTexture( nPatchTexture )

CloseWindow()
