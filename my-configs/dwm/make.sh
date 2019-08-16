#! /usr/bin/env bash

branches=(
  "movestack"
  "config"
  "systray"
  "autostart"
  "pertag"
  "attachbottom"
  "bottomstack"
  "noborder"
  "hide_vacant_tags"
  "center"
  "dullbar"
)

fullclean() {
  make clean && \
  rm -f config.h && \
  git reset --hard origin/master
}

build() {
  make && sudo make clean install
}

apply() {
  for branch in "${branches[@]}"; do
    echo "merging $branch"
    git merge $branch -m $branch
  done
}

push_patches() {
  for branch in "${branches[@]}"; do
    git push gh "$branch"
  done
}

case "$@" in
  fullclean) 
    fullclean
  ;;

  build)
    build
  ;;

  apply)
    fullclean && apply
  ;;

  clean-build)
    fullclean && apply && build  
  ;;

  push-patches|push_patches)
    push_patches
  ;;
esac

