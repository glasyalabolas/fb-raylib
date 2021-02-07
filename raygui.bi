/'******************************************************************************************
*
*   raygui v2.8 - A simple and easy-to-use immediate-mode gui library
*
*   DESCRIPTION:
*
*   raygui is a tools-dev-focused immediate-mode-gui library based on raylib but also
*   available as a standalone library, as long as input and drawing functions are provided.
*
*   Controls provided:
*
*   # Container/separators Controls
*       - WindowBox
*       - GroupBox
*       - Line
*       - Panel
*
*   # Basic Controls
*       - Label
*       - Button
*       - LabelButton   -=1> Label
*       - ImageButton   -=1> Button
*       - ImageButtonEx -=1> Button
*       - Toggle
*       - ToggleGroup   -=1> Toggle
*       - CheckBox
*       - ComboBox
*       - DropdownBox
*       - TextBox
*       - TextBoxMulti
*       - ValueBox      -=1> TextBox
*       - Spinner       -=1> Button, ValueBox
*       - Slider
*       - SliderBar     -=1> Slider
*       - ProgressBar
*       - StatusBar
*       - ScrollBar
*       - ScrollPanel
*       - DummyRec
*       - Grid
*
*   # Advance Controls
*       - ListView
*       - ColorPicker   -=1> ColorPanel, ColorBarHue
*       - MessageBox    -=1> Window, Label, Button
*       - TextInputBox  -=1> Window, Label, TextBox, Button
*
*   It also provides a set of functions for styling the controls based on its properties (size, color).
*
*   CONFIGURATION:
*
*   #define RAYGUI_IMPLEMENTATION
*       Generates the implementation of the library integero the included file.
*       If not defined, the library is in header only mode and can be included in other headers
*       or source files without problems. But only ONE file should hold the implementation.
*
*   #define RAYGUI_STATIC (defined by default)
*       The generated implementation will stay private inside implementation file and all
*       integerernal symbols and functions will only be visible inside that file.
*
*   #define RAYGUI_STANDALONE
*       Asub raylib.h header inclusion in this file. Data types defined on raylib are defined
*       integerernally in the library and input management and drawing functions must be provided by
*       the user (check library implementation for further details).
*
*   #define RAYGUI_SUPPORT_ICONS
*       Includes riconsdata.h header defining a set of 128 icons (binary format) to be used on
*       multiple controls and following raygui styles
*
*
*   VERSIONS HISTORY:
*       2.8 (03-May-2020) Centralized rectangles drawing to GuiDrawRectangle()
*       2.7 (20-Feb-2020) Added possible tooltips API
*       2.6 (09-Sep-2019) ADDED: GuiTextInputBox()
*                         REDESIGNED: GuiListView*(), GuiDropdownBox(), GuiSlider*(), GuiProgressBar(), GuiMessageBox()
*                         REVIEWED: GuiTextBox(), GuiSpinner(), GuiValueBox(), GuiLoadStyle()
*                         Replaced property INNER_PADDING by TEXT_PADDING, renamed some properties
*                         Added 8 new custom styles ready to use
*                         Multiple minor tweaks and bugs corrected
*       2.5 (28-May-2019) Implemented extended GuiTextBox(), GuiValueBox(), GuiSpinner()
*       2.3 (29-Apr-2019) Added rIcons auxiliar library and support for it, multiple controls reviewed
*                         Refactor all controls drawing mechanism to use control state
*       2.2 (05-Feb-2019) Added GuiScrollBar(), GuiScrollPanel(), reviewed GuiListView(), removed Gui*Ex() controls
*       2.1 (26-Dec-2018) Redesign of GuiCheckBox(), GuiComboBox(), GuiDropdownBox(), GuiToggleGroup() > Use combined text string
*                         Complete redesign of style system (breaking change)
*       2.0 (08-Nov-2018) Support controls guiLock and custom fonts, reviewed GuiComboBox(), GuiListView()...
*       1.9 (09-Oct-2018) Controls review: GuiGrid(), GuiTextBox(), GuiTextBoxMulti(), GuiValueBox()...
*       1.8 (01-May-2018) Lot of rework and redesign to align with rGuiStyler and rGuiLayout
*       1.5 (21-Jun-2017) Working in an improved styles system
*       1.4 (15-Jun-2017) Rewritten all GUI functions (removed useless ones)
*       1.3 (12-Jun-2017) Redesigned styles system
*       1.1 (01-Jun-2017) Complete review of the library
*       1.0 (07-Jun-2016) Converted to header-only by Ramon Santamaria.
*       0.9 (07-Mar-2016) Reviewed and tested by Albert Martos, Ian Eito, Sergio Martinez and Ramon Santamaria.
*       0.8 (27-Aug-2015) Initial release. Implemented by Kevin Gato, Daniel Nicolás and Ramon Santamaria.
*
*   CONTRIBUTORS:
*       Ramon Santamaria:   Supervision, review, redesign, update and maintegerenance...
*       Vlad Adrian:        Complete rewrite of GuiTextBox() to support extended features (2019)
*       Sergio Martinez:    Review, testing (2015) and redesign of multiple controls (2018)
*       Adria Arranz:       Testing and Implementation of additional controls (2018)
*       Jordi Jorba:        Testing and Implementation of additional controls (2018)
*       Albert Martos:      Review and testing of the library (2015)
*       Ian Eito:           Review and testing of the library (2015)
*       Kevin Gato:         Initial implementation of basic components (2014)
*       Daniel Nicolas:     Initial implementation of basic components (2014)
*
*
*   LICENSE: zlib/libpng
*
*   Copyright (c) 2014-2020 Ramon Santamaria (@raysan5)
*
*   This software is provided "as-is", without any express or implied warranty. In no event
*   will the authors be held liable for any damages arising from the use of this software.
*
*   Permission is granted to anyone to use this software for any purpose, including commercial
*   applications, and to alter it and redistribute it freely, subject to the following restrictions:
*
*     1. The origin of this software must not be misrepresented you must not claim that you
*     wrote the original software. If you use this software in a product, an acknowledgment
*     in the product documentation would be appreciated but is not required.
*
*     2. Altered source versions must be plainly marked as such, and must not be misrepresented
*     as being the original software.
*
*     3. This notice may not be removed or altered from any source distribution.
*
*********************************************************************************************'/

#ifndef RAYGUI_BI
#define RAYGUI_BI

#define RAYGUI_VERSION  "2.6-dev"

#If Not defined(RAYGUI_STANDALONE)
#include Once "../raylib.bi"
#endif

' Define functions scope to be used internally (static) or externally (extern) to the module including this file
#if defined(_WIN32)
' Microsoft attibutes to tell compiler that symbols are imported/exported from a .dll
#if defined(BUILD_LIBTYPE_SHARED)
#define RAYGUIDEF __declspec(dllexport)     ' We are building raygui as a Win32 shared library (.dll)
#elseif defined(USE_LIBTYPE_SHARED)
#define RAYGUIDEF __declspec(dllimport)     ' We are using raygui as a Win32 shared library (.dll)
#else
#define RAYGUIDEF Declare  ' We are building or using raygui as a static library
#endif
#else
#define RAYGUIDEF  Declare      ' We are building or using raygui as a static library (or Linux shared library)
#endif

#if Not Defined(RAYGUI_MALLOC) andalso Not Defined(RAYGUI_CALLOC) andalso Not Defined(RAYGUI_FREE)
#include "crt/stdlib.bi"                 ' Required for: malloc(), calloc(), free()
#endif

' Allow custom memory allocators
#ifndef RAYGUI_MALLOC
#define RAYGUI_MALLOC(sz)       malloc(sz)
#endif
#ifndef RAYGUI_CALLOC
#define RAYGUI_CALLOC(n,sz)     calloc(n,sz)
#endif
#ifndef RAYGUI_FREE
#define RAYGUI_FREE(p)          free(p)
#endif

'-----------------------------------------=1
' Defines and Macros
'-----------------------------------------=1
#define NUM_CONTROLS                    16      ' Number of standard controls
#define NUM_PROPS_DEFAULT               16      ' Number of standard properties
#define NUM_PROPS_EXTENDED               8      ' Number of extended properties

#define TEXTEDIT_CURSOR_BLINK_FRAMES    20      ' Text edit controls cursor blink timming

#if defined(__cplusplus)
extern "C"             ' Prevents name mangling of functions
#endif

'-----------------------------------------=1
' Types and Structures Definition
' NOTE: Some types are required for RAYGUI_STANDALONE usage
'-----------------------------------------=1
#if defined(RAYGUI_STANDALONE)

' Vector2 type
type Vector2
	as single x
	as single y
end type

' Vector3 type
type Vector3
	as  single x
	as  single y
	as  single z
end type

' Color type, RGBA (32bit)
type Color
	as  ubyte r
	as UByte g
	as UByte b
	as UByte a
end type

' Rectangle type
type Rectangle
	As  single x
	As  single y
	As   single width
	As  single height
end type

' TODO: Texture2D type is very coupled to raylib, mostly required by GuiImageButton()
' It should be redesigned to be provided by user
type Texture2D
	As    ulong id        ' OpenGL texture id
	width0 As long              ' Texture base width
	height0 As long             ' Texture base height
	As    long mipmaps            ' Mipmap levels, 1 by default
	As   long format             ' Data format (PixelFormat type)
end type

' Font character info
type CharInfo As CharInfo

' TODO: Font type is very coupled to raylib, mostly required by GuiLoadStyle()
' It should be redesigned to be provided by user
type Font
	As        long baseSize           ' Base size (default chars height)
	charsCount as long         ' Number of characters
	texture as Texture2D       ' Characters texture atlas
	As   Rectangle Ptr recs        ' Characters rectangles in texture
	As  CharInfo Ptr chars        ' Characters info data
end type
#endif

' Style property
type GuiStyleProp
	As Unsigned Short controlId
	As Unsigned short propertyId
	As long propertyValue
end type

' Gui control state
enum GuiControlState
GUI_STATE_NORMAL = 0,
GUI_STATE_FOCUSED,
GUI_STATE_PRESSED,
GUI_STATE_DISABLED,
end enum

' Gui control text alignment
enum GuiTextAlignment
GUI_TEXT_ALIGN_LEFT = 0,
GUI_TEXT_ALIGN_CENTER,
GUI_TEXT_ALIGN_RIGHT,
end enum

' Gui controls
enum GuiControl
DEFAULT = 0,
LABEL,          ' LABELBUTTON
BUTTON,         ' IMAGEBUTTON
TOGGLE,         ' TOGGLEGROUP
SLIDER,         ' SLIDERBAR
PROGRESSBAR,
CHECKBOX,
COMBOBOX,
DROPDOWNBOX,
TEXTBOX,        ' TEXTBOXMULTI
VALUEBOX,
SPINNER,
LISTVIEW,
COLORPICKER,
SCROLLBAR,
STATUSBAR
end enum

' Gui base properties for every control
enum GuiControlProperty
BORDER_COLOR_NORMAL = 0,
BASE_COLOR_NORMAL,
TEXT_COLOR_NORMAL,
BORDER_COLOR_FOCUSED,
BASE_COLOR_FOCUSED,
TEXT_COLOR_FOCUSED,
BORDER_COLOR_PRESSED,
BASE_COLOR_PRESSED,
TEXT_COLOR_PRESSED,
BORDER_COLOR_DISABLED,
BASE_COLOR_DISABLED,
TEXT_COLOR_DISABLED,
BORDER_WIDTH,
TEXT_PADDING,
TEXT_ALIGNMENT,
RESERVED
end enum

' Gui extended properties depend on control
' NOTE: We reserve a fixed size of additional properties per control

' DEFAULT properties
enum GuiDefaultProperty
TEXT_SIZE = 16,
TEXT_SPACING,
LINE_COLOR,
BACKGROUND_COLOR,
end enum

' Label
'enum } GuiLabelProperty

' Button
'enum } GuiButtonProperty

' Toggle / ToggleGroup
enum GuiToggleProperty
GROUP_PADDING = 16,
end enum

' Slider / SliderBar
enum GuiSliderProperty
SLIDER_WIDTH = 16,
SLIDER_PADDING
end enum

' ProgressBar
enum GuiProgressBarProperty
PROGRESS_PADDING = 16,
end enum

' CheckBox
enum GuiCheckBoxProperty
CHECK_PADDING = 16
end enum

' ComboBox
enum GuiComboBoxProperty
COMBO_BUTTON_WIDTH = 16,
COMBO_BUTTON_PADDING
end enum

' DropdownBox
enum GuiDropdownBoxProperty
ARROW_PADDING = 16,
DROPDOWN_ITEMS_PADDING
end enum

' TextBox / TextBoxMulti / ValueBox / Spinner
enum GuiTextBoxProperty
TEXT_INNER_PADDING = 16,
TEXT_LINES_PADDING,
COLOR_SELECTED_FG,
COLOR_SELECTED_BG
end enum

' Spinner
enum GuiSpinnerProperty
SPIN_BUTTON_WIDTH = 16,
SPIN_BUTTON_PADDING,
end enum

' ScrollBar
enum GuiScrollBarProperty
ARROWS_SIZE = 16,
ARROWS_VISIBLE,
SCROLL_SLIDER_PADDING,
SCROLL_SLIDER_SIZE,
SCROLL_PADDING,
SCROLL_SPEED,
end enum

' ScrollBar side
enum GuiScrollBarSide
SCROLLBAR_LEFT_SIDE = 0,
SCROLLBAR_RIGHT_SIDE
end enum


' ListView
enum GuiListViewProperty
LIST_ITEMS_HEIGHT = 16,
LIST_ITEMS_PADDING,
SCROLLBAR_WIDTH,
SCROLLBAR_SIDE,
end enum

' ColorPicker
enum GuiColorPickerProperty
COLOR_SELECTOR_SIZE = 16,
HUEBAR_WIDTH,                  ' Right hue bar width
HUEBAR_PADDING,                ' Right hue bar separation from panel
HUEBAR_SELECTOR_HEIGHT,        ' Right hue bar selector height
HUEBAR_SELECTOR_OVERFLOW       ' Right hue bar selector overflow
end enum

'-----------------------------------------=1
' Global Variables Definition
'-----------------------------------------=1
' ...

'-----------------------------------------=1
' Module Functions Declaration
'-----------------------------------------=1

/'
  <paul>
  This function converts an array into a zstring ptr ptr, to be
  able to overload functions that take them as parameters to use
  FreeBasic's native strings. A hack to use until the header is
  reimplemented to use FreeBasic's native strings where appropriate.
'/
#if not defined( toPtrArray )
private function toPtrArray( a() as string ) as zstring ptr ptr
	static as zstring ptr p()

	redim p( lbound( a ) to ubound( a ) )

	for i as integer = lbound( p ) to ubound( p )
		p( i ) = strPtr( a( i ) )
	next

	return( @p( 0 ) )
end function
#endif

' State modification functions
RAYGUIDEF sub GuiEnable()                                         ' Enable gui controls (global state)
RAYGUIDEF sub GuiDisable()                                        ' Disable gui controls (global state)
RAYGUIDEF Sub GuiLock()                                           ' Lock gui controls (global state)
RAYGUIDEF Sub GuiUnlock()                                         ' Unlock gui controls (global state)
RAYGUIDEF Sub GuiFade(Alpha0 As Single )                                    ' Set gui controls alpha (global state), alpha goes from 0.0f to 1.0f
RAYGUIDEF sub GuiSetState(state As long )                                  ' Set gui state (global state)
RAYGUIDEF Function GuiGetState() As long                                        ' Get gui state (global state)

' Font set/get functions
RAYGUIDEF sub GuiSetFont(font As Font)                                   ' Set gui custom font (global state)
RAYGUIDEF function GuiGetFont() As Font                                       ' Get gui custom font (global state)

' Style set/get functions
RAYGUIDEF Sub GuiSetStyle( control As long, Propertys As long ,value As long)       ' Set one style property
RAYGUIDEF Function GuiGetStyle(control As long , Propertys As long ) As long                  ' Get one style property

' Tooltips set functions
RAYGUIDEF Sub GuiEnableTooltip()                                  ' Enable gui tooltips
RAYGUIDEF Sub GuiDisableTooltip()                                 ' Disable gui tooltips
RAYGUIDEF Sub GuiSetTooltip( tooltip As Const zstring Ptr)                      ' Set current tooltip for display
RAYGUIDEF Sub GuiClearTooltip()                                   ' Clear any tooltip registered

' Container/separator controls, useful for controls organization
RAYGUIDEF Function GuiWindowBox(bounds As Rectangle , title As Const zstring Ptr )  As boolean                                     ' Window Box control, shows a window that can be closed
RAYGUIDEF Sub GuiGroupBox(bounds As Rectangle , text0 As ZString Ptr )                                         ' Group Box control with text name
RAYGUIDEF Sub GuiLine(bounds As Rectangle ,  text0 As Const zstring Ptr)                                             ' Line separator control, could contain text
RAYGUIDEF Sub GuiPanel(bounds As Rectangle )                                                              ' Panel control, useful to group controls
RAYGUIDEF Function GuiScrollPanel(bounds As Rectangle, content as Rectangle, scroll As Vector2 Ptr) As Rectangle              ' Scroll Panel control

' Basic controls set
RAYGUIDEF Sub GuiLabel(bounds As Rectangle, text0 As Const zstring Ptr)                                            ' Label control, shows text
RAYGUIDEF Function GuiButton(bounds As Rectangle, text0 As Const zstring Ptr) As boolean                                          ' Button control, returns true when clicked
RAYGUIDEF function GuiLabelButton(bounds As Rectangle, text0 As Const zstring Ptr) As boolean                                      ' Label button control, show true when clicked
RAYGUIDEF Function GuiImageButton(bounds As Rectangle, text0 As Const zstring Ptr, texture as Texture2D ) As boolean                   ' Image button control, returns true when clicked
RAYGUIDEF Function GuiImageButtonEx(bounds As Rectangle, text0 As Const zstring Ptr, texture as Texture2D , texSource as Rectangle ) As boolean    ' Image button extended control, returns true when clicked
RAYGUIDEF Function GuiToggle(bounds As Rectangle, text0 As Const zstring Ptr, active as boolean) As boolean                              ' Toggle Button control, returns true when active
RAYGUIDEF function GuiToggleGroup(bounds As Rectangle, text0 As Const zstring Ptr, active as long) As long                         ' Toggle Group control, returns active toggle index
RAYGUIDEF Function GuiCheckBox(bounds As Rectangle, text0 As Const zstring Ptr,checked as boolean)  As boolean                         ' Check Box control, returns true when active
RAYGUIDEF Function GuiComboBox(bounds As Rectangle, text0 As Const zstring Ptr, active as long)  As long                            ' Combo Box control, returns selected item index
RAYGUIDEF Function GuiDropdownBox(bounds As Rectangle, text0 As Const zstring Ptr, active as long ptr, editMode as boolean) As boolean         ' Dropdown Box control, returns selected item
RAYGUIDEF Function GuiSpinner(bounds As Rectangle, text0 As Const zstring Ptr, value as long ptr, minValue as long, maxValue as long, editMode as boolean)  As boolean    ' Spinner control, returns selected value
RAYGUIDEF Function GuiValueBox(bounds As Rectangle, text0 As Const zstring Ptr, value as long Ptr, minValue as long, maxValue as long, editMode as boolean)  As boolean   ' Value Box control, updates input text with numbers
'RAYGUIDEF Function GuiTextBox(bounds As Rectangle, text0 as zstring Ptr, textSize as long, editMode as boolean)   As boolean                 ' Text Box control, updates input text
RAYGUIDEF Function GuiTextBox(bounds As Rectangle, text0 as string, textSize as long, editMode as boolean)   As boolean                 ' Text Box control, updates input text
RAYGUIDEF Function GuiTextBoxMulti(bounds As Rectangle, text0 as string, textSize as long, editMode as boolean)  As boolean             ' Text Box control with multiple lines
RAYGUIDEF function GuiSlider(bounds As Rectangle, textLeft As Const zstring Ptr, textRight As Const zstring Ptr, value as single, minValue as single, maxValue as Single)  As Single     ' Slider control, returns selected value
RAYGUIDEF Function GuiSliderBar(bounds As Rectangle, textLeft As Const zstring Ptr, textRight As Const zstring Ptr, value as Single, minValue as Single, maxValue as Single) As Single   ' Slider Bar control, returns selected value
RAYGUIDEF Function GuiProgressBar(bounds As Rectangle, textLeft As Const zstring Ptr, textRight As Const zstring Ptr, value as Single, minValue as Single, maxValue as Single) As Single ' Progress Bar control, shows current progress value
RAYGUIDEF Sub GuiStatusBar(bounds As Rectangle, text0 As Const zstring Ptr)                                        ' Status Bar control, shows info text
RAYGUIDEF Sub GuiDummyRec(bounds As Rectangle, text0 As Const zstring Ptr)                                         ' Dummy control for placeholders
RAYGUIDEF function GuiScrollBar(bounds As Rectangle, value as long, minValue as long, maxValue as long) As long                   ' Scroll Bar control
RAYGUIDEF Function GuiGrid(bounds As Rectangle, spacing as single, subdivs as long) As Vector2                               ' Grid control

' Advance controls set
RAYGUIDEF Function GuiListView(bounds As Rectangle, text0 As Const zstring Ptr, scrollIndex as long ptr, active as long) As long            ' List View control, returns selected list item index
RAYGUIDEF Function GuiListViewEx overload(bounds As Rectangle, text0 As Const zstring ptr ptr, count as long , focus as long ptr, scrollIndex as long Ptr, active as long) As long   ' List View with extended parameters
RAYGUIDEF Function GuiListViewEx(bounds As Rectangle, text0() as string, count as long , focus as long ptr, scrollIndex as long Ptr, active as long) As long   ' List View with extended parameters
RAYGUIDEF Function GuiMessageBox(bounds As Rectangle, title As Const zstring Ptr,  message As Const zstring Ptr,  buttons As Const zstring Ptr) As long             ' Message Box control, displays a message
RAYGUIDEF Function GuiTextInputBox(bounds As Rectangle,  title As Const zstring Ptr,  message As Const zstring Ptr,  buttons As Const zstring Ptr, text as zstring Ptr)  As long  ' Text Input Box control, ask for text
RAYGUIDEF Function GuiColorPicker(bounds As Rectangle, color as Color) As Color                                          ' Color Picker control (multiple color controls)
RAYGUIDEF Function GuiColorPanel(bounds As Rectangle, color as Color) As Color                                          ' Color Panel control
RAYGUIDEF Function GuiColorBarAlpha(bounds As Rectangle, alpha as single) As Single                                       ' Color Bar Alpha control
RAYGUIDEF Function GuiColorBarHue(bounds As Rectangle, value as Single) As Single                                         ' Color Bar Hue control

' Styles loading functions
RAYGUIDEF Sub GuiLoadStyle( fileName As zstring ptr)              ' Load style file (.rgs)
RAYGUIDEF Sub GuiLoadStyleDefault()                       ' Load style default over global style

/'
typedef GuiStyle (ulong *)
RAYGUIDEF GuiStyle LoadGuiStyle( fileName As Const zstring Ptr)          ' Load style from file (.rgs)
RAYGUIDEF sub UnloadGuiStyle(GuiStyle style)                  ' Unload style
'/

RAYGUIDEF  Function GuiIconText( iconId as long, text As Const zstring Ptr) As Const zstring Ptr ' Get text with icon id prepended (if supported)

#if defined(RAYGUI_SUPPORT_ICONS)
' Gui icons functionality
RAYGUIDEF Sub GuiDrawIcon( iconId as long, position as Vector2 , pixelSize as long, color0 as Color)

RAYGUIDEF Function GuiGetIcons()  As ulong ptr                    ' Get full icons data pointegerer
RAYGUIDEF Function GuiGetIconData( iconId as long) As ulong ptr            ' Get icon bit data
RAYGUIDEF Sub GuiSetIconData( iconId as long, data as ulong ptr)  ' Set icon bit data

RAYGUIDEF Sub GuiSetIconPixel( iconId as long, x as long, y as long)       ' Set icon pixel value
RAYGUIDEF sub GuiClearIconPixel( iconId as long, x as long, y as long)     ' Clear icon pixel value
RAYGUIDEF function GuiCheckIconPixel( iconId as long, x as long, y as long) As boolean    ' Check icon pixel value
#endif

#endif ' RAYGUI_H


/'**********************************************************************************
*
*   RAYGUI IMPLEMENTATION
*
***********************************************************************************'/

#if defined(RAYGUI_IMPLEMENTATION)

#if defined(RAYGUI_SUPPORT_ICONS)
#define RICONS_IMPLEMENTATION
#include "./ricons.bi"         ' Required for: raygui icons data
#endif

#include "crt/stdio.bi"              ' Required for: FILE, fopen(), fclose(), fprintegerf(), feof(), fscanf(), vsprintf()
#include "crt/string.bi"             ' Required for: strlen() on GuiTextBox()
#include "crt/math.bi"               ' Required for: roundf() on GuiColorPicker()

#if defined(RAYGUI_STANDALONE)
#include "crt/stdarg.bi"        ' Required for: va_list, va_start(), vfprintegerf(), va_end()
#endif

#ifdef __cplusplus
#define RAYGUI_CLITERAL(name) name
#else
#define RAYGUI_CLITERAL(name) (name)
#endif

'-----------------------------------------=1
' Defines and Macros
'-----------------------------------------=1
'...

'-----------------------------------------=1
' Types and Structures Definition
'-----------------------------------------=1
' Gui control property style color element
enum GuiPropertyElement
BORDER = 0,
BASE0 = 1,
TEXT,
OTHER
End Enum

'-----------------------------------------=1
' Global Variables Definition
'-----------------------------------------=1
Dim shared guiState As GuiControlState = GUI_STATE_NORMAL

Dim shared  guiFont As Font  =  (0)             ' Gui current font (WARNING: highly coupled to raylib)
Dim shared  guiLocked As boolean  = false          ' Gui lock state (no inputs processed)
Dim shared  guiAlpha As Single  = 1.0f           ' Gui element transpacency on drawing

' Global gui style array (allocated on data segment by default)
' NOTE: In raygui we manage a single long array with all the possible style properties.
' When a new style is loaded, it loads over the global style... but default gui style
' could always be recovered with GuiLoadStyleDefault()
Dim shared  guiStyle(NUM_CONTROLS*(NUM_PROPS_DEFAULT + NUM_PROPS_EXTENDED)) As ulong =  {0 }
Dim shared  guiStyleLoaded As boolean = false     ' Style loaded flag for lazy style initialization

' Tooltips required variables
Dim shared  guiTooltip As Const zstring Ptr= NULL   ' Gui tooltip currently active (user provided)
Dim Shared  guiTooltipEnabled As boolean = true   ' Gui tooltips enabled

'-----------------------------------------=1
' Standalone Mode Functions Declaration
'
' NOTE: raygui depend on some raylib input and drawing functions
' To use raygui as standalone library, below functions must be defined by the user
'-----------------------------------------=1
#if defined(RAYGUI_STANDALONE)

