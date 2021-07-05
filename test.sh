#!/usr/bin/env bash

# home position by icubsim - loose L shape
if [[ $2 -eq 1 ]]; then 
fkin --model $1 --joints "(0.0 0.0 0.0 0.0 0.0 0.0 60.5 0.0 0.0 0.0)"
fi

# Arm in L shape - 90deg elbow
if [[ $2 -eq 2 ]]; then
fkin --model $1 --joints "(0.0 0.0 0.0 0.0 0.0 0.0 90.5 0.0 0.0 0.0)"
fi

# Arm in T-pose with palm facing forward
if [[ $2 -eq 3 ]]; then
fkin --model $1 --joints "(0 0 0 0 90 -30 15 0 0 0)"
fi
# Shoulder lift up with arm in L-shape and hand with negative pitch
if [[ $2 -eq 4 ]]; then 
fkin --model $1 --joints "(0.0 0.0 0.0 0.0 135.0 0.0 90.5 -90.0 -30.6 20.4)"
fi


