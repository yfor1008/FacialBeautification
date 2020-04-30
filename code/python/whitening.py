# -*- coding: utf-8 -*-
"""
Created on Mon Nov 07 16:50:30 2016

美白

参数：
imagename 图像路径名字
whitenlevel 美白程度

@author: yuanwenjin
"""

import numpy as np
# from skimage import io
import cv2
# import matplotlib.pyplot as plt
import argparse

def whitening(image, whitenlevel):
    "美白"
    'image:图像数据,array'
    'whitenlevel:美白程度,>1'
    
    whiten = np.zeros(image.shape)
    image1 = image.astype(float) / 255
    whiten[:,:,0] = np.log(image1[:,:,0] * (whitenlevel - 1) + 1) / np.log(whitenlevel)
    whiten[:,:,1] = np.log(image1[:,:,1] * (whitenlevel - 1) + 1) / np.log(whitenlevel)
    whiten[:,:,2] = np.log(image1[:,:,2] * (whitenlevel - 1) + 1) / np.log(whitenlevel)
    
    return np.uint8(whiten * 255)

if __name__ == '__main__':
    
    parser = argparse.ArgumentParser()
    parser.add_argument('--image', 
                        default = '../../data/ddd.jpg', 
                        help = 'image to be processing')
    parser.add_argument('--level',
                        default = 5,
                        help = 'float data > 1')
    args = parser.parse_args()
    
    imagename = args.image
    whitenlevel = float(args.level)
    
    # 读取图像
    # image = io.imread(imagename)
    image = cv2.imread(imagename)
    
    # 显示图像
    # cv2.putText(image, 'beta=1', (400, 50), cv2.FONT_HERSHEY_SIMPLEX, 0.8, (0,0,255), 1, cv2.LINE_AA)
    # cv2.imwrite('gamma1.jpg', image)
    # cv2.imshow('off', image)
    # cv2.waitKey(0)

    # cv2.destroyAllWindows()
    
    whiten = whitening(image, whitenlevel)

    cv2.putText(whiten, 'beta=%s' % args.level, (400, 50), cv2.FONT_HERSHEY_SIMPLEX, 0.8, (0,0,255), 1, cv2.LINE_AA)
    cv2.imwrite('gamma%s.jpg' % args.level, whiten)
    cv2.imshow('off', whiten)
    cv2.waitKey(0)
