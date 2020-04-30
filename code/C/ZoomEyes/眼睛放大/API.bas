Attribute VB_Name = "API"



Option Explicit


Private Type OPENFILENAME
    lStructSize As Long
    hwndOwner As Long
    hInstance As Long
    lpstrFilter As String
    lpstrCustomFilter As String
    nMaxCustFilter As Long
    nFilterIndex As Long
    lpstrFile As String
    nMaxFile As Long
    lpstrFileTitle As String
    nMaxFileTitle As Long
    lpstrInitialDir As String
    lpstrTitle As String
    Flags As Long
    nFileOffset As Integer
    nFileExtension As Integer
    lpstrDefExt As String
    lCustData As Long
    lpfnHook As Long
    lpTemplateName As String
End Type



Private Declare Function GetOpenFileName Lib "comdlg32.dll" Alias "GetOpenFileNameA" (pOpenfilename As OPENFILENAME) As Long
Private Declare Function GetSaveFileName Lib "comdlg32.dll" Alias "GetSaveFileNameA" (pOpenfilename As OPENFILENAME) As Long



Public Type RGBQUAD
    Blue As Byte
    Green As Byte
    Red As Byte
    reserved As Byte
End Type

Public Enum PaletteFlags
    [PaletteFlagsHasAlpha] = &H1
    [PaletteFlagsGrayScale] = &H2
    [PaletteFlagsHalftone] = &H4
End Enum

Public Type ColorPalette '(8bpp)
   Flags        As PaletteFlags
   Count        As Long
   Entries(255) As RGBQUAD
End Type

Public Type BITMAPFILEHEADER
    bfType      As Integer
    bfSize      As Long
    bfReserved1 As Integer
    bfReserved2 As Integer
    bfOffBits   As Long
End Type

Public Type BITMAPINFOHEADER
    biSize          As Long
    biWidth         As Long
    biHeight        As Long
    biPlanes        As Integer
    biBitCount      As Integer
    biCompression   As Long
    biSizeImage     As Long
    biXPelsPerMeter As Long
    biYPelsPerMeter As Long
    biClrUsed       As Long
    biClrImportant  As Long
End Type

Public Type Bitmap
    bmType       As Long
    bmWidth      As Long
    bmHeight     As Long
    bmStride As Long
    bmPlanes     As Integer
    bmBitsPixel  As Integer
    BmBits       As Long
End Type

Public Type BITMAPINFO
    bmiHeader As BITMAPINFOHEADER
    bmiColors As RGBQUAD
End Type

Public Type PALETTEENTRY
    peRed As Byte
    peGreen As Byte
    peBlue As Byte
    peFlags As Byte
End Type

Public Type LOGPALETTE
    palVersion As Integer
    palNumEntries As Integer
    palPalEntry(4096) As PALETTEENTRY
End Type


Public Const BI_bitfields = 3&                 '带掩码的
Public Const BI_RGB = 0                        '正常

Public Const DIB_RGB_COLORS = 0                '真彩色
Public Const SRCCOPY = &HCC0020                '直接拷贝

'******************************************** 用于图像方面的相关API ********************************************

Public Declare Function CreateDIBSection Lib "gdi32" (ByVal hdc As Long, lpBitsInfo As BITMAPINFOHEADER, ByVal wUsage As Long, lpBits As Long, ByVal handle As Long, ByVal dw As Long) As Long
Public Declare Function CreateCompatibleDC Lib "gdi32" (ByVal hdc As Long) As Long
Public Declare Function GetDIBColorTable Lib "gdi32" (ByVal hdc As Long, ByVal un1 As Long, ByVal un2 As Long, lpRGBQuad As Any) As Long
Public Declare Function SetDIBColorTable Lib "gdi32" (ByVal hdc As Long, ByVal un1 As Long, ByVal un2 As Long, pcRGBQuad As RGBQUAD) As Long
Public Declare Function CreatePalette Lib "gdi32" (lpLogPalette As LOGPALETTE) As Long
Public Declare Function BitBlt Lib "gdi32" (ByVal hDestDC As Long, ByVal X As Long, ByVal Y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hSrcDC As Long, ByVal xSrc As Long, ByVal ySrc As Long, ByVal dwRop As Long) As Long
Public Declare Function DeleteDC Lib "gdi32" (ByVal hdc As Long) As Long
Public Declare Function SelectObject Lib "gdi32" (ByVal hdc As Long, ByVal hObject As Long) As Long
Public Declare Function DeleteObject Lib "gdi32" (ByVal hObject As Long) As Long
Public Declare Function GetNearestPaletteIndex Lib "gdi32" (ByVal hPalette As Long, ByVal crColor As Long) As Long

