#!/bin/bash
echo "Current Tag Version:"
current_tag= git describe --tags --abbrev=0
case $1 in
 --desktop)
 CLICKABLE_FRAMEWORK=ubuntu-sdk-20.04 clickable desktop
 ;;
 --device)
 clickable
 ;;
 --build-all)
 clickable build -a arm64
 clickable build -a armhf
 ;;
 --add-tag)
 echo -n "New Tag: "
 read new_tag
 echo $new_tag
 git tag $new_tag
 esac