#define KEY_RIGHT           262
#define KEY_LEFT            263
#define KEY_DOWN            264
#define KEY_UP              265
#define KEY_BACKSPACE       259
#define KEY_ENTER           257

#define MOUSE_LEFT_BUTTON     0

' Input required functions
'---------------------------------------=1-
declare Function  GetMousePosition() As Vector2
declare Function  GetMouseWheelMove() As long
declare Function  IsMouseButtonDown(button As long)As boolean
Declare  IsMouseButtonPressed(button As long)As boolean
declare function boolean IsMouseButtonReleased(button As long)

declare function  IsKeyDown(key As long)As boolean
declare function  IsKeyPressed(key As long)As boolean
Declare  Function GetCharPressed() As long        ' -=1 GuiTextBox(), GuiTextBoxMulti(), GuiValueBox()
'---------------------------------------=1-

' Drawing required functions
'---------------------------------------=1-
Declare Sub DrawRectangle(x as long, y as long, width0 As long, height0 As long, color0 as Color)        ' -=1 GuiDrawRectangle(), GuiDrawIcon()

Declare Sub DrawRectangleGradientEx(rec as Rectangle, Color col1, Color col2, Color col3, Color col4)     ' -=1 GuiColorPicker()
Declare Sub DrawTriangle(v1 as Vector2, v2 as Vector2, v3 as Vector2, color0 as Color)                              ' -=1 GuiDropdownBox(), GuiScrollBar()
Declare  Sub DrawTextureRec(texture as Texture2D , sourceRec as Rectangle , position as Vector2 , tint as Color)       ' -=1 GuiImageButtonEx()

Declare  Sub DrawTextRec(font0 as Font, text As Const zstring Ptr, rec as Rectangle, fontSize as single , spacing as Single, wordWrap as boolean, tint as Color) ' -=1 GuiTextBoxMulti()
'---------------------------------------=1-

' Text required functions
'---------------------------------------=1-
declare function GetFontDefault() As Font                          ' -=1 GuiLoadStyleDefault()
declare function MeasureTextEx(font0 as Font, text As Const zstring Ptr, fontSize as single , spacing as Single)  As Vector2                         ' -=1 GetTextWidth(), GuiTextBoxMulti()
Declare  Sub DrawTextEx(font0 as Font, text As Const zstring Ptr, position as Vector2 , fontSize as Single , spacing as Single, tint as Color)  ' -=1 GuiDrawText()

declare function LoadFontEx( fileName As Const zstring Ptr, fontSize as long, fontChars as long ptr, charsCount as long) As Font ' -=1 GuiLoadStyle()
declare function LoadText( fileName As Const zstring Ptr)  As ZString ptr              ' -=1 GuiLoadStyle()
Declare Function  GetDirectoryPath( filePath As Const zstring Ptr) As Const zstring Ptr static ' -=1 GuiLoadStyle()
'---------------------------------------=1-

' raylib functions already implemented in raygui
'---------------------------------------=1-
declare function  GetColor(hexValue As long)   As Color                ' Returns a Color struct from hexadecimal value
declare function ColorToInt(color0 as Color)  As long                ' Returns hexadecimal value for a Color
declare function  Fade(color0 as Color, alpha0 as Single) As Color       ' Color fade-in or fade-out, alpha goes from 0.0f to 1.0f
declare function  CheckCollisionPointRec(point0 as Vector2 , rec as Rectangle)  As boolean ' Check if pointeger is inside rectangle
declare function  textFormat( text0 As Const zstring Ptr, ...)  As Const zstring Ptr              ' Formatting of text with variables to 'embed'
declare function  textSplit( text0 As Const zstring Ptr, char delimiter, count as long Ptr) As Const zstring Ptr    ' Split text integero multiple strings
declare function TextToInteger( text0 As Const zstring Ptr)  As long       ' Get integereger value from text

Declare  Sub DrawRectangleGradientV(long posX, long posY, width0 As long, height0 As long, color1 as Color, color1 as Color)  ' Draw rectangle vertical gradient
'---------------------------------------=1-

#endif      ' RAYGUI_STANDALONE

'-----------------------------------------=1
' Module specific Functions Declaration
'-----------------------------------------=1
Declare Function GetTextWidth( text0 As Const zstring Ptr)  As  long' Static                   ' Gui get text width using default font
Declare Function GetTextBounds(control as long, bounds As Rectangle) As Rectangle' Static' Get text bounds considering control bounds
Declare Function GetTextIcon( text0 As Const zstring Ptr, iconId as long ptr) As Const zstring Ptr' Static  ' Get text icon if provided and move text cursor

'static
Declare Sub GuiDrawText( text As Const zstring Ptr, bounds As Rectangle, alignment as long, tint as Color)         ' Gui draw text using default font
'static
Declare Sub GuiDrawRectangle(rec as Rectangle, borderWidth as long , borderColor as Color , color0 as Color)   ' Gui draw rectangle using default raygui style
'static
Declare Sub GuiDrawTooltip(bounds As Rectangle)                   ' Draw tooltip relatively to bounds

'static
Declare Function GuiTextSplit( text0 As Const zstring Ptr, count as long ptr, textRow as long ptr) As Const ubyte Ptr Ptr  ' Split controls text integero multiple strings
'static
Declare Function ConvertHSVtoRGB(hsv as Vector3)   As  Vector3                ' Convert color data from HSV to RGB
'static
Declare Function ConvertRGBtoHSV(rgb0 as Vector3)  as  Vector3                 ' Convert color data from RGB to HSV

'-----------------------------------------=1
' Gui Setup Functions Definition
'-----------------------------------------=1
' Enable gui global state
Sub GuiEnable()
	guiState = GUI_STATE_NORMAL
End Sub

' Disable gui global state
Sub GuiDisable()
	guiState = GUI_STATE_DISABLED
End Sub

' Lock gui global state
Sub GuiLock()
	guiLocked = true
End Sub

' Unlock gui global state
sub GuiUnlock()
	guiLocked = false
End Sub

' Set gui controls alpha global state
Sub GuiFade(alpha as Single)

	if (alpha < 0.0f) Then
		alpha = 0.0f
	elseif (alpha > 1.0f) then
		alpha = 1.0f
	EndIf

	guiAlpha = alpha
End Sub


' Set gui state (global state)
Sub GuiSetState(state As long )
	guiState = Cast(GuiControlState,state)
End Sub

' Get gui state (global state)
Function GuiGetState() As long
	return guiState
End function
' Set custom gui font
' NOTE: Font loading/unloading is external to raygui
Sub GuiSetFont(font0 As Font )

	if (font0.texture.id > 0) Then

		' NOTE: If we try to setup a font but default style has not been
		' lazily loaded before, it will be overwritten, so we need to force
		' default style loading first
		if (Not(guiStyleLoaded)) Then GuiLoadStyleDefault()

		guiFont = font0
		GuiSetStyle(DEFAULT, TEXT_SIZE, font0.baseSize)
	EndIf
End sub

' Get custom gui font
Function GuiGetFont() As Font

	return guiFont
End function

' Set control style property value
Sub GuiSetStyle(control0 as long, propertys0 As long , value0 as long)

	if (Not(guiStyleLoaded)) Then GuiLoadStyleDefault()
	guiStyle(control0*(NUM_PROPS_DEFAULT + NUM_PROPS_EXTENDED) + Propertys0) = value0

	' Default properties are propagated to all controls
	if ((control0 = 0) AndAlso (propertys0 < NUM_PROPS_DEFAULT)) Then
		for i As ulong=1 to NUM_CONTROLS-1
			guiStyle((i*(NUM_PROPS_DEFAULT + NUM_PROPS_EXTENDED)) + propertys0) = value0
		Next
	EndIf
End Sub

' Get control style property value
Function GuiGetStyle(control0 as long, propertys0 As long) As long

	if (Not(guiStyleLoaded)) Then GuiLoadStyleDefault()
	return guiStyle(control0*((NUM_PROPS_DEFAULT + NUM_PROPS_EXTENDED)) + propertys0)
End Function

' Enable gui tooltips
Sub GuiEnableTooltip()
	guiTooltipEnabled = true
End Sub

' Disable gui tooltips
Sub GuiDisableTooltip()
	guiTooltipEnabled = false
End Sub

' Set current tooltip for display
Sub GuiSetTooltip( tooltip As Const zstring Ptr)
	guiTooltip = tooltip
End Sub

' Clear any tooltip registered
Sub GuiClearTooltip()
	guiTooltip = NULL
End Sub


'-----------------------------------------=1
' Gui Controls Functions Definition
'-----------------------------------------=1

' Window Box control
Function GuiWindowBox(bounds As Rectangle,  title0 As Const zstring Ptr) As boolean

	' NOTE: This define is also used by GuiMessageBox() and GuiTextInputBox()
	#define WINDOW_STATUSBAR_HEIGHT        22

	Dim As GuiControlState state = guiState
	Dim As boolean clicked = false

	Dim As long statusBarHeight = WINDOW_STATUSBAR_HEIGHT + 2*GuiGetStyle(STATUSBAR, BORDER_WIDTH)
	statusBarHeight += (statusBarHeight Mod 2)

	Dim As Rectangle statusBar0 = Rectangle( bounds.x, bounds.y, bounds.width, statusBarHeight )
	If (bounds.height < statusBarHeight*2) Then bounds.height = statusBarHeight*2

	Dim As Rectangle windowPanel =  Rectangle(bounds.x, bounds.y + statusBarHeight - 1, bounds.width, bounds.height - statusBarHeight )
	Dim As Rectangle closeButtonRec =  Rectangle(statusBar0.x + statusBar0.width - GuiGetStyle(STATUSBAR, BORDER_WIDTH) - 20, _
	statusBar0.y + statusBarHeight/2 - 18/2, 18, 18 )

	' Update control
	'----------------------------------
	' NOTE: Logic is directly managed by button
	'----------------------------------

	' Draw control
	'----------------------------------
	GuiStatusBar(statusBar0, title0) ' Draw window header as status bar
	GuiPanel(windowPanel)          ' Draw window base

	' Draw window close button
	Dim As long tempBorderWidth = GuiGetStyle(BUTTON, BORDER_WIDTH)
	Dim As long tempTextAlignment = GuiGetStyle(BUTTON, TEXT_ALIGNMENT)
	GuiSetStyle(BUTTON, BORDER_WIDTH, 1)
	GuiSetStyle(BUTTON, TEXT_ALIGNMENT, GUI_TEXT_ALIGN_CENTER)
	#if defined(RAYGUI_SUPPORT_ICONS)
	'hack
	GuiSetStyle(BUTTON, TEXT_ALIGNMENT, GUI_TEXT_ALIGN_LEFT)
	clicked = GuiButton(closeButtonRec, GuiIconText(RICON_CROSS_SMALL, NULL))
	#else
	clicked = GuiButton(closeButtonRec, "x")
	#endif
	GuiSetStyle(BUTTON, BORDER_WIDTH, tempBorderWidth)
	GuiSetStyle(BUTTON, TEXT_ALIGNMENT, tempTextAlignment)
	'----------------------------------

	return clicked
End function

' Group Box control with text name
Sub GuiGroupBox(bounds As Rectangle, text0 As zstring Ptr)

	#define GROUPBOX_LINE_THICK     1
	#define GROUPBOX_TEXT_PADDING  10

	Dim As GuiControlState state = guiState

	' Draw control
	'----------------------------------
	'    GuiDrawRectangle(RAYGUI_CLITERAL(Rectangle) bounds.x, bounds.y, GROUPBOX_LINE_THICK, bounds.height }, 0, BLANK, Fade(GetColor(GuiGetStyle(DEFAULT, iif(state = GUI_STATE_DISABLED, BORDER_COLOR_DISABLED , LINE_COLOR))), guiAlpha))
	GuiDrawRectangle(Rectangle(bounds.x, bounds.y, GROUPBOX_LINE_THICK, bounds.height ), 0, BLANK, Fade(GetColor(GuiGetStyle(DEFAULT, iif(state = GUI_STATE_DISABLED, BORDER_COLOR_DISABLED , LINE_COLOR))), guiAlpha))
	'    GuiDrawRectangle(RAYGUI_CLITERAL(Rectangle) bounds.x, bounds.y + bounds.height - 1, bounds.width, GROUPBOX_LINE_THICK }, 0, BLANK, Fade(GetColor(GuiGetStyle(DEFAULT, IIf(state = GUI_STATE_DISABLED, BORDER_COLOR_DISABLED , LINE_COLOR))), guiAlpha))
	GuiDrawRectangle(Rectangle(bounds.x, bounds.y + bounds.height - 1, bounds.width, GROUPBOX_LINE_THICK ), 0, BLANK, Fade(GetColor(GuiGetStyle(DEFAULT, IIf(state = GUI_STATE_DISABLED, BORDER_COLOR_DISABLED , LINE_COLOR))), guiAlpha))
	'    GuiDrawRectangle(RAYGUI_CLITERAL(Rectangle) bounds.x + bounds.width - 1, bounds.y, GROUPBOX_LINE_THICK, bounds.height }, 0, BLANK, Fade(GetColor(GuiGetStyle(DEFAULT, iif(state = GUI_STATE_DISABLED, BORDER_COLOR_DISABLED , LINE_COLOR))), guiAlpha))
	GuiDrawRectangle(Rectangle(bounds.x + bounds.width - 1, bounds.y, GROUPBOX_LINE_THICK, bounds.height ), 0, BLANK, Fade(GetColor(GuiGetStyle(DEFAULT, iif(state = GUI_STATE_DISABLED, BORDER_COLOR_DISABLED , LINE_COLOR))), guiAlpha))

	GuiLine(Rectangle(bounds.x, bounds.y, bounds.width, 1 ), text0)
	'----------------------------------
End Sub

' Line control
Sub GuiLine(bounds As Rectangle, text0 As Const zstring Ptr)

	#define LINE_TEXT_PADDING  10

	Dim As GuiControlState state = guiState

	Dim Color0 as Color = Fade(GetColor(GuiGetStyle(DEFAULT, iif(state = GUI_STATE_DISABLED, BORDER_COLOR_DISABLED , LINE_COLOR))), guiAlpha)

	' Draw control
	'----------------------------------
	'    if (text = NULL) then GuiDrawRectangle(RAYGUI_CLITERAL(Rectangle) bounds.x, bounds.y + bounds.height/2, bounds.width, 1 }, 0, BLANK, color)
	if (text0 = NULL) then
		GuiDrawRectangle(Rectangle(bounds.x, bounds.y + bounds.height/2, bounds.width, 1 ), 0, BLANK, Color0)
	Else
		Dim As Rectangle textBounds '=  (0 )
		textBounds.width = GetTextWidth(text0)      ' TODO: Consider text icon
		textBounds.height = GuiGetStyle(DEFAULT, TEXT_SIZE)
		textBounds.x = bounds.x + LINE_TEXT_PADDING
		textBounds.y = bounds.y - GuiGetStyle(DEFAULT, TEXT_SIZE)/2

		' Draw line with embedded text label: "-=1- text -------=1"
		'        GuiDrawRectangle(RAYGUI_CLITERAL(Rectangle) bounds.x, bounds.y, LINE_TEXT_PADDING - 2, 1 }, 0, BLANK, Color0)
		GuiDrawRectangle(Rectangle(bounds.x, bounds.y, LINE_TEXT_PADDING - 2, 1 ), 0, BLANK, Color0)
		GuiLabel(textBounds, text0)
		'GuiDrawRectangle(RAYGUI_CLITERAL(Rectangle) bounds.x + LINE_TEXT_PADDING + textBounds.width + 4, bounds.y, bounds.width - textBounds.width - LINE_TEXT_PADDING - 4, 1 }, 0, BLANK, color)
		GuiDrawRectangle(Rectangle(bounds.x + LINE_TEXT_PADDING + textBounds.width + 4, bounds.y, bounds.width - textBounds.width - LINE_TEXT_PADDING - 4, 1 ), 0, BLANK, Color0)
	EndIf
	'----------------------------------
End sub

' Panel control
Sub GuiPanel(bounds As Rectangle)

	#define PANEL_BORDER_WIDTH   1

	Dim As GuiControlState state = guiState

	' Draw control
	'----------------------------------
	'    GuiDrawRectangle(bounds, PANEL_BORDER_WIDTH, Fade(GetColor(GuiGetStyle(DEFAULT, (state == GUI_STATE_DISABLED)? BORDER_COLOR_DISABLED: LINE_COLOR)), guiAlpha),
	'                     Fade(GetColor(GuiGetStyle(DEFAULT, (state == GUI_STATE_DISABLED)? BASE_COLOR_DISABLED : BACKGROUND_COLOR)), guiAlpha))
	GuiDrawRectangle(bounds, PANEL_BORDER_WIDTH, Fade(GetColor(GuiGetStyle(DEFAULT, IIf(state = GUI_STATE_DISABLED, BORDER_COLOR_DISABLED, LINE_COLOR))), guiAlpha), _
	Fade(GetColor(GuiGetStyle(DEFAULT, iif(state = GUI_STATE_DISABLED, BASE_COLOR_DISABLED , BACKGROUND_COLOR))), guiAlpha))
	'----------------------------------
End sub

' Scroll Panel control
function GuiScrollPanel(bounds As Rectangle, content as Rectangle, scroll As Vector2 ptr) as Rectangle

	Dim As GuiControlState state = guiState

	Dim As Vector2 scrollPos =  Vector2(0.0f, 0.0f )
	if (scroll <> NULL) Then scrollPos = *scroll

	Dim As boolean hasHorizontalScrollBar = IIf(content.width > bounds.width - 2*GuiGetStyle(DEFAULT, BORDER_WIDTH), true , FALSE)
	Dim As boolean hasVerticalScrollBar = IIf(content.height > bounds.height - 2*GuiGetStyle(DEFAULT, BORDER_WIDTH), true , FALSE)

	' Recheck to account for the other scrollbar being visible
	if (Not hasHorizontalScrollBar) Then hasHorizontalScrollBar = IIf(hasVerticalScrollBar and (content.width > (bounds.width - 2*GuiGetStyle(DEFAULT, BORDER_WIDTH) - GuiGetStyle(LISTVIEW, SCROLLBAR_WIDTH))), true , false)
	if (Not hasVerticalScrollBar) Then hasVerticalScrollBar = IIf(hasHorizontalScrollBar And (content.height > (bounds.height - 2*GuiGetStyle(DEFAULT, BORDER_WIDTH) - GuiGetStyle(LISTVIEW, SCROLLBAR_WIDTH))), true , false)

	Dim As Const long horizontalScrollBarWidth = IIf(hasHorizontalScrollBar, GuiGetStyle(LISTVIEW, SCROLLBAR_WIDTH) , 0)
	Dim As Const long verticalScrollBarWidth =  IIf(hasVerticalScrollBar, GuiGetStyle(LISTVIEW, SCROLLBAR_WIDTH) , 0)
	' Dim As Const Rectangle horizontalScrollBar =  (single)((GuiGetStyle(LISTVIEW, SCROLLBAR_SIDE) == SCROLLBAR_LEFT_SIDE)? (single)bounds.x + verticalScrollBarWidth : (single)bounds.x) + GuiGetStyle(DEFAULT, BORDER_WIDTH), (single)bounds.y + bounds.height - horizontalScrollBarWidth - GuiGetStyle(DEFAULT, BORDER_WIDTH), (single)bounds.width - verticalScrollBarWidth - 2*GuiGetStyle(DEFAULT, BORDER_WIDTH), (single)horizontalScrollBarWidth }
	' Dim As Const Rectangle verticalScrollBar =  (single)((GuiGetStyle(LISTVIEW, SCROLLBAR_SIDE) == SCROLLBAR_LEFT_SIDE)? (single)bounds.x + GuiGetStyle(DEFAULT, BORDER_WIDTH) : (single)bounds.x + bounds.width - verticalScrollBarWidth - GuiGetStyle(DEFAULT, BORDER_WIDTH)), (single)bounds.y + GuiGetStyle(DEFAULT, BORDER_WIDTH), (single)verticalScrollBarWidth, (single)bounds.height - horizontalScrollBarWidth - 2*GuiGetStyle(DEFAULT, BORDER_WIDTH) }
	Dim As Const Rectangle horizontalScrollBar =  Rectangle(IIf((GuiGetStyle(LISTVIEW, SCROLLBAR_SIDE) = SCROLLBAR_LEFT_SIDE), bounds.x + verticalScrollBarWidth , bounds.x) + _
	GuiGetStyle(DEFAULT, BORDER_WIDTH), _
	bounds.y + bounds.height - horizontalScrollBarWidth - GuiGetStyle(DEFAULT, BORDER_WIDTH), _
	bounds.width - verticalScrollBarWidth - 2*GuiGetStyle(DEFAULT, BORDER_WIDTH), _
	horizontalScrollBarWidth )

	Dim As Const Rectangle verticalScrollBar =   Rectangle(IIf((GuiGetStyle(LISTVIEW, SCROLLBAR_SIDE) = SCROLLBAR_LEFT_SIDE), bounds.x + GuiGetStyle(DEFAULT, BORDER_WIDTH) , bounds.x + bounds.width - verticalScrollBarWidth - GuiGetStyle(DEFAULT, BORDER_WIDTH)), _
	bounds.y + GuiGetStyle(DEFAULT, BORDER_WIDTH), _
	verticalScrollBarWidth, _
	bounds.height - horizontalScrollBarWidth - 2*GuiGetStyle(DEFAULT, BORDER_WIDTH) )

	' Calculate view area (area without the scrollbars)
	Dim As Rectangle view0 = iif(GuiGetStyle(LISTVIEW, SCROLLBAR_SIDE) = SCROLLBAR_LEFT_SIDE , _
	Rectangle(bounds.x + verticalScrollBarWidth + GuiGetStyle(DEFAULT, BORDER_WIDTH), bounds.y + GuiGetStyle(DEFAULT, BORDER_WIDTH), bounds.width - 2*GuiGetStyle(DEFAULT, BORDER_WIDTH) - verticalScrollBarWidth, bounds.height - 2*GuiGetStyle(DEFAULT, BORDER_WIDTH) - horizontalScrollBarWidth ) , _
	Rectangle(bounds.x + GuiGetStyle(DEFAULT, BORDER_WIDTH), bounds.y + GuiGetStyle(DEFAULT, BORDER_WIDTH), bounds.width - 2*GuiGetStyle(DEFAULT, BORDER_WIDTH) - verticalScrollBarWidth, bounds.height - 2*GuiGetStyle(DEFAULT, BORDER_WIDTH) - horizontalScrollBarWidth ))

	' Clip view area to the actual content size
	if (view0.width > content.width) Then view0.width = content.width
	if (view0.height > content.height) Then view0.height = content.height

	' TODO: Review!
	Dim As Const long horizontalMin = IIf(hasHorizontalScrollBar, iif(GuiGetStyle(LISTVIEW, SCROLLBAR_SIDE) = SCROLLBAR_LEFT_SIDE, -verticalScrollBarWidth , 0) - GuiGetStyle(DEFAULT, BORDER_WIDTH) , iif(GuiGetStyle(LISTVIEW, SCROLLBAR_SIDE) = SCROLLBAR_LEFT_SIDE, -verticalScrollBarWidth , 0) - GuiGetStyle(DEFAULT, BORDER_WIDTH))
	Dim As Const long horizontalMax = IIf(hasHorizontalScrollBar, content.width - bounds.width + verticalScrollBarWidth + GuiGetStyle(DEFAULT, BORDER_WIDTH) - iif(GuiGetStyle(LISTVIEW, SCROLLBAR_SIDE) = SCROLLBAR_LEFT_SIDE, verticalScrollBarWidth , 0) , -GuiGetStyle(DEFAULT, BORDER_WIDTH))
	Dim As Const long verticalMin = IIf(hasVerticalScrollBar, -GuiGetStyle(DEFAULT, BORDER_WIDTH) , -GuiGetStyle(DEFAULT, BORDER_WIDTH))
	Dim As Const long verticalMax = IIf(hasVerticalScrollBar, content.height - bounds.height + horizontalScrollBarWidth + GuiGetStyle(DEFAULT, BORDER_WIDTH) , -GuiGetStyle(DEFAULT, BORDER_WIDTH))

	' Update control
	'----------------------------------
	if ((state <> GUI_STATE_DISABLED) andalso Not guiLocked) Then

		Dim As Vector2 mousePointeger = GetMousePosition()

		' Check button state
		if (CheckCollisionPointRec(mousePointeger, bounds)) Then

			if (IsMouseButtonDown(MOUSE_LEFT_BUTTON)) Then
				state = GUI_STATE_PRESSED
			else
				state = GUI_STATE_FOCUSED
			EndIf

			if (hasHorizontalScrollBar) Then
				if (IsKeyDown(KEY_RIGHT)) Then scrollPos.x -= GuiGetStyle(SCROLLBAR, SCROLL_SPEED)
				if (IsKeyDown(KEY_LEFT)) Then scrollPos.x += GuiGetStyle(SCROLLBAR, SCROLL_SPEED)
			EndIf

			if (hasVerticalScrollBar) Then

				if (IsKeyDown(KEY_DOWN)) Then scrollPos.y -= GuiGetStyle(SCROLLBAR, SCROLL_SPEED)
				if (IsKeyDown(KEY_UP)) Then scrollPos.y += GuiGetStyle(SCROLLBAR, SCROLL_SPEED)
			EndIf

			Dim As long wheelMove = GetMouseWheelMove()

			' Horizontal scroll (Shift + Mouse wheel)
			if (hasHorizontalScrollBar andalso (IsKeyDown(KEY_LEFT_SHIFT) orelse IsKeyDown(KEY_RIGHT_SHIFT))) Then
				scrollPos.x += wheelMove*20
			else
				scrollPos.y += wheelMove*20 ' Vertical scroll
			EndIf
		EndIf
	EndIf

	' Normalize scroll values
	if (scrollPos.x > -horizontalMin) Then scrollPos.x = -horizontalMin
	if (scrollPos.x < -horizontalMax) Then scrollPos.x = -horizontalMax
	if (scrollPos.y > -verticalMin) Then scrollPos.y = -verticalMin
	if (scrollPos.y < -verticalMax) Then scrollPos.y = -verticalMax
	'----------------------------------

	' Draw control
	'----------------------------------
	GuiDrawRectangle(bounds, 0, BLANK, GetColor(GuiGetStyle(DEFAULT, BACKGROUND_COLOR)))        ' Draw background

	' Save size of the scrollbar slider
	Dim As Const long slider = GuiGetStyle(SCROLLBAR, SCROLL_SLIDER_SIZE)

	' Draw horizontal scrollbar if visible
	if (hasHorizontalScrollBar) Then

		' Change scrollbar slider size to show the diff in size between the content width and the widget width
		GuiSetStyle(SCROLLBAR, SCROLL_SLIDER_SIZE, ((bounds.width - 2*GuiGetStyle(DEFAULT, BORDER_WIDTH) - verticalScrollBarWidth)/content.width)*(bounds.width - 2*GuiGetStyle(DEFAULT, BORDER_WIDTH) - verticalScrollBarWidth))
		scrollPos.x = -GuiScrollBar(Cast(Rectangle,horizontalScrollBar), -scrollPos.x, horizontalMin, horizontalMax)
	EndIf

	' Draw vertical scrollbar if visible
	if (hasVerticalScrollBar) Then

		' Change scrollbar slider size to show the diff in size between the content height and the widget height
		GuiSetStyle(SCROLLBAR, SCROLL_SLIDER_SIZE, ((bounds.height - 2*GuiGetStyle(DEFAULT, BORDER_WIDTH) - horizontalScrollBarWidth)/content.height)* (bounds.height - 2*GuiGetStyle(DEFAULT, BORDER_WIDTH) - horizontalScrollBarWidth))
		scrollPos.y = -GuiScrollBar(Cast(Rectangle,verticalScrollBar), -scrollPos.y, verticalMin, verticalMax)
	EndIf

	' Draw detail corner rectangle if both scroll bars are visible
	if (hasHorizontalScrollBar andalso hasVerticalScrollBar) Then

		' TODO: Consider scroll bars side
		Dim As Rectangle corner =  Rectangle(horizontalScrollBar.x + horizontalScrollBar.width + 2, verticalScrollBar.y + verticalScrollBar.height + 2, horizontalScrollBarWidth - 4, verticalScrollBarWidth - 4 )
		GuiDrawRectangle(corner, 0, BLANK, Fade(GetColor(GuiGetStyle(LISTVIEW, TEXT + (state*3))), guiAlpha))
	EndIf

	' Draw scrollbar lines depending on current state
	GuiDrawRectangle(bounds, GuiGetStyle(DEFAULT, BORDER_WIDTH), Fade(GetColor(GuiGetStyle(LISTVIEW, BORDER + (state*3))), guiAlpha), BLANK)

	' Set scrollbar slider size back to the way it was before
	GuiSetStyle(SCROLLBAR, SCROLL_SLIDER_SIZE, slider)
	'----------------------------------

	if (scroll <> NULL) Then *scroll = scrollPos

	return view0
