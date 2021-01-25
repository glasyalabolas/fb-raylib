/'*******************************************************************************************
*
*   raylib easings (header only file)
*   
*   Useful easing functions for values animation
*
*   This header uses:
*       #define EASINGS_STATIC_INLINE       // Inlines all functions code, so it runs faster.
*                                           // This requires lots of memory on system.
*   How to use:
*   The four inputs t,b,c,d are defined as follows:
*   t = current time (in any unit measure, but same unit as duration)
*   b = starting value to interpolate
*   c = the total change in value of b that needs to occur
*   d = total time it should take to complete (duration)
*
*   Example:
*
*   int currentTime = 0;
*   int duration = 100;
*   float startPositionX = 0.0f;
*   float finalPositionX = 30.0f;
*   float currentPositionX = startPositionX;
*
*   while (currentPositionX < finalPositionX)
*   {
*       currentPositionX = EaseSineIn(currentTime, startPositionX, finalPositionX - startPositionX, duration);
*       currentTime++;
*   }
*
*   A port of Robert Penner's easing equations to C (http://robertpenner.com/easing/)
*
*   Robert Penner License
*   ---------------------------------------------------------------------------------
*   Open source under the BSD License. 
*
*   Copyright (c) 2001 Robert Penner. All rights reserved.
*
*   Redistribution and use in source and binary forms, with or without modification, 
*   are permitted provided that the following conditions are met:
*
*       - Redistributions of source code must retain the above copyright notice, 
*         this list of conditions and the following disclaimer.
*       - Redistributions in binary form must reproduce the above copyright notice, 
*         this list of conditions and the following disclaimer in the documentation 
*         and/or other materials provided with the distribution.
*       - Neither the name of the author nor the names of contributors may be used 
*         to endorse or promote products derived from this software without specific 
*         prior written permission.
*
*   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
*   ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
*   WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
*   IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
*   INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, 
*   BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
*   DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
*   LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE 
*   OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED 
*   OF THE POSSIBILITY OF SUCH DAMAGE.
*   ---------------------------------------------------------------------------------
*
*   Copyright (c) 2015 Ramon Santamaria
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

#ifndef EASINGS_BI
#define EASINGS_BI

#define EASINGS_STATIC_INLINE     '' NOTE: By default, compile functions as static inline

#if defined( EASINGS_STATIC_INLINE )
  #define EASEDEF private
#else
  #define EASEDEF
#endif

#ifndef PI
  #define PI 3.14159265358979323846f
#endif

extern "C" '' Prevents name mangling of functions

#define flt as single
#define pow( b, e ) ( ( b ) ^ ( e ) )

'' Linear Easing functions
EASEDEF function EaseLinearNone( t flt, b flt, c flt, d flt ) flt : return( c * t / d + b ) : end function
EASEDEF function EaseLinearIn( t flt, b flt, c flt, d flt ) flt : return( c * t / d + b ) : end function
EASEDEF function EaseLinearOut( t flt, b flt, c flt, d flt ) flt : return( c * t / d + b ) : end function
EASEDEF function EaseLinearInOut( t flt, b flt, c flt, d flt ) flt : return ( c * t / d + b ) : end function

'' Sine Easing functions
EASEDEF function EaseSineIn( t flt, b flt, c flt, d flt ) flt : return( -c * cos( t / d * ( PI / 2 ) ) + c + b ) : end function
EASEDEF function EaseSineOut( t flt, b flt, c flt, d flt ) flt : return( c * sin( t / d * ( PI / 2 ) ) + b) : end function
EASEDEF function EaseSineInOut( t flt, b flt, c flt, d flt ) flt : return( -c / 2 * ( cos( PI * t / d ) - 1 ) + b ) : end function

'' Circular Easing functions
EASEDEF function EaseCircIn( t flt, b flt, c flt, d flt ) flt : t /= d : return( -c * ( sqr ( 1 - t * t ) - 1) + b ) : end function
EASEDEF function EaseCircOut( t flt, b flt, c flt, d flt ) flt : t = t / d - 1 : return( c * sqr( 1 - t * t ) + b ) : end function
EASEDEF function EaseCircInOut( t flt, b flt, c flt, d flt ) flt 
  t /= d / 2
  if( t < 1 ) then return( -c / 2 * ( sqr( 1 - t * t ) - 1 ) + b )
  t -= 2 : return( c / 2 * ( sqr( 1 - t * t ) + 1 ) + b )
end function

'' Cubic Easing functions
EASEDEF function EaseCubicIn( t flt, b flt, c flt, d flt ) flt : t /= d : return( c * t * t * t + b ) : end function
EASEDEF function EaseCubicOut( t flt, b flt, c flt, d flt ) flt : t = t / d - 1 : return( c * ( t * t * t + 1 ) + b ) : end function
EASEDEF function EaseCubicInOut( t flt, b flt, c flt, d flt ) flt
  t /= d / 2
  if( t < 1 ) then return( c / 2 * t * t * t + b )
  t -= 2 : return( c / 2 * ( t * t * t + 2 ) + b )
end function

'' Quadratic Easing functions
EASEDEF function EaseQuadIn( t flt, b flt, c flt, d flt ) flt : t /= d : return( c * t * t + b ) : end function
EASEDEF function EaseQuadOut( t flt, b flt, c flt, d flt ) flt : t /= d : return( -c * t * ( t - 2 ) + b ) : end function
EASEDEF function EaseQuadInOut( t flt, b flt, c flt, d flt ) flt
  t /= d / 2
  if( t < 1 ) then return( ( ( c / 2 ) * ( t * t ) ) + b )
  t -= 1 : return( -c / 2 * ( ( ( t - 2 ) * t ) - 1 ) + b )
