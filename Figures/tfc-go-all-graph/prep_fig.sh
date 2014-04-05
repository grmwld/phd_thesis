#!/usr/bin/env bash

convert ./tfc-go-all-graph.png -crop 8x1+100+0@ +repage +adjoin tfc-go-all-graph_%d.png

mogrify -trim +repage ./tfc-go-all-graph_*.png