End function

' Label control
Sub GuiLabel(bounds As Rectangle, text0 As Const zstring Ptr)

	Dim As GuiControlState state = guiState

	' Update control
	'----------------------------------
	' ...
	'----------------------------------

	' Draw control
	'----------------------------------
	GuiDrawText(text0, GetTextBounds(LABEL, bounds), GuiGetStyle(LABEL, TEXT_ALIGNMENT), Fade(GetColor(GuiGetStyle(LABEL, iif(state = GUI_STATE_DISABLED, TEXT_COLOR_DISABLED , TEXT_COLOR_NORMAL))), guiAlpha))
	'----------------------------------
End sub

' Button control, returns true when clicked
Function GuiButton(bounds As Rectangle, text0 As Const zstring Ptr) As boolean

	Dim As GuiControlState state = guiState
	Dim As boolean pressed = false

	' Update control
	'----------------------------------
	if ((state <> GUI_STATE_DISABLED) andalso Not guiLocked) Then

		Dim As Vector2 mousePointeger = GetMousePosition()

		' Check button state
		if (CheckCollisionPointRec(mousePointeger, bounds)) Then

			if (IsMouseButtonDown(MOUSE_LEFT_BUTTON)) Then
				state = GUI_STATE_PRESSED
			Else
				state = GUI_STATE_FOCUSED
			EndIf

			if (IsMouseButtonReleased(MOUSE_LEFT_BUTTON)) Then pressed = true
		EndIf
	EndIf
	'----------------------------------

	' Draw control
	'----------------------------------
	GuiDrawRectangle(bounds, GuiGetStyle(BUTTON, BORDER_WIDTH), Fade(GetColor(GuiGetStyle(BUTTON, BORDER + (state*3))), guiAlpha), Fade(GetColor(GuiGetStyle(BUTTON, BASE0 + (state*3))), guiAlpha))
	GuiDrawText(text0, GetTextBounds(BUTTON, bounds), GuiGetStyle(BUTTON, TEXT_ALIGNMENT), Fade(GetColor(GuiGetStyle(BUTTON, (TEXT + (state*3)))), guiAlpha))
	'---------------------------------=1

	return pressed
End function

' Label button control
Function GuiLabelButton(bounds As Rectangle, text0 As Const zstring Ptr) As boolean

	Dim As GuiControlState state = guiState
	Dim As boolean pressed = false

	' NOTE: We force bounds.width to be all text
	Dim As long textWidth = MeasureTextEx(guiFont, text0, GuiGetStyle(DEFAULT, TEXT_SIZE), GuiGetStyle(DEFAULT, TEXT_SPACING)).x
	if (bounds.width < textWidth) Then bounds.width = textWidth

	' Update control
	'----------------------------------
	if ((state <> GUI_STATE_DISABLED) andalso Not guiLocked) Then

		Dim As Vector2 mousePointeger = GetMousePosition()

		' Check checkbox state
		if (CheckCollisionPointRec(mousePointeger, bounds)) Then

			if (IsMouseButtonDown(MOUSE_LEFT_BUTTON)) Then
				state = GUI_STATE_PRESSED
			else
				state = GUI_STATE_FOCUSED
			EndIf

			if (IsMouseButtonReleased(MOUSE_LEFT_BUTTON)) Then pressed = true
		EndIf
	EndIf
	'----------------------------------

	' Draw control
	'----------------------------------
	GuiDrawText(text0, GetTextBounds(LABEL, bounds), GuiGetStyle(LABEL, TEXT_ALIGNMENT), Fade(GetColor(GuiGetStyle(LABEL, TEXT + (state*3))), guiAlpha))
	'----------------------------------

	return pressed
End Function

' Image button control, returns true when clicked
Function GuiImageButton(bounds As Rectangle, text As Const zstring Ptr, texture as Texture2D ) As boolean

	return GuiImageButtonEx(bounds, text, texture, Rectangle( 0, 0, texture.width, texture.height ))
End Function

' Image button control, returns true when clicked
Function GuiImageButtonEx(bounds As Rectangle, text0 As Const zstring Ptr, texture as Texture2D , texSource as Rectangle ) As boolean

	Dim As GuiControlState state = guiState
	Dim As boolean clicked = false

	' Update control
	'----------------------------------
	if ((state <> GUI_STATE_DISABLED) andalso Not guiLocked) Then

		Dim As Vector2 mousePointeger = GetMousePosition()

		' Check button state
		if (CheckCollisionPointRec(mousePointeger, bounds)) Then

			if (IsMouseButtonDown(MOUSE_LEFT_BUTTON)) Then
				state = GUI_STATE_PRESSED
			elseif (IsMouseButtonReleased(MOUSE_LEFT_BUTTON)) Then
				clicked = true
			else
				state = GUI_STATE_FOCUSED
			EndIf
		EndIf
	EndIf
	'----------------------------------

	' Draw control
	'----------------------------------
	GuiDrawRectangle(bounds, GuiGetStyle(BUTTON, BORDER_WIDTH), Fade(GetColor(GuiGetStyle(BUTTON, BORDER + (state*3))), guiAlpha), Fade(GetColor(GuiGetStyle(BUTTON, BASE0 + (state*3))), guiAlpha))

	if (text0 <> NULL) Then GuiDrawText(text0, GetTextBounds(BUTTON, bounds), GuiGetStyle(BUTTON, TEXT_ALIGNMENT), Fade(GetColor(GuiGetStyle(BUTTON, TEXT + (state*3))), guiAlpha))
	if (texture.id > 0) Then DrawTextureRec(texture, texSource, Vector2(bounds.x + bounds.width/2 - texSource.width/2, bounds.y + bounds.height/2 - texSource.height/2 ), Fade(GetColor(GuiGetStyle(BUTTON, TEXT + (state*3))), guiAlpha))
	'---------------------------------=1

	return clicked
End function

' Toggle Button control, returns true when active
Function GuiToggle(bounds As Rectangle, text0 As Const zstring Ptr, active as boolean) As boolean

	Dim As GuiControlState state = guiState

	' Update control
	'----------------------------------
	if ((state <> GUI_STATE_DISABLED) andalso Not guiLocked) Then

		Dim As Vector2 mousePointeger = GetMousePosition()

		' Check toggle button state
		if (CheckCollisionPointRec(mousePointeger, bounds)) Then

			if (IsMouseButtonDown(MOUSE_LEFT_BUTTON)) Then
				state = GUI_STATE_PRESSED
			elseif (IsMouseButtonReleased(MOUSE_LEFT_BUTTON)) Then
				state = GUI_STATE_NORMAL
				active = Not active
			else
				state = GUI_STATE_FOCUSED
			EndIf
		EndIf
	EndIf
	'----------------------------------

	' Draw control
	'----------------------------------
	if (state = GUI_STATE_NORMAL) Then

		GuiDrawRectangle(bounds, GuiGetStyle(TOGGLE, BORDER_WIDTH), Fade(GetColor(GuiGetStyle(TOGGLE, iif(active, BORDER_COLOR_PRESSED , (BORDER + state*3)))), guiAlpha), Fade(GetColor(GuiGetStyle(TOGGLE, iif(active, BASE_COLOR_PRESSED , (BASE0 + state*3)))), guiAlpha))
		GuiDrawText(text0, GetTextBounds(TOGGLE, bounds), GuiGetStyle(TOGGLE, TEXT_ALIGNMENT), Fade(GetColor(GuiGetStyle(TOGGLE, iif(active, TEXT_COLOR_PRESSED , (TEXT + state*3)))), guiAlpha))
	else
		GuiDrawRectangle(bounds, GuiGetStyle(TOGGLE, BORDER_WIDTH), Fade(GetColor(GuiGetStyle(TOGGLE, BORDER + state*3)), guiAlpha), Fade(GetColor(GuiGetStyle(TOGGLE, BASE0 + state*3)), guiAlpha))
		GuiDrawText(text0, GetTextBounds(TOGGLE, bounds), GuiGetStyle(TOGGLE, TEXT_ALIGNMENT), Fade(GetColor(GuiGetStyle(TOGGLE, TEXT + state*3)), guiAlpha))
	EndIf
	'----------------------------------

	return active
End function

' Toggle Group control, returns toggled button index
Function GuiToggleGroup(bounds As Rectangle, text As Const zstring Ptr, active as long) As long

	#if  Not Defined(TOGGLEGROUP_MAX_ELEMENTS)
	#define TOGGLEGROUP_MAX_ELEMENTS    32
	#endif

	Dim As Single initBoundsX = bounds.x

	' Get substrings items from text (items pointegerers)
	Dim As long rows(TOGGLEGROUP_MAX_ELEMENTS)' =  (0 )
	Dim As long itemsCount = 0
	Dim As Const zstring Ptr Ptr items = GuiTextSplit(text, @itemsCount, @rows(0))

	Dim As long prevRow = rows(0)

	for i As long=0 To itemsCount-1'(long i = 0 i < itemsCount i+=1)

		if (prevRow <> rows(i)) Then

			bounds.x = initBoundsX
			bounds.y += (bounds.height + GuiGetStyle(TOGGLE, GROUP_PADDING))
			prevRow = rows(i)
		EndIf

		if (i = active) Then
			GuiToggle(bounds, @items[i][0], true)
		elseif (GuiToggle(bounds, @items[i][0], false) = true) Then
			active = i
		EndIf
		bounds.x += (bounds.width + GuiGetStyle(TOGGLE, GROUP_PADDING))
	Next

	return active
End function

' Check Box control, returns true when active
Function GuiCheckBox(bounds As Rectangle, text0 As Const zstring Ptr,checked as boolean) As boolean

	Dim As GuiControlState state = guiState

	Dim As Rectangle textBounds

	if (text0 <> NULL) Then

		textBounds.width = GetTextWidth(text0)
		textBounds.height = GuiGetStyle(DEFAULT, TEXT_SIZE)
		textBounds.x = bounds.x + bounds.width + GuiGetStyle(CHECKBOX, TEXT_PADDING)
		textBounds.y = bounds.y + bounds.height/2 - GuiGetStyle(DEFAULT, TEXT_SIZE)/2
		if (GuiGetStyle(CHECKBOX, TEXT_ALIGNMENT) = GUI_TEXT_ALIGN_LEFT) Then textBounds.x = bounds.x - textBounds.width - GuiGetStyle(CHECKBOX, TEXT_PADDING)
	EndIf

	' Update control
	'----------------------------------
	if ((state <> GUI_STATE_DISABLED) andalso Not guiLocked) then

		Dim As Vector2 mousePointeger = GetMousePosition()

		Dim As Rectangle totalBounds = Rectangle( _
		iif(GuiGetStyle(CHECKBOX, TEXT_ALIGNMENT) = GUI_TEXT_ALIGN_LEFT, textBounds.x , bounds.x), _
		bounds.y, _
		bounds.width + textBounds.width + GuiGetStyle(CHECKBOX, TEXT_PADDING), _
		bounds.height _
		)

		' Check checkbox state
		if (CheckCollisionPointRec(mousePointeger, totalBounds)) Then

			if (IsMouseButtonDown(MOUSE_LEFT_BUTTON)) Then
				state = GUI_STATE_PRESSED
			else
				state = GUI_STATE_FOCUSED
			EndIf
			if (IsMouseButtonReleased(MOUSE_LEFT_BUTTON)) Then checked = Not checked
		EndIf
	EndIf
	'----------------------------------

	' Draw control
	'----------------------------------
	GuiDrawRectangle(bounds, GuiGetStyle(CHECKBOX, BORDER_WIDTH), Fade(GetColor(GuiGetStyle(CHECKBOX, BORDER + (state*3))), guiAlpha), BLANK)

	if (checked) Then

		Dim As Rectangle check = Rectangle(bounds.x + GuiGetStyle(CHECKBOX, BORDER_WIDTH) + GuiGetStyle(CHECKBOX, CHECK_PADDING), _
		bounds.y + GuiGetStyle(CHECKBOX, BORDER_WIDTH) + GuiGetStyle(CHECKBOX, CHECK_PADDING), _
		bounds.width - 2*(GuiGetStyle(CHECKBOX, BORDER_WIDTH) + GuiGetStyle(CHECKBOX, CHECK_PADDING)), _
		bounds.height - 2*(GuiGetStyle(CHECKBOX, BORDER_WIDTH) + GuiGetStyle(CHECKBOX, CHECK_PADDING)) )
		GuiDrawRectangle(check, 0, BLANK, Fade(GetColor(GuiGetStyle(CHECKBOX, TEXT + state*3)), guiAlpha))
	EndIf

	if (text <> NULL) Then GuiDrawText(text0, textBounds, iif(GuiGetStyle(CHECKBOX, TEXT_ALIGNMENT) = GUI_TEXT_ALIGN_RIGHT, GUI_TEXT_ALIGN_LEFT , GUI_TEXT_ALIGN_RIGHT), Fade(GetColor(GuiGetStyle(LABEL, TEXT + (state*3))), guiAlpha))
	'----------------------------------

	return checked
End Function

' Combo Box control, returns selected item index
Function GuiComboBox(bounds As Rectangle, text0 As Const zstring Ptr, active as long) As long

	Dim As GuiControlState state = guiState

	bounds.width -= (GuiGetStyle(COMBOBOX, COMBO_BUTTON_WIDTH) + GuiGetStyle(COMBOBOX, COMBO_BUTTON_PADDING))

	Dim As Rectangle selector = Rectangle(bounds.x + bounds.width + GuiGetStyle(COMBOBOX, COMBO_BUTTON_PADDING), _
	bounds.y, GuiGetStyle(COMBOBOX, COMBO_BUTTON_WIDTH), bounds.height )

	' Get substrings items from text (items pointegerers, lengths and count)
	Dim As long itemsCount = 0
	dim As Const zstring Ptr Ptr items = GuiTextSplit(text0, @itemsCount, NULL)

	if (active < 0) Then
		active = 0
	elseif (active > itemsCount - 1) Then
		active = itemsCount - 1
	EndIf

	' Update control
	'----------------------------------
	if ((state <> GUI_STATE_DISABLED) andalso Not guiLocked andalso (itemsCount > 1)) Then

		Dim As Vector2 mousePointeger = GetMousePosition()

		if (CheckCollisionPointRec(mousePointeger, bounds) OrElse _
			CheckCollisionPointRec(mousePointeger, selector)) Then

			if (IsMouseButtonPressed(MOUSE_LEFT_BUTTON)) Then

				active += 1
				if (active >= itemsCount) Then active = 0
			EndIf

			if (IsMouseButtonDown(MOUSE_LEFT_BUTTON)) Then
				state = GUI_STATE_PRESSED
			else
				state = GUI_STATE_FOCUSED
			EndIf
		EndIf
	EndIf
	'----------------------------------

	' Draw control
	'----------------------------------
	' Draw combo box main
	GuiDrawRectangle(bounds, GuiGetStyle(COMBOBOX, BORDER_WIDTH), Fade(GetColor(GuiGetStyle(COMBOBOX, BORDER + (state*3))), guiAlpha), Fade(GetColor(GuiGetStyle(COMBOBOX, BASE0 + (state*3))), guiAlpha))
	GuiDrawText(@items[active][0], GetTextBounds(COMBOBOX, bounds), GuiGetStyle(COMBOBOX, TEXT_ALIGNMENT), Fade(GetColor(GuiGetStyle(COMBOBOX, TEXT + (state*3))), guiAlpha))

	' Draw selector using a custom button
	' NOTE: BORDER_WIDTH and TEXT_ALIGNMENT forced values
	Dim As long tempBorderWidth = GuiGetStyle(BUTTON, BORDER_WIDTH)
	Dim As long tempTextAlign = GuiGetStyle(BUTTON, TEXT_ALIGNMENT)
	GuiSetStyle(BUTTON, BORDER_WIDTH, 1)
	GuiSetStyle(BUTTON, TEXT_ALIGNMENT, GUI_TEXT_ALIGN_CENTER)

	GuiButton(selector, TextFormat(!"%i/%i", active + 1, itemsCount))

	GuiSetStyle(BUTTON, TEXT_ALIGNMENT, tempTextAlign)
	GuiSetStyle(BUTTON, BORDER_WIDTH, tempBorderWidth)
	'----------------------------------

	return active
End Function

' Dropdown Box control
' NOTE: Returns mouse click
Function GuiDropdownBox(bounds As Rectangle, text0 As Const zstring Ptr, active0 as long ptr, editMode as boolean) As boolean

	Dim As GuiControlState state = guiState
	Dim As long itemSelected = *active0
	Dim As long itemFocused = -1

	' Get substrings items from text (items pointegerers, lengths and count)
	Dim As long itemsCount = 0
	Dim As Const ZString Ptr Ptr items = GuiTextSplit(text0, @itemsCount, NULL)

	Dim As Rectangle boundsOpen = bounds
	boundsOpen.height = (itemsCount + 1)*(bounds.height + GuiGetStyle(DROPDOWNBOX, DROPDOWN_ITEMS_PADDING))

	Dim As Rectangle itemBounds = bounds

	Dim As boolean pressed = false       ' Check mouse button pressed

	' Update control
	'----------------------------------
	if ((state <> GUI_STATE_DISABLED) andalso not guiLocked AndAlso (itemsCount > 1)) Then

		Dim As Vector2 mousePointeger = GetMousePosition()

		if (editMode) Then

			state = GUI_STATE_PRESSED

			' Check if mouse has been pressed or released outside limits
			if (Not CheckCollisionPointRec(mousePointeger, boundsOpen)) Then

				if (IsMouseButtonPressed(MOUSE_LEFT_BUTTON) OrElse IsMouseButtonReleased(MOUSE_LEFT_BUTTON)) Then pressed = true
			EndIf

			' Check if already selected item has been pressed again
			if (CheckCollisionPointRec(mousePointeger, bounds) AndAlso IsMouseButtonPressed(MOUSE_LEFT_BUTTON)) Then pressed = true

			' Check focused and selected item
			for i As long=0 To itemsCount-1

				' Update item rectangle y position for next item
				itemBounds.y += (bounds.height + GuiGetStyle(DROPDOWNBOX, DROPDOWN_ITEMS_PADDING))

				if (CheckCollisionPointRec(mousePointeger, itemBounds)) Then

					itemFocused = i
					if (IsMouseButtonReleased(MOUSE_LEFT_BUTTON)) Then

						itemSelected = i
						pressed = true     ' Item selected, change to editMode = false
					EndIf
					Exit For
				EndIf
			Next

			itemBounds = bounds
		else

			if (CheckCollisionPointRec(mousePointeger, bounds)) Then

				if (IsMouseButtonPressed(MOUSE_LEFT_BUTTON)) Then

					pressed = true
					state = GUI_STATE_PRESSED

				else
					state = GUI_STATE_FOCUSED
				EndIf
			EndIf
		EndIf
	endif
	'----------------------------------

	' Draw control
	'----------------------------------
	if (editMode) Then GuiPanel(boundsOpen)

	GuiDrawRectangle(bounds, GuiGetStyle(DROPDOWNBOX, BORDER_WIDTH), Fade(GetColor(GuiGetStyle(DROPDOWNBOX, BORDER + state*3)), guiAlpha), Fade(GetColor(GuiGetStyle(DROPDOWNBOX, BASE0 + state*3)), guiAlpha))
	GuiDrawText(items[itemSelected], GetTextBounds(DEFAULT, bounds), GuiGetStyle(DROPDOWNBOX, TEXT_ALIGNMENT), Fade(GetColor(GuiGetStyle(DROPDOWNBOX, TEXT + state*3)), guiAlpha))

	if (editMode) Then

		' Draw visible items
		for i As long=0 To itemsCount-1

			' Update item rectangle y position for next item
			itemBounds.y += (bounds.height + GuiGetStyle(DROPDOWNBOX, DROPDOWN_ITEMS_PADDING))

			if (i = itemSelected) then

				GuiDrawRectangle(itemBounds, GuiGetStyle(DROPDOWNBOX, BORDER_WIDTH), Fade(GetColor(GuiGetStyle(DROPDOWNBOX, BORDER_COLOR_PRESSED)), guiAlpha), Fade(GetColor(GuiGetStyle(DROPDOWNBOX, BASE_COLOR_PRESSED)), guiAlpha))
				GuiDrawText(items[i], GetTextBounds(DEFAULT, itemBounds), GuiGetStyle(DROPDOWNBOX, TEXT_ALIGNMENT), Fade(GetColor(GuiGetStyle(DROPDOWNBOX, TEXT_COLOR_PRESSED)), guiAlpha))

			elseif (i = itemFocused) Then

				GuiDrawRectangle(itemBounds, GuiGetStyle(DROPDOWNBOX, BORDER_WIDTH), Fade(GetColor(GuiGetStyle(DROPDOWNBOX, BORDER_COLOR_FOCUSED)), guiAlpha), Fade(GetColor(GuiGetStyle(DROPDOWNBOX, BASE_COLOR_FOCUSED)), guiAlpha))
				GuiDrawText(items[i], GetTextBounds(DEFAULT, itemBounds), GuiGetStyle(DROPDOWNBOX, TEXT_ALIGNMENT), Fade(GetColor(GuiGetStyle(DROPDOWNBOX, TEXT_COLOR_FOCUSED)), guiAlpha))

			else
				GuiDrawText(items[i], GetTextBounds(DEFAULT, itemBounds), GuiGetStyle(DROPDOWNBOX, TEXT_ALIGNMENT), Fade(GetColor(GuiGetStyle(DROPDOWNBOX, TEXT_COLOR_NORMAL)), guiAlpha))
			EndIf
		Next
	EndIf

	' TODO: Asub this function, use icon instead or 'v'
	DrawTriangle(Vector2( bounds.x + bounds.width - GuiGetStyle(DROPDOWNBOX, ARROW_PADDING), bounds.y + bounds.height/2 - 2 ), _
	Vector2( bounds.x + bounds.width - GuiGetStyle(DROPDOWNBOX, ARROW_PADDING) + 5, bounds.y + bounds.height/2 - 2 + 5 ), _
	Vector2( bounds.x + bounds.width - GuiGetStyle(DROPDOWNBOX, ARROW_PADDING) + 10, bounds.y + bounds.height/2 - 2 ),_
	Fade(GetColor(GuiGetStyle(DROPDOWNBOX, TEXT + (state*3))), guiAlpha))

	'GuiDrawText("v", RAYGUI_CLITERAL(Rectangle) bounds.x + bounds.width - GuiGetStyle(DROPDOWNBOX, ARROW_PADDING), bounds.y + bounds.height/2 - 2, 10, 10 },
	'            GUI_TEXT_ALIGN_CENTER, Fade(GetColor(GuiGetStyle(DROPDOWNBOX, TEXT + (state*3))), guiAlpha))
	'----------------------------------

	*active0 = itemSelected
	return pressed
End function

