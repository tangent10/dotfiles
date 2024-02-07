#!/usr/bin/env python3

from PIL import Image
import sys

def resize_image(path, w, h):
    # Output (max) size
    size = (w,h)
  
    # Open source
    im = Image.open(path)
   
    # resize, with quality/optimizer options
    smaller = im.resize(size, Image.ANTIALIAS)
    smaller.save(path)
    smaller.save(path, optimize=True, quality=95)

def main():
    if len(sys.argv) < 2:
        print('usage:\n  ./resize.py $filepath [width-and-height|width, height]')
        return None
  
    if len(sys.argv) == 3:
        width = int(sys.argv[2])
        height = int(sys.argv[2])
    elif len(sys.argv) > 3:
        width = int(sys.argv[2])
        height = int(sys.argv[3])
    else:
        print('usage:\n  ./resize.py $filepath [width-and-height|width, height]')


  
    print(f'shrinking file @ {sys.argv[1]}')
    resize_image(sys.argv[1], width, height)

if __name__ == "__main__":
    main()