Public Declare Function StretchBlt Lib "gdi32" (ByVal hdc As Long, ByVal X As Long, ByVal Y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hSrcDC As Long, ByVal xSrc As Long, ByVal ySrc As Long, ByVal nSrcWidth As Long, ByVal nSrcHeight As Long, ByVal dwRop As Long) As Long
Public Declare Function SetStretchBltMode Lib "gdi32" (ByVal hdc As Long, ByVal nStretchMode As Long) As Long

Public Const GMEM_FIXED = &H0
Public Const GMEM_ZEROINIT = &H40
Public Const GPTR = (GMEM_FIXED Or GMEM_ZEROINIT)
Public Declare Function VarPtrArray Lib "msvbvm60.dll" Alias "VarPtr" (ByRef Ptr() As Any) As Long
Public Declare Function GlobalAlloc Lib "kernel32" (ByVal wFlags As Long, ByVal dwBytes As Long) As Long
Public Declare Function GlobalFree Lib "kernel32" (ByVal hMem As Long) As Long
Public Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (lpDst As Any, lpSrc As Any, ByVal ByteLength As Long)


Public Declare Sub ZeroMemory Lib "kernel32" Alias "RtlMoveMemory" (dest As Any, ByVal numBytes As Long)
Public Declare Sub FillMemory Lib "kernel32.dll" Alias "RtlFillMemory" (ByRef Destination As Any, ByVal Length As Long, ByVal Fill As Byte)
Public Declare Function GetDC Lib "user32" (ByVal Hwnd As Long) As Long
Public Declare Function ReleaseDC Lib "user32" (ByVal Hwnd As Long, ByVal hdc As Long) As Long


Public Declare Function GetTickCount Lib "kernel32" () As Long


Public Declare Function GdipSetImagePalette Lib "gdiplus" (ByVal hImage As Long, Palette As ColorPalette) As Long


'******************************************** 用于提升线程优先级别的API和常数 ********************************************

Public Const THREAD_BASE_PRIORITY_IDLE = -15
Public Const THREAD_BASE_PRIORITY_LOWRT = 15
Public Const THREAD_BASE_PRIORITY_MIN = -2
Public Const THREAD_BASE_PRIORITY_MAX = 2
Public Const THREAD_PRIORITY_LOWEST = THREAD_BASE_PRIORITY_MIN
Public Const THREAD_PRIORITY_HIGHEST = THREAD_BASE_PRIORITY_MAX
Public Const THREAD_PRIORITY_BELOW_NORMAL = (THREAD_PRIORITY_LOWEST + 1)
Public Const THREAD_PRIORITY_ABOVE_NORMAL = (THREAD_PRIORITY_HIGHEST - 1)
Public Const THREAD_PRIORITY_IDLE = THREAD_BASE_PRIORITY_IDLE
Public Const THREAD_PRIORITY_NORMAL = 0
Public Const THREAD_PRIORITY_TIME_CRITICAL = THREAD_BASE_PRIORITY_LOWRT
Public Const HIGH_PRIORITY_CLASS = &H80
Public Const IDLE_PRIORITY_CLASS = &H40
Public Const NORMAL_PRIORITY_CLASS = &H20
Public Const REALTIME_PRIORITY_CLASS = &H100

Public Declare Function SetThreadPriority Lib "kernel32" (ByVal hThread As Long, ByVal nPriority As Long) As Long
Public Declare Function SetPriorityClass Lib "kernel32" (ByVal hProcess As Long, ByVal dwPriorityClass As Long) As Long
Public Declare Function GetThreadPriority Lib "kernel32" (ByVal hThread As Long) As Long
Public Declare Function GetPriorityClass Lib "kernel32" (ByVal hProcess As Long) As Long
Public Declare Function GetCurrentThread Lib "kernel32" () As Long
Public Declare Function GetCurrentProcess Lib "kernel32" () As Long

Public Type SAFEARRAYBOUND
    cElements As Long
    lLbound As Long
End Type

