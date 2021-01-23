/'**********************************************************************************************
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
**********************************************************************************************'/

#ifndef RLIGHTS_H
#define RLIGHTS_H

#include once "raylib.bi"

''----------------------------------------------------------------------------------
'' Defines and Macros
''----------------------------------------------------------------------------------
#define         MAX_LIGHTS            4         '' Max lights supported by shader
#define         LIGHT_DISTANCE        3.5f      '' Light distance from world center
#define         LIGHT_HEIGHT          1.0f      '' Light height position

''----------------------------------------------------------------------------------
'' Types and Structures Definition
''----------------------------------------------------------------------------------
const as long _
  LIGHT_DIRECTIONAL = 0, _
  LIGHT_POINT = 1

type Light
  as long type
  as Vector3 position
  as Vector3 target
  as RayColor color
  as long enabled
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
declare sub CreateLight( type_ as long, pos_ as Vector3, targ as Vector3, color_ as RayColor, shader_ as Shader )

'' Send to PBR shader light values
declare sub UpdateLightValues( shader_ as Shader, light_ as Light )

end extern

#endif

/'***********************************************************************************
*
*   RLIGHTS IMPLEMENTATION
*
************************************************************************************'/
#if defined( RLIGHTS_IMPLEMENTATION )

#include once "raylib.bi"

''----------------------------------------------------------------------------------
'' Global Variables Definition
''----------------------------------------------------------------------------------
dim shared as Light lights( 0 to MAX_LIGHTS - 1 )
dim shared as long lightsCount = 0 '' Current amount of created lights

extern "C"
  '' Defines a light and get locations from PBR shader
  sub CreateLight( type_ as long, pos_ as Vector3, target_ as Vector3, color_ as RayColor, shader_ as Shader )
    dim as Light light_
    
    if( lightsCount < MAX_LIGHTS ) then
      with light_
        .enabled = 1
        .type = type_
        .position = pos_
        .target = target_
        .color = color_
      end with
      
      dim as string _
        enabledName = "lights[" & lightsCount & "].enabled", _
        typeName = "lights[" & lightsCount & "].type", _
        posName = "lights[" & lightsCount & "].position", _
        targetName = "lights[" & lightsCount & "].target", _
        colorName = "lights[" & lightsCount & "].color"
      
      with light_
        .enabledLoc = GetShaderLocation( shader_, strPtr( enabledName ) )
        .typeLoc = GetShaderLocation( shader_, strPtr( typeName ) )
        .posLoc = GetShaderLocation( shader_, strPtr( posName ) )
        .targetLoc = GetShaderLocation( shader_, strPtr( targetName ) )
        .colorLoc = GetShaderLocation( shader_, strPtr( colorName ) )
      end with
      
      UpdateLightValues( shader_, light_ )
      
      lights( lightsCount ) = light_
      lightsCount += 1
    end if
  end sub
  
  '' Send to PBR shader light values
  sub UpdateLightValues( shader_ as Shader, light_ as Light )
    '' Send to shader light enabled state and type
    SetShaderValue( shader_, light_.enabledLoc, @light_.enabled, UNIFORM_INT )
    SetShaderValue( shader_, light_.typeLoc, @light_.type, UNIFORM_INT )
    
    '' Send to shader light position values
    dim as single position( 0 to 2 ) = { _
      light_.position.x, light_.position.y, light_.position.z }
    
    SetShaderValue( shader_, light_.posLoc, @position( 0 ), UNIFORM_VEC3 )
    
    '' Send to shader light target position values
    dim as single target( 0 to 2 ) = { _
      light_.target.x, light_.target.y, light_.target.z }
    
    SetShaderValue( shader_, light_.targetLoc, @target( 0 ), UNIFORM_VEC3 )
    
    '' Send to shader light color values
    dim as single diff( 0 to 3 ) = { _
      light_.color.r / 255, light_.color.g / 255, light_.color.b / 255, light_.color.a / 255 }
    
    SetShaderValue( shader_, light_.colorLoc, @diff( 0 ), UNIFORM_VEC4 )
  end sub
end extern

#endif '' RLIGHTS_IMPLEMENTATION
