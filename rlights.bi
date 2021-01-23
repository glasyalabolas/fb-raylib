/'
/**********************************************************************************************
*
*   raylib.lights - Some useful functions to deal with lights data
*
*   CONFIGURATION:
*
*   #define RLIGHTS_IMPLEMENTATION
*       Generates the implementation of the library into the included file.
*       If not defined, the library is in header only mode and can be included in other headers 
*       or source files without problems. But only ONE file should hold the implementation.
*
*   LICENSE: zlib/libpng
*
*   Copyright (c) 2017 Victor Fisac and Ramon Santamaria
*
*   This software is provided "as-is", without any express or implied warranty. In no event
*   will the authors be held liable for any damages arising from the use of this software.
*
*   Permission is granted to anyone to use this software for any purpose, including commercial
*   applications, and to alter it and redistribute it freely, subject to the following restrictions:
*
*     1. The origin of this software must not be misrepresented; you must not claim that you
*     wrote the original software. If you use this software in a product, an acknowledgment
*     in the product documentation would be appreciated but is not required.
*
*     2. Altered source versions must be plainly marked as such, and must not be misrepresented
*     as being the original software.
*
*     3. This notice may not be removed or altered from any source distribution.
*
**********************************************************************************************/
'/
#ifndef RLIGHTS_H
#define RLIGHTS_H

#include once "raylib.bi"

''----------------------------------------------------------------------------------
'' Defines and Macros
''----------------------------------------------------------------------------------
#define         MAX_LIGHTS            4         '' Max lights supported by shader
#define         LIGHT_DISTANCE        3.5!      '' Light distance from world center
#define         LIGHT_HEIGHT          1.0!      '' Light height position

''----------------------------------------------------------------------------------
'' Types and Structures Definition
''----------------------------------------------------------------------------------
'enum LightType
'  LIGHT_DIRECTIONAL
'  LIGHT_POINT
'end enum
const as long _
  LIGHT_DIRECTIONAL => 0, _
  LIGHT_POINT => 1

type as long LightType

type Light
  as bool enabled
  as LightType type
  as Vector3 position
  as Vector3 target
  as Color color
  as long _
    enabledLoc, _
    typeLoc, _
    posLoc, _
    targetLoc, _
    colorLoc
end type

extern "C" '' Prevents name mangling of functions

''----------------------------------------------------------------------------------
'' Module Functions Declaration
''----------------------------------------------------------------------------------
'' Defines a light and get locations from PBR shader
declare sub CreateLight( _
  type_ as long, _
  pos_ as Vector3, _
  targ as Vector3, _
  color_ as Color, _
  shader_ as Shader )

'' Send to PBR shader light values
declare sub UpdateLightValues( _
  shader_ as Shader, _
  light_ as Light )

end extern

#endif

/'
/***********************************************************************************
*
*   RLIGHTS IMPLEMENTATION
*
************************************************************************************/
'/
#if defined( RLIGHTS_IMPLEMENTATION )

#include once "raylib.bi"

''----------------------------------------------------------------------------------
'' Global Variables Definition
''----------------------------------------------------------------------------------
dim shared as Light _
  lights( 0 to MAX_LIGHTS - 1 )
dim shared as long _
  lightsCount => 0 '' Current amount of created lights

extern "C"
  '' Defines a light and get locations from PBR shader
  sub CreateLight( _
    type_ as long, _
    pos_ as Vector3, _
    targ as Vector3, _
    color_ as Color, _
    shader_ as Shader )
    
    dim as Light _
      light
    
    if ( lightsCount < MAX_LIGHTS ) then
      light.enabled => true
      light.type => type_
      light.position => pos_
      light.target => targ
      light.color => color_
    
      'char enabledName[32] = "lights[x].enabled\0"
      'char typeName[32] = "lights[x].type\0"
      'char posName[32] = "lights[x].position\0"
      'char targetName[32] = "lights[x].target\0"
      'char colorName[32] = "lights[x].color\0"
      'enabledName[7] = '0' + lightsCount;
      'typeName[7] = '0' + lightsCount;
      'posName[7] = '0' + lightsCount;
      'targetName[7] = '0' + lightsCount;
      'colorName[7] = '0' + lightsCount;
      
      dim as string _
        enabledName => "lights[" & lightsCount & "].enabled", _
        typeName => "lights[" & lightsCount & "].type", _
        posName => "lights[" & lightsCount & "].position", _
        targetName => "lights[" & lightsCount & "].target", _
        colorName => "lights[" & lightsCount & "].color"
      
      light.enabledLoc => GetShaderLocation( shader_, strPtr( enabledName) )
      light.typeLoc => GetShaderLocation( shader_, strPtr( typeName) )
      light.posLoc => GetShaderLocation( shader_, strPtr( posName ) )
      light.targetLoc => GetShaderLocation( shader_, strPtr( targetName ) )
      light.colorLoc => GetShaderLocation( shader_, strPtr( colorName ) )
      
      UpdateLightValues( shader_, light )
      
      lights( lightsCount ) => light
      lightsCount +=> 1
    end if
  end sub
  
  '' Send to PBR shader light values
  sub UpdateLightValues( _
    shader_ as Shader, _
    light_ as Light )
    
    '' Send to shader light enabled state and type
    SetShaderValue( shader_, light_.enabledLoc, @light.enabled, UNIFORM_INT )
    SetShaderValue( shader_, light_.typeLoc, @light.type, UNIFORM_INT )
    
    '' Send to shader light position values
    dim as single _
      position( 0 to 2 ) => { light_.position.x, light_.position.y, light_.position.z }
    
    SetShaderValue( shader_, light_.posLoc, @position( 0 ), UNIFORM_VEC3 )
    
    '' Send to shader light target position values
    dim as single _
      target( 0 to 2 ) => { light_.target.x, light_.target.y, light_.target.z }
    
    SetShaderValue( shader_, light_.targetLoc, @target( 0 ), UNIFORM_VEC3 )
    
    '' Send to shader light color values
    dim as single _
      diff( 0 to 3 ) => { _
        light_.color.r / 255, _
        light_.color.g / 255, _
        light_.color.b / 255, _
        light_.color.a / 255 }
    
    SetShaderValue( shader_, light_.colorLoc, @diff( 0 ), UNIFORM_VEC4 )
  end sub
end extern

#endif '' RLIGHTS_IMPLEMENTATION
