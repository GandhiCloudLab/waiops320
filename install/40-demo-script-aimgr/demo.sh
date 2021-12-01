#!/bin/bash

source ./config.sh

menu_option_1() {

  date1=$(date '+%Y-%m-%d %H:%M:%S')
  echo "Introduce anomaly into ratings Service in BookInfo App ...started ....$date1"

  iks/iks-login.sh
  iks/induce-log-error.sh
  log-load/log-load-generate.sh

  date1=$(date '+%Y-%m-%d %H:%M:%S')
  echo "Introduce anomaly into ratings Service in BookInfo App...completed ....$date1"
}

menu_option_2() {
  date1=$(date '+%Y-%m-%d %H:%M:%S')
  echo "Clear log anomaly ...started ....$date1"
  
  iks/iks-login.sh
  iks/clear-log-error.sh

  date1=$(date '+%Y-%m-%d %H:%M:%S')
  echo "Clear log anomaly ...completed ....$date1"
}

press_enter() {
  echo ""
  read -p "	Press Enter to continue "
  clear
}

incorrect_selection() {
  echo "Incorrect selection! Try again."
}

clear

until [ "$selection" = "0" ]; do
  echo ""
  echo "      Watson AI-Ops Demo "
  echo "      -------------------"
  echo ""
  echo "      1  -  Introduce anomaly into BookInfo App"
  echo "      2  -  Clear log anomaly"
  echo ""
  echo "      0  -  Exit"
  echo ""
  read -p "      Enter selection: " selection
  echo ""
  case $selection in
    1 ) clear ; menu_option_1 ; press_enter ;;
    2 ) clear ; menu_option_2 ; press_enter ;;
    0 ) clear ; exit ;;
    * ) clear ; incorrect_selection ; press_enter ;;
  esac
done

