#!/usr/bin/env bash

declare ARGS=$*

function usage() {
cat<<-EOF
        $0 [options]
        Options:
            --distr [ubuntu|debian|centos]
              Manually set the distribution for appropriate Ansible installation.
            --skip-ansible [y|n]
              Skip Ansible check and installation, assuming you have ansible-playbook working.
            --skip-playbook [y|n]
              Don't run install.yml playbook.
            --force-yes [y|n]
              Do not ask if you want to proceed with Ansible installation.


EOF
}

function main () {
  if [ "$(get_opt skip-ansible)" = y ]; then
    echo "Force skipping Ansible installation"
  else
    if $(get_ansible); then
      echo "Found installed Ansible, using it."
    else
      # Ansible installation
      local dist=$(get_dist)
      if [ $(get_dist) = unknown ]; then
        echo2 "Can't determine Linux distribution."
        echo2 "use --dist [ubuntu|debian|centos] to force set distribution"
        echo2 "or --skip-ansible to force skip Ansible installation."
        exit 1
      else
        local confirm=n
        if [ "$(get_opt force-yes)" = y ]; then
          confirm=y
        else
          read -p "Enter 'y' to proceed with Ansible installation: " confirm
        fi
        if [ "$confirm" = y ] || [ "$confirm" = Y ]; then
          echo "Installing Ansible on $dist."
          install_ansible_$dist
        else
          echo2 "Ansible installation aborted, exiting installer."
          echo2 "Use --skip-ansible to force skip Ansible installation."
        fi
      fi
    fi
  fi

  if [ "$(get_opt skip-playbook)" = y ]; then
    echo "Skipping playbook execution."
  else
    run_playbook
  fi
}

function echo2() {
  >&2 echo "Error: $*"
}

function get_opt() {
  local opt=$1
  echo "$ARGS"| sed -rne "s/.*--${opt}\s+([0-9a-zA-Z_\\-]+).*/\1/p"
}

function is_usage_set() {
  echo "$ARGS"| grep -qE '\-\-(help|usage)'
}

function get_ansible() {
  which ansible-playbook >/dev/null 2>&1
}

function install_ansible_redhat() {
  sudo yum install epel-release -y \
  && sudo yum install ansible -y
}

function install_ansible_debian() {
  echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu bionic main" > /etc/apt/sources.list.d/ansible-alc.list \
  && apt install sudo dirmngr -y \
  && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 93C4A3FD7BB9C367 \
  && apt update \
  && apt install ansible -y
}

function install_ansible_ubuntu() {
  sudo apt update -y \
  && sudo apt install software-properties-common -y \
  && sudo apt-add-repository --yes --update ppa:ansible/ansible \
  && sudo apt install ansible -y
}

function get_dist() {
  local force_dist=$(get_opt dist)
  if [ -z "$force_dist" ]; then
    if [ -f /etc/debian_version ]; then
      if source /etc/os-release; then
        case "$ID" in
          debian)
          echo debian
          ;;
          ubuntu)
          echo ubuntu
          ;;
          *)
          echo unknown
          ;;
        esac
      else
        echo unknown
      fi
    elif [ -f /etc/redhat-release ]; then
      echo redhat
    elif [ -f /etc/centos-release ]; then
      echo redhat
    else
      echo unknown
    fi
  else
    echo $force_dist
  fi
}

function run_playbook() {
  ansible-playbook install.yml
}

function check_root() {
  if [ $UID -ne 0 ]; then
    echo2 "This script requires root priviledges, please use sudo or run it as root user."
    exit 1
  fi
}

if $(is_usage_set); then
  usage
else
  check_root
  main
fi
