#!/bin/bash

show_help() {
  echo "Usage: $0 [options]"
  echo "Options:"
  echo "  --desktop       Build for desktop"
  echo "  --device        Build for device"
  echo "  --build-all     Build for all architectures (arm64 and armhf)"
  echo "  --add-tag       Add a new tag"
  echo "  --remove-tag    Remove a specific tag"
  echo "  --help          Show help"
}

current_tag=$(git describe --tags --abbrev=0)

case $1 in
  --desktop)
    CLICKABLE_FRAMEWORK=ubuntu-sdk-20.04 clickable desktop
    ;;
  --device)
    CLICKABLE_FRAMEWORK=ubuntu-sdk-20.04 clickable
    ;;
  --build-all)
    CLICKABLE_FRAMEWORK=ubuntu-sdk-20.04 clickable build -a arm64
    CLICKABLE_FRAMEWORK=ubuntu-sdk-20.04 clickable build -a armhf
    ;;
  --add-tag)
    echo -n "New Tag: "
    read -r new_tag
    if [[ -z "$new_tag" ]]; then
      echo "Error: No new tag provided."
      exit 1
    fi
    git tag "$new_tag"
    ;;
  --remove-tag)
    echo -n "Tag to remove: "
    read -r tag_to_remove
    if [[ -z "$tag_to_remove" ]]; then
      echo "Error: No tag specified."
      exit 1
    fi
    git tag -d "$tag_to_remove"
    ;;
  --help)
    show_help
    ;;
  *)
    echo "Invalid option. Use --help for available options."
    exit 1
    ;;
esac
