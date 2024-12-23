#!/bin/sh

RAYLIB_INCLUDE_PATH="/opt/homebrew/opt/raylib"

zig build-exe main.zig -O ReleaseFast -idirafter $RAYLIB_INCLUDE_PATH/include -idirafter $RAYLIB_INCLUDE_PATH/src/external -idirafter ./ -L$RAYLIB_INCLUDE_PATH/lib -lc -lraylib

