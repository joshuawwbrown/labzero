#!/bin/bash
while read x; do
    echo -n "[";
    echo -n `date +%Y-%m-%d\ %H:%M:%S`;
    echo -n "] ";
    echo $x;
done
