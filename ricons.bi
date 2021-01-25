/'*********************************************************************************************
*
*   rIcons - Icons pack intended for tools development with raygui
*
*   LICENSE: zlib/libpng
*
*   Copyright (c) 2019-2020 Ramon Santamaria (@raysan5)
*
*********************************************************************************************'/

#ifndef RICONS_BI
#define RICONS_BI

'----------------------------------------------------------------------------------
' Defines and Macros
'----------------------------------------------------------------------------------
#define RICON_MAX_ICONS         256       ' Maximum number of icons
#define RICON_SIZE               16       ' Size of icons (squared)

#define RICON_MAX_NAME_LENGTH    32       ' Maximum length of icon name id

' Icons data is defined by bit array (every bit represents one pixel)
' Those arrays are stored as unsigned int data arrays, so every array
' element defines 32 pixels (bits) of information
' Number of elemens depend on RICON_SIZE (by default 16x16 pixels)
#define RICON_DATA_ELEMENTS   (RICON_SIZE*RICON_SIZE\32)

'----------------------------------------------------------------------------------
' Icons enumeration
'----------------------------------------------------------------------------------
enum guiIconName
RIC0ON_NONE                     = 0,
RICON_FOLDER_FILE_OPEN         = 1,
RICON_FILE_SAVE_CLASSIC        = 2,
RICON_FOLDER_OPEN              = 3,
RICON_FOLDER_SAVE              = 4,
RICON_FILE_OPEN                = 5,
RICON_FILE_SAVE                = 6,
RICON_FILE_EXPORT              = 7,
RICON_FILE_NEW                 = 8,
RICON_FILE_DELETE              = 9,
RICON_FILETYPE_TEXT            = 10,
RICON_FILETYPE_AUDIO           = 11,
RICON_FILETYPE_IMAGE           = 12,
RICON_FILETYPE_PLAY            = 13,
RICON_FILETYPE_VIDEO           = 14,
RICON_FILETYPE_INFO            = 15,
RICON_FILE_COPY                = 16,
RICON_FILE_CUT                 = 17,
RICON_FILE_PASTE               = 18,
RICON_CURSOR_HAND              = 19,
RICON_CURSOR_POINTER           = 20,
RICON_CURSOR_CLASSIC           = 21,
RICON_PENCIL                   = 22,
RICON_PENCIL_BIG               = 23,
RICON_BRUSH_CLASSIC            = 24,
RICON_BRUSH_PAINTER            = 25,
RICON_WATER_DROP               = 26,
RICON_COLOR_PICKER             = 27,
RICON_RUBBER                   = 28,
RICON_COLOR_BUCKET             = 29,
RICON_TEXT_T                   = 30,
RICON_TEXT_A                   = 31,
RICON_SCALE                    = 32,
RICON_RESIZE                   = 33,
RICON_FILTER_POINT             = 34,
RICON_FILTER_BILINEAR          = 35,
RICON_CROP                     = 36,
RICON_CROP_ALPHA               = 37,
RICON_SQUARE_TOGGLE            = 38,
RICON_SYMMETRY                 = 39,
RICON_SYMMETRY_HORIZONTAL      = 40,
RICON_SYMMETRY_VERTICAL        = 41,
RICON_LENS                     = 42,
RICON_LENS_BIG                 = 43,
RICON_EYE_ON                   = 44,
RICON_EYE_OFF                  = 45,
RICON_FILTER_TOP               = 46,
RICON_FILTER                   = 47,
RICON_TARGET_POINT             = 48,
RICON_TARGET_SMALL             = 49,
RICON_TARGET_BIG               = 50,
RICON_TARGET_MOVE              = 51,
RICON_CURSOR_MOVE              = 52,
RICON_CURSOR_SCALE             = 53,
RICON_CURSOR_SCALE_RIGHT       = 54,
RICON_CURSOR_SCALE_LEFT        = 55,
RICON_UNDO                     = 56,
RICON_REDO                     = 57,
RICON_REREDO                   = 58,
RICON_MUTATE                   = 59,
RICON_ROTATE                   = 60,
RICON_REPEAT                   = 61,
RICON_SHUFFLE                  = 62,
RICON_EMPTYBOX                 = 63,
RICON_TARGET                   = 64,
RICON_TARGET_SMALL_FILL        = 65,
RICON_TARGET_BIG_FILL          = 66,
RICON_TARGET_MOVE_FILL         = 67,
RICON_CURSOR_MOVE_FILL         = 68,
RICON_CURSOR_SCALE_FILL        = 69,
RICON_CURSOR_SCALE_RIGHT_FILL  = 70,
RICON_CURSOR_SCALE_LEFT_FILL   = 71,
RICON_UNDO_FILL                = 72,
RICON_REDO_FILL                = 73,
RICON_REREDO_FILL              = 74,
RICON_MUTATE_FILL              = 75,
RICON_ROTATE_FILL              = 76,
RICON_REPEAT_FILL              = 77,
RICON_SHUFFLE_FILL             = 78,
RICON_EMPTYBOX_SMALL           = 79,
RICON_BOX                      = 80,
RICON_BOX_TOP                  = 81,
RICON_BOX_TOP_RIGHT            = 82,
RICON_BOX_RIGHT                = 83,
RICON_BOX_BOTTOM_RIGHT         = 84,
RICON_BOX_BOTTOM               = 85,
RICON_BOX_BOTTOM_LEFT          = 86,
RICON_BOX_LEFT                 = 87,
RICON_BOX_TOP_LEFT             = 88,
RICON_BOX_CENTER               = 89,
RICON_BOX_CIRCLE_MASK          = 90,
RICON_POT                      = 91,
RICON_ALPHA_MULTIPLY           = 92,
RICON_ALPHA_CLEAR              = 93,
RICON_DITHERING                = 94,
RICON_MIPMAPS                  = 95,
RICON_BOX_GRID                 = 96,
RICON_GRID                     = 97,
RICON_BOX_CORNERS_SMALL        = 98,
RICON_BOX_CORNERS_BIG          = 99,
RICON_FOUR_BOXES               = 100,
RICON_GRID_FILL                = 101,
RICON_BOX_MULTISIZE            = 102,
RICON_ZOOM_SMALL               = 103,
RICON_ZOOM_MEDIUM              = 104,
RICON_ZOOM_BIG                 = 105,
RICON_ZOOM_ALL                 = 106,
RICON_ZOOM_CENTER              = 107,
RICON_BOX_DOTS_SMALL           = 108,
RICON_BOX_DOTS_BIG             = 109,
RICON_BOX_CONCENTRIC           = 110,
RICON_BOX_GRID_BIG             = 111,
RICON_OK_TICK                  = 112,
RICON_CROSS                    = 113,
RICON_ARROW_LEFT               = 114,
RICON_ARROW_RIGHT              = 115,
RICON_ARROW_BOTTOM             = 116,
RICON_ARROW_TOP                = 117,
RICON_ARROW_LEFT_FILL          = 118,
RICON_ARROW_RIGHT_FILL         = 119,
RICON_ARROW_BOTTOM_FILL        = 120,
RICON_ARROW_TOP_FILL           = 121,
RICON_AUDIO                    = 122,
RICON_FX                       = 123,
RICON_WAVE                     = 124,
RICON_WAVE_SINUS               = 125,
RICON_WAVE_SQUARE              = 126,
RICON_WAVE_TRIANGULAR          = 127,
RICON_CROSS_SMALL              = 128,
RICON_PLAYER_PREVIOUS          = 129,
RICON_PLAYER_PLAY_BACK         = 130,
RICON_PLAYER_PLAY              = 131,
RICON_PLAYER_PAUSE             = 132,
RICON_PLAYER_STOP              = 133,
RICON_PLAYER_NEXT              = 134,
RICON_PLAYER_RECORD            = 135,
RICON_MAGNET                   = 136,
RICON_LOCK_CLOSE               = 137,
RICON_LOCK_OPEN                = 138,
RICON_CLOCK                    = 139,
RICON_TOOLS                    = 140,
RICON_GEAR                     = 141,
RICON_GEAR_BIG                 = 142,
RICON_BIN                      = 143,
RICON_HAND_POINTER             = 144,
RICON_LASER                    = 145,
RICON_COIN                     = 146,
RICON_EXPLOSION                = 147,
RICON_1UP                      = 148,
RICON_PLAYER                   = 149,
RICON_PLAYER_JUMP              = 150,
RICON_KEY                      = 151,
RICON_DEMON                    = 152,
RICON_TEXT_POPUP               = 153,
RICON_GEAR_EX                  = 154,
RICON_CRACK                    = 155,
RICON_CRACK_POINTS             = 156,
RICON_STAR                     = 157,
RICON_DOOR                     = 158,
RICON_EXIT                     = 159,
RICON_MODE_2D                  = 160,
RICON_MODE_3D                  = 161,
RICON_CUBE                     = 162,
RICON_CUBE_FACE_TOP            = 163,
RICON_CUBE_FACE_LEFT           = 164,
RICON_CUBE_FACE_FRONT          = 165,
RICON_CUBE_FACE_BOTTOM         = 166,
RICON_CUBE_FACE_RIGHT          = 167,
RICON_CUBE_FACE_BACK           = 168,
RICON_CAMERA                   = 169,
RICON_SPECIAL                  = 170,
RICON_LINK_NET                 = 171,
RICON_LINK_BOXES               = 172,
RICON_LINK_MULTI               = 173,
RICON_LINK                     = 174,
RICON_LINK_BROKE               = 175,
RICON_TEXT_NOTES               = 176,
RICON_NOTEBOOK                 = 177,
RICON_SUITCASE                 = 178,
RICON_SUITCASE_ZIP             = 179,
RICON_MAILBOX                  = 180,
RICON_MONITOR                  = 181,
RICON_PRINTER                  = 182,
RICON_PHOTO_CAMERA             = 183,
RICON_PHOTO_CAMERA_FLASH       = 184,
RICON_HOUSE                    = 185,
RICON_HEART                    = 186,
RICON_CORNER                   = 187,
RICON_VERTICAL_BARS            = 188,
RICON_VERTICAL_BARS_FILL       = 189,
RICON_LIFE_BARS                = 190,
RICON_INFO                     = 191,
RICON_CROSSLINE                = 192,
RICON_HELP                     = 193,
RICON_FILETYPE_ALPHA           = 194,
RICON_FILETYPE_HOME            = 195,
RICON_LAYERS_VISIBLE           = 196,
RICON_LAYERS                   = 197,
RICON_WINDOW                   = 198,
RICON_HIDPI                    = 199,
RICON_200                      = 200,
RICON_201                      = 201,
RICON_202                      = 202,
RICON_203                      = 203,
RICON_204                      = 204,
RICON_205                      = 205,
RICON_206                      = 206,
RICON_207                      = 207,
RICON_208                      = 208,
RICON_209                      = 209,
RICON_210                      = 210,
RICON_211                      = 211,
RICON_212                      = 212,
RICON_213                      = 213,
RICON_214                      = 214,
RICON_215                      = 215,
RICON_216                      = 216,
RICON_217                      = 217,
RICON_218                      = 218,
RICON_219                      = 219,
RICON_220                      = 220,
RICON_221                      = 221,
RICON_222                      = 222,
RICON_223                      = 223,
RICON_224                      = 224,
RICON_225                      = 225,
RICON_226                      = 226,
RICON_227                      = 227,
RICON_228                      = 228,
RICON_229                      = 229,
RICON_230                      = 230,
RICON_231                      = 231,
RICON_232                      = 232,
RICON_233                      = 233,
RICON_234                      = 234,
RICON_235                      = 235,
RICON_236                      = 236,
RICON_237                      = 237,
RICON_238                      = 238,
RICON_239                      = 239,
RICON_240                      = 240,
RICON_241                      = 241,
RICON_242                      = 242,
RICON_243                      = 243,
RICON_244                      = 244,
RICON_245                      = 245,
RICON_246                      = 246,
RICON_247                      = 247,
RICON_248                      = 248,
RICON_249                      = 249,
RICON_250                      = 250,
RICON_251                      = 251,
RICON_252                      = 252,
RICON_253                      = 253,
RICON_254                      = 254,
RICON_255                      = 255,
End enum

