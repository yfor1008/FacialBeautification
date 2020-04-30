
# -*- coding: utf-8 -*-
"""
Created on Tue Nov 08 11:41:40 2016

磨皮

@author: yuanwenjin
"""

import cv2
import argparse

def dermabrasion(image, dermabrasionlevel):
    "磨皮"
    'image:图像数据,array'
    'dermabrasionlevel:磨皮程度'    
    
    p = dermabrasionlevel
    # 滤波
    value1 = 3
    value2 = 1
    temp1 = cv2.bilateralFilter(image, value1 * 5, value1 * 12.5, value1 * 12.5)
    temp1 = temp1.astype('float')
    image = image.astype('float')
    
    # 细节
    temp2 = temp1 - image + 128
    
    # 细节滤波
    temp3 = cv2.GaussianBlur(temp2, (2 * value2 - 1, 2 * value2 - 1), 0, 0)
    
    # 
    temp4 = image + 2 * temp3 - 255
    dst = (image * (100 - p) + temp4 * p) / 100
    dst[dst < 0] = 0
    dst[dst > 255] = 255
    
    return dst
    

if __name__ == '__main__':
    
    parser = argparse.ArgumentParser()
    parser.add_argument('--image', 
                        default = '../../data/142204107567719.jpg', 
                        help = 'image to be processing')
    parser.add_argument('--level',
                        default = 20,
                        help = 'float data > 0 & < 100')
    args = parser.parse_args()
    
    imagename = args.image
    dermabrasionlevel = float(args.level)
    
    # 读取图像
    image = cv2.imread(imagename)

    filtered = dermabrasion(image, dermabrasionlevel)
    cv2.imwrite('ddd.jpg', filtered.astype('uint8'))

    cv2.imshow('image', image)
    cv2.imshow('filtered', filtered.astype('uint8'))
    
    cv2.waitKey(0)
    