' Text Box control, updates input text
' NOTE 1: Requires static variables: framesCounter
' NOTE 2: Returns if KEY_ENTER pressed (useful for data validation)
'Function GuiTextBox(bounds As Rectangle, text0 as zstring Ptr, textSize as long, editMode as boolean) As boolean
'	Static As long framesCounter = 0           ' Required for blinking cursor
'
'	Dim As GuiControlState state = guiState
'	Dim As boolean pressed = false
'
'	Dim As Rectangle cursor = Rectangle( _
'  	bounds.x + GuiGetStyle(TEXTBOX, TEXT_PADDING) + GetTextWidth(text0) + 2, _
'  	bounds.y + bounds.height/2 - GuiGetStyle(DEFAULT, TEXT_SIZE), _
'  	1, _
'  	GuiGetStyle(DEFAULT, TEXT_SIZE)*2 )
'
'	' Update control
'	'----------------------------------
'	if ((state <> GUI_STATE_DISABLED) andalso not guiLocked) Then
'		Dim As Vector2 mousePointeger = GetMousePosition()
'
'		if (editMode) Then
'			state = GUI_STATE_PRESSED
'			framesCounter+=1
'
'			Dim As long key = GetCharPressed()      ' Returns codepointeger as Unicode
'			Dim As long keyCount = len( *text0 )'strlen(text0)
'
'			' Only allow keys in range [32..125]
'			if (keyCount < (textSize - 1)) Then
'				Dim As long maxWidth = (bounds.width - (GuiGetStyle(TEXTBOX, TEXT_INNER_PADDING)*2))
'
'				if ((GetTextWidth(text0) < (maxWidth - GuiGetStyle(DEFAULT, TEXT_SIZE))) AndAlso (key >= 32)) Then
'					dim As long byteLength = 0
'					dim As const zstring ptr textUtf8 = CodepointToUtf8( key, @byteLength )
'
'					for i As long=0 To byteLength-1
'						text0[keyCount] = textUtf8[i]
'						keyCount+=1
'					Next
'
'					text0[keyCount] = 0'!"\0"
'				End If
'			End If
'
'			' Delete text
'			if (keyCount > 0) Then
'				if (IsKeyPressed(KEY_BACKSPACE)) Then
'					keyCount-=1
'					text0[keyCount] = 0'!"\0"
'					framesCounter = 0
'					if (keyCount < 0) Then keyCount = 0
'
'				elseif (IsKeyDown(KEY_BACKSPACE)) Then
'					if ((framesCounter > TEXTEDIT_CURSOR_BLINK_FRAMES) AndAlso (framesCounter mod 2) = 0) Then keyCount-=1
'					text0[keyCount] = 0'!"\0"
'					if (keyCount < 0) Then keyCount = 0
'				EndIf
'			EndIf
'
'			if (IsKeyPressed(KEY_ENTER) OrElse (Not CheckCollisionPointRec(mousePointeger, bounds) AndAlso IsMouseButtonPressed(MOUSE_LEFT_BUTTON))) Then pressed = true
'
'			' Check text alignment to position cursor properly
'			Dim As long textAlignment = GuiGetStyle(TEXTBOX, TEXT_ALIGNMENT)
'			if (textAlignment = GUI_TEXT_ALIGN_CENTER) then
'				cursor.x = bounds.x + GetTextWidth(text0)/2 + bounds.width/2 + 1
'			elseif (textAlignment = GUI_TEXT_ALIGN_RIGHT) Then
'				cursor.x = bounds.x + bounds.width - GuiGetStyle(TEXTBOX, TEXT_INNER_PADDING)
'			EndIf
'		else
'			if (CheckCollisionPointRec(mousePointeger, bounds)) Then
'				state = GUI_STATE_FOCUSED
'				if (IsMouseButtonPressed(MOUSE_LEFT_BUTTON)) Then pressed = true
'			EndIf
'		EndIf
'
'		if (pressed) Then framesCounter = 0
'	EndIf
'	'----------------------------------
'
'	' Draw control
'	'----------------------------------
'	if (state = GUI_STATE_PRESSED) Then
'
'		GuiDrawRectangle(bounds, GuiGetStyle(TEXTBOX, BORDER_WIDTH), Fade(GetColor(GuiGetStyle(TEXTBOX, BORDER + (state*3))), guiAlpha), Fade(GetColor(GuiGetStyle(TEXTBOX, BASE_COLOR_PRESSED)), guiAlpha))
'
'		' Draw blinking cursor
'		if (editMode AndAlso ((framesCounter/20) mod 2 = 0)) Then GuiDrawRectangle(cursor, 0, BLANK, Fade(GetColor(GuiGetStyle(TEXTBOX, BORDER_COLOR_PRESSED)), guiAlpha))
'
'	elseif (state = GUI_STATE_DISABLED) Then
'
'		GuiDrawRectangle(bounds, GuiGetStyle(TEXTBOX, BORDER_WIDTH), Fade(GetColor(GuiGetStyle(TEXTBOX, BORDER + (state*3))), guiAlpha), Fade(GetColor(GuiGetStyle(TEXTBOX, BASE_COLOR_DISABLED)), guiAlpha))
'
'	else
'		GuiDrawRectangle(bounds, 1, Fade(GetColor(GuiGetStyle(TEXTBOX, BORDER + (state*3))), guiAlpha), BLANK)
'	EndIf
'	GuiDrawText(text0, GetTextBounds(TEXTBOX, bounds), GuiGetStyle(TEXTBOX, TEXT_ALIGNMENT), Fade(GetColor(GuiGetStyle(TEXTBOX, TEXT + (state*3))), guiAlpha))
'	'----------------------------------
'
'	return pressed
'End function

function GuiTextBox( bounds as Rectangle, text_ as string, textSize as long, editMode as boolean ) as boolean
	static as long framesCounter = 0           '' Required for blinking cursor

	dim as GuiControlState state = guiState
	dim as boolean pressed = false

	dim as Rectangle cursor = Rectangle( _
	bounds.x + GuiGetStyle( TEXTBOX, TEXT_PADDING ) + GetTextWidth( text_ ) + 2, _
	bounds.y + bounds.height / 2 - GuiGetStyle( DEFAULT, TEXT_SIZE ), _
	1, _
	GuiGetStyle( DEFAULT, TEXT_SIZE ) * 2 )

	'' Update
	if( ( state <> GUI_STATE_DISABLED ) andAlso not guiLocked ) then
		dim as Vector2 mousePointeger = GetMousePosition()

		if( editMode ) then
			state = GUI_STATE_PRESSED
			framesCounter += 1

			dim as long key = GetCharPressed()      '' Returns codepointeger as Unicode
			dim as long keyCount = iif( len( text_ ), strlen( text_ ), 0 )

			'' Only allow keys in range [32..125]
			if( keyCount < ( textSize - 1 ) ) then
				dim as long maxWidth = ( bounds.width - ( GuiGetStyle( TEXTBOX, TEXT_INNER_PADDING ) * 2 ) )

				if( ( GetTextWidth( text_ ) < ( maxWidth - GuiGetStyle( DEFAULT, TEXT_SIZE ) ) ) andAlso ( key >= 32 ) ) then
					dim as long byteLength = 0
					dim as const zstring ptr textUtf8 = CodepointToUtf8( key, @byteLength )

					text_ += space( byteLength )

					for i As integer = 0 To byteLength - 1
						text_[ keyCount ] = textUtf8[ i ]
						keyCount += 1
					next
				end if
			end if

			'' Delete text
			if( keyCount > 0 ) then
				if( IsKeyPressed( KEY_BACKSPACE ) ) then
					keyCount -= 1
					text_ = left( text_, keyCount )
					framesCounter = 0

					if( keyCount < 0 ) then keyCount = 0
				elseif( IsKeyDown( KEY_BACKSPACE ) ) then
					if( ( framesCounter > TEXTEDIT_CURSOR_BLINK_FRAMES ) andAlso ( framesCounter mod 2 ) = 0 ) then
						keyCount -= 1
					end if

					text_ = left( text_, keyCount )
					if( keyCount < 0 ) then keyCount = 0
				endif
			endif

			if( IsKeyPressed( KEY_ENTER ) orElse ( not CheckCollisionPointRec( mousePointeger, bounds ) andAlso IsMouseButtonPressed( MOUSE_LEFT_BUTTON ) ) ) then
				pressed = true
			end if

			' Check text alignment to position cursor properly
			dim As long textAlignment = GuiGetStyle( TEXTBOX, TEXT_ALIGNMENT )

			if( textAlignment = GUI_TEXT_ALIGN_CENTER ) then
				cursor.x = bounds.x + GetTextWidth( text_ ) / 2 + bounds.width / 2 + 1
			elseif( textAlignment = GUI_TEXT_ALIGN_RIGHT ) then
				cursor.x = bounds.x + bounds.width - GuiGetStyle( TEXTBOX, TEXT_INNER_PADDING )
			endif
		else
			if( CheckCollisionPointRec( mousePointeger, bounds ) ) then
				state = GUI_STATE_FOCUSED
				if( IsMouseButtonPressed( MOUSE_LEFT_BUTTON ) ) then pressed = true
			endif
		endif

		if( pressed ) then framesCounter = 0
	endif

	'' Draw
	if( state = GUI_STATE_PRESSED ) then
		GuiDrawRectangle( bounds, GuiGetStyle( TEXTBOX, BORDER_WIDTH ), Fade( GetColor( GuiGetStyle( TEXTBOX, BORDER + ( state * 3 ) ) ), guiAlpha ), Fade( GetColor( GuiGetStyle( TEXTBOX, BASE_COLOR_PRESSED ) ), guiAlpha ) )

		' Draw blinking cursor
		if( editMode andAlso ( ( framesCounter / 20 ) mod 2 = 0 ) ) then
			GuiDrawRectangle( cursor, 0, BLANK, Fade( GetColor( GuiGetStyle( TEXTBOX, BORDER_COLOR_PRESSED ) ), guiAlpha ) )
		end if
	elseif( state = GUI_STATE_DISABLED ) then
		GuiDrawRectangle( bounds, GuiGetStyle( TEXTBOX, BORDER_WIDTH ), Fade( GetColor( GuiGetStyle( TEXTBOX, BORDER + ( state * 3 ) ) ), guiAlpha ), Fade( GetColor( GuiGetStyle( TEXTBOX, BASE_COLOR_DISABLED ) ), guiAlpha ) )
	else
		GuiDrawRectangle( bounds, 1, Fade( GetColor( GuiGetStyle( TEXTBOX, BORDER + ( state * 3 ) ) ), guiAlpha ), BLANK )
	EndIf

	GuiDrawText( text_, GetTextBounds( TEXTBOX, bounds ), GuiGetStyle( TEXTBOX, TEXT_ALIGNMENT ), Fade( GetColor( GuiGetStyle( TEXTBOX, TEXT + ( state * 3 ) ) ), guiAlpha ) )

	return( pressed )
end function

' Spinner control, returns selected value
Function GuiSpinner(bounds As Rectangle, text0 As Const zstring Ptr, value as long Ptr, minValue as long, maxValue as long, editMode as boolean) As boolean

	Dim As GuiControlState state = guiState

	Dim As boolean pressed = false
	Dim As long tempValue = *value

	Dim As Rectangle spinner0 =  Rectangle(bounds.x + GuiGetStyle(SPINNER, SPIN_BUTTON_WIDTH) + GuiGetStyle(SPINNER, SPIN_BUTTON_PADDING), bounds.y, _
	bounds.width - 2*(GuiGetStyle(SPINNER, SPIN_BUTTON_WIDTH) + GuiGetStyle(SPINNER, SPIN_BUTTON_PADDING)), bounds.height )
	Dim As Rectangle leftButtonBound =  Rectangle(bounds.x, bounds.y, GuiGetStyle(SPINNER, SPIN_BUTTON_WIDTH), bounds.height )
	'Dim As Rectangle rightButtonBound =  Rectangle(bounds.x + bounds.width - GuiGetStyle(SPINNER, SPIN_BUTTON_WIDTH), bounds.y, GuiGetStyle(SPINNER, SPIN_BUTTON_WIDTH), bounds.height )
	'hack
	Dim As Rectangle rightButtonBound =  Rectangle(bounds.x + bounds.width - GuiGetStyle(SPINNER, SPIN_BUTTON_WIDTH), bounds.y, GuiGetStyle(SPINNER, SPIN_BUTTON_WIDTH), bounds.height )

	Dim As Rectangle textBounds
	if (text0 <> NULL) Then

		textBounds.width = GetTextWidth(text0)
		textBounds.height = GuiGetStyle(DEFAULT, TEXT_SIZE)
		textBounds.x = bounds.x + bounds.width + GuiGetStyle(SPINNER, TEXT_PADDING)
		textBounds.y = bounds.y + bounds.height/2 - GuiGetStyle(DEFAULT, TEXT_SIZE)/2
		if (GuiGetStyle(SPINNER, TEXT_ALIGNMENT) = GUI_TEXT_ALIGN_LEFT) Then textBounds.x = bounds.x - textBounds.width - GuiGetStyle(SPINNER, TEXT_PADDING)
	EndIf

	' Update control
	'----------------------------------
	if ((state <> GUI_STATE_DISABLED) andalso not guiLocked) Then

		Dim As Vector2 mousePointeger = GetMousePosition()

		' Check spinner state
		if (CheckCollisionPointRec(mousePointeger, bounds)) Then

			if (IsMouseButtonDown(MOUSE_LEFT_BUTTON)) Then
				state = GUI_STATE_PRESSED

			else
				state = GUI_STATE_FOCUSED
			EndIf
		EndIf
	EndIf

	if (Not editMode) Then

		if (tempValue < minValue) Then tempValue = minValue
		if (tempValue > maxValue) Then tempValue = maxValue
	EndIf
	'----------------------------------

	' Draw control
	'----------------------------------
	' TODO: Set Spinner properties for ValueBox
	pressed = GuiValueBox(spinner0, NULL, @tempValue, minValue, maxValue, editMode)

	' Draw value selector custom buttons
	' NOTE: BORDER_WIDTH and TEXT_ALIGNMENT forced values
	Dim As long tempBorderWidth = GuiGetStyle(BUTTON, BORDER_WIDTH)
	Dim As long tempTextAlign = GuiGetStyle(BUTTON, TEXT_ALIGNMENT)
	GuiSetStyle(BUTTON, BORDER_WIDTH, GuiGetStyle(SPINNER, BORDER_WIDTH))
	GuiSetStyle(BUTTON, TEXT_ALIGNMENT, GUI_TEXT_ALIGN_CENTER)

	#if defined(RAYGUI_SUPPORT_ICONS)
	'hack
	GuiSetStyle(BUTTON, TEXT_ALIGNMENT, GUI_TEXT_ALIGN_LEFT)
	if (GuiButton(leftButtonBound, GuiIconText(RICON_ARROW_LEFT_FILL, NULL))) Then tempValue-=1
	'hack
	GuiSetStyle(BUTTON, TEXT_ALIGNMENT, GUI_TEXT_ALIGN_LEFT)
	if (GuiButton(rightButtonBound, GuiIconText(RICON_ARROW_RIGHT_FILL, NULL))) Then tempValue+=1
	'hack
	GuiSetStyle(BUTTON, TEXT_ALIGNMENT, GUI_TEXT_ALIGN_CENTER)
	#else
	if (GuiButton(leftButtonBound, @"<")) Then tempValue-=1
	if (GuiButton(rightButtonBound, @">")) Then tempValue+=1
	#endif

	GuiSetStyle(BUTTON, TEXT_ALIGNMENT, tempTextAlign)
	GuiSetStyle(BUTTON, BORDER_WIDTH, tempBorderWidth)

	' Draw text label if provided
	if (text0 <> NULL) Then GuiDrawText(text0, textBounds, iif(GuiGetStyle(SPINNER, TEXT_ALIGNMENT) = GUI_TEXT_ALIGN_RIGHT, GUI_TEXT_ALIGN_LEFT , GUI_TEXT_ALIGN_RIGHT), Fade(GetColor(GuiGetStyle(LABEL, TEXT + (state*3))), guiAlpha))
	'----------------------------------

	*value = tempValue
	return pressed
End function

' Value Box control, updates input text with numbers
' NOTE: Requires static variables: framesCounter
'Function GuiValueBox(bounds As Rectangle, text0 As Const zstring Ptr, value as long Ptr, minValue as long, maxValue as long, editMode as boolean) As boolean
'
'	#if Not Defined(VALUEBOX_MAX_CHARS)
'	#define VALUEBOX_MAX_CHARS  32
'	#endif
'
'	static As long framesCounter = 0           ' Required for blinking cursor
'
'	Dim As GuiControlState state = guiState
'	Dim As boolean pressed = false
'
'	'Dim As Byte textValue(VALUEBOX_MAX_CHARS + 1) '= 0'"\0"
'	'hack
'	Dim As ZString*(VALUEBOX_MAX_CHARS + 1) textValue '= 0'"\0"
'	sprintf(@textValue, "%i", *value)
'
'	Dim As Rectangle textBounds
'
'	if (text0 <> NULL) Then
'		textBounds.width = GetTextWidth(text0)
'		textBounds.height = GuiGetStyle(DEFAULT, TEXT_SIZE)
'		textBounds.x = bounds.x + bounds.width + GuiGetStyle(VALUEBOX, TEXT_PADDING)
'		textBounds.y = bounds.y + bounds.height/2 - GuiGetStyle(DEFAULT, TEXT_SIZE)/2
'		if (GuiGetStyle(VALUEBOX, TEXT_ALIGNMENT) = GUI_TEXT_ALIGN_LEFT) Then textBounds.x = bounds.x - textBounds.width - GuiGetStyle(VALUEBOX, TEXT_PADDING)
'	EndIf
'
'	' Update control
'	'----------------------------------
'	if ((state <> GUI_STATE_DISABLED) andalso not guiLocked) Then
'		Dim As Vector2 mousePointeger = GetMousePosition()
'
'		Dim As boolean valueHasChanged = false
'
'		if (editMode) Then
'			state = GUI_STATE_PRESSED
'
'			framesCounter+=1
'
'			Dim As long keyCount = strlen(textValue)
'
'			' Only allow keys in range [48..57]
'			if (keyCount < VALUEBOX_MAX_CHARS) Then
'
'				Dim As long maxWidth = bounds.width
'				if (GetTextWidth(textValue) < maxWidth) Then
'
'					Dim As long key = GetCharPressed()
'					if ((key >= 48) AndAlso (key <= 57)) Then
'
'						textValue[keyCount] = key
'						keyCount+=1
'						valueHasChanged = true
'					EndIf
'				EndIf
'			endif
'
'			' Delete text
'			if (keyCount > 0) Then
'
'				if (IsKeyPressed(KEY_BACKSPACE)) Then
'					keyCount-=1
'					if (keyCount < 0) Then keyCount = 0
'					textValue[keyCount] = 0''\0'
'					framesCounter = 0
'					valueHasChanged = true
'
'				elseif (IsKeyDown(KEY_BACKSPACE)) Then
'					if ((framesCounter > TEXTEDIT_CURSOR_BLINK_FRAMES) AndAlso (framesCounter mod 2) = 0) Then keyCount-=1
'					if (keyCount < 0) Then keyCount = 0
'					textValue[keyCount] = 0'asc(!"\0")
'					valueHasChanged = true
'				EndIf
'			EndIf
'
'			'if (valueHasChanged) Then *value = TextToInteger(@textValue[0])
'			'hack
'			if (valueHasChanged) Then
'				*value = TextToInteger(@textValue[0])
'				if (*value > maxValue) Then
'					*value = maxValue
'				ElseIf (*value < minValue) Then
'					*value = minValue
'				EndIf
'			EndIf
'
'			if (IsKeyPressed(KEY_ENTER) OrElse ( Not CheckCollisionPointRec(mousePointeger, bounds) AndAlso IsMouseButtonPressed(MOUSE_LEFT_BUTTON))) Then pressed = true
'		else
'			if (*value > maxValue) Then
'				*value = maxValue
'			elseif (*value < minValue) Then
'				*value = minValue
'			EndIf
'
'			if (CheckCollisionPointRec(mousePointeger, bounds)) Then
'
'				state = GUI_STATE_FOCUSED
'				if (IsMouseButtonPressed(MOUSE_LEFT_BUTTON)) Then pressed = true
'			EndIf
'		EndIf
'
'		if (pressed) Then framesCounter = 0
'	endif
'	'----------------------------------
'
'	' Draw control
'	'----------------------------------
'	Dim As Color baseColor = BLANK
'	if (state = GUI_STATE_PRESSED) Then
'		baseColor = GetColor(GuiGetStyle(VALUEBOX, BASE_COLOR_PRESSED))
'	ElseIf (state = GUI_STATE_DISABLED) Then
'		baseColor = GetColor(GuiGetStyle(VALUEBOX, BASE_COLOR_DISABLED))
'	EndIf
'	' WARNING: BLANK color does not work properly with Fade()
'	GuiDrawRectangle(bounds, GuiGetStyle(VALUEBOX, BORDER_WIDTH), Fade(GetColor(GuiGetStyle(VALUEBOX, BORDER + (state*3))), guiAlpha), baseColor)
'	GuiDrawText(textValue, GetTextBounds(VALUEBOX, bounds), GUI_TEXT_ALIGN_CENTER, Fade(GetColor(GuiGetStyle(VALUEBOX, TEXT + (state*3))), guiAlpha))
'
'	' Draw blinking cursor
'	if ((state = GUI_STATE_PRESSED) andalso (editMode AndAlso ((framesCounter/20) mod 2 = 0))) Then
'
'		' NOTE: ValueBox integerernal text is always centered
'		Dim As Rectangle cursor =  Rectangle(bounds.x + GetTextWidth(textValue)/2 + bounds.width/2 + 2, bounds.y + 2*GuiGetStyle(VALUEBOX, BORDER_WIDTH), 1, bounds.height - 4*GuiGetStyle(VALUEBOX, BORDER_WIDTH) )
'		GuiDrawRectangle(cursor, 0, BLANK, Fade(GetColor(GuiGetStyle(VALUEBOX, BORDER_COLOR_PRESSED)), guiAlpha))
'	EndIf
'
'	' Draw text label if provided
'	if (text0 <> NULL) Then GuiDrawText(text0, textBounds, iif(GuiGetStyle(VALUEBOX, TEXT_ALIGNMENT) = GUI_TEXT_ALIGN_RIGHT, GUI_TEXT_ALIGN_LEFT , GUI_TEXT_ALIGN_RIGHT), Fade(GetColor(GuiGetStyle(LABEL, TEXT + (state*3))), guiAlpha))
'	'----------------------------------
'
'	return pressed
'End function

Function GuiValueBox(bounds As Rectangle, text0 As Const zstring Ptr, value as long Ptr, minValue as long, maxValue as long, editMode as boolean) As boolean
	#if Not Defined(VALUEBOX_MAX_CHARS)
	#define VALUEBOX_MAX_CHARS  32
	#endif

	static As long framesCounter = 0           ' Required for blinking cursor

	Dim As GuiControlState state = guiState
	Dim As boolean pressed = false

	Dim As string textValue
	textValue = str( *value )

	Dim As Rectangle textBounds

	if (text0 <> NULL) Then
		textBounds.width = GetTextWidth(text0)
		textBounds.height = GuiGetStyle(DEFAULT, TEXT_SIZE)
		textBounds.x = bounds.x + bounds.width + GuiGetStyle(VALUEBOX, TEXT_PADDING)
		textBounds.y = bounds.y + bounds.height/2 - GuiGetStyle(DEFAULT, TEXT_SIZE)/2
		if (GuiGetStyle(VALUEBOX, TEXT_ALIGNMENT) = GUI_TEXT_ALIGN_LEFT) Then textBounds.x = bounds.x - textBounds.width - GuiGetStyle(VALUEBOX, TEXT_PADDING)
	EndIf

	' Update control
	'----------------------------------
	if ((state <> GUI_STATE_DISABLED) andalso not guiLocked) Then
		Dim As Vector2 mousePointeger = GetMousePosition()

		Dim As boolean valueHasChanged = false

		if (editMode) Then
			state = GUI_STATE_PRESSED

			framesCounter+=1

			Dim As long keyCount = len(textValue)

			' Only allow keys in range [48..57]
			if (keyCount < VALUEBOX_MAX_CHARS) Then
				Dim As long maxWidth = bounds.width
				if (GetTextWidth(textValue) < maxWidth) Then
					Dim As long key = GetCharPressed()
					if ((key >= 48) AndAlso (key <= 57)) Then
						textValue += chr( key )
						keyCount+=1
						valueHasChanged = true
					EndIf
				EndIf
			endif

			' Delete text
			if (keyCount > 0) Then
				if (IsKeyPressed(KEY_BACKSPACE)) Then
					keyCount-=1
					if (keyCount < 0) Then keyCount = 0
					textValue = left( textValue, keyCount )
					framesCounter = 0
					valueHasChanged = true
				elseif (IsKeyDown(KEY_BACKSPACE)) Then
					if ((framesCounter > TEXTEDIT_CURSOR_BLINK_FRAMES) AndAlso (framesCounter mod 2) = 0) Then keyCount-=1
					if (keyCount < 0) Then keyCount = 0
					textValue = left( textValue, keyCount )
					valueHasChanged = true
				EndIf
			EndIf

			if (valueHasChanged) Then
				*value = clng( val( textValue ) )
				if (*value > maxValue) Then
					*value = maxValue
				ElseIf (*value < minValue) Then
					*value = minValue
				EndIf
			EndIf

			if (IsKeyPressed(KEY_ENTER) OrElse ( Not CheckCollisionPointRec(mousePointeger, bounds) AndAlso IsMouseButtonPressed(MOUSE_LEFT_BUTTON))) Then
				pressed = true
			elseif (*value > maxValue) Then
				*value = maxValue
			elseif (*value < minValue) Then
				*value = minValue
			EndIf

			if (CheckCollisionPointRec(mousePointeger, bounds)) Then
				state = GUI_STATE_FOCUSED
				if (IsMouseButtonPressed(MOUSE_LEFT_BUTTON)) Then pressed = true
			EndIf
		EndIf

		if (pressed) Then framesCounter = 0
	endif
	'----------------------------------

	' Draw control
	'----------------------------------
	Dim As Color baseColor = BLANK
	if (state = GUI_STATE_PRESSED) Then
		baseColor = GetColor(GuiGetStyle(VALUEBOX, BASE_COLOR_PRESSED))
	ElseIf (state = GUI_STATE_DISABLED) Then
		baseColor = GetColor(GuiGetStyle(VALUEBOX, BASE_COLOR_DISABLED))
	EndIf
	' WARNING: BLANK color does not work properly with Fade()
	GuiDrawRectangle(bounds, GuiGetStyle(VALUEBOX, BORDER_WIDTH), Fade(GetColor(GuiGetStyle(VALUEBOX, BORDER + (state*3))), guiAlpha), baseColor)
	GuiDrawText(textValue, GetTextBounds(VALUEBOX, bounds), GUI_TEXT_ALIGN_CENTER, Fade(GetColor(GuiGetStyle(VALUEBOX, TEXT + (state*3))), guiAlpha))

	' Draw blinking cursor
	if ((state = GUI_STATE_PRESSED) andalso (editMode AndAlso ((framesCounter/20) mod 2 = 0))) Then

		' NOTE: ValueBox integerernal text is always centered
		Dim As Rectangle cursor =  Rectangle(bounds.x + GetTextWidth(textValue)/2 + bounds.width/2 + 2, bounds.y + 2*GuiGetStyle(VALUEBOX, BORDER_WIDTH), 1, bounds.height - 4*GuiGetStyle(VALUEBOX, BORDER_WIDTH) )
		GuiDrawRectangle(cursor, 0, BLANK, Fade(GetColor(GuiGetStyle(VALUEBOX, BORDER_COLOR_PRESSED)), guiAlpha))
	EndIf

	' Draw text label if provided
	if (text0 <> NULL) Then GuiDrawText(text0, textBounds, iif(GuiGetStyle(VALUEBOX, TEXT_ALIGNMENT) = GUI_TEXT_ALIGN_RIGHT, GUI_TEXT_ALIGN_LEFT , GUI_TEXT_ALIGN_RIGHT), Fade(GetColor(GuiGetStyle(LABEL, TEXT + (state*3))), guiAlpha))
	'----------------------------------

	return pressed
End function