Public Type SAFEARRAY
    cDims As Integer
    fFeatures As Integer
    cbElements As Long
    cLocks As Long
    pvData As Long
    Bounds As SAFEARRAYBOUND
End Type


Public Enum Bmp16
    X1R5G5B5 = 0
    R5G6B5 = 1
    R6G5B5 = 2
    R5G5B6 = 3
    X4R4G4B4 = 4
    A1R5G5B5 = 5
    A4R4G4B4 = 6
End Enum

Public Type Mask
    RedMask As Long
    GreenMask As Long
    BlueMask As Long
    AlphaMask As Long
End Type



Public Type GdiplusStartupInput
    GdiplusVersion           As Long
    DebugEventCallback       As Long
    SuppressBackgroundThread As Long
    SuppressExternalCodecs   As Long
End Type



Public Enum ImageLockMode
   ImageLockModeRead = &H1
   ImageLockModeWrite = &H2
   ImageLockModeUserInputBuf = &H4
End Enum

Public Type BitmapData
   Width As Long
   Height As Long
   Stride As Long
   PixelFormat As Long
   scan0 As Long
   reserved As Long
End Type

Public Type RECT
    Left As Long
    Top As Long
    Right As Long
    Bottom As Long
End Type

Public Type RECTF
    nLeft               As Double
    nTop                As Double
    nWidth              As Double
    nHeight             As Double
End Type




Public Enum PixelFormatEnum
    PixelFormat1bppIndexed = &H30101
    PixelFormat4bppIndexed = &H30402
    PixelFormat8bppIndexed = &H30803
    PixelFormat8bppGrayScale = &H30804
    PixelFormat16bppGreyScale = &H101004
    PixelFormat16bppRGB555 = &H21005
    PixelFormat16bppRGB565 = &H21006
    PixelFormat16bppARGB1555 = &H61007
    PixelFormat24bppRGB = &H21808
    PixelFormat32bppRGB = &H22009
    PixelFormat32bppARGB = &H26200A
    PixelFormat32bppPARGB = &HE200B
    PixelFormat48bppRGB = &H10300C
    PixelFormat64bppARGB = &H34400D
    PixelFormat64bppPARGB = &H1C400E
End Enum

Public Declare Function GdiplusStartup Lib "gdiplus" (Token As Long, inputbuf As GdiplusStartupInput, Optional ByVal outputbuf As Long = 0) As Long
Public Declare Sub GdiplusShutdown Lib "gdiplus" (ByVal Token As Long)
Public Declare Function GdipLoadImageFromFile Lib "gdiplus" (ByVal FileName As Long, hImage As Long) As Long
Public Declare Function GdipDisposeImage Lib "gdiplus" (ByVal Image As Long) As Long
Public Declare Function GdipCreateFromHDC Lib "gdiplus" (ByVal hdc As Long, Graphics As Long) As Long
Public Declare Function GdipDeleteGraphics Lib "gdiplus" (ByVal Graphics As Long) As Long
Public Declare Function GdipDrawImageRectRectI Lib "gdiplus" (ByVal Graphics As Long, ByVal hImage As Long, ByVal dstX As Long, ByVal dstY As Long, ByVal dstWidth As Long, ByVal dstHeight As Long, ByVal SrcX As Long, ByVal SrcY As Long, ByVal SrcWidth As Long, ByVal SrcHeight As Long, ByVal srcUnit As Long, Optional ByVal imageAttributes As Long = 0, Optional ByVal callback As Long = 0, Optional ByVal callbackData As Long = 0) As Long
Public Declare Function GdipGetImageWidth Lib "gdiplus" (ByVal Image As Long, Width As Long) As Long
Public Declare Function GdipGetImageHeight Lib "gdiplus" (ByVal Image As Long, Height As Long) As Long
Public Declare Function GdipGetImageBounds Lib "gdiplus.dll" (ByVal nImage As Long, SrcRect As RECTF, srcUnit As Long) As Long

Public Declare Function GdipBitmapLockBits Lib "gdiplus" (ByVal Bitmap As Long, Rct As RECT, ByVal Flags As ImageLockMode, ByVal PixelFormat As Long, lockedBitmapData As BitmapData) As Long
Public Declare Function GdipBitmapUnlockBits Lib "gdiplus" (ByVal Bitmap As Long, lockedBitmapData As BitmapData) As Long
Public Declare Function GdipGetImagePixelFormat Lib "gdiplus" (ByVal m_Image As Long, PixelFormat As Long) As Long
Public GdiPToken        As Long


