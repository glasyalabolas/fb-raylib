/'*******************************************************************************************
*
*   raygui - controls test suite
*
*   TEST CONTROLS:
*       - GuiDropdownBox()
*       - GuiCheckBox()
*       - GuiSpinner()
*       - GuiValueBox()
*       - GuiTextBox()
*       - GuiButton()
*       - GuiComboBox()
*       - GuiListView()
*       - GuiToggleGroup()
*       - GuiTextBoxMulti()
*       - GuiColorPicker()
*       - GuiSlider()
*       - GuiSliderBar()
*       - GuiProgressBar()
*       - GuiColorBarAlpha()
*       - GuiScrollPanel()
*
*
*   DEPENDENCIES:
*       raylib 3.5-dev  - Windowing/input management and drawing.
*       raygui 2.6-dev  - Immediate-mode GUI controls.
*
*   COMPILATION (Windows - MinGW):
*       gcc -o $(NAME_PART).exe $(FILE_NAME) -I../../src -lraylib -lopengl32 -lgdi32 -std=c99
*
*   LICENSE: zlib/libpng
*
*   Copyright (c) 2020 Ramon Santamaria (@raysan5)
*
**********************************************************************************************'/

#include "../raylib.bi"

#define RAYGUI_IMPLEMENTATION
#define RAYGUI_SUPPORT_ICONS
#include "../raygui.bi"

#undef RAYGUI_IMPLEMENTATION            '' Avoid including raygui implementation again

'' Initialization
dim as long _
  screenWidth = 690, screenHeight = 560

InitWindow( screenWidth, screenHeight, "raygui - controls test suite" )
SetExitKey( 0 )

'' GUI controls initialization
dim as long dropdownBox000Active = 0
dim as bool dropDown000EditMode = false

dim as long dropdownBox001Active = 0
dim as bool dropDown001EditMode = false    

dim as long spinner001Value = 0
dim as bool spinnerEditMode = false

dim as long valueBox002Value = 0
dim as bool valueBoxEditMode = false

dim as string textBoxText = "Text box"
dim as bool textBoxEditMode = false

dim as long listViewScrollIndex = 0
dim as long listViewActive = -1

dim as long listViewExScrollIndex = 0
dim as long listViewExActive = 2
dim as long listViewExFocus = -1
dim as string listViewExList( ... ) = { "This", "is", "a", "list view", "with", "disable", "elements", "amazing!" }

dim as string multiTextBoxText = "Multi text box"
dim as bool multiTextBoxEditMode = false
dim as RayColor colorPickerValue = RAYRED

dim as long sliderValue = 50
dim as long sliderBarValue = 60
dim as single progressValue = 0.4f

dim as bool forceSquaredChecked = false

dim as single alphaValue = 0.5f

dim as long comboBoxActive = 1

dim as long toggleGroupActive = 0

dim as Vector2 viewScroll

dim as bool exitWindow = false
dim as bool showMessageBox = false

dim as string textInput
dim as bool showTextInputBox = false

dim as string textInputFileName

SetTargetFPS( 60 )