' Text Box control with multiple lines
'' TODO <paul>: fix cursor alignment issues
function GuiTextBoxMulti( bounds as Rectangle, text_ as string, textSize as long, editMode as boolean ) as boolean
	static as long framesCounter = 0           '' Required for blinking cursor

	dim as GuiControlState state = guiState
	dim as boolean pressed = false

	var textAreaBounds = Rectangle( _
	bounds.x + GuiGetStyle( TEXTBOX, TEXT_INNER_PADDING ), _
	bounds.y + GuiGetStyle( TEXTBOX, TEXT_INNER_PADDING ), _
	bounds.width - 2 * GuiGetStyle( TEXTBOX, TEXT_INNER_PADDING ), _
	bounds.height - 2 * GuiGetStyle( TEXTBOX, TEXT_INNER_PADDING ) )

	'' Cursor position, [x, y] values should be updated
	var cursor = Rectangle( 0, 0, 1, GuiGetStyle( DEFAULT, TEXT_SIZE ) + 2 )

	dim as long _
	textWidth = 0, _
	currentLine = 0

	'' Update control
	if( ( state <> GUI_STATE_DISABLED ) andAlso not guiLocked ) then
		dim as Vector2 mousePoint = GetMousePosition()
		if( editMode ) then
			state = GUI_STATE_PRESSED
			framesCounter += 1

			dim as long character = GetCharPressed()
			dim as long keyCount = len( text_ )'strlen( text_ )

			'' Introduce characters
			if( keyCount < ( textSize - 1 ) ) then
				dim as Vector2 textSize = MeasureTextEx( guiFont, text_, GuiGetStyle( DEFAULT, TEXT_SIZE ), GuiGetStyle( DEFAULT, TEXT_SPACING ) )

				if( textSize.y < ( textAreaBounds.height - GuiGetStyle( DEFAULT, TEXT_SIZE ) ) ) then
					if( IsKeyPressed( KEY_ENTER ) ) then
						'text_[ keyCount ] = asc( !"\n" )
						text_ += !"\n"
						keyCount += 1
					elseif( ( ( character >= 32 ) andAlso ( character < 255 ) ) ) then '' TODO: Support Unicode inputs
						'text_[ keyCount ] = character
						text_ += chr( character )
						keyCount += 1
					end if
				end if
			end if

			'' Delete characters
			if( keyCount > 0 ) then
				if( IsKeyPressed( KEY_BACKSPACE ) ) then
					keyCount -= 1
					'text_[ keyCount ] = asc( !"\0" )
					text_ = left( text_, keyCount )
					framesCounter = 0

					if( keyCount < 0 ) then keyCount = 0
				elseif( IsKeyDown( KEY_BACKSPACE ) ) then
					if( ( framesCounter > TEXTEDIT_CURSOR_BLINK_FRAMES ) andAlso ( framesCounter mod 2 ) = 0 ) then
						keyCount -= 1
					end if
					'text_[ keyCount ] = asc( !"\0" )
					text_ = left( text_, keyCount )
					if( keyCount < 0 ) then keyCount = 0
				end if
			end if

			'' Calculate cursor position considering text
			dim as ubyte oneCharText( 0 to 1 )
			dim as long lastBreakingPos = -1
			dim as long i

			do while( i < keyCount andAlso currentLine < keyCount )
				oneCharText( 0 ) = text_[ i ]
				textWidth += ( GetTextWidth( @oneCharText( 0 ) ) + GuiGetStyle( DEFAULT, TEXT_SPACING ) )

				if( text_[ i ] = asc( " " ) orElse text_[ i ] = asc( !"\n" ) ) then lastBreakingPos = i

				if( text_[ i ] = asc( !"\n" ) orElse textWidth >= textAreaBounds.width ) then
					currentLine += 1
					textWidth = 0

					if( lastBreakingPos > 0 ) then
						i = lastBreakingPos
					else
						textWidth += ( GetTextWidth( @oneCharText( 0 ) ) + GuiGetStyle( DEFAULT, TEXT_SPACING ) )
					end if

					lastBreakingPos = -1
				end if
				i += 1
			loop

			cursor.x = bounds.x + GuiGetStyle( TEXTBOX, BORDER_WIDTH ) + GuiGetStyle( TEXTBOX, TEXT_INNER_PADDING ) + textWidth - GuiGetStyle( DEFAULT, TEXT_SPACING )
			cursor.y = bounds.y + GuiGetStyle( TEXTBOX, BORDER_WIDTH ) + GuiGetStyle( TEXTBOX, TEXT_INNER_PADDING ) / 2 + ( ( GuiGetStyle( DEFAULT, TEXT_SIZE ) + GuiGetStyle( TEXTBOX, TEXT_INNER_PADDING ) ) * currentLine )

			'' Exit edit mode
			if( not CheckCollisionPointRec( mousePoint, bounds ) andAlso IsMouseButtonPressed( MOUSE_LEFT_BUTTON ) ) then
				pressed = true
			end if
		else
			if( CheckCollisionPointRec( mousePoint, bounds ) ) then
				state = GUI_STATE_FOCUSED
				if( IsMouseButtonPressed( MOUSE_LEFT_BUTTON ) ) then pressed = true
			end if
		end if

		if( pressed ) then framesCounter = 0     '' Reset blinking cursor
	end if

	'' Draw control
	if( state = GUI_STATE_PRESSED ) then
		GuiDrawRectangle( bounds, GuiGetStyle( TEXTBOX, BORDER_WIDTH ), Fade( GetColor( GuiGetStyle( TEXTBOX, BORDER + ( state * 3 ) ) ), guiAlpha ), Fade( GetColor( GuiGetStyle( TEXTBOX, BASE_COLOR_PRESSED ) ), guiAlpha ) )

		'' Draw blinking cursor
		if( editMode andAlso ( ( framesCounter / 20 ) mod 2 = 0 ) ) then
			GuiDrawRectangle( cursor, 0, BLANK, Fade( GetColor( GuiGetStyle( TEXTBOX, BORDER_COLOR_PRESSED ) ), guiAlpha ) )
		end if
	elseif( state = GUI_STATE_DISABLED ) then
		GuiDrawRectangle( bounds, GuiGetStyle( TEXTBOX, BORDER_WIDTH ), Fade( GetColor( GuiGetStyle( TEXTBOX, BORDER + ( state * 3 ) ) ), guiAlpha ), Fade( GetColor( GuiGetStyle( TEXTBOX, BASE_COLOR_DISABLED ) ), guiAlpha ) )
	else
		GuiDrawRectangle( bounds, 1, Fade( GetColor( GuiGetStyle( TEXTBOX, BORDER + ( state * 3 ) ) ), guiAlpha ), BLANK )
	end if

	DrawTextRec(guiFont, text_, textAreaBounds, GuiGetStyle(DEFAULT, TEXT_SIZE), GuiGetStyle(DEFAULT, TEXT_SPACING), true, Fade(GetColor(GuiGetStyle(TEXTBOX, TEXT + (state*3))), guiAlpha))

	return( pressed )
end function

' Slider control with pro parameters
' NOTE: Other GuiSlider*() controls use this one
Function GuiSliderPro(bounds As Rectangle, textLeft As Const zstring Ptr, textRight As Const zstring Ptr, value as Single, minValue as Single, maxValue as Single, sliderWidth As long ) As Single

	Dim As GuiControlState state = guiState

	Dim As long sliderValue = (((value - minValue)/(maxValue - minValue))*(bounds.width - 2*GuiGetStyle(SLIDER, BORDER_WIDTH)))

	Dim As Rectangle slider0 =  Rectangle(bounds.x, bounds.y + GuiGetStyle(SLIDER, BORDER_WIDTH) + GuiGetStyle(SLIDER, SLIDER_PADDING), _
	0, bounds.height - 2*GuiGetStyle(SLIDER, BORDER_WIDTH) - 2*GuiGetStyle(SLIDER, SLIDER_PADDING) )

	if (sliderWidth > 0) Then       ' Slider

		slider0.x += (sliderValue - sliderWidth/2)
		slider0.width = sliderWidth

	elseif (sliderWidth = 0) Then ' SliderBar

		slider0.x += GuiGetStyle(SLIDER, BORDER_WIDTH)
		slider0.width = sliderValue
	EndIf

	' Update control
	'----------------------------------
	if ((state <> GUI_STATE_DISABLED) andalso not guiLocked) Then

		Dim As Vector2 mousePointeger = GetMousePosition()

		if (CheckCollisionPointRec(mousePointeger, bounds)) Then

			if (IsMouseButtonDown(MOUSE_LEFT_BUTTON)) Then

				state = GUI_STATE_PRESSED

				' Get equivalent value and slider position from mousePointeger.x
				value = ((maxValue - minValue)*(mousePointeger.x - (bounds.x + sliderWidth/2)))/(bounds.width - sliderWidth) + minValue

				if (sliderWidth > 0) Then
					slider0.x = mousePointeger.x - slider0.width/2  ' Slider

				ElseIf (sliderWidth = 0) Then
					slider0.width = sliderValue          ' SliderBar
				EndIf
			else
				state = GUI_STATE_FOCUSED
			EndIf

			if (value > maxValue) Then
				value = maxValue

			elseif (value < minValue) Then
				value = minValue
			EndIf
		EndIf
	EndIf

	' Bar limits check
	if (sliderWidth > 0) Then       ' Slider

		if (slider0.x <= (bounds.x + GuiGetStyle(SLIDER, BORDER_WIDTH))) Then
			slider0.x = bounds.x + GuiGetStyle(SLIDER, BORDER_WIDTH)

		elseif ((slider0.x + slider0.width) >= (bounds.x + bounds.width)) Then
			slider0.x = bounds.x + bounds.width - slider0.width - GuiGetStyle(SLIDER, BORDER_WIDTH)
		EndIf

	elseif (sliderWidth = 0) Then ' SliderBar

		if (slider0.width > bounds.width) Then slider0.width = bounds.width - 2*GuiGetStyle(SLIDER, BORDER_WIDTH)
	EndIf
	'----------------------------------

	' Draw control
	'----------------------------------
	GuiDrawRectangle(bounds, GuiGetStyle(SLIDER, BORDER_WIDTH), Fade(GetColor(GuiGetStyle(SLIDER, BORDER + (state*3))), guiAlpha), Fade(GetColor(GuiGetStyle(SLIDER, iif(state <> GUI_STATE_DISABLED,  BASE_COLOR_NORMAL , BASE_COLOR_DISABLED))), guiAlpha))

	' Draw slider integerernal bar (depends on state)
	if ((state = GUI_STATE_NORMAL) OrElse (state = GUI_STATE_PRESSED)) Then
		GuiDrawRectangle(slider0, 0, BLANK, Fade(GetColor(GuiGetStyle(SLIDER, BASE_COLOR_PRESSED)), guiAlpha))

	elseif (state = GUI_STATE_FOCUSED) Then
		GuiDrawRectangle(slider0, 0, BLANK, Fade(GetColor(GuiGetStyle(SLIDER, TEXT_COLOR_FOCUSED)), guiAlpha))
	EndIf

	' Draw left/right text if provided
	if (textLeft <> NULL) Then

		Dim As Rectangle textBounds
		textBounds.width = GetTextWidth(textLeft)  ' TODO: Consider text icon
		textBounds.height = GuiGetStyle(DEFAULT, TEXT_SIZE)
		textBounds.x = bounds.x - textBounds.width - GuiGetStyle(SLIDER, TEXT_PADDING)
		textBounds.y = bounds.y + bounds.height/2 - GuiGetStyle(DEFAULT, TEXT_SIZE)/2

		GuiDrawText(textLeft, textBounds, GUI_TEXT_ALIGN_RIGHT, Fade(GetColor(GuiGetStyle(SLIDER, TEXT + (state*3))), guiAlpha))
	EndIf

	if (textRight <> NULL) Then

		Dim As Rectangle textBounds
		textBounds.width = GetTextWidth(textRight)  ' TODO: Consider text icon
		textBounds.height = GuiGetStyle(DEFAULT, TEXT_SIZE)
		textBounds.x = bounds.x + bounds.width + GuiGetStyle(SLIDER, TEXT_PADDING)
		textBounds.y = bounds.y + bounds.height/2 - GuiGetStyle(DEFAULT, TEXT_SIZE)/2

		GuiDrawText(textRight, textBounds, GUI_TEXT_ALIGN_LEFT, Fade(GetColor(GuiGetStyle(SLIDER, TEXT + (state*3))), guiAlpha))
	EndIf
	'----------------------------------

	return value
End function

' Slider control extended, returns selected value and has text
function GuiSlider(bounds As Rectangle, textLeft As Const zstring Ptr, textRight As Const zstring Ptr, value as Single, minValue as Single, maxValue as Single) As Single

	return GuiSliderPro(bounds, textLeft, textRight, value, minValue, maxValue, GuiGetStyle(SLIDER, SLIDER_WIDTH))
End Function

' Slider Bar control extended, returns selected value
Function GuiSliderBar(bounds As Rectangle, textLeft As Const zstring Ptr, textRight As Const zstring Ptr, value as Single, minValue as Single, maxValue as Single) As Single

	return GuiSliderPro(bounds, textLeft, textRight, value, minValue, maxValue, 0)
End Function

' Progress Bar control extended, shows current progress value
Function GuiProgressBar(bounds As Rectangle, textLeft As Const zstring Ptr, textRight As Const zstring Ptr, value as Single, minValue as Single, maxValue as single) As Single

	Dim As GuiControlState state = guiState

	Dim As Rectangle progress = Rectangle( bounds.x + GuiGetStyle(PROGRESSBAR, BORDER_WIDTH), _
	bounds.y + GuiGetStyle(PROGRESSBAR, BORDER_WIDTH) + GuiGetStyle(PROGRESSBAR, PROGRESS_PADDING), 0, _
	bounds.height - 2*GuiGetStyle(PROGRESSBAR, BORDER_WIDTH) - 2*GuiGetStyle(PROGRESSBAR, PROGRESS_PADDING) )

	' Update control
	'----------------------------------
	if (state <> GUI_STATE_DISABLED) Then progress.width = (value/(maxValue - minValue)*(bounds.width - 2*GuiGetStyle(PROGRESSBAR, BORDER_WIDTH)))
	'----------------------------------

	' Draw control
	'----------------------------------
	GuiDrawRectangle(bounds, GuiGetStyle(PROGRESSBAR, BORDER_WIDTH), Fade(GetColor(GuiGetStyle(PROGRESSBAR, BORDER + (state*3))), guiAlpha), BLANK)

	' Draw slider integerernal progress bar (depends on state)
	if ((state = GUI_STATE_NORMAL) OrElse (state = GUI_STATE_PRESSED)) Then
		GuiDrawRectangle(progress, 0, BLANK, Fade(GetColor(GuiGetStyle(PROGRESSBAR, BASE_COLOR_PRESSED)), guiAlpha))

	elseif (state = GUI_STATE_FOCUSED) Then
		GuiDrawRectangle(progress, 0, BLANK, Fade(GetColor(GuiGetStyle(PROGRESSBAR, TEXT_COLOR_FOCUSED)), guiAlpha))
	EndIf
	' Draw left/right text if provided
	if (textLeft <> NULL) Then

		Dim As Rectangle textBounds
		textBounds.width = GetTextWidth(textLeft)  ' TODO: Consider text icon
		textBounds.height = GuiGetStyle(DEFAULT, TEXT_SIZE)
		textBounds.x = bounds.x - textBounds.width - GuiGetStyle(PROGRESSBAR, TEXT_PADDING)
		textBounds.y = bounds.y + bounds.height/2 - GuiGetStyle(DEFAULT, TEXT_SIZE)/2

		GuiDrawText(textLeft, textBounds, GUI_TEXT_ALIGN_RIGHT, Fade(GetColor(GuiGetStyle(PROGRESSBAR, TEXT + (state*3))), guiAlpha))
	EndIf

	if (textRight <> NULL) Then

		Dim As Rectangle textBounds
		textBounds.width = GetTextWidth(textRight)  ' TODO: Consider text icon
		textBounds.height = GuiGetStyle(DEFAULT, TEXT_SIZE)
		textBounds.x = bounds.x + bounds.width + GuiGetStyle(PROGRESSBAR, TEXT_PADDING)
		textBounds.y = bounds.y + bounds.height/2 - GuiGetStyle(DEFAULT, TEXT_SIZE)/2

		GuiDrawText(textRight, textBounds, GUI_TEXT_ALIGN_LEFT, Fade(GetColor(GuiGetStyle(PROGRESSBAR, TEXT + (state*3))), guiAlpha))
	EndIf
	'----------------------------------

	return value
End function

' Status Bar control
Sub GuiStatusBar(bounds As Rectangle, text0 As Const zstring Ptr)

	Dim As GuiControlState state = guiState

	' Draw control
	'----------------------------------
	GuiDrawRectangle(bounds, GuiGetStyle(STATUSBAR, BORDER_WIDTH), Fade(GetColor(GuiGetStyle(STATUSBAR, iif(state <> GUI_STATE_DISABLED, BORDER_COLOR_NORMAL , BORDER_COLOR_DISABLED))), guiAlpha), _
	Fade(GetColor(GuiGetStyle(STATUSBAR, iif(state <> GUI_STATE_DISABLED, BASE_COLOR_NORMAL , BASE_COLOR_DISABLED))), guiAlpha))
	GuiDrawText(text0, GetTextBounds(STATUSBAR, bounds), GuiGetStyle(STATUSBAR, TEXT_ALIGNMENT), Fade(GetColor(GuiGetStyle(STATUSBAR, iif(state <> GUI_STATE_DISABLED, TEXT_COLOR_NORMAL , TEXT_COLOR_DISABLED))), guiAlpha))
	'----------------------------------
End Sub

' Dummy rectangle control, integerended for placeholding
Sub GuiDummyRec(bounds As Rectangle, text0 As Const zstring Ptr)

	Dim As GuiControlState state = guiState

	' Update control
	'----------------------------------
	if ((state <> GUI_STATE_DISABLED) andalso not guiLocked) Then

		Dim As Vector2 mousePointeger = GetMousePosition()

		' Check button state
		if (CheckCollisionPointRec(mousePointeger, bounds)) Then

			if (IsMouseButtonDown(MOUSE_LEFT_BUTTON)) Then
				state = GUI_STATE_PRESSED

			else
				state = GUI_STATE_FOCUSED
			EndIf
		EndIf
	EndIf
	'----------------------------------

	' Draw control
	'----------------------------------
	GuiDrawRectangle(bounds, 0, BLANK, Fade(GetColor(GuiGetStyle(DEFAULT, iif(state <> GUI_STATE_DISABLED, BASE_COLOR_NORMAL , BASE_COLOR_DISABLED))), guiAlpha))
	GuiDrawText(text0, GetTextBounds(DEFAULT, bounds), GUI_TEXT_ALIGN_CENTER, Fade(GetColor(GuiGetStyle(BUTTON, iif(state <> GUI_STATE_DISABLED, TEXT_COLOR_NORMAL , TEXT_COLOR_DISABLED))), guiAlpha))
	'---------------------------------=1
End Sub

' Scroll Bar control
' TODO: I feel GuiScrollBar could be simplified...
Function GuiScrollBar(bounds As Rectangle, value as long, minValue as long, maxValue as long) As long

	Dim As GuiControlState state = guiState

	' Is the scrollbar horizontal or vertical?
	Dim As boolean isVertical = iif(bounds.width > bounds.height, false , TRUE)

	' The size (width or height depending on scrollbar type) of the spinner buttons
	Dim As Const long spinnerSize = IIf(GuiGetStyle(SCROLLBAR, ARROWS_VISIBLE), iif(isVertical, bounds.width - 2*GuiGetStyle(SCROLLBAR, BORDER_WIDTH) , bounds.height - 2*GuiGetStyle(SCROLLBAR, BORDER_WIDTH)) , 0)

	' Arrow buttons [<] [>] [∧] [∨]
	Dim As Rectangle arrowUpLeft
	Dim As Rectangle arrowDownRight

	' Actual area of the scrollbar excluding the arrow buttons
	Dim As Rectangle scrollbar0

	' Slider bar that moves     -=1['/]---
	Dim As Rectangle slider0

	' Normalize value
	if (value > maxValue) Then value = maxValue
	if (value < minValue) Then value = minValue

	Dim As Const long range = maxValue - minValue
	Dim As long sliderSize = GuiGetStyle(SCROLLBAR, SCROLL_SLIDER_SIZE)

	' Calculate rectangles for all of the components
	arrowUpLeft = Rectangle(bounds.x + GuiGetStyle(SCROLLBAR, BORDER_WIDTH), bounds.y + GuiGetStyle(SCROLLBAR, BORDER_WIDTH), spinnerSize, spinnerSize )

	if (isVertical) Then

		arrowDownRight = Rectangle( bounds.x + GuiGetStyle(SCROLLBAR, BORDER_WIDTH), bounds.y + bounds.height - spinnerSize - GuiGetStyle(SCROLLBAR, BORDER_WIDTH), spinnerSize, spinnerSize)
		scrollbar0 = Rectangle( bounds.x + GuiGetStyle(SCROLLBAR, BORDER_WIDTH) + GuiGetStyle(SCROLLBAR, SCROLL_PADDING), arrowUpLeft.y + arrowUpLeft.height, bounds.width - 2*(GuiGetStyle(SCROLLBAR, BORDER_WIDTH) + GuiGetStyle(SCROLLBAR, SCROLL_PADDING)), bounds.height - arrowUpLeft.height - arrowDownRight.height - 2*GuiGetStyle(SCROLLBAR, BORDER_WIDTH) )
		sliderSize = iif(sliderSize >= scrollbar0.height, (scrollbar0.height - 2) , sliderSize )    ' Make sure the slider won't get outside of the scrollbar
		slider0 = Rectangle( bounds.x + GuiGetStyle(SCROLLBAR, BORDER_WIDTH) + GuiGetStyle(SCROLLBAR, SCROLL_SLIDER_PADDING), scrollbar0.y + (((value - minValue)/range)*(scrollbar0.height - sliderSize)), bounds.width - 2*(GuiGetStyle(SCROLLBAR, BORDER_WIDTH) + GuiGetStyle(SCROLLBAR, SCROLL_SLIDER_PADDING)), sliderSize )

	else

		arrowDownRight = Rectangle( bounds.x + bounds.width - spinnerSize - GuiGetStyle(SCROLLBAR, BORDER_WIDTH), bounds.y + GuiGetStyle(SCROLLBAR, BORDER_WIDTH), spinnerSize, spinnerSize)
		scrollbar0 = Rectangle( arrowUpLeft.x + arrowUpLeft.width, bounds.y + GuiGetStyle(SCROLLBAR, BORDER_WIDTH) + GuiGetStyle(SCROLLBAR, SCROLL_PADDING), bounds.width - arrowUpLeft.width - arrowDownRight.width - 2*GuiGetStyle(SCROLLBAR, BORDER_WIDTH), bounds.height - 2*(GuiGetStyle(SCROLLBAR, BORDER_WIDTH) + GuiGetStyle(SCROLLBAR, SCROLL_PADDING)))
		sliderSize = iif(sliderSize >= scrollbar0.width, (scrollbar0.width - 2) , sliderSize)       ' Make sure the slider won't get outside of the scrollbar
		slider0 = Rectangle( scrollbar0.x + (((value - minValue)/range)*(scrollbar0.width - sliderSize)), bounds.y + GuiGetStyle(SCROLLBAR, BORDER_WIDTH) + GuiGetStyle(SCROLLBAR, SCROLL_SLIDER_PADDING), sliderSize, bounds.height - 2*(GuiGetStyle(SCROLLBAR, BORDER_WIDTH) + GuiGetStyle(SCROLLBAR, SCROLL_SLIDER_PADDING)) )
	endif

	' Update control
	'----------------------------------
	if ((state <> GUI_STATE_DISABLED) andalso not guiLocked) Then

		Dim As Vector2 mousePointeger = GetMousePosition()

		if (CheckCollisionPointRec(mousePointeger, bounds)) then

			state = GUI_STATE_FOCUSED

			' Handle mouse wheel
			Dim As long wheel = GetMouseWheelMove()
			if (wheel <> 0) Then value += wheel

			if (IsMouseButtonPressed(MOUSE_LEFT_BUTTON)) Then

				if (CheckCollisionPointRec(mousePointeger, arrowUpLeft)) Then
					value -= range/GuiGetStyle(SCROLLBAR, SCROLL_SPEED)
				ElseIf (CheckCollisionPointRec(mousePointeger, arrowDownRight)) Then
					value += range/GuiGetStyle(SCROLLBAR, SCROLL_SPEED)
				EndIf
				state = GUI_STATE_PRESSED

			elseif (IsMouseButtonDown(MOUSE_LEFT_BUTTON)) Then

				if (Not isVertical)Then

					Dim As Rectangle scrollArea =  Rectangle (arrowUpLeft.x + arrowUpLeft.width, arrowUpLeft.y, scrollbar0.width, bounds.height - 2*GuiGetStyle(SCROLLBAR, BORDER_WIDTH))
					if (CheckCollisionPointRec(mousePointeger, scrollArea)) Then value = ((mousePointeger.x - scrollArea.x - slider0.width/2)*range)/(scrollArea.width - slider0.width) + minValue

				else

					Dim As Rectangle scrollArea =  Rectangle(arrowUpLeft.x, arrowUpLeft.y+arrowUpLeft.height, bounds.width - 2*GuiGetStyle(SCROLLBAR, BORDER_WIDTH),  scrollbar0.height)
					if (CheckCollisionPointRec(mousePointeger, scrollArea)) Then value = ((mousePointeger.y - scrollArea.y - slider0.height/2)*range)/(scrollArea.height - slider0.height) + minValue
				EndIf
			EndIf
		endif

		' Normalize value
		if (value > maxValue) Then value = maxValue
		if (value < minValue) Then value = minValue
	EndIf
	'----------------------------------

	' Draw control
	'----------------------------------
	GuiDrawRectangle(bounds, GuiGetStyle(SCROLLBAR, BORDER_WIDTH), Fade(GetColor(GuiGetStyle(LISTVIEW, BORDER + state*3)), guiAlpha), Fade(GetColor(GuiGetStyle(DEFAULT, BORDER_COLOR_DISABLED)), guiAlpha))   ' Draw the background

	GuiDrawRectangle(scrollbar0, 0, BLANK, Fade(GetColor(GuiGetStyle(BUTTON, BASE_COLOR_NORMAL)), guiAlpha))     ' Draw the scrollbar active area background
	GuiDrawRectangle(slider0, 0, BLANK, Fade(GetColor(GuiGetStyle(SLIDER, BORDER + state*3)), guiAlpha))         ' Draw the slider bar

	' Draw arrows
	Dim As Const long padding = (spinnerSize - GuiGetStyle(SCROLLBAR, ARROWS_SIZE))/2
	Dim As Const Vector2 lineCoords(0 To 11) = { _
	_' Coordinates for <     0,1,2
	Vector2(arrowUpLeft.x + padding, arrowUpLeft.y + spinnerSize/2 ), _
	Vector2(arrowUpLeft.x + spinnerSize - padding, arrowUpLeft.y + padding ), _
	Vector2(arrowUpLeft.x + spinnerSize - padding, arrowUpLeft.y + spinnerSize - padding ), _
	_' Coordinates for >     3,4,5
	Vector2(arrowDownRight.x + padding, arrowDownRight.y + padding ), _
	Vector2(arrowDownRight.x + spinnerSize - padding, arrowDownRight.y + spinnerSize/2 ), _
	Vector2(arrowDownRight.x + padding, arrowDownRight.y + spinnerSize - padding ), _
	_' Coordinates for ∧     6,7,8
	Vector2(arrowUpLeft.x + spinnerSize/2, arrowUpLeft.y + padding ), _
	Vector2(arrowUpLeft.x + padding, arrowUpLeft.y + spinnerSize - padding ), _
	Vector2(arrowUpLeft.x + spinnerSize - padding, arrowUpLeft.y + spinnerSize - padding ), _
	_' Coordinates for ∨     9,10,11
	Vector2(arrowDownRight.x + padding, arrowDownRight.y + padding ), _
	Vector2(arrowDownRight.x + spinnerSize/2, arrowDownRight.y + spinnerSize - padding ), _
	Vector2(arrowDownRight.x + spinnerSize - padding, arrowDownRight.y + padding ) _
	}

	Dim As Color lineColor = Fade(GetColor(GuiGetStyle(BUTTON, TEXT + state*3)), guiAlpha)

	if (GuiGetStyle(SCROLLBAR, ARROWS_VISIBLE)) Then

		if (isVertical) Then

			DrawTriangle(lineCoords(6), lineCoords(7), lineCoords(8), lineColor)
			DrawTriangle(lineCoords(9), lineCoords(10), lineCoords(11), lineColor)

		else

			DrawTriangle(lineCoords(2), lineCoords(1), lineCoords(0), lineColor)
			DrawTriangle(lineCoords(5), lineCoords(4), lineCoords(3), lineColor)
		EndIf
	EndIf
	'----------------------------------

	return value
