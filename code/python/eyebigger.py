# -*- coding: utf-8 -*-
"""
Created on Wed Nov 09 09:06:45 2016

人眼放大

@author: yuanwenjin
"""

import cv2
import numpy as np
import copy

def nothing(x):
    pass

def eyebigger(img, pos, radius, scale):
    "人眼放大,插值方法为最邻近"
    'img:图像数据,array'
    'pos:中心位置,(x,y)'
    'radius:半径'
    'scale:放大程度'

    # 图像信息    
    height, width, channel = img.shape
    dst = copy.deepcopy(img)
    
    # 处理区域边界值
    left = max(pos[0] - radius, 0)
    top = max(pos[1] - radius, 0)
    right = min(pos[0] + radius, width - 1)
    bottom = min(pos[1] + radius, height - 1)
    
    # 
    radius2 = radius * radius
    
    # 插值处理
    for rgb in xrange(channel):
        for i in xrange(top, bottom):
            offy = i - pos[1]
            for j in xrange(left, right):
                offx = j - pos[0]
                
                dist = offy * offy + offx * offx
                if dist < radius2:
                    
                    scalefactor = 1.0 - dist * 1.0 / radius2
                    scalefactor = 1 - scale * 1.0 / 100.0 * scalefactor
                    
#                    print scalefactor
                                        
                    posy = offy * scalefactor + pos[1]
                    posy = np.round(posy)
                    posy = min(posy, height - 1)
                    posy = max(posy, 1)
#                    print posy                    
                    
                    posx = offx * scalefactor + pos[0]
                    posx = np.round(posx)
                    posx = min(posx, width - 1)
                    posx = max(posx, 1)
#                    print posx
                    
                    dst[i, j, rgb] = img[posy.astype('int'), posx.astype('int'), rgb]
    return dst.astype('uint8')
    

#mouse callback function
def draw_circle(event,x,y,flags,param):
    global img
    radius = cv2.getTrackbarPos('radius', 'image')
    if event == cv2.EVENT_MOUSEMOVE:
        img1 = copy.deepcopy(img)
        cv2.circle(img1, (x,y), radius, (255,0,0), 1)
        cv2.imshow('image',img1)
    if event == cv2.EVENT_LBUTTONDOWN:
        
        # 放大处理
        img = eyebigger(img, (x,y), radius, 20.0)
        
#        cv2.circle(img, (x,y), radius, (255,0,0), 1)

    if event == cv2.EVENT_RBUTTONDOWN:
        img = copy.deepcopy(src)

# 图像数据
#src = np.zeros((512,512,3),np.uint8)
src = cv2.imread('142204107567719.jpg')
img = copy.deepcopy(src)
img1 = copy.deepcopy(src)

# 窗口
cv2.namedWindow('image')
cv2.createTrackbar('radius', 'image', 20, 100, nothing)
# 设置鼠标响应
cv2.setMouseCallback('image',draw_circle)
cv2.imshow('image',img1)

# 显示
while(1):
    if cv2.waitKey(20)&0xFF==27:
        break
cv2.destroyAllWindows()
