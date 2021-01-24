/'*******************************************************************************************
*
*   raylib [shaders] example - Color palette switch
*
*   NOTE: This example requires raylib OpenGL 3.3 or ES2 versions for shaders support,
*         OpenGL 1.1 does not support shaders, recompile raylib to OpenGL 3.3 version.
*
*   NOTE: Shaders used in this example are #version 330 (OpenGL 3.3), to test this example
*         on OpenGL ES 2.0 platforms (Android, Raspberry Pi, HTML5), use #version 100 shaders
*         raylib comes with shaders ready for both versions, check raylib/shaders install folder
*
*   This example has been created using raylib 2.3 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Example contributed by Marco Lizza (@MarcoLizza) and reviewed by Ramon Santamaria (@raysan5)
*
*   Copyright (c) 2019 Marco Lizza (@MarcoLizza) and Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"

#if defined( PLATFORM_DESKTOP )
  #define GLSL_VERSION            330
#else   '' PLATFORM_RPI, PLATFORM_ANDROID, PLATFORM_WEB
  #define GLSL_VERSION            100
#endif

#define MAX_PALETTES            3
#define COLORS_PER_PALETTE      8
#define VALUES_PER_COLOR        3

dim as const long palettes( 0 to MAX_PALETTES - 1, COLORS_PER_PALETTE * VALUES_PER_COLOR ) = { _
  { _ '' 3-BIT RGB
    0, 0, 0, _
    255, 0, 0, _
    0, 255, 0, _
    0, 0, 255, _
    0, 255, 255, _
    255, 0, 255, _
    255, 255, 0, _
    255, 255, 255 _
  }, _
  { _ '' AMMO-8 (GameBoy-like)
      4, 12, 6, _
      17, 35, 24, _
      30, 58, 41, _
      48, 93, 66, _
      77, 128, 97, _
      137, 162, 87, _
      190, 220, 127, _
      238, 255, 204 _
  }, _
  { _ '' RKBV (2-strip film)
    21, 25, 26, _
    138, 76, 88, _
    217, 98, 117, _
    230, 184, 193, _
    69, 107, 115, _
    75, 151, 166, _
    165, 189, 194, _
    255, 245, 247 _
  } _
}

dim as const string paletteText( ... ) = { _
  "3-BIT RGB", _
  "AMMO-8 (GameBoy-like)", _
  "RKBV (2-strip film)" _
}

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [shaders] example - color palette switch" )

'' Load shader to be used on some parts drawing
'' NOTE 1: Using GLSL 330 shader version, on OpenGL ES 2.0 use GLSL 100 shader version
'' NOTE 2: Defining 0 (NULL) for vertex shader forces usage of internal default vertex shader
dim as Shader shader = LoadShader( 0, TextFormat( "resources/shaders/glsl%i/palette_switch.fs", GLSL_VERSION ) )

'' Get variable (uniform) location on the shader to connect with the program
'' NOTE: If uniform variable could not be found in the shader, function returns -1
dim as long _
  paletteLoc = GetShaderLocation( shader, "palette" ), _
  currentPalette = 0, _
  lineHeight = screenHeight / COLORS_PER_PALETTE

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  if( IsKeyPressed( KEY_RIGHT ) ) then
    currentPalette += 1
  elseif( IsKeyPressed(KEY_LEFT)) then
    currentPalette -= 1
  end if
  
  if( currentPalette >= MAX_PALETTES ) then
    currentPalette = 0
  elseif( currentPalette < 0 ) then
    currentPalette = MAX_PALETTES - 1
  end if
  
  '' Send new value to the shader to be used on drawing.
  '' NOTE: We are sending RGB triplets w/o the alpha channel
  SetShaderValueV( shader, paletteLoc, @palettes( currentPalette, 0 ), UNIFORM_IVEC3, COLORS_PER_PALETTE )
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    BeginShaderMode( shader )
      for i as integer = 0 to COLORS_PER_PALETTE - 1
        '' Draw horizontal screen-wide rectangles with increasing "palette index"
        '' The used palette index is encoded in the RGB components of the pixel
        DrawRectangle( 0, lineHeight * i, GetScreenWidth(), lineHeight, RayColor( i, i, i, 255 ) )
      next
    EndShaderMode()
    
    DrawText( "< >", 10, 10, 30, DARKBLUE )
    DrawText( "CURRENT PALETTE:", 60, 15, 20, RAYWHITE )
    DrawText( paletteText( currentPalette ), 300, 15, 20, RAYRED )
    
    DrawFPS( 700, 15 )
  EndDrawing()
loop

'' De-Initialization
UnloadShader( shader )

CloseWindow()
