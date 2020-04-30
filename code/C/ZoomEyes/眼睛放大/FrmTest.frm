VERSION 5.00
Begin VB.Form FrmTest 
   Caption         =   "眼睛放大"
   ClientHeight    =   8550
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   16560
   Icon            =   "FrmTest.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   8550
   ScaleWidth      =   16560
   StartUpPosition =   2  '屏幕中心
   Begin VB.PictureBox PicS 
      Height          =   375
      Left            =   7560
      Picture         =   "FrmTest.frx":08CA
      ScaleHeight     =   315
      ScaleWidth      =   435
      TabIndex        =   11
      Top             =   8880
      Visible         =   0   'False
      Width           =   495
   End
   Begin VB.CommandButton CmdReset 
      Caption         =   "恢复图像"
      Height          =   375
      Left            =   2160
      TabIndex        =   10
      Top             =   7980
      Width           =   1815
   End
   Begin VB.PictureBox Picture1 
      BorderStyle     =   0  'None
      Height          =   645
      Left            =   4080
      ScaleHeight     =   645
      ScaleWidth      =   11655
      TabIndex        =   3
      Top             =   7920
      Width           =   11655
      Begin VB.HScrollBar BlockSize 
         Height          =   375
         Left            =   1080
         Max             =   80
         Min             =   5
         TabIndex        =   7
         Top             =   60
         Value           =   60
         Width           =   3615
      End
      Begin VB.HScrollBar Ratio 
         Height          =   375
         Left            =   6480
         Max             =   30
         Min             =   -30
         TabIndex        =   4
         Top             =   0
         Value           =   12
         Width           =   4215
      End
      Begin VB.Label LblInfo 
         AutoSize        =   -1  'True
         Caption         =   "画笔大小"
         Height          =   180
         Index           =   3
         Left            =   240
         TabIndex        =   9
         Top             =   150
         Width           =   720
      End
      Begin VB.Label LblInfo 
         AutoSize        =   -1  'True
         Caption         =   "60"
         Height          =   180
         Index           =   2
         Left            =   4950
         TabIndex        =   8
         Top             =   120
         Width           =   180
      End
      Begin VB.Label LblInfo 
         AutoSize        =   -1  'True
         Caption         =   "力度"
         Height          =   180
         Index           =   0
         Left            =   5640
         TabIndex        =   6
         Top             =   120
         Width           =   360
      End
      Begin VB.Label LblInfo 
         AutoSize        =   -1  'True
         Caption         =   "12"
         Height          =   180
         Index           =   1
         Left            =   10920
         TabIndex        =   5
         Top             =   120
         Width           =   180
      End
   End
   Begin VB.CommandButton CmdOpen 
      Caption         =   "选择图像"
      Height          =   375
      Left            =   240
      TabIndex        =   2
      Top             =   7980
      Width           =   1935
   End
   Begin VB.PictureBox Container 
      Height          =   7695
      Left            =   120
      ScaleHeight     =   509
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   1083
      TabIndex        =   0
      Top             =   120
      Width           =   16305
      Begin VB.PictureBox Pic 
         AutoRedraw      =   -1  'True
         AutoSize        =   -1  'True
         BorderStyle     =   0  'None
         Height          =   7620
         Left            =   1800
         Picture         =   "FrmTest.frx":764C
         ScaleHeight     =   508
         ScaleMode       =   3  'Pixel
         ScaleWidth      =   500
         TabIndex        =   1
         Top             =   -1440
         Width           =   7500
         Begin VB.Shape Shape2 
            BorderColor     =   &H00FF0000&
            Height          =   60
            Left            =   4590
            Shape           =   3  'Circle
            Top             =   4440
            Width           =   60
         End
         Begin VB.Shape Shape1 
            BorderColor     =   &H00FF0000&
            Height          =   1815
            Left            =   2790
            Shape           =   3  'Circle
            Top             =   4110
            Width           =   1815
         End
      End
   End
End
Attribute VB_Name = "FrmTest"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

'*****************************************************************************************
'**    开发日期 ：  2009-7-21
'**    作    者 ：  laviewpbt
'**    联系方式：   33184777
'**    修改日期 ：   2009-7-21
'**    版    本 ：  Version 1.3.1
'**    转载请不要删除以上信息
'****************************************************************************************




