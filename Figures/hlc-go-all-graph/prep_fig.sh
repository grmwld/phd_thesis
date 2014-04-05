#!/usr/bin/env bash

convert hlc-go-all-graph.png -crop 8x1+150+0@ +repage +adjoin hlc-go-all-graph_%d.png

mogrify -trim +repage hlc-go-all-graph_{0,1,2,3,4,5,6,7}.png
