#!/usr/bin/env bash

TOGGLE=${HOME}/.toggle

if [ "$(uname -n)" = "goedel" ]; then
  PRIMARY=eDP1;
  SECONDARY=HDMI2;
elif [ "$(uname -n)" = "heisenberg" ]; then
  PRIMARY=eDP-1-1;
  SECONDARY=VGA-1-1;
fi


if [ ! -e "$TOGGLE" ]; then
  touch "$TOGGLE"
  xrandr --output "$PRIMARY" --auto --output "$SECONDARY" --auto --"$2-above" "$PRIMARY"
else
  rm ${TOGGLE}
  xrandr --output "$SECONDARY" --auto --off
fi

unset PRIMARY
unset SECONDARY
