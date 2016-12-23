# -*- coding: utf-8 -*-
"""
Created on Thu Nov 10 13:47:26 2016

瘦脸

@author: yuanwenjin
"""

import cv2
import numpy as np
import copy

def nothing(x):
    pass

def smallface(img, pos, curpos, radius, scale):
    "瘦脸,插值方法为最邻近"
    'img:图像数据,array'
    'pos:中心位置,(x,y)'
    'curpos:当前位置,(x,y),瘦脸方向'
    'radius:半径'

    # 图像信息    
    height, width, channel = img.shape
    dst = copy.deepcopy(img)
    
    # 处理区域边界值
    left = max(pos[0] - radius, 0)
    top = max(pos[1] - radius, 0)
    right = min(pos[0] + radius, width - 1)
    bottom = min(pos[1] + radius, height - 1)
    
    # 
    distX = pos[0] - curpos[0]
    distY = pos[1] - curpos[1]
    
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
                
                    scalefactor = dist * 1.0 / radius2
                    scalefactor = 1 - scale * 1.0 / 100.0 * scalefactor
                    
                    posy = scalefactor * distY + i
                    posy = np.round(posy)
                    posy = min(posy, height - 1)
                    posy = max(posy, 1)                
                    
                    posx = scalefactor * distX + j
                    posx = np.round(posx)
                    posx = min(posx, width - 1)
                    posx = max(posx, 1)
                    
                    dst[i, j, rgb] = img[posy.astype('int'), posx.astype('int'), rgb]
    return dst.astype('uint8')
    

#mouse callback function
def draw_circle(event,x,y,flags,param):
    global img, img1, points, lbflg

    if event == cv2.EVENT_MOUSEMOVE:
        img2 = copy.deepcopy(img1)
        if len(points) > 0:
            cv2.line(img2, (points[0][0], points[0][1]), (x,y), (0,0,255), 1)
        cv2.imshow('image',img2)
    if event == cv2.EVENT_LBUTTONDOWN:
        
        if len(points) < 2:
            points.append((x, y))
        else:
            img1 = smallface(img1, points[0], points[1], 20, 10)
            points = []

# 图像数据
#src = np.zeros((512,512,3),np.uint8)
src = cv2.imread('142204107567719.jpg')
img = copy.deepcopy(src)
img1 = copy.deepcopy(src)

# 坐标位置
points = []


# 鼠标左键按下标记
lbflg = False

# 窗口
cv2.namedWindow('image')

# 设置鼠标响应
cv2.setMouseCallback('image',draw_circle)
cv2.imshow('image',img1)

# 显示
while(1):
    if cv2.waitKey(20)&0xFF==27:
        break
cv2.destroyAllWindows()
