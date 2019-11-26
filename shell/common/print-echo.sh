#!/bin/bash

SupportColor=("black","red","green","yellow","blue","purple","sky-blue","white")
USAGE(){
    echo "$0 Text [${SupportColor}]"
}

print(){
    color=$1
    shift
    text=$@
    if [ -z "${color}" ];then
        USAGE
    fi

    if [ -z "${text}" ];then
        USAGE
    fi
    case ${color} in
    black)
    echo -e "\033[30m ${text} \033[0m"
    ;;
    red)
    echo -e "\033[31m ${text} \033[0m"
    ;;
    green)
    echo -e "\033[32m ${text} \033[0m"
    ;;
    yellow)
    echo -e "\033[33m ${text} \033[0m"
    ;;
    blue)
    echo -e "\033[34m ${text} \033[0m"
    ;;
    purple)
    echo -e "\033[35m ${text} \033[0m"
    ;;
    sky-blue)
    echo -e "\033[36m ${text} \033[0m"
    ;;
    white)
    echo -e "\033[37m ${text} \033[0m"
    ;;
    *)
    USAGE
    ;;
    esac
}

print_msg(){
    msg=$@
    echo "$msg"
}

print_err(){
    text=$@
    print red $text
}
# test
#print red "this is red"
#print black "this is black"
#print green "this is green"
#print yellow "this is yellow"
#print blue "this is blue"
#print purple "this is purple"
#print sky-blue "this is sky-blue"
#print white "this is white"
#print other "this is other"
#echo "---------------------------------"
#print_err "this is error"