End function

' List View control
Function GuiListView(bounds As Rectangle, text0 As Const zstring Ptr, scrollIndex as long Ptr, active as long) As long

	Dim As long itemsCount = 0
	Dim As Const zstring Ptr Ptr items = NULL

	if (text0 <> NULL) Then items = GuiTextSplit(text0, @itemsCount, NULL)

	return GuiListViewEx(bounds, items, itemsCount, NULL, scrollIndex, active)
End Function

' List View control with extended parameters
Function GuiListViewEx overload(bounds As Rectangle, text0 As Const zstring Ptr Ptr, count as long , focus as long ptr, scrollIndex as long ptr, active as long) As long
	Dim As GuiControlState state = guiState
	Dim As long itemFocused = iif(focus = NULL, -1 , *focus)
	Dim As long itemSelected = active

	' Check if we need a scroll bar
	Dim As boolean useScrollBar = false
	if ((GuiGetStyle(LISTVIEW, LIST_ITEMS_HEIGHT) + GuiGetStyle(LISTVIEW, LIST_ITEMS_PADDING))*count > bounds.height) Then useScrollBar = true

	' Define base item rectangle [0]
	Dim As Rectangle itemBounds
	itemBounds.x = bounds.x + GuiGetStyle(LISTVIEW, LIST_ITEMS_PADDING)
	itemBounds.y = bounds.y + GuiGetStyle(LISTVIEW, LIST_ITEMS_PADDING) + GuiGetStyle(DEFAULT, BORDER_WIDTH)
	itemBounds.width = bounds.width - 2*GuiGetStyle(LISTVIEW, LIST_ITEMS_PADDING) - GuiGetStyle(DEFAULT, BORDER_WIDTH)
	itemBounds.height = GuiGetStyle(LISTVIEW, LIST_ITEMS_HEIGHT)
	if (useScrollBar) Then itemBounds.width -= GuiGetStyle(LISTVIEW, SCROLLBAR_WIDTH)

	' Get items on the list
	Dim As long visibleItems = bounds.height/(GuiGetStyle(LISTVIEW, LIST_ITEMS_HEIGHT) + GuiGetStyle(LISTVIEW, LIST_ITEMS_PADDING))
	if (visibleItems > count) Then visibleItems = count

	Dim As long startIndex = iif(scrollIndex = NULL, 0 , *scrollIndex)
	if ((startIndex < 0) OrElse (startIndex > (count - visibleItems))) Then startIndex = 0
	Dim As long endIndex = startIndex + visibleItems

	' Update control
	'----------------------------------
	if ((state <> GUI_STATE_DISABLED) andalso not guiLocked) Then

		Dim As Vector2 mousePointeger = GetMousePosition()

		' Check mouse inside list view
		if (CheckCollisionPointRec(mousePointeger, bounds)) then

			state = GUI_STATE_FOCUSED

			' Check focused and selected item
			for i As long=0 To visibleItems-1

				if (CheckCollisionPointRec(mousePointeger, itemBounds)) then

					itemFocused = startIndex + i
					if (IsMouseButtonPressed(MOUSE_LEFT_BUTTON)) Then

						if (itemSelected = (startIndex + i)) Then
							itemSelected = -1
						else
							itemSelected = startIndex + i
						EndIf
					EndIf
					Exit For
				EndIf

				' Update item rectangle y position for next item
				itemBounds.y += (GuiGetStyle(LISTVIEW, LIST_ITEMS_HEIGHT) + GuiGetStyle(LISTVIEW, LIST_ITEMS_PADDING))
			Next

			if (useScrollBar) Then

				Dim As long wheelMove = GetMouseWheelMove()
				startIndex -= wheelMove

				if (startIndex < 0) Then
					startIndex = 0
				ElseIf (startIndex > (count - visibleItems)) Then
					startIndex = count - visibleItems
				EndIf
				endIndex = startIndex + visibleItems
				if (endIndex > count) Then endIndex = count
			EndIf

		else
			itemFocused = -1
		EndIf
		' Reset item rectangle y to [0]
		itemBounds.y = bounds.y + GuiGetStyle(LISTVIEW, LIST_ITEMS_PADDING) + GuiGetStyle(DEFAULT, BORDER_WIDTH)
	EndIf
	'----------------------------------

	' Draw control
	'----------------------------------
	GuiDrawRectangle(bounds, GuiGetStyle(DEFAULT, BORDER_WIDTH), Fade(GetColor(GuiGetStyle(LISTVIEW, BORDER + state*3)), guiAlpha), GetColor(GuiGetStyle(DEFAULT, BACKGROUND_COLOR)))     ' Draw background

	' Draw visible items
	'for (long i = 0 ((i < visibleItems) AndAlso (text <> NULL)) i+=1)
	Dim i As long=0
	While ((i < visibleItems) AndAlso (text <> NULL))
		if (state = GUI_STATE_DISABLED) Then

			if ((startIndex + i) = itemSelected) Then GuiDrawRectangle(itemBounds, GuiGetStyle(LISTVIEW, BORDER_WIDTH), Fade(GetColor(GuiGetStyle(LISTVIEW, BORDER_COLOR_DISABLED)), guiAlpha), Fade(GetColor(GuiGetStyle(LISTVIEW, BASE_COLOR_DISABLED)), guiAlpha))

			GuiDrawText(text0[startIndex + i], GetTextBounds(DEFAULT, itemBounds), GuiGetStyle(LISTVIEW, TEXT_ALIGNMENT), Fade(GetColor(GuiGetStyle(LISTVIEW, TEXT_COLOR_DISABLED)), guiAlpha))

		else

			if ((startIndex + i) = itemSelected) then

				' Draw item selected
				GuiDrawRectangle(itemBounds, GuiGetStyle(LISTVIEW, BORDER_WIDTH), Fade(GetColor(GuiGetStyle(LISTVIEW, BORDER_COLOR_PRESSED)), guiAlpha), Fade(GetColor(GuiGetStyle(LISTVIEW, BASE_COLOR_PRESSED)), guiAlpha))
				GuiDrawText(text0[startIndex + i], GetTextBounds(DEFAULT, itemBounds), GuiGetStyle(LISTVIEW, TEXT_ALIGNMENT), Fade(GetColor(GuiGetStyle(LISTVIEW, TEXT_COLOR_PRESSED)), guiAlpha))

			ElseIf ((startIndex + i) = itemFocused) Then

				' Draw item focused
				GuiDrawRectangle(itemBounds, GuiGetStyle(LISTVIEW, BORDER_WIDTH), Fade(GetColor(GuiGetStyle(LISTVIEW, BORDER_COLOR_FOCUSED)), guiAlpha), Fade(GetColor(GuiGetStyle(LISTVIEW, BASE_COLOR_FOCUSED)), guiAlpha))
				GuiDrawText(text0[startIndex + i], GetTextBounds(DEFAULT, itemBounds), GuiGetStyle(LISTVIEW, TEXT_ALIGNMENT), Fade(GetColor(GuiGetStyle(LISTVIEW, TEXT_COLOR_FOCUSED)), guiAlpha))

			else

				' Draw item normal
				GuiDrawText(text0[startIndex + i], GetTextBounds(DEFAULT, itemBounds), GuiGetStyle(LISTVIEW, TEXT_ALIGNMENT), Fade(GetColor(GuiGetStyle(LISTVIEW, TEXT_COLOR_NORMAL)), guiAlpha))
			EndIf
		EndIf

		' Update item rectangle y position for next item
		itemBounds.y += (GuiGetStyle(LISTVIEW, LIST_ITEMS_HEIGHT) + GuiGetStyle(LISTVIEW, LIST_ITEMS_PADDING))
		i+=1
	wend

	if (useScrollBar) Then

		Dim As Rectangle scrollBarBounds = Rectangle( _
		bounds.x + bounds.width - GuiGetStyle(LISTVIEW, BORDER_WIDTH) - GuiGetStyle(LISTVIEW, SCROLLBAR_WIDTH), _
		bounds.y + GuiGetStyle(LISTVIEW, BORDER_WIDTH),GuiGetStyle(LISTVIEW, SCROLLBAR_WIDTH), _
		bounds.height - 2*GuiGetStyle(DEFAULT, BORDER_WIDTH) _
		)

		' Calculate percentage of visible items and apply same percentage to scrollbar
		Dim As Single percentVisible = (endIndex - startIndex)/count
		Dim As Single sliderSize = bounds.height*percentVisible

		Dim As long prevSliderSize = GuiGetStyle(SCROLLBAR, SCROLL_SLIDER_SIZE)   ' Save default slider size
		Dim As long prevScrollSpeed = GuiGetStyle(SCROLLBAR, SCROLL_SPEED) ' Save default scroll speed
		GuiSetStyle(SCROLLBAR, SCROLL_SLIDER_SIZE, sliderSize)            ' Change slider size
		GuiSetStyle(SCROLLBAR, SCROLL_SPEED, count - visibleItems) ' Change scroll speed

		startIndex = GuiScrollBar(scrollBarBounds, startIndex, 0, count - visibleItems)

		GuiSetStyle(SCROLLBAR, SCROLL_SPEED, prevScrollSpeed) ' Reset scroll speed to default
		GuiSetStyle(SCROLLBAR, SCROLL_SLIDER_SIZE, prevSliderSize) ' Reset slider size to default
	EndIf
	'----------------------------------

	if (focus <> NULL) Then *focus = itemFocused
	if (scrollIndex <> NULL) Then *scrollIndex = startIndex

	return itemSelected
End function

'' Overload to accept a native string array instead of a C one
function GuiListViewEx( bounds As Rectangle, text_() as string, count as long, focus as long ptr, scrollIndex as long ptr, active as long ) as long
	return( GuiListViewEx( bounds, toPtrArray( text_() ), count, focus, scrollIndex, active ) )
end function

' Color Panel control
Function GuiColorPanelEx(bounds As Rectangle, color0 as Color, hue As Single) As Color

	Dim As GuiControlState state = guiState
	static As Vector2 pickerSelector
	Dim As Vector3 vcolor =  Vector3(color0.r/255.0f, color0.g/255.0f, color0.b/255.0f )
	Dim hsv as Vector3 = ConvertRGBtoHSV(vcolor)

		pickerSelector.x = bounds.x + hsv.y*bounds.width            ' HSV: Saturation
		pickerSelector.y = bounds.y + (1.0f - hsv.z)*bounds.height  ' HSV: Value

	Dim As Vector3 maxHue =  Vector3(iif(hue >= 0.0f , hue , hsv.x), 1.0f, 1.0f)
	Dim As Vector3 rgbHue = ConvertHSVtoRGB(maxHue)
	Dim As Color maxHueCol =  Color((255.0f*rgbHue.x),_
	(255.0f*rgbHue.y),_
	(255.0f*rgbHue.z), 255 )

	Dim As Const Color colWhite = Color( 255, 255, 255, 255 )
	Dim As Const Color colBlack = Color( 0, 0, 0, 255 )

	' Update control
	'----------------------------------
	if ((state <> GUI_STATE_DISABLED) andalso not guiLocked) Then

		Dim As Vector2 mousePointer = GetMousePosition()

		if (CheckCollisionPointRec(mousePointer, bounds)) Then

			if (IsMouseButtonDown(MOUSE_LEFT_BUTTON)) Then

				state = GUI_STATE_PRESSED
				pickerSelector = mousePointer

				' Calculate color from picker
				Dim As Vector2 colorPick = Vector2( pickerSelector.x - bounds.x, pickerSelector.y - bounds.y )

				colorPick.x /= bounds.width     ' Get normalized value on x
				colorPick.y /= bounds.height    ' Get normalized value on y

				hsv.y = colorPick.x
				hsv.z = 1.0f - colorPick.y

				Dim rgb1 as Vector3 = ConvertHSVtoRGB(hsv)

				' NOTE: Vector3ToColor() only available on raylib 1.8.1
				color0 = Color( (255.0f*rgb1.x),_
				(255.0f*rgb1.y),_
				(255.0f*rgb1.z),_
				(255.0f*color0.a/255.0f) )


			else
				state = GUI_STATE_FOCUSED
			EndIf
		endif
	endif
	'----------------------------------

	' Draw control
	'----------------------------------
	if (state <> GUI_STATE_DISABLED)Then

		DrawRectangleGradientEx(bounds, Fade(colWhite, guiAlpha), Fade(colWhite, guiAlpha), Fade(maxHueCol, guiAlpha), Fade(maxHueCol, guiAlpha))
		DrawRectangleGradientEx(bounds, Fade(colBlack, 0), Fade(colBlack, guiAlpha), Fade(colBlack, guiAlpha), Fade(colBlack, 0))

		' Draw color picker: selector
		Dim As Rectangle selector =  Rectangle (pickerSelector.x - GuiGetStyle(COLORPICKER, COLOR_SELECTOR_SIZE)/2, pickerSelector.y - GuiGetStyle(COLORPICKER, COLOR_SELECTOR_SIZE)/2, GuiGetStyle(COLORPICKER, COLOR_SELECTOR_SIZE), GuiGetStyle(COLORPICKER, COLOR_SELECTOR_SIZE) )
		GuiDrawRectangle(selector, 0, BLANK, Fade(colWhite, guiAlpha))

	else

		DrawRectangleGradientEx(bounds, Fade(Fade(GetColor(GuiGetStyle(COLORPICKER, BASE_COLOR_DISABLED)), 0.1f), guiAlpha), Fade(Fade(colBlack, 0.6f), guiAlpha), Fade(Fade(colBlack, 0.6f), guiAlpha), Fade(Fade(GetColor(GuiGetStyle(COLORPICKER, BORDER_COLOR_DISABLED)), 0.6f), guiAlpha))
	endif

	GuiDrawRectangle(bounds, 1, Fade(GetColor(GuiGetStyle(COLORPICKER, BORDER + state*3)), guiAlpha), BLANK)
	'----------------------------------

	return color0
End function

function GuiColorPanel(bounds As Rectangle, color0 as Color) As Color

	return GuiColorPanelEx(bounds, color0, -1.0f)
End Function

' Color Bar Alpha control
' NOTE: Returns alpha value normalized [0..1]
Function GuiColorBarAlpha(bounds As Rectangle, alpha0 as Single) As single
	alpha0/=255.0f
	#define COLORBARALPHA_CHECKED_SIZE   10

	Dim As GuiControlState state = guiState
	Dim As Rectangle selector = Rectangle(bounds.x + alpha0*bounds.width - GuiGetStyle(COLORPICKER, HUEBAR_SELECTOR_OVERFLOW), bounds.y - GuiGetStyle(COLORPICKER, HUEBAR_SELECTOR_OVERFLOW), GuiGetStyle(COLORPICKER, HUEBAR_SELECTOR_HEIGHT), bounds.height + GuiGetStyle(COLORPICKER, HUEBAR_SELECTOR_OVERFLOW)*2 )

	' Update control
	'----------------------------------
	if ((state <> GUI_STATE_DISABLED) andalso not guiLocked) Then

		Dim As Vector2 mousePointeger = GetMousePosition()

		if (CheckCollisionPointRec(mousePointeger, bounds) OrElse _
			CheckCollisionPointRec(mousePointeger, selector)) Then

			if (IsMouseButtonDown(MOUSE_LEFT_BUTTON)) Then

				state = GUI_STATE_PRESSED
				selector.x = mousePointeger.x - selector.width/2

				alpha0 = (mousePointeger.x - bounds.x)/bounds.width
				if (alpha0 <= 0.0f) Then alpha0 = 0.0f
				if (alpha0 >= 1.0f) Then alpha0 = 1.0f
				'selector.x = bounds.x + (((alpha0 - 0)/(100 - 0))*(bounds.width - 2*GuiGetStyle(SLIDER, BORDER_WIDTH))) - selector.width/2

			else
				state = GUI_STATE_FOCUSED
			EndIf
		EndIf
	EndIf
	'----------------------------------

	' Draw control
	'----------------------------------

	' Draw alpha bar: checked background
	if (state <> GUI_STATE_DISABLED) Then

		Dim As long checksX = bounds.width/COLORBARALPHA_CHECKED_SIZE
		Dim As long checksY = bounds.height/COLORBARALPHA_CHECKED_SIZE

		for x As long=0 To checksX-1

			for y As long=0 To checksY-1

				Dim As Rectangle check = Rectangle( bounds.x + x*COLORBARALPHA_CHECKED_SIZE, bounds.y + y*COLORBARALPHA_CHECKED_SIZE, COLORBARALPHA_CHECKED_SIZE, COLORBARALPHA_CHECKED_SIZE )
				GuiDrawRectangle(check, 0, BLANK, iif((((x + y) mod 2)=0), Fade(Fade(GetColor(GuiGetStyle(COLORPICKER, BORDER_COLOR_DISABLED)), 0.4f), guiAlpha) , Fade(Fade(GetColor(GuiGetStyle(COLORPICKER, BASE_COLOR_DISABLED)), 0.4f), guiAlpha) ) )
			Next
		Next

		DrawRectangleGradientEx(bounds, Color( 255, 255, 255, 0 ), Color(255, 255, 255, 0 ), Fade(Color( 0, 0, 0, 255 ), guiAlpha), Fade(Color(0, 0, 0, 255 ), guiAlpha))

	else
		DrawRectangleGradientEx(bounds, Fade(GetColor(GuiGetStyle(COLORPICKER, BASE_COLOR_DISABLED)), 0.1f), Fade(GetColor(GuiGetStyle(COLORPICKER, BASE_COLOR_DISABLED)), 0.1f), Fade(GetColor(GuiGetStyle(COLORPICKER, BORDER_COLOR_DISABLED)), guiAlpha), Fade(GetColor(GuiGetStyle(COLORPICKER, BORDER_COLOR_DISABLED)), guiAlpha))
	EndIf
	GuiDrawRectangle(bounds, 1, Fade(GetColor(GuiGetStyle(COLORPICKER, BORDER + state*3)), guiAlpha), BLANK)

	' Draw alpha bar: selector
	GuiDrawRectangle(selector, 0, BLANK, Fade(GetColor(GuiGetStyle(COLORPICKER, BORDER + state*3)), guiAlpha))
	'----------------------------------

	return alpha0*255.0f
End Function

' Color Bar Hue control
' NOTE: Returns hue value normalized [0..1]
Function GuiColorBarHue(bounds As Rectangle, hue As single) As single

	Dim As GuiControlState state = guiState
	Dim As Rectangle selector = Rectangle(bounds.x - GuiGetStyle(COLORPICKER, HUEBAR_SELECTOR_OVERFLOW), bounds.y + hue/360.0f*bounds.height - GuiGetStyle(COLORPICKER, HUEBAR_SELECTOR_OVERFLOW), bounds.width + GuiGetStyle(COLORPICKER, HUEBAR_SELECTOR_OVERFLOW)*2, GuiGetStyle(COLORPICKER, HUEBAR_SELECTOR_HEIGHT) )

	' Update control
	'----------------------------------
	if ((state <> GUI_STATE_DISABLED) andalso not guiLocked) Then

		Dim As Vector2 mousePointer = GetMousePosition()

		if (CheckCollisionPointRec(mousePointer, bounds) OrElse _
			CheckCollisionPointRec(mousePointer, selector)) Then

			if (IsMouseButtonDown(MOUSE_LEFT_BUTTON)) Then

				state = GUI_STATE_PRESSED
				selector.y = mousePointer.y - (selector.height/2)

				hue = (mousePointer.y - bounds.y)*(360.0f/bounds.height)
				if (hue < 0.0f) Then hue += 360.0f
				if (hue >= 359.0f) Then hue -= 360.0f


			else
				state = GUI_STATE_FOCUSED
			EndIf
			/'if (IsKeyDown(KEY_UP))

                hue -= 2.0f
                if (hue <= 0.0f) hue = 0.0f
            }
            else if (IsKeyDown(KEY_DOWN))

                hue += 2.0f
                if (hue >= 360.0f) hue = 360.0f
            }'/
		EndIf
	EndIf
	'----------------------------------

	' Draw control
	'----------------------------------
	if (state <> GUI_STATE_DISABLED) Then

		' Draw hue bar:color bars
		DrawRectangleGradientV(bounds.x + GuiGetStyle(COLORPICKER, HUEBAR_SELECTOR_OVERFLOW)/2, bounds.y + 0*(bounds.height/6) + GuiGetStyle(COLORPICKER, HUEBAR_SELECTOR_OVERFLOW)/2, bounds.width - GuiGetStyle(COLORPICKER, HUEBAR_SELECTOR_OVERFLOW), bounds.height/6, Fade(Color( 255,0,0,255 ), guiAlpha), Fade(Color( 255,255,0,255 ), guiAlpha))
		DrawRectangleGradientV(bounds.x + GuiGetStyle(COLORPICKER, HUEBAR_SELECTOR_OVERFLOW)/2, bounds.y + 1*(bounds.height/6) + GuiGetStyle(COLORPICKER, HUEBAR_SELECTOR_OVERFLOW)/2, bounds.width - GuiGetStyle(COLORPICKER, HUEBAR_SELECTOR_OVERFLOW), bounds.height/6, Fade(Color( 255,255,0,255 ), guiAlpha), Fade(Color(0,255,0,255 ), guiAlpha))
		DrawRectangleGradientV(bounds.x + GuiGetStyle(COLORPICKER, HUEBAR_SELECTOR_OVERFLOW)/2, bounds.y + 2*(bounds.height/6) + GuiGetStyle(COLORPICKER, HUEBAR_SELECTOR_OVERFLOW)/2-1, bounds.width - GuiGetStyle(COLORPICKER, HUEBAR_SELECTOR_OVERFLOW), bounds.height/6+1, Fade(Color( 0,255,0,255 ), guiAlpha), Fade(Color( 0,255,255,255 ), guiAlpha))
		DrawRectangleGradientV(bounds.x + GuiGetStyle(COLORPICKER, HUEBAR_SELECTOR_OVERFLOW)/2, bounds.y + 3*(bounds.height/6) + GuiGetStyle(COLORPICKER, HUEBAR_SELECTOR_OVERFLOW)/2-1, bounds.width - GuiGetStyle(COLORPICKER, HUEBAR_SELECTOR_OVERFLOW), bounds.height/6+1, Fade(Color( 0,255,255,255 ), guiAlpha), Fade(Color( 0,0,255,255 ), guiAlpha))
		DrawRectangleGradientV(bounds.x + GuiGetStyle(COLORPICKER, HUEBAR_SELECTOR_OVERFLOW)/2, bounds.y + 4*(bounds.height/6) + GuiGetStyle(COLORPICKER, HUEBAR_SELECTOR_OVERFLOW)/2, bounds.width - GuiGetStyle(COLORPICKER, HUEBAR_SELECTOR_OVERFLOW), bounds.height/6, Fade(Color( 0,0,255,255 ), guiAlpha), Fade(Color( 255,0,255,255 ), guiAlpha))
		DrawRectangleGradientV(bounds.x + GuiGetStyle(COLORPICKER, HUEBAR_SELECTOR_OVERFLOW)/2, bounds.y + 5*(bounds.height/6) + GuiGetStyle(COLORPICKER, HUEBAR_SELECTOR_OVERFLOW)/2-1, bounds.width - GuiGetStyle(COLORPICKER, HUEBAR_SELECTOR_OVERFLOW), bounds.height/6+1 - GuiGetStyle(COLORPICKER, HUEBAR_SELECTOR_OVERFLOW), Fade(Color( 255,0,255,255 ), guiAlpha), Fade(Color( 255,0,0,255 ), guiAlpha))

	else
		DrawRectangleGradientV(bounds.x, bounds.y, bounds.width, bounds.height, Fade(Fade(GetColor(GuiGetStyle(COLORPICKER, BASE_COLOR_DISABLED)), 0.1f), guiAlpha), Fade(GetColor(GuiGetStyle(COLORPICKER, BORDER_COLOR_DISABLED)), guiAlpha))
	EndIf
	GuiDrawRectangle(bounds, 1, Fade(GetColor(GuiGetStyle(COLORPICKER, BORDER + state*3)), guiAlpha), BLANK)

	' Draw hue bar: selector
	GuiDrawRectangle(selector, 0, BLANK, Fade(GetColor(GuiGetStyle(COLORPICKER, BORDER + state*3)), guiAlpha))
	'----------------------------------

	return hue
End function

' TODO: Color GuiColorBarSat() [WHITE->color]
' TODO: Color GuiColorBarValue() [BLACK->color], HSV / HSL
' TODO: single GuiColorBarLuminance() [BLACK->WHITE]

