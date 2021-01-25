/'*******************************************************************************************
*
*   raylib [shaders] example - Simple shader mask
*
*   This example has been created using raylib 2.5 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Example contributed by Chris Camacho (@chriscamacho -  http://bedroomcoders.co.uk/) 
*   and reviewed by Ramon Santamaria (@raysan5)
*
*   Copyright (c) 2019 Chris Camacho (@chriscamacho) and Ramon Santamaria (@raysan5)
*
********************************************************************************************
*
*   The shader makes alpha holes in the forground to give the apearance of a top
*   down look at a spotlight casting a pool of light...
* 
*   The right hand side of the screen there is just enough light to see whats
*   going on without the spot light, great for a stealth type game where you
*   have to avoid the spotlights.
* 
*   The left hand side of the screen is in pitch dark except for where the spotlights are.
* 
*   Although this example doesn't scale like the letterbox example, you could integrate
*   the two techniques, but by scaling the actual colour of the render texture rather
*   than using alpha as a mask.
*
********************************************************************************************'/

#include once "../raylib.bi"
#include once "../raymath.bi"

#if defined( PLATFORM_DESKTOP )
  #define GLSL_VERSION            330
#else   '' PLATFORM_RPI, PLATFORM_ANDROID, PLATFORM_WEB
  #define GLSL_VERSION            100
#endif

#define MAX_SPOTS         3        '' NOTE: It must be the same as define in shader
#define MAX_STARS       400

'' Spot data
type Spot   
  as Vector2 pos
  as Vector2 vel
  as single inner
  as single radius
  
  '' Shader locations
  as ulong posLoc
  as ulong innerLoc
  as ulong radiusLoc
end type

'' Stars in the star field have a position and velocity
type Star
  as Vector2 pos
  as Vector2 vel
end type

declare sub UpdateStar( as Star ptr )
declare sub ResetStar( as Star ptr )

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib - shader spotlight" )
HideCursor()

dim as Texture texRay = LoadTexture( "resources/raysan.png" )

dim as Star stars( 0 to MAX_STARS - 1 )

for n as integer = 0 to MAX_STARS - 1
  ResetStar( @stars( n ) )
next

'' Progress all the stars on, so they don't all start in the centre
for m as integer = 0 to ( screenWidth / 2.0 ) - 1
  for n as integer = 0 to MAX_STARS - 1
    UpdateStar( @stars( n ) )
  next
next

dim as long frameCounter = 0

'' Use default vert shader
dim as Shader shdrSpot = LoadShader( 0, TextFormat("resources/shaders/glsl%i/spotlight.fs", GLSL_VERSION ) )

'' Get the locations of spots in the shader
dim as Spot spots( 0 to MAX_SPOTS - 1 )

for i as integer = 0 to MAX_SPOTS - 1 
  'char posName[32] = "spots[x].pos\0";
  'char innerName[32] = "spots[x].inner\0";
  'char radiusName[32] = "spots[x].radius\0";
  dim as string _
    posName = "spots[" & str( i ) & "].pos", _
    innerName = "spots[" & str( i ) & "].inner", _
    radiusName = "spots[" & str( i ) & "].radius"
  
  'posName[6] = '0' + i;
  'innerName[6] = '0' + i;
  'radiusName[6] = '0' + i;
  
  with spots( i )
    .posLoc = GetShaderLocation( shdrSpot, posName )
    .innerLoc = GetShaderLocation( shdrSpot, innerName )
    .radiusLoc = GetShaderLocation( shdrSpot, radiusName )
  end with
next

'' Tell the shader how wide the screen is so we can have
'' a pitch black half and a dimly lit half.
dim as ulong wLoc = GetShaderLocation( shdrSpot, "screenWidth" )
dim as single sw = GetScreenWidth()
SetShaderValue( shdrSpot, wLoc, @sw, UNIFORM_FLOAT )

'' Randomise the locations and velocities of the spotlights
'' and initialise the shader locations
for i as integer = 0 to MAX_SPOTS - 1
  with spots( i )
    .pos.x = GetRandomValue( 64, screenWidth - 64 )
    .pos.y = GetRandomValue( 64, screenHeight - 64 )
    .vel = Vector2( 0, 0 )
    
    do while( ( abs( .vel.x ) + abs( .vel.y ) ) < 2 )
      .vel.x = GetRandomValue( -40, 40 ) / 10.0
      .vel.y = GetRandomValue( -40, 40 ) / 10.0
    loop
    
    .inner = 28 * ( i + 1 )
    .radius = 48 * ( i + 1 )
    
    SetShaderValue( shdrSpot, .posLoc, @.pos.x, UNIFORM_VEC2 )
    SetShaderValue( shdrSpot, .innerLoc, @.inner, UNIFORM_FLOAT )
    SetShaderValue( shdrSpot, .radiusLoc, @.radius, UNIFORM_FLOAT )
  end with
next

SetTargetFPS( 60 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  frameCounter += 1
  
  '' Move the stars, resetting them if the go offscreen
  for n as integer = 0 to MAX_STARS - 1
    UpdateStar( @stars( n ) )
  next
  
  '' Update the spots, send them to the shader
  for i as integer = 0 to MAX_SPOTS - 1
    with spots( i )
      if( i = 0 ) then
        dim as Vector2 mp = GetMousePosition()
        .pos.x = mp.x    
        .pos.y = screenHeight - mp.y
      else
        .pos.x += .vel.x                    
        .pos.y += .vel.y
        
        if( .pos.x < 64 ) then .vel.x = -.vel.x                    
        if( .pos.x > ( screenWidth - 64 ) ) then .vel.x = -.vel.x                    
        if( .pos.y < 64) then .vel.y = -.vel.y     
        if( .pos.y > ( screenHeight - 64 ) ) then .vel.y = -.vel.y
      end if
      
      SetShaderValue( shdrSpot, .posLoc, @.pos.x, UNIFORM_VEC2 )
    end with
  next
  
  '' Draw
  BeginDrawing()
    ClearBackground( DARKBLUE )
    
    '' Draw stars and bobs
    for n as integer = 0 to MAX_STARS - 1
      '' Single pixel is just too small these days!
      DrawRectangle( stars( n ).pos.x, stars( n ).pos.y, 2, 2, WHITE )
    next
    
    for i as integer = 0 to 15
      DrawTexture( texRay, _
        ( screenWidth / 2.0 ) + cos( ( frameCounter + i * 8 ) / 51.45f ) * ( screenWidth / 2.2 ) - 32, _
        ( screenHeight / 2.0 ) + sin( ( frameCounter + i * 8 ) / 17.87f ) * ( screenHeight / 4.2 ), WHITE )
    next
    
    '' Draw spot lights
    BeginShaderMode( shdrSpot )
      '' Instead of a blank rectangle you could render here
      '' a render texture of the full screen used to do screen
      '' scaling (slight adjustment to shader would be required
      '' to actually pay attention to the colour!)
      DrawRectangle( 0, 0, screenWidth, screenHeight, WHITE )
    EndShaderMode()
    
    DrawFPS( 10, 10 )
    
    DrawText( "Move the mouse!", 10, 30, 20, RAYGREEN )
    DrawText( "Pitch Black", screenWidth * 0.2f, screenHeight/2, 20, RAYGREEN )
    DrawText( "Dark", screenWidth * .66f, screenHeight/2, 20, RAYGREEN )
  EndDrawing()
loop

'' De-Initialization
UnloadTexture( texRay )
UnloadShader( shdrSpot )

CloseWindow()

sub ResetStar( s as Star ptr )
  s->pos = Vector2( GetScreenWidth() / 2.0f, GetScreenHeight() / 2.0f )
  
  do
    s->vel.x = GetRandomValue( -1000, 1000 ) / 100.0f
    s->vel.y = GetRandomValue( -1000, 1000 ) / 100.0f
  loop while( not( abs( s->vel.x ) + ( abs( s->vel.y ) > 1 ) ) )
  
  s->pos = Vector2Add( s->pos, Vector2Multiply( s->vel, Vector2( 8.0f, 8.0f ) ) )
end sub

sub UpdateStar( s as Star ptr )
  s->pos = Vector2Add( s->pos, s->vel )
  
  if( ( s->pos.x < 0 ) orElse ( s->pos.x > GetScreenWidth() ) orElse _
      ( s->pos.y < 0 ) orElse ( s->pos.y > GetScreenHeight() ) ) then
    
    ResetStar( s )
  end if
end sub