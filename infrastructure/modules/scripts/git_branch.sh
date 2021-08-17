#!/bin/bash

git branch | grep "*" | sed s/\*\ //g