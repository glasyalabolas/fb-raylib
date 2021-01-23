/'*******************************************************************************************
*
*   raylib [core] example - VR Simulator (Oculus Rift CV1 parameters)
*
*   This example has been created using raylib 1.7 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Copyright (c) 2017 Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"

#if defined( PLATFORM_DESKTOP )
  #define GLSL_VERSION            330
#else   '' PLATFORM_RPI, PLATFORM_ANDROID, PLATFORM_WEB
  #define GLSL_VERSION            100
#endif

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

'' NOTE: screenWidth/screenHeight should match VR device aspect ratio

SetConfigFlags( FLAG_MSAA_4X_HINT )
InitWindow( screenWidth, screenHeight, "raylib [core] example - vr simulator" )

'' Init VR simulator (Oculus Rift CV1 parameters)
InitVrSimulator()

dim as VrDeviceInfo hmd '' VR device parameters (head-mounted-device)

'' Oculus Rift CV1 parameters for simulator
with hmd
  .hResolution = 2160                 '' HMD horizontal resolution in pixels
  .vResolution = 1200                 '' HMD vertical resolution in pixels
  .hScreenSize = 0.133793f            '' HMD horizontal size in meters
  .vScreenSize = 0.0669f              '' HMD vertical size in meters
  .vScreenCenter = 0.04678f           '' HMD screen center in meters
  .eyeToScreenDistance = 0.041f       '' HMD distance between eye and display in meters
  .lensSeparationDistance = 0.07f     '' HMD lens separation distance in meters
  .interpupillaryDistance = 0.07f     '' HMD IPD (distance between pupils) in meters
  
  '' NOTE: CV1 uses a Fresnel-hybrid-asymmetric lenses with specific distortion compute shaders.
  '' Following parameters are an approximation to distortion stereo rendering but results differ from actual device.
  .lensDistortionValues( 0 ) = 1.0f     '' HMD lens distortion constant parameter 0
  .lensDistortionValues( 1 ) = 0.22f    '' HMD lens distortion constant parameter 1
  .lensDistortionValues( 2 ) = 0.24f    '' HMD lens distortion constant parameter 2
  .lensDistortionValues( 3 ) = 0.0f     '' HMD lens distortion constant parameter 3
  .chromaAbCorrection( 0 ) = 0.996f     '' HMD chromatic aberration correction parameter 0
  .chromaAbCorrection( 1 ) = -0.004f    '' HMD chromatic aberration correction parameter 1
  .chromaAbCorrection( 2 ) = 1.014f     '' HMD chromatic aberration correction parameter 2
  .chromaAbCorrection( 3 ) = 0.0f       '' HMD chromatic aberration correction parameter 3
end with

'' Distortion shader (uses device lens distortion and chroma)
dim as Shader distortion = LoadShader( 0, TextFormat( "resources/distortion%i.fs", GLSL_VERSION ) )

SetVrConfiguration( hmd, distortion )    '' Set Vr device parameters for stereo rendering

'' Define the camera to look into our 3d world
dim as Camera camera

with camera
  .position = Vector3( 5.0f, 2.0f, 5.0f )
  .target = Vector3( 0.0f, 2.0f, 0.0f )
  .up = Vector3( 0.0f, 1.0f, 0.0f )
  .fovy = 60.0f
  .type = CAMERA_PERSPECTIVE
end with

var cubePosition = Vector3( 0.0f, 0.0f, 0.0f )

SetCameraMode( camera, CAMERA_FIRST_PERSON )

SetTargetFPS( 90 )

'' Main game loop
do while( not WindowShouldClose() )
  '' Update
  UpdateCamera( @camera )
  
  if( IsKeyPressed( KEY_SPACE ) ) then ToggleVrMode()
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    BeginVrDrawing()
      BeginMode3D( camera )
        DrawCube( cubePosition, 2.0f, 2.0f, 2.0f, RAYRED )
        DrawCubeWires( cubePosition, 2.0f, 2.0f, 2.0f, MAROON )
        
        DrawGrid( 40, 1.0f )
      EndMode3D()
    EndVrDrawing()
    
    DrawFPS( 10, 10 )
  EndDrawing()
loop

'' De-Initialization
UnloadShader( distortion )
CloseVrSimulator()
CloseWindow()
