#!/usr/bin/env bash

convert ./hlc-go-pot-down.png -crop 4x1+100+0@ +repage +adjoin hlc-go-pot-down_%d.png

mogrify -trim +repage ./hlc-go-pot-down_*.png