'' Main game loop
do while( not exitWindow )
  '' Update
  exitWindow = WindowShouldClose()
  
  if( IsKeyPressed( KEY_ESCAPE ) ) then showMessageBox xor= true
  if( IsKeyDown( KEY_LEFT_CONTROL ) andAlso IsKeyPressed( KEY_S ) ) then showTextInputBox = true
  
  if( IsFileDropped() ) then
    dim as long dropsCount = 0
    dim as zstring ptr ptr droppedFiles = GetDroppedFiles( @dropsCount )
    
    if( ( dropsCount > 0 ) andAlso IsFileExtension( droppedFiles[ 0 ], ".rgs" ) ) then
      GuiLoadStyle( droppedFiles[ 0 ] )
    end if
    
    ClearDroppedFiles()
  end if
  
  '' Draw
  BeginDrawing()
    ClearBackground( GetColor( GuiGetStyle( DEFAULT, BACKGROUND_COLOR ) ) )
    
    '' raygui: controls drawing
    if( dropDown000EditMode orElse dropDown001EditMode ) then GuiLock()
    
    '' First GUI column
    forceSquaredChecked = GuiCheckBox( Rectangle( 25, 108, 15, 15 ), "FORCE CHECK!", forceSquaredChecked )
    
    GuiSetStyle( TEXTBOX, TEXT_ALIGNMENT, GUI_TEXT_ALIGN_CENTER )
    
    if( GuiSpinner( Rectangle( 25, 135, 125, 30 ), NULL, @spinner001Value, 0, 100, spinnerEditMode ) ) then spinnerEditMode xor= true
    if( GuiValueBox( Rectangle( 25, 175, 125, 30 ), NULL, @valueBox002Value, 0, 100, valueBoxEditMode ) ) then valueBoxEditMode xor= true
    
    GuiSetStyle( TEXTBOX, TEXT_ALIGNMENT, GUI_TEXT_ALIGN_LEFT )
    if( GuiTextBox( Rectangle( 25, 215, 125, 30 ), textBoxText, 64, textBoxEditMode ) ) then textBoxEditMode xor= true
    
    GuiSetStyle( BUTTON, TEXT_ALIGNMENT, GUI_TEXT_ALIGN_CENTER )
    GuiSetTooltip( "Save current file" )
    
    if( GuiButton( Rectangle( 25, 255, 125, 30 ), GuiIconText( RICON_FILE_SAVE, "Save File" ) ) ) then showTextInputBox = true
    GuiClearTooltip()
    
    GuiGroupBox( Rectangle( 25, 310, 125, 150 ), "STATES" )
    GuiLock()
    GuiSetState( GUI_STATE_NORMAL ) : if( GuiButton( Rectangle( 30, 320, 115, 30 ), "NORMAL" ) ) then end if
    GuiSetState( GUI_STATE_FOCUSED ) : if( GuiButton( Rectangle( 30, 355, 115, 30 ), "FOCUSED" ) ) then end if
    GuiSetState( GUI_STATE_PRESSED ) : if( GuiButton( Rectangle( 30, 390, 115, 30 ), "#15#PRESSED" ) ) then end if
    GuiSetState( GUI_STATE_DISABLED ) : if( GuiButton( Rectangle( 30, 425, 115, 30 ), "DISABLED" ) ) then end if
    GuiSetState( GUI_STATE_NORMAL )
    GuiUnlock()
    
    comboBoxActive = GuiComboBox( Rectangle( 25, 470, 125, 30 ), "ONE;TWO;THREE;FOUR", comboBoxActive )
    
    '' NOTE: GuiDropdownBox must draw after any other control that can be covered on unfolding
    GuiSetStyle( DROPDOWNBOX, TEXT_ALIGNMENT, GUI_TEXT_ALIGN_LEFT )
    if( GuiDropdownBox( Rectangle( 25, 65, 125, 30 ), !"#01#ONE;#02#TWO;#03#THREE;#04#FOUR", @dropdownBox001Active, dropDown001EditMode) ) then dropDown001EditMode xor= true
    
    GuiSetStyle( DROPDOWNBOX, TEXT_ALIGNMENT, GUI_TEXT_ALIGN_CENTER )
    if( GuiDropdownBox( Rectangle( 25, 25, 125, 30 ), !"ONE;TWO;THREE", @dropdownBox000Active, dropDown000EditMode ) ) then dropDown000EditMode xor= true
    
    '' Second GUI column
    listViewActive = GuiListView( Rectangle( 165, 25, 140, 140 ), !"Charmander;Bulbasaur;#18#Squirtel;Pikachu;Eevee;Pidgey", @listViewScrollIndex, listViewActive )
    
    toggleGroupActive = GuiToggleGroup( Rectangle( 165, 400, 140, 25 ), !"#1#ONE\n#3#TWO\n#8#THREE\n#23#", toggleGroupActive )
    
    '' Third GUI column
    if( GuiTextBoxMulti( Rectangle( 320, 25, 225, 140 ), multiTextBoxText, 256, multiTextBoxEditMode ) ) then multiTextBoxEditMode xor= true
    colorPickerValue = GuiColorPicker( Rectangle( 320, 185, 196, 192 ), colorPickerValue )
    
    sliderValue = GuiSlider( Rectangle( 355, 400, 165, 20 ), "TEST", TextFormat( "%2.2f", csng( sliderValue ) ), sliderValue, -50, 100 )
    sliderBarValue = GuiSliderBar( Rectangle( 320, 430, 200, 20 ), NULL, TextFormat( "%i", clng( sliderBarValue) ), sliderBarValue, 0, 100 )
    progressValue = GuiProgressBar( Rectangle( 320, 460, 200, 20 ), NULL, NULL, progressValue, 0, 1 )
    
    '' NOTE: View rectangle could be used to perform some scissor test
    dim as Rectangle view_ = GuiScrollPanel( Rectangle( 560, 25, 100, 160 ), Rectangle( 560, 25, 200, 400 ), @viewScroll )
    
    GuiStatusBar( Rectangle( 0, GetScreenHeight() - 20, GetScreenWidth(), 20 ), "This is a status bar" )
    
    alphaValue = GuiColorBarAlpha( Rectangle( 320, 490, 200, 30 ), alphaValue )
    
    if( showMessageBox ) then
      DrawRectangle( 0, 0, GetScreenWidth(), GetScreenHeight(), Fade( RAYWHITE, 0.8f ) )
      dim as long result = GuiMessageBox( Rectangle( GetScreenWidth() / 2 - 125, GetScreenHeight() / 2 - 50, 250, 100 ), GuiIconText( RICON_EXIT, "Close Window" ), "Do you really want to exit?", "Yes;No" ) 
      
      if( ( result = 0 ) orElse ( result = 2 ) ) then
        showMessageBox = false
      elseif( result = 1 ) then
        exitWindow = true
      end if
    end if
    
    if( showTextInputBox ) then
      DrawRectangle( 0, 0, GetScreenWidth(), GetScreenHeight(), Fade( RAYWHITE, 0.8f ) )
      dim as long result = GuiTextInputBox( Rectangle( GetScreenWidth() / 2 - 120, GetScreenHeight() / 2 - 60, 240, 140 ), GuiIconText( RICON_FILE_SAVE, "Save file as..." ), "Introduce a save file name", "Ok;Cancel", textInput )
      
      if( result = 1 ) then
        '' TODO: Validate textInput value and save
        
        textInput = textInputFileName
      end if
      
      if( ( result = 0 ) orElse ( result = 1 ) orElse ( result = 2 ) ) then 
        showTextInputBox = false
        textInput = ""
      end if
    end if
    
    GuiUnlock()
  EndDrawing()
loop

'' De-Initialization
CloseWindow()
