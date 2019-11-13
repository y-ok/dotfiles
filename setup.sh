#!/bin/sh

set -eu

pacman -S --noconfirm gcc

curl "https://nim-lang.org/choosenim/init.sh" > init.sh
sh init.sh -y
rm init.sh
export PATH=$PATH:$HOME/.nimble/bin

nim --hints:off $DRY_RUN setup