' Color Picker control
' NOTE: It's divided in multiple controls:
'      Color GuiColorPanel(bounds As Rectangle, color as Color)
'      single GuiColorBarAlpha(bounds As Rectangle, alpha as single)
'      single GuiColorBarHue(bounds As Rectangle, value as single)
' NOTE: bounds define GuiColorPanel() size
Function GuiColorPicker(bounds As Rectangle, color0 as Color) As Color

	color0 = GuiColorPanel(bounds, color0)

	Dim As Rectangle boundsHue =  Rectangle(bounds.x + bounds.width + GuiGetStyle(COLORPICKER, HUEBAR_PADDING), bounds.y, GuiGetStyle(COLORPICKER, HUEBAR_WIDTH), bounds.height )
	dim As Rectangle boundsAlpha =  Rectangle(bounds.x, bounds.y + bounds.height + GuiGetStyle(COLORPICKER, HUEBAR_PADDING), bounds.width, GuiGetStyle(COLORPICKER, HUEBAR_WIDTH) )

	Dim hsv as Vector3 = ConvertRGBtoHSV(Vector3( color0.r/255.0f, color0.g/255.0f, color0.b/255.0f ))
	hsv.x = GuiColorBarHue(boundsHue, hsv.x)
	color0.a = GuiColorBarAlpha(boundsAlpha, color0.a)
	Dim RGB0 as Vector3 = ConvertHSVtoRGB(hsv)
	color0 = Color( roundf(rgb0.x*255.0f), roundf(rgb0.y*255.0f), roundf(rgb0.z*255.0f), color0.a )
	'-----------------------------------------------
	#define COLORBARALPHA_CHECKED_SIZE   10

	Dim As Rectangle colB=Rectangle(boundsAlpha.x+boundsAlpha.width+ GuiGetStyle(COLORPICKER, HUEBAR_PADDING),boundsAlpha.y,boundsAlpha.height,boundsAlpha.height)
	Dim As GuiControlState state = guiState

	if (state <> GUI_STATE_DISABLED) Then

		Dim As long checksX = colB.width/COLORBARALPHA_CHECKED_SIZE
		Dim As long checksY = colB.height/COLORBARALPHA_CHECKED_SIZE
		Dim c0 As Color=WHITE
		Dim c1 As Color=BLACK
		Dim c2 As Color
		c2.r=(color0.r+c0.r)/2
		c2.g=(color0.g+c0.g)/2
		c2.b=(color0.b+c0.b)/2
		c2.a=color0.a
		Dim c3 As Color
		c3.r=(color0.r+c2.r)/2
		c3.g=(color0.g+c2.g)/2
		c3.b=(color0.b+c2.b)/2
		c3.a=color0.a
		for x As long=0 To checksX-1

			for y As long=0 To checksY-1

				Dim As Rectangle check = Rectangle( colB.x + x*COLORBARALPHA_CHECKED_SIZE, colB.y + y*COLORBARALPHA_CHECKED_SIZE, COLORBARALPHA_CHECKED_SIZE, COLORBARALPHA_CHECKED_SIZE )
				GuiDrawRectangle(check, 0, BLANK, iif((((x + y) mod 2)=0), Fade(c2, color0.a/255.0) , Fade(c3, (color0.a/255)*0.9) ) )
			Next
		Next


	else
		DrawRectangleGradientEx(colB, Fade(GetColor(GuiGetStyle(COLORPICKER, BASE_COLOR_DISABLED)), 0.1f), Fade(GetColor(GuiGetStyle(COLORPICKER, BASE_COLOR_DISABLED)), 0.1f), Fade(GetColor(GuiGetStyle(COLORPICKER, BORDER_COLOR_DISABLED)), guiAlpha), Fade(GetColor(GuiGetStyle(COLORPICKER, BORDER_COLOR_DISABLED)), guiAlpha))
	EndIf
	GuiDrawRectangle(colB, 1, Fade(GetColor(GuiGetStyle(COLORPICKER, BORDER + state*3)), guiAlpha), BLANK)

	'----------------------------------

	'-------------------------------------------------------------
	return color0
End Function

' Message Box control
Function GuiMessageBox(bounds As Rectangle,  title As Const zstring Ptr,  message As Const zstring Ptr,  buttons As Const zstring Ptr) As long

	#define MESSAGEBOX_BUTTON_HEIGHT    24
	#define MESSAGEBOX_BUTTON_PADDING   10
	#define WINDOW_STATUSBAR_HEIGHT     22

	Dim As long clicked = -1    ' Returns clicked button from buttons list, 0 refers to closed window button

	Dim As long buttonsCount = 0
	dim As Const zstring Ptr Ptr buttonsText = GuiTextSplit(buttons, @buttonsCount, NULL)
	Dim As Rectangle buttonBounds
	buttonBounds.x = bounds.x + MESSAGEBOX_BUTTON_PADDING
	buttonBounds.y = bounds.y + bounds.height - MESSAGEBOX_BUTTON_HEIGHT - MESSAGEBOX_BUTTON_PADDING
	buttonBounds.width = (bounds.width - MESSAGEBOX_BUTTON_PADDING*(buttonsCount + 1))/buttonsCount
	buttonBounds.height = MESSAGEBOX_BUTTON_HEIGHT

	Dim As Vector2 textSize = MeasureTextEx(guiFont, message, GuiGetStyle(DEFAULT, TEXT_SIZE), 1)

	Dim As Rectangle textBounds
	textBounds.x = bounds.x + bounds.width/2 - textSize.x/2
	textBounds.y = bounds.y + WINDOW_STATUSBAR_HEIGHT + (bounds.height - WINDOW_STATUSBAR_HEIGHT - MESSAGEBOX_BUTTON_HEIGHT - MESSAGEBOX_BUTTON_PADDING)/2 - textSize.y/2
	textBounds.width = textSize.x
	textBounds.height = textSize.y

	' Draw control
	'----------------------------------
	if (GuiWindowBox(bounds, title)) Then clicked = 0

	Dim As long prevTextAlignment = GuiGetStyle(LABEL, TEXT_ALIGNMENT)
	GuiSetStyle(LABEL, TEXT_ALIGNMENT, GUI_TEXT_ALIGN_CENTER)
	GuiLabel(textBounds, message)
	GuiSetStyle(LABEL, TEXT_ALIGNMENT, prevTextAlignment)

	prevTextAlignment = GuiGetStyle(BUTTON, TEXT_ALIGNMENT)
	GuiSetStyle(BUTTON, TEXT_ALIGNMENT, GUI_TEXT_ALIGN_CENTER)

	for i As long  = 0 to buttonsCount -1

		if (GuiButton(buttonBounds, @buttonsText[i][0])) Then clicked = i + 1
		buttonBounds.x += (buttonBounds.width + MESSAGEBOX_BUTTON_PADDING)
	Next

	GuiSetStyle(BUTTON, TEXT_ALIGNMENT, prevTextAlignment)
	'----------------------------------

	return clicked
End Function

' Text Input Box control, ask for text
Function GuiTextInputBox(bounds As Rectangle,  title As Const zstring Ptr,  message As Const zstring Ptr,  buttons As Const zstring Ptr, text as zstring Ptr) As long

	#define MESSAGEBOX_BUTTON_PADDING   10
	#define TEXTINPUTBOX_BUTTON_HEIGHT      24
	#define TEXTINPUTBOX_BUTTON_PADDING     10
	#define TEXTINPUTBOX_HEIGHT             30

	#define TEXTINPUTBOX_MAX_TEXT_LENGTH   256
	#Define WINDOW_STATUSBAR_HEIGHT 22
	' Used to enable text edit mode
	' WARNING: No more than one GuiTextInputBox() should be open at the same time
	static As boolean textEditMode = false

	Dim As long btnIndex = -1

	Dim As long buttonsCount = 0
	Dim As Const zstring Ptr Ptr buttonsText = GuiTextSplit(buttons, @buttonsCount, NULL)
	Dim As Rectangle buttonBounds
	buttonBounds.x = bounds.x + TEXTINPUTBOX_BUTTON_PADDING
	buttonBounds.y = bounds.y + bounds.height - TEXTINPUTBOX_BUTTON_HEIGHT - TEXTINPUTBOX_BUTTON_PADDING
	buttonBounds.width = (bounds.width - TEXTINPUTBOX_BUTTON_PADDING*(buttonsCount + 1))/buttonsCount
	buttonBounds.height = TEXTINPUTBOX_BUTTON_HEIGHT

	Dim As long messageInputHeight = bounds.height - WINDOW_STATUSBAR_HEIGHT - GuiGetStyle(STATUSBAR, BORDER_WIDTH) - TEXTINPUTBOX_BUTTON_HEIGHT - 2*TEXTINPUTBOX_BUTTON_PADDING

	Dim As Rectangle textBounds
	if (message <> NULL) Then

		Dim As Vector2 textSize = MeasureTextEx(guiFont, message, GuiGetStyle(DEFAULT, TEXT_SIZE), 1)

		textBounds.x = bounds.x + bounds.width/2 - textSize.x/2
		textBounds.y = bounds.y + WINDOW_STATUSBAR_HEIGHT + messageInputHeight/4 - textSize.y/2
		textBounds.width = textSize.x
		textBounds.height = textSize.y
	EndIf

	Dim As Rectangle textBoxBounds
	textBoxBounds.x = bounds.x + TEXTINPUTBOX_BUTTON_PADDING
	textBoxBounds.y = bounds.y + WINDOW_STATUSBAR_HEIGHT - TEXTINPUTBOX_HEIGHT/2
	if (message = NULL) Then
		textBoxBounds.y += messageInputHeight/2
	else
		textBoxBounds.y += (messageInputHeight/2 + messageInputHeight/4)
	EndIf
	textBoxBounds.width = bounds.width - TEXTINPUTBOX_BUTTON_PADDING*2
	textBoxBounds.height = TEXTINPUTBOX_HEIGHT

	' Draw control
	'----------------------------------
	if (GuiWindowBox(bounds, title)) Then btnIndex = 0

	' Draw message if available
	if (message <> NULL) Then

		Dim As long prevTextAlignment = GuiGetStyle(LABEL, TEXT_ALIGNMENT)
		GuiSetStyle(LABEL, TEXT_ALIGNMENT, GUI_TEXT_ALIGN_CENTER)
		GuiLabel(textBounds, message)
		GuiSetStyle(LABEL, TEXT_ALIGNMENT, prevTextAlignment)
	EndIf

	if (GuiTextBox(textBoxBounds, *text, TEXTINPUTBOX_MAX_TEXT_LENGTH, textEditMode)) Then textEditMode = Not textEditMode

	Dim As long prevBtnTextAlignment = GuiGetStyle(BUTTON, TEXT_ALIGNMENT)
	GuiSetStyle(BUTTON, TEXT_ALIGNMENT, GUI_TEXT_ALIGN_CENTER)

	for i As long  = 0 to buttonsCount-1

		if (GuiButton(buttonBounds, @buttonsText[i][0])) Then btnIndex = i + 1
		buttonBounds.x += (buttonBounds.width + MESSAGEBOX_BUTTON_PADDING)
	Next

	GuiSetStyle(BUTTON, TEXT_ALIGNMENT, prevBtnTextAlignment)
	'----------------------------------

	return btnIndex
End Function

' Grid control
' NOTE: Returns grid mouse-hover selected cell
' About drawing lines at subpixel spacing, simple put, not easy solution:
' https:'stackoverflow.com/questions/4435450/2d-opengl-drawing-lines-that-dont-exactly-fit-pixel-raster
Function GuiGrid(bounds As Rectangle, spacing as Single, subdivs as long) As Vector2

	#if Not Defined(GRID_COLOR_ALPHA)
	#define GRID_COLOR_ALPHA    0.15f           ' Grid lines alpha amount
	#endif

	Dim As GuiControlState state = guiState
	Dim As Vector2 mousePointeger = GetMousePosition()
	Dim As Vector2 currentCell = Vector2( -1, -1 )

	Dim As long linesV = ((bounds.width/spacing))*subdivs + 1
	Dim As long linesH = ((bounds.height/spacing))*subdivs + 1

	' Update control
	'----------------------------------
	if ((state <> GUI_STATE_DISABLED) andalso not guiLocked) Then

		if (CheckCollisionPointRec(mousePointeger, bounds)) Then

			currentCell.x = ((mousePointeger.x - bounds.x)/spacing)
			currentCell.y = ((mousePointeger.y - bounds.y)/spacing)
		EndIf
	EndIf
	'----------------------------------

	' Draw control
	'----------------------------------
	Select case as const (state)

		case GUI_STATE_NORMAL:

			if (subdivs > 0) Then

				' Draw vertical grid lines
				for i As long  = 0 to linesV-1

					Dim As Rectangle lineV =  Rectangle(bounds.x + spacing * i / subdivs, bounds.y, 1, bounds.height )
					GuiDrawRectangle(lineV, 0, BLANK, iif(((i mod subdivs) = 0) , Fade(GetColor(GuiGetStyle(DEFAULT, LINE_COLOR)), GRID_COLOR_ALPHA * 4) , Fade(GetColor(GuiGetStyle(DEFAULT, LINE_COLOR)), GRID_COLOR_ALPHA)))
				Next

				' Draw horizontal grid lines
				for i As long = 0 To linesH-1

					dim As Rectangle lineH =  Rectangle(bounds.x, bounds.y + spacing * i / subdivs, bounds.width, 1 )
					GuiDrawRectangle(lineH, 0, BLANK, iif(((i mod subdivs) = 0) , Fade(GetColor(GuiGetStyle(DEFAULT, LINE_COLOR)), GRID_COLOR_ALPHA * 4) , Fade(GetColor(GuiGetStyle(DEFAULT, LINE_COLOR)), GRID_COLOR_ALPHA)))
				Next
			EndIf

		Case else:
	End select

	return currentCell
End Function


'-----------------------------------------=1
' Styles loading functions
'-----------------------------------------=1

' Load raygui style file (.rgs)
' Load raygui style file (.rgs)
Sub GuiLoadStyle( fileName As ZString Ptr)

	Dim As boolean tryBinary = false

	' Try reading the files as text file first
	Dim As FILE Ptr rgsFile = fopen(fileName, "rt")

	if (rgsFile <> NULL) Then

		Dim As ZString*256 buffer
		fgets(buffer, 256, rgsFile)
		if (buffer[0] = Asc("#")) then

			Dim As Integer controlId = 0
			Dim As Integer propertyId = 0
			Dim As UInteger propertyValue = 0

			while (feof(rgsFile)=0)

				Select Case As Const (buffer[0])
					'Print buffer
					case (asc("p"))
						' Style property: p <control_id> <property_id> <property_value> <property_name>

						sscanf(buffer, "p %d %d 0x%x", @controlId, @propertyId, @propertyValue)
						GuiSetStyle(controlId, propertyId, propertyValue)
						Exit select

					Case Asc("f")

						' Style font: f <gen_font_size> <charmap_file> <font_file>

						Dim fontSize as Integer = 0
						Dim As ZString*256 charmapFileName
						Dim As ZString*256 fontFileName
						sscanf(buffer, !"f %d %s %[^\r\n]s", @fontSize, @charmapFileName, fontFileName)

						Dim font0 as Font

						'printf("%s",charmapFileName)
						if (charmapFileName[0] <> Asc("0")) then

							' Load characters from charmap file,
							' expected '\n' separated list of integereger values
							Dim As zstring ptr charValues = LoadText(charmapFileName)
							if (charValues <> NULL) Then

								Dim charsCount as long = 0
								Dim As Const ZString Ptr Ptr chars = TextSplit(charValues, Asc(!"\n"), @charsCount)

								Dim as long Ptr values = Cast(long Ptr,RAYGUI_MALLOC(charsCount*sizeof(long)))
								for i As Integer = 0 to charsCount-1
									values[i] = TextToInteger(chars[i])
								Next

								font0 = LoadFontEx(TextFormat("%s/%s", GetDirectoryPath(fileName), fontFileName), fontSize, values, charsCount)

								RAYGUI_FREE(values)
							EndIf

						else
							font0 = LoadFontEx(TextFormat("%s/%s", GetDirectoryPath(fileName), fontFileName), fontSize, NULL, 0)
						EndIf
						if ((font0.texture.id > 0) AndAlso (font0.charsCount > 0)) Then GuiSetFont(font0)
						Exit select

						'Case else:

				End Select

				fgets(buffer, 256, rgsFile)
			Wend

		else
			tryBinary = true
		EndIf
		fclose(rgsFile)
	EndIf

	if (tryBinary) Then

		rgsFile = fopen(fileName, "rb")

		if (rgsFile = NULL) Then Return

		Dim As ZString*5 signature
		Dim As Short version = 0
		Dim As Short reserved = 0
		Dim As Integer propertiesCount = 0

		fread(@signature, 1, 4, rgsFile)
		fread(@version, 1, sizeof(short), rgsFile)
		fread(@reserved, 1, sizeof(short), rgsFile)
		fread(@propertiesCount, 1, sizeof(integer), rgsFile)

		if ((signature[0] = Asc("r")) AndAlso _
			(signature[1] = Asc("G")) AndAlso _
			(signature[2] = Asc("S")) AndAlso _
			(signature[3] = Asc(" "))) Then

			Dim As Short controlId = 0
			Dim As Short propertyId = 0
			Dim As Integer propertyValue = 0

			for i As Integer = 0 to propertiesCount-1

				fread(@controlId, 1, sizeof(short), rgsFile)
				fread(@propertyId, 1, sizeof(short), rgsFile)
				fread(@propertyValue, 1, sizeof(integer), rgsFile)

				if (controlId = 0) Then' DEFAULT control

					' If a DEFAULT property is loaded, it is propagated to all controls
					' NOTE: All DEFAULT properties should be defined first in the file
					GuiSetStyle(0,propertyId, propertyValue)

					if (propertyId < NUM_PROPS_DEFAULT) Then
						for i As Integer  = 1 to NUM_CONTROLS-1
							GuiSetStyle(i, propertyId, propertyValue)
						Next
					EndIf

				Else
					GuiSetStyle(controlId, propertyId, propertyValue)
				EndIf
			next

			' Font loading is highly dependant on raylib API to load font data and image
			' TODO: Find some mechanism to support it in standalone mode
			#if Not Defined(RAYGUI_STANDALONE)
			' Load custom font if available
			Dim As Integer fontDataSize = 0
			fread(@fontDataSize, 1, sizeof(integer), rgsFile)

			if (fontDataSize > 0) Then

				Dim font0 as Font
				Dim As Integer fontType = 0   ' 0-Normal, 1-SDF
				Dim As Rectangle whiteRec

				fread(@font0.baseSize, 1, sizeof(integer), rgsFile)
				fread(@font0.charsCount, 1, sizeof(integer), rgsFile)
				fread(@fontType, 1, sizeof(integer), rgsFile)

				' Load font white rectangle
				fread(@whiteRec, 1, sizeof(Rectangle), rgsFile)

				' Load font image parameters
				Dim As Integer fontImageSize = 0
				fread(@fontImageSize, 1, sizeof(integer), rgsFile)

				if (fontImageSize > 0) then

					Dim As Image imFont
					imFont.mipmaps = 1
					fread(@imFont.width, 1, sizeof(integer), rgsFile)
					fread(@imFont.height, 1, sizeof(integer), rgsFile)
					fread(@imFont.format, 1, sizeof(integer), rgsFile)

					imFont.data = Cast(zstring Ptr,RAYGUI_MALLOC(fontImageSize))
					fread(imFont.data, 1, fontImageSize, rgsFile)

					font0.texture = LoadTextureFromImage(imFont)

					UnloadImage(imFont)
				EndIf

				' Load font recs data
				font0.recs = Cast(Rectangle Ptr,RAYGUI_CALLOC(font0.charsCount, sizeof(Rectangle)))
				for i As integer = 0 to font0.charsCount-1
					fread(@font0.recs[i], 1, sizeof(Rectangle), rgsFile)
				Next

				' Load font chars info data
				font0.chars = cast(CharInfo Ptr,RAYGUI_CALLOC(font0.charsCount, sizeof(CharInfo)))
				for i As Integer = 0 to font0.charsCount-1

					fread(@font0.chars[i].value, 1, sizeof(integer), rgsFile)
					fread(@font0.chars[i].offsetX, 1, sizeof(integer), rgsFile)
					fread(@font0.chars[i].offsetY, 1, sizeof(integer), rgsFile)
					fread(@font0.chars[i].advanceX, 1, sizeof(integer), rgsFile)
				Next

				GuiSetFont(font0)

				' Set font texture source rectangle to be used as white texture to draw shapes
				' NOTE: This way, all gui can be draw using a single draw call
				if ((whiteRec.width <> 0) AndAlso (whiteRec.height <> 0)) Then SetShapesTexture(font0.texture, whiteRec)
			EndIf
			#endif
		EndIf

		fclose(rgsFile)
	EndIf
End Sub

' Load style default over global style
Sub GuiLoadStyleDefault()

	' We set this variable first to asub cyclic function calls
	' when calling GuiSetStyle() and GuiGetStyle()
	guiStyleLoaded = true

	' Initialize default LIGHT style property values
	GuiSetStyle(DEFAULT, BORDER_COLOR_NORMAL, &h838383ff)
	GuiSetStyle(DEFAULT, BASE_COLOR_NORMAL, &hc9c9c9ff)
	GuiSetStyle(DEFAULT, TEXT_COLOR_NORMAL, &h686868ff)
	GuiSetStyle(DEFAULT, BORDER_COLOR_FOCUSED, &h5bb2d9ff)
	GuiSetStyle(DEFAULT, BASE_COLOR_FOCUSED, &hc9effeff)
	GuiSetStyle(DEFAULT, TEXT_COLOR_FOCUSED, &h6c9bbcff)
	GuiSetStyle(DEFAULT, BORDER_COLOR_PRESSED, &h0492c7ff)
	GuiSetStyle(DEFAULT, BASE_COLOR_PRESSED, &h97e8ffff)
	GuiSetStyle(DEFAULT, TEXT_COLOR_PRESSED, &h368bafff)
	GuiSetStyle(DEFAULT, BORDER_COLOR_DISABLED, &hb5c1c2ff)
	GuiSetStyle(DEFAULT, BASE_COLOR_DISABLED, &he6e9e9ff)
	GuiSetStyle(DEFAULT, TEXT_COLOR_DISABLED, &haeb7b8ff)
	GuiSetStyle(DEFAULT, BORDER_WIDTH, 1)                       ' WARNING: Some controls use other values
	GuiSetStyle(DEFAULT, TEXT_PADDING, 0)                       ' WARNING: Some controls use other values
	GuiSetStyle(DEFAULT, TEXT_ALIGNMENT, GUI_TEXT_ALIGN_CENTER) ' WARNING: Some controls use other values

	' Initialize control-specific property values
	' NOTE: Those properties are in default list but require specific values by control type
	GuiSetStyle(LABEL, TEXT_ALIGNMENT, GUI_TEXT_ALIGN_LEFT)
	GuiSetStyle(BUTTON, BORDER_WIDTH, 2)
	GuiSetStyle(SLIDER, TEXT_PADDING, 5)
	GuiSetStyle(CHECKBOX, TEXT_PADDING, 5)
	GuiSetStyle(CHECKBOX, TEXT_ALIGNMENT, GUI_TEXT_ALIGN_RIGHT)
	GuiSetStyle(TEXTBOX, TEXT_PADDING, 5)
	GuiSetStyle(TEXTBOX, TEXT_ALIGNMENT, GUI_TEXT_ALIGN_LEFT)
	GuiSetStyle(VALUEBOX, TEXT_PADDING, 4)
	GuiSetStyle(VALUEBOX, TEXT_ALIGNMENT, GUI_TEXT_ALIGN_LEFT)
	GuiSetStyle(SPINNER, TEXT_PADDING, 4)
	GuiSetStyle(SPINNER, TEXT_ALIGNMENT, GUI_TEXT_ALIGN_LEFT)
	GuiSetStyle(STATUSBAR, TEXT_PADDING, 6)
	GuiSetStyle(STATUSBAR, TEXT_ALIGNMENT, GUI_TEXT_ALIGN_LEFT)

	' Initialize extended property values
	' NOTE: By default, extended property values are initialized to 0
	GuiSetStyle(DEFAULT, TEXT_SIZE, 10)                ' DEFAULT, shared by all controls
	GuiSetStyle(DEFAULT, TEXT_SPACING, 1)              ' DEFAULT, shared by all controls
	GuiSetStyle(DEFAULT, LINE_COLOR, &h90abb5ff)       ' DEFAULT specific property
	GuiSetStyle(DEFAULT, BACKGROUND_COLOR, &hf5f5f5ff) ' DEFAULT specific property
	GuiSetStyle(TOGGLE, GROUP_PADDING, 2)
	GuiSetStyle(SLIDER, SLIDER_WIDTH, 15)
	GuiSetStyle(SLIDER, SLIDER_PADDING, 1)
	GuiSetStyle(PROGRESSBAR, PROGRESS_PADDING, 1)
	GuiSetStyle(CHECKBOX, CHECK_PADDING, 1)
	GuiSetStyle(COMBOBOX, COMBO_BUTTON_WIDTH, 30)
	GuiSetStyle(COMBOBOX, COMBO_BUTTON_PADDING, 2)
	GuiSetStyle(DROPDOWNBOX, ARROW_PADDING, 16)
	GuiSetStyle(DROPDOWNBOX, DROPDOWN_ITEMS_PADDING, 2)
	GuiSetStyle(TEXTBOX, TEXT_LINES_PADDING, 5)
	GuiSetStyle(TEXTBOX, TEXT_INNER_PADDING, 4)
	GuiSetStyle(TEXTBOX, COLOR_SELECTED_FG, &hf0fffeff)
	GuiSetStyle(TEXTBOX, COLOR_SELECTED_BG, &h839affe0)
	GuiSetStyle(SPINNER, SPIN_BUTTON_WIDTH, 20)
	GuiSetStyle(SPINNER, SPIN_BUTTON_PADDING, 2)
	GuiSetStyle(SCROLLBAR, BORDER_WIDTH, 0)
	GuiSetStyle(SCROLLBAR, ARROWS_VISIBLE, 0)
	GuiSetStyle(SCROLLBAR, ARROWS_SIZE, 6)
	GuiSetStyle(SCROLLBAR, SCROLL_SLIDER_PADDING, 0)
	GuiSetStyle(SCROLLBAR, SCROLL_SLIDER_SIZE, 16)
	GuiSetStyle(SCROLLBAR, SCROLL_PADDING, 0)
	GuiSetStyle(SCROLLBAR, SCROLL_SPEED, 10)
	GuiSetStyle(LISTVIEW, LIST_ITEMS_HEIGHT, &h1e)
	GuiSetStyle(LISTVIEW, LIST_ITEMS_PADDING, 2)
	GuiSetStyle(LISTVIEW, SCROLLBAR_WIDTH, 10)
	GuiSetStyle(LISTVIEW, SCROLLBAR_SIDE, SCROLLBAR_RIGHT_SIDE)
	GuiSetStyle(COLORPICKER, COLOR_SELECTOR_SIZE, 6)
	GuiSetStyle(COLORPICKER, HUEBAR_WIDTH, &h14)
	GuiSetStyle(COLORPICKER, HUEBAR_PADDING, &ha)
	GuiSetStyle(COLORPICKER, HUEBAR_SELECTOR_HEIGHT, 6)
	GuiSetStyle(COLORPICKER, HUEBAR_SELECTOR_OVERFLOW, 2)

	guiFont = GetFontDefault()     ' Initialize default font
End Sub

' Get text with icon id prepended
' NOTE: Useful to add icons by name id (enum) instead of
' a number that can change between ricon versions
Function GuiIconText( iconId as long, text0 As Const zstring Ptr) As Const ZString Ptr

	#if defined(RAYGUI_SUPPORT_ICONS)
	static As ZString*1024 buffer'[1024]
	memset(@buffer, 0, 1023)

	sprintf(buffer, "#%03i#", iconId)
	if (text0 <> NULL) Then

		for i As long  = 5 to 1024 -1

			buffer[i] = text0[i - 5]
			if (text0[i - 5] = Asc(!"\0")) then exit for
		Next
	EndIf

	return @buffer
	#else
	return NULL
	#endif
End function

#if defined(RAYGUI_SUPPORT_ICONS)

' Get full icons data pointer
Function GuiGetIcons()  As ulong Ptr
	return cast( ulong ptr, @guiIcons(0) )
