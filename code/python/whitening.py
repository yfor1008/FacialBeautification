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
from skimage import io
import matplotlib.pyplot as plt
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
                        default = '142204107567719.jpg', 
                        help = 'image to be processing')
    parser.add_argument('--level',
                        default = 3,
                        help = 'float data > 1')
    args = parser.parse_args()
    
    imagename = args.image
    whitenlevel = float(args.level)
    
    # 读取图像
    image = io.imread(imagename)
    
    # 显示图像
    plt.axis('off')
    plt.imshow(image)
    plt.show()
    
    whiten = whitening(image, whitenlevel)
    plt.axis('off')
    plt.imshow(whiten)
    plt.show()
