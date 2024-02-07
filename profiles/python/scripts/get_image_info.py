#!/usr/bin/env python3.9

import os
from PIL import Image # ,ImageDraw,ImageFont
import sys

# from s/o: <link>
def sizeof_fmt(num, suffix="B"):
  for unit in ["", "Ki", "Mi", "Gi", "Ti", "Pi", "Ei", "Zi"]:
    if abs(num) < 1024.0:
      return f"{num:3.1f}{unit}{suffix}"
    num /= 1024.0
  return f"{num:.1f}Yi{suffix}"

def main():
  if not sys.argv[1:]:
    print('usage: ./get-image-info.py $filepath')
    return None

  path = sys.argv[1]
  img = Image.open(path)
  bytessize = os.path.getsize(path)
  print(f'{{ "name"   : "{path}", "bytes": {bytessize}, "hbytes": "{sizeof_fmt(bytessize)}", "xy": "{img.size}" }}')
#   print(f'name   : {path}')
#   print(f'bytes  : {sizeof_fmt(os.path.getsize(path))}')
#   print(f'(x,y)  : {img.size}')


if __name__ == "__main__":
  main()
