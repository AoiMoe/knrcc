#! /bin/sh

usage() {
    echo "$1" >&2
    echo "$0 <repo URL>" >&2
    exit 1
}

test x"$1" = x && usage "error: no argument"

repo="$1"
shift

git remote add origin $repo
git push -f -u origin master
git push -f origin epoch v5 v6 v7
