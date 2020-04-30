#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# gen_gif.py
# @Author :  生成gif
# @Link   : 
# @Date   : 2019-8-23 19:46:39

import imageio


def create_gif(image_list, gif_name, duration=0.8):
    frames = []
    for image_name in image_list:
        frames.append(imageio.imread(image_name))
    imageio.mimsave(gif_name, frames, 'GIF', duration=duration, fps=1)
    return


def main():
    image_list = ['gamma1.jpg', 'gamma2.jpg', 'gamma3.jpg', 'gamma4.jpg', 'gamma5.jpg']
    gif_name = 'beta.gif'
    duration = 0.8
    create_gif(image_list, gif_name, duration)


if __name__ == '__main__':
    main()