end function

'' Exponential Easing functions
EASEDEF function EaseExpoIn( t flt, b flt, c flt, d flt ) flt: return( iif( t = 0, b, ( c * pow( 2, 10 * ( t / d - 1 ) ) + b ) ) ) : end function
EASEDEF function EaseExpoOut( t flt, b flt, c flt, d flt ) flt : return( iif( t = d, ( b + c ), ( c * ( -pow( 2, -10 * t / d ) + 1 ) + b ) ) ) : end function
EASEDEF function EaseExpoInOut( t flt, b flt, c flt, d flt ) flt 
  if( t = 0 ) then return( b )
  if( t = d ) then return( b + c )
  t /= d / 2
  if( t < 1 ) then return( c / 2 * pow( 2, 10 * ( t - 1 ) ) + b )
  
  t -= 1
  return( c / 2 * ( -pow( 2, -10 * t ) + 2 ) + b )
end function

'' Back Easing functions
EASEDEF function EaseBackIn( t flt, b flt, c flt, d flt ) flt 
  dim as single s = 1.70158f
  t /= d
  dim as single postFix = t
  return( c * ( postFix ) * t * ( ( s + 1 ) * t - s ) + b )
end function

EASEDEF function EaseBackOut( t flt, b flt, c flt, d flt ) flt
  dim as single s = 1.70158f
  t = t / d - 1
  return( c * ( t * t * ( ( s + 1 ) * t + s ) + 1 ) + b )
end function

EASEDEF function EaseBackInOut( t flt, b flt, c flt, d flt ) flt
  dim as single s = 1.70158f
  t /= d / 2
  if( t < 1 ) then
    s *= 1.525f
    return( c / 2 * ( t * t * ( ( s + 1 ) * t - s ) ) + b )
  end if
  
  t -= 2
  dim as single postFix = t
  s *= 1.525f
  return( c / 2 * ( ( postFix ) * t * ( ( s + 1 ) * t + s ) + 2 ) + b )
end function

'' Bounce Easing functions
EASEDEF function EaseBounceOut( t flt, b flt, c flt, d flt ) flt
  t /= d
  if( t < ( 1 / 2.75f ) ) then 
    return( c * ( 7.5625f * t * t ) + b )
  elseif( t < ( 2 / 2.75f ) ) then 
    t -= ( 1.5f / 2.75f )
    dim as single postFix = t
    return( c * ( 7.5625f * ( postFix ) * t + 0.75f ) + b )
  elseif( t < ( 2.5 / 2.75 ) ) then
    t -= ( 2.25f / 2.75f )    
    dim as single postFix = t
    return( c * ( 7.5625f * ( postFix ) * t + 0.9375f ) + b )
  else 
    t -= ( 2.625f / 2.75f )
    dim as single postFix = t
    return( c * ( 7.5625f * ( postFix ) * t + 0.984375f ) + b )
  end if
end function

EASEDEF function EaseBounceIn( t flt, b flt, c flt, d flt ) flt : return( c - EaseBounceOut( d - t, 0, c, d ) + b ) : end function
EASEDEF function EaseBounceInOut( t flt, b flt, c flt, d flt ) flt 
  if( t < d / 2 ) then
    return( EaseBounceIn( t * 2, 0, c, d ) * 0.5f + b )
  else
    return( EaseBounceOut( t * 2 - d, 0, c, d ) * 0.5f + c * 0.5f + b )
  end if
end function

'' Elastic Easing functions
EASEDEF function EaseElasticIn( t flt, b flt, c flt, d flt ) flt 
  if( t = 0 ) then return( b )
  t /= d
  if( t = 1 ) then return( b + c )
  
  dim as single _
    p = d * 0.3f, _
    a = c, _
    s = p / 4
  
  t -= 1
  dim as single postFix = a * pow( 2, 10 * t )
  return ( -( postFix * sin( ( t * d - s ) * ( 2 * PI ) / p ) ) + b )
end function

EASEDEF function EaseElasticOut( t flt, b flt, c flt, d flt ) flt
  if( t = 0 ) then return( b )
  t /= d
  if( t = 1 ) then return( b + c )
  
  dim as single _
    p = d * 0.3f, _
    a = c, _ 
    s = p / 4
  
  return( a * pow( 2, -10 * t ) * sin( ( t * d - s ) * ( 2 * PI ) / p ) + c + b )    
end function

EASEDEF function EaseElasticInOut( t flt, b flt, c flt, d flt ) flt
  if( t = 0 ) then return( b )
  t /= d / 2
  if( t = 2 ) then return( b + c )
  
  dim as single _
    p = d * ( 0.3f * 1.5f ), _
    a = c, _
    s = p / 4
  
  if( t < 1 ) then
    t -= 1
    dim as single postFix = a * pow( 2, 10 * t )
    return( -0.5f * ( postFix * sin( ( t * d - s ) * ( 2 * PI ) / p ) ) + b )
  end if
  
  t -= 1
  dim as single postFix = a * pow( 2, -10 * t )
  
  return( postFix * sin( ( t * d - s ) * ( 2 * PI ) / p ) * 0.5f + c + b )
end function

end extern

#undef flt
#undef pow

#endif '' EASINGS_BI