#endif  ' RICONS_H

#if defined(RICONS_IMPLEMENTATION)
'----------------------------------------------------------------------------------
' Icons data (allocated on memory data section by default)
' NOTE: A new icon set could be loaded over this array using GuiLoadIcons(),
' just note that loaded icons set must be same RICON_SIZE
'----------------------------------------------------------------------------------
Dim Shared guiIcons(RICON_MAX_ICONS*RICON_DATA_ELEMENTS) As UInteger = { _
_/' RICON_NONE                  '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_FOLDER_FILE_OPEN      '/
&h3ff80000, &h2f082008, &h2042207e, &h40027fc2, &h40024002, &h40024002, &h40024002, &h00007ffe, _
_/' RICON_FILE_SAVE_CLASSIC     '/
&h3ffe0000, &h44226422, &h400247e2, &h5ffa4002, &h57ea500a, &h500a500a, &h40025ffa, &h00007ffe, _
_/' RICON_FOLDER_OPEN           '/
&h00000000, &h0042007e, &h40027fc2, &h40024002, &h41024002, &h44424282, &h793e4102, &h00000100, _
_/' RICON_FOLDER_SAVE           '/
&h00000000, &h0042007e, &h40027fc2, &h40024002, &h41024102, &h44424102, &h793e4282, &h00000000, _
_/' RICON_FILE_OPEN             '/
&h3ff00000, &h201c2010, &h20042004, &h21042004, &h24442284, &h21042104, &h20042104, &h00003ffc, _
_/' RICON_FILE_SAVE             '/
&h3ff00000, &h201c2010, &h20042004, &h21042004, &h21042104, &h22842444, &h20042104, &h00003ffc, _
_/' RICON_FILE_EXPORT           '/
&h3ff00000, &h201c2010, &h00042004, &h20041004, &h20844784, &h00841384, &h20042784, &h00003ffc, _
_/' RICON_FILE_NEW              '/
&h3ff00000, &h201c2010, &h20042004, &h20042004, &h22042204, &h22042f84, &h20042204, &h00003ffc, _
_/' RICON_FILE_DELETE           '/
&h3ff00000, &h201c2010, &h20042004, &h20042004, &h25042884, &h25042204, &h20042884, &h00003ffc, _
_/' RICON_FILETYPE_TEXT         '/
&h3ff00000, &h201c2010, &h20042004, &h20042ff4, &h20042ff4, &h20042ff4, &h20042004, &h00003ffc, _
_/' RICON_FILETYPE_AUDIO        '/
&h3ff00000, &h201c2010, &h27042004, &h244424c4, &h26442444, &h20642664, &h20042004, &h00003ffc, _
_/' RICON_FILETYPE_IMAGE        '/
&h3ff00000, &h201c2010, &h26042604, &h20042004, &h35442884, &h2414222c, &h20042004, &h00003ffc, _
_/' RICON_FILETYPE_PLAY         '/
&h3ff00000, &h201c2010, &h20c42004, &h22442144, &h22442444, &h20c42144, &h20042004, &h00003ffc, _
_/' RICON_FILETYPE_VIDEO        '/
&h3ff00000, &h3ffc2ff0, &h3f3c2ff4, &h3dbc2eb4, &h3dbc2bb4, &h3f3c2eb4, &h3ffc2ff4, &h00002ff4, _
_/' RICON_FILETYPE_INFO         '/
&h3ff00000, &h201c2010, &h21842184, &h21842004, &h21842184, &h21842184, &h20042184, &h00003ffc, _
_/' RICON_FILE_COPY             '/
&h0ff00000, &h381c0810, &h28042804, &h28042804, &h28042804, &h28042804, &h20102ffc, &h00003ff0, _
_/' RICON_FILE_CUT              '/
&h00000000, &h701c0000, &h079c1e14, &h55a000f0, &h079c00f0, &h701c1e14, &h00000000, &h00000000, _
_/' RICON_FILE_PASTE            '/
&h01c00000, &h13e41bec, &h3f841004, &h204420c4, &h20442044, &h20442044, &h207c2044, &h00003fc0, _
_/' RICON_CURSOR_HAND           '/
&h00000000, &h3aa00fe0, &h2abc2aa0, &h2aa42aa4, &h20042aa4, &h20042004, &h3ffc2004, &h00000000, _
_/' RICON_CURSOR_POINTER        '/
&h00000000, &h003c000c, &h030800c8, &h30100c10, &h10202020, &h04400840, &h01800280, &h00000000, _
_/' RICON_CURSOR_CLASSIC        '/
&h00000000, &h00180000, &h01f00078, &h03e007f0, &h07c003e0, &h04000e40, &h00000000, &h00000000, _
_/' RICON_PENCIL                '/
&h00000000, &h04000000, &h11000a00, &h04400a80, &h01100220, &h00580088, &h00000038, &h00000000, _
_/' RICON_PENCIL_BIG            '/
&h04000000, &h15000a00, &h50402880, &h14102820, &h05040a08, &h015c028c, &h007c00bc, &h00000000, _
_/' RICON_BRUSH_CLASSIC         '/
&h01c00000, &h01400140, &h01400140, &h0ff80140, &h0ff80808, &h0aa80808, &h0aa80aa8, &h00000ff8, _
_/' RICON_BRUSH_PAINTER         '/
&h1ffc0000, &h5ffc7ffe, &h40004000, &h00807f80, &h01c001c0, &h01c001c0, &h01c001c0, &h00000080, _
_/' RICON_WATER_DROP            '/
&h00000000, &h00800000, &h01c00080, &h03e001c0, &h07f003e0, &h036006f0, &h000001c0, &h00000000, _
_/' RICON_COLOR_PICKER          '/
&h00000000, &h3e003800, &h1f803f80, &h0c201e40, &h02080c10, &h00840104, &h00380044, &h00000000, _
_/' RICON_RUBBER                '/
&h00000000, &h07800300, &h1fe00fc0, &h3f883fd0, &h0e021f04, &h02040402, &h00f00108, &h00000000, _
_/' RICON_COLOR_BUCKET          '/
&h00c00000, &h02800140, &h08200440, &h20081010, &h2ffe3004, &h03f807fc, &h00e001f0, &h00000040, _
_/' RICON_TEXT_T                '/
&h00000000, &h21843ffc, &h01800180, &h01800180, &h01800180, &h01800180, &h03c00180, &h00000000, _
_/' RICON_TEXT_A                '/
&h00800000, &h01400180, &h06200340, &h0c100620, &h1ff80c10, &h380c1808, &h70067004, &h0000f80f, _
_/' RICON_SCALE                 '/
&h78000000, &h50004000, &h00004800, &h03c003c0, &h03c003c0, &h00100000, &h0002000a, &h0000000e, _
_/' RICON_RESIZE                '/
&h75560000, &h5e004002, &h54001002, &h41001202, &h408200fe, &h40820082, &h40820082, &h00006afe, _
_/' RICON_FILTER_POINT          '/
&h00000000, &h3f003f00, &h3f003f00, &h3f003f00, &h00400080, &h001c0020, &h001c001c, &h00000000, _
_/' RICON_FILTER_BILINEAR       '/
&h6d800000, &h00004080, &h40804080, &h40800000, &h00406d80, &h001c0020, &h001c001c, &h00000000, _
_/' RICON_CROP                  '/
&h40080000, &h1ffe2008, &h14081008, &h11081208, &h10481088, &h10081028, &h10047ff8, &h00001002, _
_/' RICON_CROP_ALPHA            '/
&h00100000, &h3ffc0010, &h2ab03550, &h22b02550, &h20b02150, &h20302050, &h2000fff0, &h00002000, _
_/' RICON_SQUARE_TOGGLE         '/
&h40000000, &h1ff82000, &h04082808, &h01082208, &h00482088, &h00182028, &h35542008, &h00000002, _
_/' RICON_SIMMETRY              '/
&h00000000, &h02800280, &h06c006c0, &h0ea00ee0, &h1e901eb0, &h3e883e98, &h7efc7e8c, &h00000000, _
_/' RICON_SIMMETRY_HORIZONTAL   '/
&h01000000, &h05600100, &h1d480d50, &h7d423d44, &h3d447d42, &h0d501d48, &h01000560, &h00000100, _
_/' RICON_SIMMETRY_VERTICAL     '/
&h01800000, &h04200240, &h10080810, &h00001ff8, &h00007ffe, &h0ff01ff8, &h03c007e0, &h00000180, _
_/' RICON_LENS                  '/
&h00000000, &h010800f0, &h02040204, &h02040204, &h07f00308, &h1c000e00, &h30003800, &h00000000, _
_/' RICON_LENS_BIG              '/
&h00000000, &h061803f0, &h08240c0c, &h08040814, &h0c0c0804, &h23f01618, &h18002400, &h00000000, _
_/' RICON_EYE_ON                '/
&h00000000, &h00000000, &h1c7007c0, &h638e3398, &h1c703398, &h000007c0, &h00000000, &h00000000, _
_/' RICON_EYE_OFF               '/
&h00000000, &h10002000, &h04700fc0, &h610e3218, &h1c703098, &h001007a0, &h00000008, &h00000000, _
_/' RICON_FILTER_TOP            '/
&h00000000, &h00007ffc, &h40047ffc, &h10102008, &h04400820, &h02800280, &h02800280, &h00000100, _
_/' RICON_FILTER                '/
&h00000000, &h40027ffe, &h10082004, &h04200810, &h02400240, &h02400240, &h01400240, &h000000c0, _
_/' RICON_TARGET_POINT          '/
&h00800000, &h00800080, &h00000080, &h3c9e0000, &h00000000, &h00800080, &h00800080, &h00000000, _
_/' RICON_TARGET_SMALL          '/
&h00800000, &h00800080, &h00800080, &h3f7e01c0, &h008001c0, &h00800080, &h00800080, &h00000000, _
_/' RICON_TARGET_BIG            '/
&h00800000, &h00800080, &h03e00080, &h3e3e0220, &h03e00220, &h00800080, &h00800080, &h00000000, _
_/' RICON_TARGET_MOVE           '/
&h01000000, &h04400280, &h01000100, &h43842008, &h43849ab2, &h01002008, &h04400100, &h01000280, _
_/' RICON_CURSOR_MOVE           '/
&h01000000, &h04400280, &h01000100, &h41042108, &h41049ff2, &h01002108, &h04400100, &h01000280, _
_/' RICON_CURSOR_SCALE          '/
&h781e0000, &h500a4002, &h04204812, &h00000240, &h02400000, &h48120420, &h4002500a, &h0000781e, _
_/' RICON_CURSOR_SCALE_RIGHT    '/
&h00000000, &h20003c00, &h24002800, &h01000200, &h00400080, &h00140024, &h003c0004, &h00000000, _
_/' RICON_CURSOR_SCALE_LEFT     '/
&h00000000, &h0004003c, &h00240014, &h00800040, &h02000100, &h28002400, &h3c002000, &h00000000, _
_/' RICON_UNDO                  '/
&h00000000, &h00100020, &h10101fc8, &h10001020, &h10001000, &h10001000, &h00001fc0, &h00000000, _
_/' RICON_REDO                  '/
&h00000000, &h08000400, &h080813f8, &h00080408, &h00080008, &h00080008, &h000003f8, &h00000000, _
_/' RICON_REREDO                '/
&h00000000, &h3ffc0000, &h20042004, &h20002000, &h20402000, &h3f902020, &h00400020, &h00000000, _
_/' RICON_MUTATE                '/
&h00000000, &h3ffc0000, &h20042004, &h27fc2004, &h20202000, &h3fc82010, &h00200010, &h00000000, _
_/' RICON_ROTATE                '/
&h00000000, &h0ff00000, &h10081818, &h11801008, &h10001180, &h18101020, &h00100fc8, &h00000020, _
_/' RICON_REPEAT                '/
&h00000000, &h04000200, &h240429fc, &h20042204, &h20442004, &h3f942024, &h00400020, &h00000000, _
_/' RICON_SHUFFLE               '/
&h00000000, &h20001000, &h22104c0e, &h00801120, &h11200040, &h4c0e2210, &h10002000, &h00000000, _
_/' RICON_EMPTYBOX              '/
&h7ffe0000, &h50024002, &h44024802, &h41024202, &h40424082, &h40124022, &h4002400a, &h00007ffe, _
_/' RICON_TARGET                '/
&h00800000, &h03e00080, &h08080490, &h3c9e0808, &h08080808, &h03e00490, &h00800080, &h00000000, _
_/' RICON_TARGET_SMALL_FILL     '/
&h00800000, &h00800080, &h00800080, &h3ffe01c0, &h008001c0, &h00800080, &h00800080, &h00000000, _
_/' RICON_TARGET_BIG_FILL       '/
&h00800000, &h00800080, &h03e00080, &h3ffe03e0, &h03e003e0, &h00800080, &h00800080, &h00000000, _
_/' RICON_TARGET_MOVE_FILL      '/
&h01000000, &h07c00380, &h01000100, &h638c2008, &h638cfbbe, &h01002008, &h07c00100, &h01000380, _
_/' RICON_CURSOR_MOVE_FILL      '/
&h01000000, &h07c00380, &h01000100, &h610c2108, &h610cfffe, &h01002108, &h07c00100, &h01000380, _
_/' RICON_CURSOR_SCALE_FILL     '/
&h781e0000, &h6006700e, &h04204812, &h00000240, &h02400000, &h48120420, &h700e6006, &h0000781e, _
_/' RICON_CURSOR_SCALE_RIGHT    '/
&h00000000, &h38003c00, &h24003000, &h01000200, &h00400080, &h000c0024, &h003c001c, &h00000000, _
_/' RICON_CURSOR_SCALE_LEFT     '/
&h00000000, &h001c003c, &h0024000c, &h00800040, &h02000100, &h30002400, &h3c003800, &h00000000, _
_/' RICON_UNDO_FILL             '/
&h00000000, &h00300020, &h10301ff8, &h10001020, &h10001000, &h10001000, &h00001fc0, &h00000000, _
_/' RICON_REDO_FILL             '/
&h00000000, &h0c000400, &h0c081ff8, &h00080408, &h00080008, &h00080008, &h000003f8, &h00000000, _
_/' RICON_REREDO_FILL           '/
&h00000000, &h3ffc0000, &h20042004, &h20002000, &h20402000, &h3ff02060, &h00400060, &h00000000, _
_/' RICON_MUTATE_FILL           '/
&h00000000, &h3ffc0000, &h20042004, &h27fc2004, &h20202000, &h3ff82030, &h00200030, &h00000000, _
_/' RICON_ROTATE_FILL           '/
&h00000000, &h0ff00000, &h10081818, &h11801008, &h10001180, &h18301020, &h00300ff8, &h00000020, _
_/' RICON_REPEAT_FILL           '/
&h00000000, &h06000200, &h26042ffc, &h20042204, &h20442004, &h3ff42064, &h00400060, &h00000000, _
_/' RICON_SHUFFLE_FILL          '/
&h00000000, &h30001000, &h32107c0e, &h00801120, &h11200040, &h7c0e3210, &h10003000, &h00000000, _
_/' RICON_EMPTYBOX_SMALL        '/
&h00000000, &h30043ffc, &h24042804, &h21042204, &h20442084, &h20142024, &h3ffc200c, &h00000000, _
_/' RICON_BOX                   '/
&h00000000, &h20043ffc, &h20042004, &h20042004, &h20042004, &h20042004, &h3ffc2004, &h00000000, _
_/' RICON_BOX_TOP               '/
&h00000000, &h23c43ffc, &h23c423c4, &h200423c4, &h20042004, &h20042004, &h3ffc2004, &h00000000, _
_/' RICON_BOX_TOP_RIGHT         '/
&h00000000, &h3e043ffc, &h3e043e04, &h20043e04, &h20042004, &h20042004, &h3ffc2004, &h00000000, _
_/' RICON_BOX_RIGHT             '/
&h00000000, &h20043ffc, &h20042004, &h3e043e04, &h3e043e04, &h20042004, &h3ffc2004, &h00000000, _
_/' RICON_BOX_BOTTOM_RIGHT      '/
&h00000000, &h20043ffc, &h20042004, &h20042004, &h3e042004, &h3e043e04, &h3ffc3e04, &h00000000, _
_/' RICON_BOX_BOTTOM            '/
&h00000000, &h20043ffc, &h20042004, &h20042004, &h23c42004, &h23c423c4, &h3ffc23c4, &h00000000, _
_/' RICON_BOX_BOTTOM_LEFT       '/
&h00000000, &h20043ffc, &h20042004, &h20042004, &h207c2004, &h207c207c, &h3ffc207c, &h00000000, _
_/' RICON_BOX_LEFT              '/
&h00000000, &h20043ffc, &h20042004, &h207c207c, &h207c207c, &h20042004, &h3ffc2004, &h00000000, _
_/' RICON_BOX_TOP_LEFT          '/
&h00000000, &h207c3ffc, &h207c207c, &h2004207c, &h20042004, &h20042004, &h3ffc2004, &h00000000, _
_/' RICON_BOX_CIRCLE_MASK       '/
&h00000000, &h20043ffc, &h20042004, &h23c423c4, &h23c423c4, &h20042004, &h3ffc2004, &h00000000, _
_/' RICON_BOX_CENTER            '/
&h7ffe0000, &h40024002, &h47e24182, &h4ff247e2, &h47e24ff2, &h418247e2, &h40024002, &h00007ffe, _
_/' RICON_POT                   '/
&h7fff0000, &h40014001, &h40014001, &h49555ddd, &h4945495d, &h400149c5, &h40014001, &h00007fff, _
_/' RICON_ALPHA_MULTIPLY        '/
&h7ffe0000, &h53327332, &h44ce4cce, &h41324332, &h404e40ce, &h48125432, &h4006540e, &h00007ffe, _
_/' RICON_ALPHA_CLEAR           '/
&h7ffe0000, &h53327332, &h44ce4cce, &h41324332, &h5c4e40ce, &h44124432, &h40065c0e, &h00007ffe, _
_/' RICON_DITHERING             '/
&h7ffe0000, &h42fe417e, &h42fe417e, &h42fe417e, &h42fe417e, &h42fe417e, &h42fe417e, &h00007ffe, _
_/' RICON_MIPMAPS               '/
&h07fe0000, &h1ffa0002, &h7fea000a, &h402a402a, &h5b2a512a, &h5128552a, &h40205128, &h00007fe0, _
_/' RICON_BOX_GRID              '/
&h00000000, &h1ff80000, &h12481248, &h12481ff8, &h1ff81248, &h12481248, &h00001ff8, &h00000000, _
_/' RICON_GRID                  '/
&h12480000, &h7ffe1248, &h12481248, &h12487ffe, &h7ffe1248, &h12481248, &h12487ffe, &h00001248, _
_/' RICON_BOX_CORNERS_SMALL     '/
&h00000000, &h1c380000, &h1c3817e8, &h08100810, &h08100810, &h17e81c38, &h00001c38, &h00000000, _
_/' RICON_BOX_CORNERS_BIG       '/
&h700e0000, &h700e5ffa, &h20042004, &h20042004, &h20042004, &h20042004, &h5ffa700e, &h0000700e, _
_/' RICON_FOUR_BOXES            '/
&h3f7e0000, &h21422142, &h21422142, &h00003f7e, &h21423f7e, &h21422142, &h3f7e2142, &h00000000, _
_/' RICON_GRID_FILL             '/
&h00000000, &h3bb80000, &h3bb83bb8, &h3bb80000, &h3bb83bb8, &h3bb80000, &h3bb83bb8, &h00000000, _
_/' RICON_BOX_MULTISIZE         '/
&h7ffe0000, &h7ffe7ffe, &h77fe7000, &h77fe77fe, &h777e7700, &h777e777e, &h777e777e, &h0000777e, _
_/' RICON_ZOOM_SMALL            '/
&h781e0000, &h40024002, &h00004002, &h01800000, &h00000180, &h40020000, &h40024002, &h0000781e, _
_/' RICON_ZOOM_MEDIUM           '/
&h781e0000, &h40024002, &h00004002, &h03c003c0, &h03c003c0, &h40020000, &h40024002, &h0000781e, _
_/' RICON_ZOOM_BIG              '/
&h781e0000, &h40024002, &h07e04002, &h07e007e0, &h07e007e0, &h400207e0, &h40024002, &h0000781e, _
_/' RICON_ZOOM_ALL              '/
&h781e0000, &h5ffa4002, &h1ff85ffa, &h1ff81ff8, &h1ff81ff8, &h5ffa1ff8, &h40025ffa, &h0000781e, _
_/' RICON_ZOOM_CENTER           '/
&h00000000, &h2004381c, &h00002004, &h00000000, &h00000000, &h20040000, &h381c2004, &h00000000, _
_/' RICON_BOX_DOTS_SMALL        '/
&h00000000, &h1db80000, &h10081008, &h10080000, &h00001008, &h10081008, &h00001db8, &h00000000, _
_/' RICON_BOX_DOTS_BIG          '/
&h35560000, &h00002002, &h00002002, &h00002002, &h00002002, &h00002002, &h35562002, &h00000000, _
_/' RICON_BOX_CONCENTRIC        '/
&h7ffe0000, &h40024002, &h48124ff2, &h49924812, &h48124992, &h4ff24812, &h40024002, &h00007ffe, _
_/' RICON_BOX_GRID_BIG          '/
&h00000000, &h10841ffc, &h10841084, &h1ffc1084, &h10841084, &h10841084, &h00001ffc, &h00000000, _
_/' RICON_OK_TICK               '/
&h00000000, &h00000000, &h10000000, &h04000800, &h01040200, &h00500088, &h00000020, &h00000000, _
_/' RICON_CROSS                 '/
&h00000000, &h10080000, &h04200810, &h01800240, &h02400180, &h08100420, &h00001008, &h00000000, _
_/' RICON_ARROW_LEFT            '/
&h00000000, &h02000000, &h00800100, &h00200040, &h00200010, &h00800040, &h02000100, &h00000000, _
_/' RICON_ARROW_RIGHT           '/
&h00000000, &h00400000, &h01000080, &h04000200, &h04000800, &h01000200, &h00400080, &h00000000, _
_/' RICON_ARROW_BOTTOM          '/
&h00000000, &h00000000, &h00000000, &h08081004, &h02200410, &h00800140, &h00000000, &h00000000, _
_/' RICON_ARROW_TOP             '/
&h00000000, &h00000000, &h01400080, &h04100220, &h10040808, &h00000000, &h00000000, &h00000000, _
_/' RICON_ARROW_LEFT_FILL       '/
&h00000000, &h02000000, &h03800300, &h03e003c0, &h03e003f0, &h038003c0, &h02000300, &h00000000, _
_/' RICON_ARROW_RIGHT_FILL      '/
&h00000000, &h00400000, &h01c000c0, &h07c003c0, &h07c00fc0, &h01c003c0, &h004000c0, &h00000000, _
_/' RICON_ARROW_BOTTOM_FILL     '/
&h00000000, &h00000000, &h00000000, &h0ff81ffc, &h03e007f0, &h008001c0, &h00000000, &h00000000, _
_/' RICON_ARROW_TOP_FILL        '/
&h00000000, &h00000000, &h01c00080, &h07f003e0, &h1ffc0ff8, &h00000000, &h00000000, &h00000000, _
_/' RICON_AUDIO                 '/
&h00000000, &h18a008c0, &h32881290, &h24822686, &h26862482, &h12903288, &h08c018a0, &h00000000, _
_/' RICON_FX                    '/
&h00000000, &h04800780, &h004000c0, &h662000f0, &h08103c30, &h130a0e18, &h0000318e, &h00000000, _
_/' RICON_WAVE                  '/
&h00000000, &h00800000, &h08880888, &h2aaa0a8a, &h0a8a2aaa, &h08880888, &h00000080, &h00000000, _
_/' RICON_WAVE_SINUS            '/
&h00000000, &h00600000, &h01080090, &h02040108, &h42044204, &h24022402, &h00001800, &h00000000, _
_/' RICON_WAVE_SQUARE           '/
&h00000000, &h07f80000, &h04080408, &h04080408, &h04080408, &h7c0e0408, &h00000000, &h00000000, _
_/' RICON_WAVE_TRIANGULAR       '/
&h00000000, &h00000000, &h00a00040, &h22084110, &h08021404, &h00000000, &h00000000, &h00000000, _
_/' RICON_CROSS_SMALL           '/
&h00000000, &h00000000, &h04200000, &h01800240, &h02400180, &h00000420, &h00000000, &h00000000, _
_/' RICON_PLAYER_PREVIOUS       '/
&h00000000, &h18380000, &h12281428, &h10a81128, &h112810a8, &h14281228, &h00001838, &h00000000, _
_/' RICON_PLAYER_PLAY_BACK      '/
&h00000000, &h18000000, &h11801600, &h10181060, &h10601018, &h16001180, &h00001800, &h00000000, _
_/' RICON_PLAYER_PLAY           '/
&h00000000, &h00180000, &h01880068, &h18080608, &h06081808, &h00680188, &h00000018, &h00000000, _
_/' RICON_PLAYER_PAUSE          '/
&h00000000, &h1e780000, &h12481248, &h12481248, &h12481248, &h12481248, &h00001e78, &h00000000, _
_/' RICON_PLAYER_STOP           '/
&h00000000, &h1ff80000, &h10081008, &h10081008, &h10081008, &h10081008, &h00001ff8, &h00000000, _
_/' RICON_PLAYER_NEXT           '/
&h00000000, &h1c180000, &h14481428, &h15081488, &h14881508, &h14281448, &h00001c18, &h00000000, _
_/' RICON_PLAYER_RECORD         '/
&h00000000, &h03c00000, &h08100420, &h10081008, &h10081008, &h04200810, &h000003c0, &h00000000, _
_/' RICON_MAGNET                '/
&h00000000, &h0c3007e0, &h13c81818, &h14281668, &h14281428, &h1c381c38, &h08102244, &h00000000, _
_/' RICON_LOCK_CLOSE            '/
&h07c00000, &h08200820, &h3ff80820, &h23882008, &h21082388, &h20082108, &h1ff02008, &h00000000, _
_/' RICON_LOCK_OPEN             '/
&h07c00000, &h08000800, &h3ff80800, &h23882008, &h21082388, &h20082108, &h1ff02008, &h00000000, _
_/' RICON_CLOCK                 '/
&h01c00000, &h0c180770, &h3086188c, &h60832082, &h60034781, &h30062002, &h0c18180c, &h01c00770, _
_/' RICON_TOOLS                 '/
&h0a200000, &h1b201b20, &h04200e20, &h04200420, &h04700420, &h0e700e70, &h0e700e70, &h04200e70, _
_/' RICON_GEAR                  '/
&h01800000, &h3bdc318c, &h0ff01ff8, &h7c3e1e78, &h1e787c3e, &h1ff80ff0, &h318c3bdc, &h00000180, _
_/' RICON_GEAR_BIG              '/
&h01800000, &h3ffc318c, &h1c381ff8, &h781e1818, &h1818781e, &h1ff81c38, &h318c3ffc, &h00000180, _
_/' RICON_BIN                   '/
&h00000000, &h08080ff8, &h08081ffc, &h0aa80aa8, &h0aa80aa8, &h0aa80aa8, &h08080aa8, &h00000ff8, _
_/' RICON_HAND_POINTER          '/
&h00000000, &h00000000, &h20043ffc, &h08043f84, &h04040f84, &h04040784, &h000007fc, &h00000000, _
_/' RICON_LASER                 '/
&h00000000, &h24400400, &h00001480, &h6efe0e00, &h00000e00, &h24401480, &h00000400, &h00000000, _
_/' RICON_COIN                  '/
&h00000000, &h03c00000, &h08300460, &h11181118, &h11181118, &h04600830, &h000003c0, &h00000000, _
_/' RICON_EXPLOSION             '/
&h00000000, &h10880080, &h06c00810, &h366c07e0, &h07e00240, &h00001768, &h04200240, &h00000000, _
_/' RICON_1UP                   '/
&h00000000, &h3d280000, &h2528252c, &h3d282528, &h05280528, &h05e80528, &h00000000, &h00000000, _
_/' RICON_PLAYER                '/
&h01800000, &h03c003c0, &h018003c0, &h0ff007e0, &h0bd00bd0, &h0a500bd0, &h02400240, &h02400240, _
_/' RICON_PLAYER_JUMP           '/
&h01800000, &h03c003c0, &h118013c0, &h03c81ff8, &h07c003c8, &h04400440, &h0c080478, &h00000000, _
_/' RICON_KEY                   '/
&h3ff80000, &h30183ff8, &h30183018, &h3ff83ff8, &h03000300, &h03c003c0, &h03e00300, &h000003e0, _
_/' RICON_DEMON                 '/
&h3ff80000, &h3ff83ff8, &h33983ff8, &h3ff83398, &h3ff83ff8, &h00000540, &h0fe00aa0, &h00000fe0, _
_/' RICON_TEXT_POPUP            '/
&h00000000, &h0ff00000, &h20041008, &h25442004, &h10082004, &h06000bf0, &h00000300, &h00000000, _
_/' RICON_GEAR_EX               '/
&h00000000, &h11440000, &h07f00be8, &h1c1c0e38, &h1c1c0c18, &h07f00e38, &h11440be8, &h00000000, _
_/' RICON_CRACK                 '/
&h00000000, &h20080000, &h0c601010, &h07c00fe0, &h07c007c0, &h0c600fe0, &h20081010, &h00000000, _
_/' RICON_CRACK_POINTS          '/
&h00000000, &h20080000, &h0c601010, &h04400fe0, &h04405554, &h0c600fe0, &h20081010, &h00000000, _
_/' RICON_STAR                  '/
&h00000000, &h00800080, &h01c001c0, &h1ffc3ffe, &h03e007f0, &h07f003e0, &h0c180770, &h00000808, _
_/' RICON_DOOR                  '/
&h0ff00000, &h08180810, &h08100818, &h0a100810, &h08180810, &h08100818, &h08100810, &h00001ff8, _
_/' RICON_EXIT                  '/
&h0ff00000, &h08100810, &h08100810, &h10100010, &h4f902010, &h10102010, &h08100010, &h00000ff0, _
_/' RICON_MODE_2D               '/
&h00040000, &h001f000e, &h0ef40004, &h12f41284, &h0ef41214, &h10040004, &h7ffc3004, &h10003000, _
_/' RICON_MODE_3D               '/
&h78040000, &h501f600e, &h0ef44004, &h12f41284, &h0ef41284, &h10140004, &h7ffc300c, &h10003000, _
_/' RICON_CUBE                  '/
&h7fe00000, &h50286030, &h47fe4804, &h44224402, &h44224422, &h241275e2, &h0c06140a, &h000007fe, _
_/' RICON_CUBE_FACE_TOP         '/
&h7fe00000, &h5ff87ff0, &h47fe4ffc, &h44224402, &h44224422, &h241275e2, &h0c06140a, &h000007fe, _
_/' RICON_CUBE_FACE_LEFT        '/
&h7fe00000, &h50386030, &h47fe483c, &h443e443e, &h443e443e, &h241e75fe, &h0c06140e, &h000007fe, _
_/' RICON_CUBE_FACE_FRONT       '/
&h7fe00000, &h50286030, &h47fe4804, &h47fe47fe, &h47fe47fe, &h27fe77fe, &h0ffe17fe, &h000007fe, _
_/' RICON_CUBE_FACE_BOTTOM      '/
&h7fe00000, &h50286030, &h47fe4804, &h44224402, &h44224422, &h3ff27fe2, &h0ffe1ffa, &h000007fe, _
_/' RICON_CUBE_FACE_RIGHT       '/
&h7fe00000, &h70286030, &h7ffe7804, &h7c227c02, &h7c227c22, &h3c127de2, &h0c061c0a, &h000007fe, _
_/' RICON_CUBE_FACE_BACK        '/
&h7fe00000, &h7fe87ff0, &h7ffe7fe4, &h7fe27fe2, &h7fe27fe2, &h24127fe2, &h0c06140a, &h000007fe, _
_/' RICON_CAMERA                '/
&h00000000, &h2a0233fe, &h22022602, &h22022202, &h2a022602, &h00a033fe, &h02080110, &h00000000, _
_/' RICON_SPECIAL               '/
&h00000000, &h200c3ffc, &h000c000c, &h3ffc000c, &h30003000, &h30003000, &h3ffc3004, &h00000000, _
_/' RICON_LINK_NET              '/
&h00000000, &h0022003e, &h012201e2, &h0100013e, &h01000100, &h79000100, &h4f004900, &h00007800, _
_/' RICON_LINK_BOXES            '/
&h00000000, &h44007c00, &h45004600, &h00627cbe, &h00620022, &h45007cbe, &h44004600, &h00007c00, _
_/' RICON_LINK_MULTI            '/
&h00000000, &h0044007c, &h0010007c, &h3f100010, &h3f1021f0, &h3f100010, &h3f0021f0, &h00000000, _
_/' RICON_LINK                  '/
&h00000000, &h0044007c, &h00440044, &h0010007c, &h00100010, &h44107c10, &h440047f0, &h00007c00, _
_/' RICON_LINK_BROKE            '/
&h00000000, &h0044007c, &h00440044, &h0000007c, &h00000010, &h44007c10, &h44004550, &h00007c00, _
_/' RICON_TEXT_NOTES            '/
&h02a00000, &h22a43ffc, &h20042004, &h20042ff4, &h20042ff4, &h20042ff4, &h20042004, &h00003ffc, _
_/' RICON_NOTEBOOK              '/
&h3ffc0000, &h20042004, &h245e27c4, &h27c42444, &h2004201e, &h201e2004, &h20042004, &h00003ffc, _
_/' RICON_SUITCASE              '/
&h00000000, &h07e00000, &h04200420, &h24243ffc, &h24242424, &h24242424, &h3ffc2424, &h00000000, _
_/' RICON_SUITCASE_ZIP          '/
&h00000000, &h0fe00000, &h08200820, &h40047ffc, &h7ffc5554, &h40045554, &h7ffc4004, &h00000000, _
_/' RICON_MAILBOX               '/
&h00000000, &h20043ffc, &h3ffc2004, &h13c81008, &h100813c8, &h10081008, &h1ff81008, &h00000000, _
_/' RICON_MONITOR               '/
&h00000000, &h40027ffe, &h5ffa5ffa, &h5ffa5ffa, &h40025ffa, &h03c07ffe, &h1ff81ff8, &h00000000, _
_/' RICON_PRINTER               '/
&h0ff00000, &h6bfe7ffe, &h7ffe7ffe, &h68167ffe, &h08106816, &h08100810, &h0ff00810, &h00000000, _
_/' RICON_PHOTO_CAMERA          '/
&h3ff80000, &hfffe2008, &h870a8002, &h904a888a, &h904a904a, &h870a888a, &hfffe8002, &h00000000, _
_/' RICON_PHOTO_CAMERA_FLASH    '/
&h0fc00000, &hfcfe0cd8, &h8002fffe, &h84428382, &h84428442, &h80028382, &hfffe8002, &h00000000, _
_/' RICON_HOUSE                 '/
&h00000000, &h02400180, &h08100420, &h20041008, &h23c42004, &h22442244, &h3ffc2244, &h00000000, _
_/' RICON_HEART                 '/
&h00000000, &h1c700000, &h3ff83ef8, &h3ff83ff8, &h0fe01ff0, &h038007c0, &h00000100, &h00000000, _
_/' RICON_CORNER                '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h80000000, &he000c000, _
_/' RICON_VERTICAL_BARS         '/
&h00000000, &h14001c00, &h15c01400, &h15401540, &h155c1540, &h15541554, &h1ddc1554, &h00000000, _
_/' RICON_VERTICAL_BARS_FILL    '/
&h00000000, &h03000300, &h1b001b00, &h1b601b60, &h1b6c1b60, &h1b6c1b6c, &h1b6c1b6c, &h00000000, _
_/' RICON_LIFE_BARS             '/
&h00000000, &h00000000, &h403e7ffe, &h7ffe403e, &h7ffe0000, &h43fe43fe, &h00007ffe, &h00000000, _
_/' RICON_INFO                  '/
&h7ffc0000, &h43844004, &h43844284, &h43844004, &h42844284, &h42844284, &h40044384, &h00007ffc, _
_/' RICON_CROSSLINE             '/
&h40008000, &h10002000, &h04000800, &h01000200, &h00400080, &h00100020, &h00040008, &h00010002, _
_/' RICON_HELP                  '/
&h00000000, &h1ff01ff0, &h18301830, &h1f001830, &h03001f00, &h00000300, &h03000300, &h00000000, _
_/' RICON_FILETYPE_ALPHA        '/
&h3ff00000, &h2abc3550, &h2aac3554, &h2aac3554, &h2aac3554, &h2aac3554, &h2aac3554, &h00003ffc, _
_/' RICON_FILETYPE_HOME         '/
&h3ff00000, &h201c2010, &h22442184, &h28142424, &h29942814, &h2ff42994, &h20042004, &h00003ffc, _
_/' RICON_LAYERS_VISIBLE        '/
&h07fe0000, &h04020402, &h7fe20402, &h44224422, &h44224422, &h402047fe, &h40204020, &h00007fe0, _
_/' RICON_LAYERS                '/
&h07fe0000, &h04020402, &h7c020402, &h44024402, &h44024402, &h402047fe, &h40204020, &h00007fe0, _
_/' RICON_WINDOW                '/
&h00000000, &h40027ffe, &h7ffe4002, &h40024002, &h40024002, &h40024002, &h7ffe4002, &h00000000, _
_/' RICON_HIDPI                 '/
&h09100000, &h09f00910, &h09100910, &h00000910, &h24a2779e, &h27a224a2, &h709e20a2, &h00000000, _
_/' RICON_200                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_201                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_202                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_203                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_204                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_205                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_206                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_207                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_208                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_209                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_210                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_211                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_212                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_213                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_214                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_215                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_216                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_217                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_218                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_219                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_220                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_221                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_222                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_223                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_224                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_225                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_226                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_227                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_228                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_229                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_230                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_231                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_232                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_233                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_234                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_235                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_236                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_237                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_238                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_239                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_240                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_241                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_242                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_243                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_244                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_245                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_246                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_247                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_248                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_249                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_250                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_251                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_252                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_253                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_254                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _
_/' RICON_255                   '/
&h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000 _
}
#endif      ' RICONS_IMPLEMENTATION
