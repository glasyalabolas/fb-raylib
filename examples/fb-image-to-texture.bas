#include once "fbgfx.bi"
#include "../raylib.bi"

const as integer _
  screenWidth = 800, _
  screenHeight = 450

function ToRaylibImage( fbImg as Fb.Image ptr ) as Image
  '' Create a fully transparent image
  var rlImg = GenImageColor( fbImg->width, fbImg->height, BLANK )
  
  '' Fetch a pointer to the start of the Fb.Image pixel area, skipping header
  dim as ulong ptr _
    fbPx = cptr( ulong ptr, fbImg ) + sizeof( Fb.Image ) \ sizeof( ulong )
  
  '' Fetch a pointer to the Raylib Image pixel area
  dim as ulong ptr _
    rlPx = cptr( ulong ptr, rlImg.data )
  
  /'
    FreeBasic image buffers are padded to a paragraph (16 bytes) boundary. This
    means we need to take this into account when addressing each pixel.
  '/
  dim as integer pitchInPixels = fbImg->pitch \ sizeOf( ulong )
  
  '' Then we just transfer the pixels
  for y as integer = 0 to rlImg.height - 1
    for x as integer = 0 to rlImg.width - 1
      dim as ulong c = fbPx[ y * pitchInPixels + x ]
      
      '' Do note that we're swapping the red and blue components here!
      rlPx[ y * rlImg.width + x ] = rgba( _
        c and 255, c shr 8 and 255, c shr 16 and 255, c shr 24 )
    next
  next
  
  return( rlImg )
end function

'' Just creates an example Fb.Image
function exampleImage() as Fb.Image ptr
  dim as Fb.Image ptr img = imageCreate( 200, 200 )
  
  dim as single _
    cx = 255 / img->width, _
    cy = 255 / img->height
  
  for y as integer = 0 to img->height - 1
    for x as integer = 0 to img->width - 1
      pset img, ( x, y ), rgba( cx * x, cy * y, 255, cy * 255 )
    next
  next
  
  circle img, ( 0, 0 ), 50, rgba( 255, 0, 0, 255 ), , , , f
  circle img, ( img->width - 1, 0 ), 50, rgba( 0, 255, 0, 255 ), , , , f
  circle img, ( 0, img->height - 1 ), 50, rgba( 0, 0, 255, 255 ), , , , f
  circle img, ( img->width - 1, img->height - 1 ), 50, rgba( 255, 255, 255, 255 ), , , , f
  
  dim as string msg = "Hello Raylib!"
  
  draw string _
    img, ( ( img->width - len( msg ) * 8 ) \ 2, ( img->height - 8 ) \ 2 ), msg, rgba( 255, 255, 255, 255 )
  
  return( img )
end function

/'
  This call is important. It tells FBGFX that you're going to do your own
  rendering, but that you'll still want to use primitives and buffers.
  The width and height of the 'screen' doesn't matter if you're going to
  do rendering with Raylib, but the bytes per pixel do.
'/
screenRes( 1, 1, 32, , Fb.GFX_NULL )

/'
  And the main code looks like this
'/
InitWindow( screenWidth, screenHeight, "raylib [textures] example - Converting a FreeBasic Image buffer into a raylib texture" )

'' Create an image and convert it to a texture
dim as Fb.Image ptr fbImage = exampleImage()
var img = ToRaylibImage( fbImage )
dim as Texture2D texture = LoadTextureFromImage( img )

do while( not WindowShouldClose() )
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    DrawTexture( texture, screenWidth / 2 - texture.width / 2, screenHeight / 2 - texture.height / 2, WHITE )
    DrawText( "This is a texture created with FreeBasic primitives!", 360, 370, 10, GRAY )
  EndDrawing()
loop

UnloadTexture( texture )

'' The image can also be destroyed as soon as it is converted
UnloadImage( img )
imageDestroy( fbImage )

CloseWindow()