End function
' Load raygui icons file (.rgi)
' NOTE: In case nameIds are required, they can be requested with loadIconsName,
' they are returned as a guiIconsName[iconsCount][RICON_MAX_NAME_LENGTH],
' guiIconsName[]][] memory should be manually freed!
Function GuiLoadIcons( fileName As zstring Ptr,  loadIconsName As boolean) As zstring Ptr Ptr

	' Style File Structure (.rgi)
	' ---------------------------=1
	' Offset  | Size    | Type       | Description
	' ---------------------------=1
	' 0       | 4       | char       | Signature: "rGI "
	' 4       | 2       | short      | Version: 100
	' 6       | 2       | short      | reserved

	' 8       | 2       | short      | Num icons (N)
	' 10      | 2       | short      | Icons size (Options: 16, 32, 64) (S)

	' Icons name id (32 bytes per name id)
	' foreach (icon)
	'
	'   12+32*i  | 32   | char       | Icon NameId
	' }

	' Icons data: One bit per pixel, stored as ulong array (depends on icon size)
	' S*S pixels/32bit per ulong = K ulong per icon
	' foreach (icon)
	'
	'   ...   | K       | ulong | Icon Data
	' }

	Dim As FILE ptr rgiFile = fopen(fileName, "rb")

	Dim As zstring Ptr Ptr guiIconsName = NULL

	if (rgiFile <> NULL) Then

		Dim As ZString*5 signature = ""
		Dim As Short version = 0
		Dim As Short reserved = 0
		Dim As Short iconsCount = 0
		Dim As Short iconsSize = 0

		fread(@signature, 1, 4, rgiFile)
		fread(@version, 1, sizeof(short), rgiFile)
		fread(@reserved, 1, sizeof(short), rgiFile)
		fread(@iconsCount, 1, sizeof(short), rgiFile)
		fread(@iconsSize, 1, sizeof(short), rgiFile)

		if ((signature[0] = Asc("r")) AndAlso _
			(signature[1] = Asc("G")) AndAlso _
			(signature[2] = Asc("I")) AndAlso _
			(signature[3] = Asc(" ")) ) Then

			if (loadIconsName) Then

				guiIconsName = Cast(zstring Ptr ptr,RAYGUI_MALLOC(iconsCount*sizeof(zstring Ptr ptr)))
				for i As long = 0 to iconsCount -1

					guiIconsName[i] = Cast(zstring Ptr,RAYGUI_MALLOC(RICON_MAX_NAME_LENGTH))
					fread(guiIconsName[i], 32, 1, rgiFile)

				Next
			EndIf

			' Read icons data directly over guiIcons data array
			fread(@guiIcons(0), iconsCount*(iconsSize*iconsSize/32), sizeof(ulong), rgiFile)
		EndIf

		fclose(rgiFile)
	End If

	return guiIconsName
End Function

' Draw selected icon using rectangles pixel-by-pixel
Sub GuiDrawIcon( iconId as long, position as Vector2 , pixelSize as long, color0 as Color)

	#define BIT_CHECK(a,b) ((a) and (1 Shl (b)))

	Dim As long y=0
	for i As long = 0 to RICON_SIZE*RICON_SIZE\32-1
		for k As long = 0 to 32

			if (BIT_CHECK(guiIcons(iconId*RICON_DATA_ELEMENTS + i), k)) Then
				#if Not Defined(RAYGUI_STANDALONE)
				DrawRectangle(Int(position.x + (k mod RICON_SIZE)*pixelSize), Int(position.y + y*pixelSize), pixelSize, pixelSize, color0)
				#endif
			EndIf

			if ((k = 15) OrElse (k = 31)) Then y+=1
		Next
	Next
End Sub

' Get icon bit data
' NOTE: Bit data array grouped as ulong (ICON_SIZE*ICON_SIZE/32 elements)
Function GuiGetIconData( iconId as long) As ulong Ptr

	static As ulong iconData(RICON_DATA_ELEMENTS)
	memset(@iconData(0), 0, RICON_DATA_ELEMENTS*sizeof(ulong))

	if (iconId < RICON_MAX_ICONS) Then
		memcpy(@iconData(0), @guiIcons(iconId*RICON_DATA_ELEMENTS), RICON_DATA_ELEMENTS*sizeof(ulong))
	EndIf

	return @iconData(0)
End Function

' Set icon bit data
' NOTE: Data must be provided as ulong array (ICON_SIZE*ICON_SIZE/32 elements)
Sub GuiSetIconData( iconId as long, data0 as ulong ptr)

	if (iconId < RICON_MAX_ICONS) Then
		memcpy(@guiIcons(iconId*RICON_DATA_ELEMENTS), data0, RICON_DATA_ELEMENTS*sizeof(ulong))
	EndIf
End Sub

' Set icon pixel value
Sub GuiSetIconPixel( iconId as long, x as long, y as long)

	#define BIT_SET(a,b)   a=(a Or (1 Shl b))

	' This logic works for any RICON_SIZE pixels icons,
	' For example, in case of 16x16 pixels, every 2 lines fit in one ulong data element
	BIT_SET(guiIcons(iconId*RICON_DATA_ELEMENTS + y\((sizeof(long)*8)\RICON_SIZE)), x + ((y mod (sizeof(long)*8\RICON_SIZE))*RICON_SIZE))
End Sub

' Clear icon pixel value
Sub GuiClearIconPixel( iconId as long, x as long, y as long)

	#define BIT_CLEAR(a,b) a=(a And (not(1 Shl b)))

	' This logic works for any RICON_SIZE pixels icons,
	' For example, in case of 16x16 pixels, every 2 lines fit in one ulong data element
	BIT_CLEAR(guiIcons(iconId*RICON_DATA_ELEMENTS + y/(sizeof(long)*8/RICON_SIZE)), x + (y mod (sizeof(long)*8/RICON_SIZE)*RICON_SIZE))
End Sub

' Check icon pixel value
function GuiCheckIconPixel( iconId as long, x as long, y as long) As boolean

	#define BIT_CHECK(a,b) ((a) and (1 Shl(b)))

	return (BIT_CHECK(guiIcons(iconId*8 + y/2), x + (y mod 2*16)))
End Function
#endif      ' RAYGUI_SUPPORT_ICONS

'-----------------------------------------=1
' Module specific Functions Definition
'-----------------------------------------=1
' Gui get text width using default font
Function GetTextWidth( text0 As Const zstring Ptr) As long

	Dim As Vector2 size

	if ((text0 <> NULL) AndAlso (text0[0] <> 0)) Then size = MeasureTextEx(guiFont, text0, GuiGetStyle(DEFAULT, TEXT_SIZE), GuiGetStyle(DEFAULT, TEXT_SPACING))

	' TODO: Consider text icon width here???

	return Int(size.x)
End function

' Get text bounds considering control bounds
Function GetTextBounds(control0 as long, bounds As Rectangle)As Rectangle

	Dim As Rectangle textBounds
	textBounds = bounds

	textBounds.x = bounds.x + GuiGetStyle(control0, BORDER_WIDTH)
	textBounds.y = bounds.y + GuiGetStyle(control0, BORDER_WIDTH)
	textBounds.width = bounds.width - 2*GuiGetStyle(control0, BORDER_WIDTH)
	textBounds.height = bounds.height - 2*GuiGetStyle(control0, BORDER_WIDTH)

	' Consider TEXT_PADDING properly, depends on control type and TEXT_ALIGNMENT
	Select Case as const (control0)

		case COMBOBOX:
			bounds.width -= (GuiGetStyle(control0, COMBO_BUTTON_WIDTH) + GuiGetStyle(control0, COMBO_BUTTON_PADDING))
		case VALUEBOX:    ' NOTE: ValueBox text value always centered, text padding applies to label
		Case Else:
			if (GuiGetStyle(control0, TEXT_ALIGNMENT) = GUI_TEXT_ALIGN_RIGHT) Then
				textBounds.x -= GuiGetStyle(control0, TEXT_PADDING)
			else
				textBounds.x += GuiGetStyle(control0, TEXT_PADDING)
			EndIf
	End Select

	' TODO: Special cases (no label): COMBOBOX, DROPDOWNBOX, LISTVIEW (scrollbar?)
	' More special cases (label side): CHECKBOX, SLIDER, VALUEBOX, SPINNER

	return textBounds
End Function

' Get text icon if provided and move text cursor
' NOTE: We support up to 999 values for iconId
Function GetTextIcon( text0 As Const zstring Ptr, iconId as long ptr) As Const zstring Ptr

	#if defined(RAYGUI_SUPPORT_ICONS)
	*iconId = -1
	if (text0[0] = Asc("#")) Then     ' Maybe we have an icon!

		Dim As ZString*4 iconValue   ' Maximum length for icon value: 3 digits + asc(!"\0")

		Dim As long pos1 = 1
		while ((text0[pos1]<>Asc("#")) AndAlso (pos1 < 4) andalso ((text0[pos1] >= Asc("0")) andalso (text0[pos1] <= Asc("9"))) )

			iconValue[pos1 - 1] = text0[pos1]
			pos1+=1
		Wend
		if (text0[pos1] = Asc("#")) Then

			*iconId = TextToInteger(iconValue)

			' Move text pointegerer after icon
			' WARNING: If only icon provided, it could pointeger to EOL character!
			if (*iconId >= 0) Then text0 += (pos1 + 1)
		EndIf
	EndIf
	#EndIf
	return text0
End function

' Gui draw text using default font
Sub GuiDrawText( text0 As Const zstring Ptr, bounds As Rectangle, alignment as long, tint as Color)

	#define TEXT_VALIGN_PIXEL_OFFSET(h)  int(h Mod 2)     ' Vertical alignment for pixel perfect

	if ((text0 <> NULL) AndAlso (text0[0] <> asc(!"\0"))) Then

		dim iconId as long = 0
		text0 = GetTextIcon(text0, @iconId)  ' Check text for icon and move cursor

		' Get text position depending on alignment and iconId
		'-----------------------------------------
		#define ICON_TEXT_PADDING   4

		Dim position as Vector2
		position = Vector2( bounds.x, bounds.y )

		' NOTE: We get text size after icon been processed
		Dim As long textWidth
		textWidth = GetTextWidth(text0)
		'textWidth = IIf(textWidth=93,16,textWidth)

		Dim As long textHeight
		textHeight = GuiGetStyle(GuiControl.DEFAULT, GuiDefaultProperty.TEXT_SIZE)

		#if defined(RAYGUI_SUPPORT_ICONS)
		if (iconId >= 0) Then

			' WARNING: If only icon provided, text could be pointing to eof character!
			If ((text0 <> NULL) AndAlso (text0[0] <> Asc(!"\0"))) then textWidth += ICON_TEXT_PADDING

		EndIf
		#endif
		' Check guiTextAlign global variables
		Select Case as const(alignment)

			case GUI_TEXT_ALIGN_LEFT:

				position.x = bounds.x
				position.y = bounds.y + bounds.height/2 - textHeight/2 + TEXT_VALIGN_PIXEL_OFFSET(bounds.height)

			case GUI_TEXT_ALIGN_CENTER:

				position.x = bounds.x + bounds.width/2 - textWidth\2 - TEXT_VALIGN_PIXEL_OFFSET(bounds.width)
				position.y = bounds.y + bounds.height/2 - textHeight/2 + TEXT_VALIGN_PIXEL_OFFSET(bounds.height)

			case GUI_TEXT_ALIGN_RIGHT:

				position.x = bounds.x + bounds.width - textWidth
				position.y = bounds.y + bounds.height/2 - textHeight/2 + TEXT_VALIGN_PIXEL_OFFSET(bounds.height)

			Case Else:
		End Select

		' NOTE: Make sure we get pixel-perfect coordinates,
		' In case of decimals we got weird text positioning
		position.x = Int(position.x)*1.0f
		position.y = int(position.y)*1.0f
		'-----------------------------------------

		' Draw text (with icon if available)
		'-----------------------------------------
		#If defined(RAYGUI_SUPPORT_ICONS)
		if (iconId >= 0) Then
			While iconId>=0
				' WARNING: If only icon provided, text could be pointing to eof character!
				' NOTE: We consider icon height, probably different than text size
				GuiDrawIcon(iconId, Vector2( position.x, bounds.y + bounds.height/2 - RICON_SIZE/2 + TEXT_VALIGN_PIXEL_OFFSET(bounds.height) ), 1, tint)
				'hack
				'GuiDrawIcon(iconId, Vector2( position.x-(RICON_SIZE/2 ), bounds.y + bounds.height/2 - RICON_SIZE/2 + TEXT_VALIGN_PIXEL_OFFSET(bounds.height) ), 1, tint)
				position.x += (RICON_SIZE + ICON_TEXT_PADDING)
				text0=GetTextIcon(text0,@iconId)
			Wend
		EndIf
		#EndIf

		DrawTextEx(guiFont, text0, position, GuiGetStyle(GuiControl.DEFAULT, GuiDefaultProperty.TEXT_SIZE), GuiGetStyle(GuiControl.DEFAULT, GuiDefaultProperty.TEXT_SPACING), tint)
		'DrawTextEx(guiFont, text0, position, 16, 1, tint)
		'DrawText(text0, position.x, position.y, GuiGetStyle(DEFAULT, TEXT_SIZE), BLACK)
		'-----------------------------------------
	EndIf
End sub

' Gui draw rectangle using default raygui plain style with borders
Sub GuiDrawRectangle(rec as Rectangle, borderWidth as long , borderColor as Color , color0 as Color)

	if (color0.a > 0) Then

		' Draw rectangle filled with color
		DrawRectangle(rec.x, rec.y, rec.width, rec.height, color0)
	EndIf

	if (borderWidth > 0) Then

		' Draw rectangle border lines with color
		DrawRectangle(rec.x, rec.y, rec.width, borderWidth, borderColor)
		DrawRectangle(rec.x, rec.y + borderWidth, borderWidth, rec.height - 2*borderWidth, borderColor)
		DrawRectangle(rec.x + rec.width - borderWidth, rec.y + borderWidth, borderWidth, rec.height - 2*borderWidth, borderColor)
		DrawRectangle(rec.x, rec.y + rec.height - borderWidth, rec.width, borderWidth, borderColor)
	EndIf

	' TODO: For n-patch-based style we would need: [state] and maybe [control]
	' In this case all controls drawing logic should be moved to this function... I don't like it...
End Sub

' Draw tooltip relatively to bounds
Sub GuiDrawTooltip(bounds As Rectangle)

	'static As long tooltipFramesCounter = 0  ' Not possible gets reseted at second function call!

	if ((guiTooltipEnabled=TRUE) andalso (guiTooltip <> NULL)) Then
		if (CheckCollisionPointRec(GetMousePosition(), bounds)) Then

			Dim As Vector2 mousePosition = GetMousePosition()
			Dim As Vector2 textSize = MeasureTextEx(guiFont, guiTooltip, GuiGetStyle(DEFAULT, TEXT_SIZE), GuiGetStyle(DEFAULT, TEXT_SPACING))
			Dim As Rectangle tooltipBounds = Rectangle ( mousePosition.x, mousePosition.y, textSize.x + 20, textSize.y*2 )

			GuiDrawRectangle(tooltipBounds, 1, Fade(GetColor(GuiGetStyle(DEFAULT, LINE_COLOR)), guiAlpha), Fade(GetColor(GuiGetStyle(DEFAULT, BACKGROUND_COLOR)), guiAlpha))

			tooltipBounds.x += 10
			GuiLabel(tooltipBounds, guiTooltip)
		endif
	EndIf
End Sub

' Split controls text integero multiple strings
' Also check for multiple columns (required by GuiToggleGroup())
Function GuiTextSplit( text0 As Const zstring Ptr, count0 as long Ptr, textRow as long ptr)As Const UByte Ptr Ptr 'Static

	' NOTE: Current implementation returns a copy of the provided string with '\0' (string end delimiter)
	' inserted between strings defined by "delimiter" parameter. No memory is dynamically allocated,
	' all used memory is static... it has some limitations:
	'      1. Maximum number of possible split strings is set by TEXTSPLIT_MAX_TEXT_ELEMENTS
	'      2. Maximum size of text to split is TEXTSPLIT_MAX_TEXT_LENGTH
	' NOTE: Those definitions could be externally provided if required

	#if Not Defined(TEXTSPLIT_MAX_TEXT_LENGTH)
	#define TEXTSPLIT_MAX_TEXT_LENGTH      1024
	#endif

	#if Not Defined(TEXTSPLIT_MAX_TEXT_ELEMENTS)
	#define TEXTSPLIT_MAX_TEXT_ELEMENTS     128
	#endif

	static As UByte Ptr result(TEXTSPLIT_MAX_TEXT_ELEMENTS) = {NULL}
	static As UByte buffer(TEXTSPLIT_MAX_TEXT_LENGTH)
	memset(@buffer(0), 0, TEXTSPLIT_MAX_TEXT_LENGTH)

	result(0) = @buffer(0)
	dim as long counter = 1

	if (textRow <> NULL) Then textRow[0] = 0

	' Count how many substrings we have on text and point to every one
	for i As ulong = 0 to TEXTSPLIT_MAX_TEXT_LENGTH-1

		buffer(i) = text0[i]
		if (buffer(i) = 0) Then
			Exit For
		ElseIf ((buffer(i) = Asc(";")) orelse (buffer(i) = Asc(!"\n"))) then

			result(counter) = @buffer ( i + 1)

			if (textRow <> NULL) Then

				if (buffer(i) = Asc(!"\n")) then
					textRow[counter] = textRow[counter - 1] + 1
				else
					textRow[counter] = textRow[counter - 1]
				EndIf
			EndIf

			buffer(i) = 0   ' Set an end of string at this pointeger

			counter+=1
			if (counter = TEXTSPLIT_MAX_TEXT_ELEMENTS) Then
				Exit For
			EndIf
		EndIf
	Next
	*count0 = counter
	Return @result(0)

End Function

' Convert color data from RGB to HSV
' NOTE: Color data should be passed normalized
function ConvertRGBtoHSV(rgb0 as Vector3)As Vector3

	Dim hsv as Vector3
	Dim As Single min = 0.0f
	Dim As Single max = 0.0f
	Dim As Single delta = 0.0f

	min = iif(rgb0.x < rgb0.y, rgb0.x , rgb0.y)
	min = iif(min < rgb0.z, min  , rgb0.z)

	max = iif(rgb0.x > rgb0.y, rgb0.x , rgb0.y)
	max = iif(max > rgb0.z, max  , rgb0.z)

	hsv.z = max            ' Value
	delta = max - min

	if (delta < 0.00001f) Then

		hsv.y = 0.0f
		hsv.x = 0.0f       ' Undefined, maybe NAN?
		return hsv
	EndIf

	if (max > 0.0f) Then

		' NOTE: If max is 0, this divide would cause a crash
		hsv.y = (delta/(max))    ' Saturation

	else

		' NOTE: If max is 0, then r = g = b = 0, s = 0, h is undefined
		hsv.y = 0.0f
		hsv.x = 0.0f        ' Undefined, maybe NAN?
		return hsv
	endif

	' NOTE: Comparing value as singles could not work properly
	if (rgb0.x >= max) Then
		hsv.x = (rgb0.y - rgb0.z)/delta    ' Between yellow & magenta
	else

		if (rgb0.y >= max) Then
			hsv.x = 2.0f + (rgb0.z - rgb0.x)/delta  ' Between cyan & yellow
		else
			hsv.x = 4.0f + (rgb0.x - rgb0.y)/delta      ' Between magenta & cyan
		EndIf
	EndIf

	hsv.x *= 60.0f     ' Convert to degrees

	if (hsv.x < 0.0f) Then hsv.x += 360.0f
	if (hsv.x >= 360.0f) Then hsv.x -= 360.0f

	return hsv
End function

' Convert color data from HSV to RGB
' NOTE: Color data should be passed normalized
Function ConvertHSVtoRGB(hsv as Vector3) As Vector3

	Dim RGB0 as Vector3
	Dim As Single hh = 0.0f, p = 0.0f, q = 0.0f, t = 0.0f, ff = 0.0f
	Dim As Long i = 0

	' NOTE: Comparing value as singles could not work properly
	if (hsv.y <= 0.0f) Then

		rgb0.x = hsv.z
		rgb0.y = hsv.z
		rgb0.z = hsv.z
		return rgb0
	EndIf

	hh = hsv.x
	if (hh < 0.0f) Then hh += 360.0f
	If (hh >= 360.0f) Then hh -= 360.0f
	hh /= 60.0f

	i = fix(hh)
	ff = frac(hh)' - i)
	p = hsv.z*(1.0f - hsv.y)
	q = hsv.z*(1.0f - (hsv.y*ff))
	t = hsv.z*(1.0f - (hsv.y*(1.0f - ff)))
	'Print i
	Select Case as const(i)

		case 0:

			rgb0.x = hsv.z
			rgb0.y = t
			rgb0.z = p

		case 1:

			rgb0.x = q
			rgb0.y = hsv.z
			rgb0.z = p

		case 2:

			rgb0.x = p
			rgb0.y = hsv.z
			rgb0.z = t

		case 3:

			rgb0.x = p
			rgb0.y = q
			rgb0.z = hsv.z

		case 4:

			rgb0.x = t
			rgb0.y = p
			rgb0.z = hsv.z

		'case 5:
		Case Else:

			rgb0.x = hsv.z
			rgb0.y = p
			rgb0.z = q

	End Select

	return rgb0
End Function

#if defined(RAYGUI_STANDALONE)
' Returns a Color struct from hexadecimal value
Function GetColor(hexValue As long) As Color

	Dim color0 as Color

	color0.r = (UByte)(hexValue >> 24) And &hFF
	color0.g = (UByte)(hexValue >> 16) And &hFF
	color0.b = (UByte)(hexValue >> 8) And &hFF
	color0.a = (UByte)hexValue And &hFF

	return color0
End Function

' Returns hexadecimal value for a Color
Function ColorToInt(color0 as Color) As long

	return ((color0.r Shl 24) or (color.g shl 16) or (color0.b shl 8) or color0.a)
End Function

' Check if pointeger is inside rectangle
Function CheckCollisionPointRec(point0 As Vector2 , rec as Rectangle) As boolean

	Dim As boolean collision = false

	if ((point0.x >= rec.x) andalso (point0.x <= (rec.x + rec.width)) AndAlso _
	(point0.y >= rec.y) AndAlso (point0.y <= (rec.y + rec.height))) Then collision = true

	return collision
End Function

' Color fade-in or fade-out, alpha goes from 0.0f to 1.0f
Function Fade(color0 as Color, alpha0 as Single) As Color

	if (alpha0 < 0.0f) Then
		alpha0 = 0.0f
	elseif (alpha0 > 1.0f) Then
		alpha0 = 1.0f
	EndIf
	Dim As Color result =  Color(color0.r, color0.g, color0.b, int(255.0f*alpha) )

	return result
End Function

' Formatting of text with variables to 'embed'
Function textFormat( text As Const zstring Ptr, ...) As Const zstring Ptr

	#define MAX_FORMATTEXT_LENGTH   64

	static ubyte buffer(MAX_FORMATTEXT_LENGTH)

	va_list args
	va_start(args, text)
	vsprintegerf(buffer, text, args)
	va_end(args)

	return buffer
End Function

' Draw rectangle with vertical gradient fill color
' NOTE: This function is only used by GuiColorPicker()
sub DrawRectangleGradientV(posX As long,posY long, width0 As long,height As long, color1 as Color, color2 as Color)

	bounds As Rectangle = Rectangle( posX, posY, width0, height )
	DrawRectangleGradientEx(bounds, color1, color2, color2, color1)
End sub

#define TEXTSPLIT_MAX_TEXT_BUFFER_LENGTH    1024        ' Size of static buffer: TextSplit()
#define TEXTSPLIT_MAX_SUBSTRINGS_COUNT       128        ' Size of static pointegerers array: TextSplit()


' Split string integero multiple strings
function TextSplit( text0 As Const zstring Ptr, delimiter As zstring , count as long ptr) As Const zstring Ptr ptr

' NOTE: Current implementation returns a copy of the provided string with '\0' (string end delimiter)
' inserted between strings defined by "delimiter" parameter. No memory is dynamically allocated,
' all used memory is static... it has some limitations:
'      1. Maximum number of possible split strings is set by TEXTSPLIT_MAX_SUBSTRINGS_COUNT
'      2. Maximum size of text to split is TEXTSPLIT_MAX_TEXT_BUFFER_LENGTH

static  As Const zstring Ptr result(TEXTSPLIT_MAX_SUBSTRINGS_COUNT)
static As ZString*TEXTSPLIT_MAX_TEXT_BUFFER_LENGTH buffer
memset(buffer, 0, TEXTSPLIT_MAX_TEXT_BUFFER_LENGTH)

result[0] = buffer
Dim counter as long  = 0

if (text <> NULL) Then

counter = 1

' Count how many substrings we have on text and pointeger to every one
for i As long = 0 to TEXTSPLIT_MAX_TEXT_BUFFER_LENGTH -1

buffer[i] = text[i]
if (buffer[i] = 0) Then Exit for
elseif (buffer[i] = delimiter) Then

buffer[i] = 0   ' Set an end of string at this pointeger
result(counter) = buffer + i + 1
counter+=1

if (counter = TEXTSPLIT_MAX_SUBSTRINGS_COUNT) Then Exit For
EndIf
Next
EndIf

*count = counter
return @result(0)
End Function

' Get integereger value from text
' NOTE: This function replaces atoi() [stdlib.h]
Function  TextToInteger( text As Const zstring Ptr) As long

	Dim value as long = 0
	Dim As long sign = 1

	if ((text[0] = '+') orelse (text[0] = '-')) then

		if (text[0] = '-') then sign = -1
		text+=1
	EndIf

	while ((text[i] >= Asc("0")) andalso (text[i] <= Asc("9")))
		value = value*10 + (text[i] - Asc("0"))
	Wend
	return value*sign
End Function

' Encode codepointeger integero utf8 text (char array length returned as parameter)
function CodepointToUtf8(codepoint As long , byteLength As long ptr)As Const zstring Ptr

	static As ZString*6 utf8
	Dim As long length = 0

	if (codepointeger <= &h7f) Then

		utf8[0] = codepoint
		length = 1

	ElseIf (codepointeger <= &h7ff) Then

		utf8[0] = (char)(((codepoint shr 6) and &h1f) Or &hc0)
		utf8[1] = (char)((codepoint And &h3f) or &h80)
		length = 2

	ElseIf (codepointeger <= &hffff) Then

		utf8[0] = (char)(((codepointeger shr 12) And &h0f) Or &he0)
		utf8[1] = (char)(((codepointeger Shr  6) And &h3f) Or &h80)
		utf8[2] = (char)((codepointeger And &h3f) Or &h80)
		length = 3

	ElseIf (codepointeger <= &h10ffff)

		utf8[0] = (char)(((codepointeger >> 18) And &h07) Or &hf0)
		utf8[1] = (char)(((codepointeger >> 12) And &h3f) Or &h80)
		utf8[2] = (char)(((codepointeger >>  6) And &h3f) or &h80)
		utf8[3] = (char)((codepointeger And &h3f) or &h80)
		length = 4
	EndIf

	*byteLength = length

	return utf8
End Function
#endif      ' RAYGUI_STANDALONE

#endif      ' RAYGUI_IMPLEMENTATION

#if defined(__cplusplus)
' Prevents name mangling of functions
#endif
