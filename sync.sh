#!/bin/bash


cp ../.bashrc .
cp ../.bash_profile .
cp ../profiles -r .
mkdir -p .config
cp ../.config/nvim -r .config