Public Function InitGdiPlus() As Boolean
    Dim Gsp             As GdiplusStartupInput
    Gsp.GdiplusVersion = 1
    GdiplusStartup GdiPToken, Gsp
End Function


'*************************************************************************
'**    作    者 ：    laviewpbt
'**    函 数 名 ：    ShowOpen
'**    输    入 ：    hwnd  (long)    -   窗口句柄
'**                   Filter(String)  -   过滤选项
'**                   Title (String)  -   对话框标题
'**                   IniPath         -   首选路径
'**    输    出 ：    返回一路径字符串
'**    功能描述 ：    通用打开对话框
'**    日    期 ：    2005-10-21 11:27.25
'**    修 改 人 ：
'**    日    期 ：
'**    版    本 ：    Version 1.1.1
'*************************************************************************

Public Function ShowOpen(Hwnd As Long, Filter As String, Title As String, Optional IniPath = "") As String
    Dim OFName As OPENFILENAME
    OFName.lStructSize = Len(OFName)
    OFName.hwndOwner = Hwnd
    OFName.hInstance = App.hInstance
    OFName.lpstrFilter = Filter
    OFName.lpstrFile = Space$(254)
    OFName.nMaxFile = 255
    OFName.lpstrFileTitle = Space$(254)
    OFName.nMaxFileTitle = 255
    OFName.lpstrTitle = Title
    OFName.lpstrInitialDir = IniPath
    OFName.Flags = 0
    If GetOpenFileName(OFName) Then
        ShowOpen = Trim$(OFName.lpstrFile)
    Else
        ShowOpen = ""
    End If
End Function

'*************************************************************************
'**    作    者 ：    laviewpbt
'**    函 数 名 ：    ShowSave
'**    输    入 ：    hwnd  (long)    -   窗口句柄
'**                   Filter(String)  -   过滤选项
'**                   Title (String)  -   对话框标题
'**                   IniPath         -   首选路径
'**    输    出 ：    返回一路径字符串
'**    功能描述 ：    通用保存对话框
'**    日    期 ：    2005-10-21 11:29.42
'**    修 改 人 ：
'**    日    期 ：
'**    版    本 ：    Version 1.1.1
'*************************************************************************

Public Function ShowSave(Hwnd As Long, Filter As String, Title As String, FilterIndex As Integer, Optional IniPath = "") As String
    Dim OFName As OPENFILENAME
    OFName.lStructSize = Len(OFName)
    OFName.hwndOwner = Hwnd
    OFName.hInstance = App.hInstance
    OFName.lpstrFilter = Filter
    OFName.lpstrFile = Space$(254)
    OFName.nMaxFile = 255
    OFName.lpstrFileTitle = Space$(254)
    OFName.nMaxFileTitle = 255
    OFName.lpstrTitle = Title
    OFName.lpstrInitialDir = IniPath
    OFName.Flags = &H2                '有相同的文件是提示
    If GetSaveFileName(OFName) Then
        ShowSave = Trim$(OFName.lpstrFile)
        ShowSave = Left(ShowSave, Len(ShowSave) - 1)
        FilterIndex = OFName.nFilterIndex
    Else
        ShowSave = ""
    End If
End Function



Public Sub GetBestFitInfoEx(ByVal SrcWidth As Long, ByVal SrcHeight As Long, ByVal DestWidth As Long, ByVal DestHeight As Long, ByRef FitX As Long, ByRef FitY As Long, ByRef FitWidth As Long, ByRef FitHeight As Long)
    Dim WidthRatio As Double
    Dim HeightRatio As Double
    If SrcWidth > DestWidth Or SrcHeight > DestHeight Then
        WidthRatio = DestWidth / SrcWidth
        HeightRatio = DestHeight / SrcHeight
        If WidthRatio < HeightRatio Then
            FitWidth = DestWidth
            FitHeight = CInt(SrcHeight * WidthRatio + 0.5)
        Else
            FitHeight = DestHeight
            FitWidth = CInt(SrcWidth * HeightRatio + 0.5)
        End If
    Else
        FitWidth = SrcWidth
        FitHeight = SrcHeight
    End If
    FitX = (DestWidth - FitWidth) \ 2
    FitY = (DestHeight - FitHeight) \ 2
End Sub