Private Declare Function GetTickCount Lib "kernel32" () As Long

Private Declare Sub ZoomEyes Lib "ImageProcessing" (ByVal Src As Long, ByVal dest As Long, ByVal Width As Long, ByVal Height As Long, ByVal Stride As Long, ByVal PointX As Long, ByVal PointY As Long, ByVal Radius As Long, ByVal Strength As Long)



Private OriginalX           As Double
Private OriginalY           As Double
Private NewX                As Double
Private NewY                As Double        '以上四行变量用于图片的移动和绘制
Private Img      As Cimage
Attribute Img.VB_VarHelpID = -1
Private Radius              As Long
Private Strength            As Long








Private Sub CmdOpen_Click()
    Dim FileName            As String
    FileName = API.ShowOpen(Me.Hwnd, "All Suppported Images |*.bmp;*.jpg;|BMP Images|*.bmp|JPG Images|*.jpg", "选择图像")
    If FileName <> "" Then
        Pic.Picture = LoadPicture(FileName)
        DoEvents                    '让Pic有个缓冲的时间，不然下面的代码没效果
        Pic.Move (Container.ScaleWidth - Pic.ScaleWidth) / 2, (Container.ScaleHeight - Pic.ScaleHeight) / 2
        Img.LoadPictureFromStdPicture Pic.Picture
        PicS.Picture = LoadPicture(FileName)
    End If
End Sub

Private Sub CmdReset_Click()
    Pic.Picture = PicS.Picture
    Img.LoadPictureFromStdPicture Pic.Picture
End Sub

Private Sub Form_Load()
    Pic.Move (Container.ScaleWidth - Pic.ScaleWidth) / 2, (Container.ScaleHeight - Pic.ScaleHeight) / 2
    Set Img = New Cimage
    Img.LoadPictureFromStdPicture Pic.Picture
    Radius = 60
    Strength = 12
    Shape1.Width = 2 * Radius + 1
    Shape1.Height = 2 * Radius + 2
    
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Img.DisposeResource
    Set Img = Nothing
End Sub


Private Sub LblInfo_Click(Index As Integer)

End Sub

Private Sub Pic_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    If Button = vbLeftButton Then
        OriginalX = X                   '记录起点坐标
        OriginalY = Y
    End If
End Sub

Private Sub Pic_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Shape1.Left = X - Radius
    Shape1.Top = Y - Radius
    Shape2.Left = X - 1
    Shape2.Top = Y - 1
    If Button = vbLeftButton Then
         NewX = Pic.Left + X - OriginalX  '新的X坐标
         NewY = Pic.Top + Y - OriginalY
         If Pic.Left <= 0 Then         '如果>0,则没有移动的必要
             If NewX > 0 Then             '越界处理
                 Pic.Left = 0
             ElseIf NewX >= Container.ScaleWidth - Pic.ScaleWidth Then
                 Pic.Left = NewX
             End If
         End If
         If Pic.Top <= 0 Then
             If NewY > 0 Then
                 Pic.Top = 0
             ElseIf NewY >= Container.ScaleHeight - Pic.ScaleHeight Then
                 Pic.Top = NewY
             End If
         End If
     End If
End Sub


Private Sub Pic_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    If Button = vbLeftButton Then
        Debug.Print X, Y, Radius, Strength
        
        Dim ImgC    As New Cimage
        Set ImgC = Img.Clone
        ZoomEyes ImgC.Pointer, Img.Pointer, Img.Width, Img.Height, Img.Stride, CLng(X), CLng(Y), Radius, Strength
        ImgC.DisposeResource
        Img.OutPut Pic.hdc
        Pic.Refresh
    End If
End Sub

Private Sub Ratio_Change()
    LblInfo(1).Caption = Ratio.Value
    Strength = Ratio.Value
End Sub

Private Sub Ratio_Scroll()
    Ratio_Change
End Sub

Private Sub BlockSize_Change()
    LblInfo(2).Caption = BlockSize.Value
    Radius = BlockSize.Value
    Shape1.Width = 2 * Radius + 1
    Shape1.Height = 2 * Radius + 2
End Sub

Private Sub BlockSize_Scroll()
    BlockSize_Change
End Sub



