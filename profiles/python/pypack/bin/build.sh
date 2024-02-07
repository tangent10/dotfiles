#!/bin/bash

function conda_build()
{
  python3 -m pip install --no-deps .
}

conda_build "$@"
