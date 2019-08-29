#!/bin/bash

set -eu

THIS_DIR=$(
  cd "$(dirname "${BASH_SOURCE:-$0}")" && pwd
)
readonly THIS_DIR
cd "$THIS_DIR"

readonly DOTDIR=$HOME/dotfiles
OS=""

readonly RED=$'\x1b[31m'
readonly GREEN=$'\x1b[32m'
readonly RESET=$'\x1b[m'

main() {
  set_os
  update_packages
  before_install
  install_packages
  return $?
}

usage() {
  cat << EOS
TODO
EOS
}

set_os() {
  if has pacman; then
    OS=manjaro
  elif has apt; then
    OS=ubuntu
  elif has yum; then
    OS=centos
  else
    echo "Unsupported OS."
    exit 1
  fi
  readonly OS
  info "OS: $OS"
}

update_packages() {
  # manjaroは不要
  if [[ "$OS" == ubuntu ]]; then
    apt update -yqq >& /dev/null
  fi
}

before_install() {
  for cmd in git python3; do
    if ! has "$cmd"; then
      silent_install "$cmd"
    else
      info "$cmd はすでに存在します。"
    fi
  done

  if ! has pip3; then
    silent_install python-pip
  fi

  if ! has ansible; then
    pip3 install -q "ansible==v2.8.4"
    info "ansibleのインストールが完了しました。"
  fi
}

install_packages() {
  git clone -q https://github.com/jiro4989/dotfiles "$DOTDIR"
  cd "$DOTDIR/ansible"
  info "Ansibleでの環境構築を開始します。"
  info "この処理には非常に時間がかかります。"
  ansible-playbook "site_$OS.yaml"
  return $?
}

has() {
  type "$1" >& /dev/null
}

silent_install() {
  local pkg="$1"
  if [[ "$OS" == manjaro ]]; then
    pacman -Syyu --noconfirm "$pkg" >& /dev/null
  elif [[ "$OS" == ubuntu ]]; then
    apt install -yqq "$pkg" >& /dev/null
  else
    err "Unsupported OS. (OS = $OS)"
    exit 1
  fi
  info "$pkg のインストールが完了しました。"
}

log() {
  local level="$1"
  shift
  echo -e "[ $level ] $*" >&2
}

info() {
  log "${GREEN}info${RESET}" "$*"
}

err() {
  log "${RED}err${RESET}" "$*"
}

main ${1+"$@"}
exit $?