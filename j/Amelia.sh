#!/bin/bash

# Amelia Installer
# Version: 7.0

set -euo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR
###################################################################################################
# COLOR FUNCTIONS
        redbgbl="\e[5;1;41m" #blink bg
        redbg="\e[1;41m" #bg
        red="\e[31m"
        greenbgbl="\e[5;1;42m" #blink bg
        greenbg="\e[1;42m" #bg
        green="\e[32m"
        yellowbgbl="\e[5;1;43m" #blink bg
        yellowbg="\e[1;43m" #bg
        yellow="\e[33m"
        yellowl="\e[93m"
        bluebgbl="\e[5;1;44m" #blink bg
        bluebg="\e[1;44m" #bg
        blue="\e[94m"
        magentabgbl="\e[5;1;45m" #blink bg
        magentabg="\e[1;45m" #bg
        magenta="\e[35m"
        cyanbgbl="\e[5;1;46m" #blink bg
        cyanbg="\e[1;46m" #bg
        cyan="\e[36m"
        bwhite="\e[0;97m" #bright
        nc="\e[0m"

REDBGBL (){
        echo -e "${redbgbl} $1${nc}"
}
REDBG (){
        echo -e "${redbg} $1${nc}"
}
RED (){
        echo -e "${red} $1${nc}"
}
GREENBGBL (){
        echo -e "${greenbgbl} $1${nc}"
}
GREENBG (){
        echo -e "${greenbg} $1${nc}"
}
GREEN (){
        echo -e "${green} $1${nc}"
}
YELLOWBGBL (){
        echo -e "${yellowbgbl} $1${nc}"
}
YELLOWBG (){
        echo -e "${yellowbg} $1${nc}"
}
YELLOW (){
        echo -e "${yellow} $1${nc}"
}
YELLOWL (){
        echo -e "${yellowl} $1${nc}"
}
BLUEBGBL (){
        echo -e "${bluebgbl} $1${nc}"
}
BLUEBG (){
        echo -e "${bluebg} $1${nc}"
}
BLUE (){
        echo -e "${blue} $1${nc}"
}
MAGENTABGBL (){
        echo -e "${magentabgbl} $1${nc}"
}
MAGENTABG (){
        echo -e "${magentabg} $1${nc}"
}
MAGENTA (){
        echo -e "${magenta} $1${nc}"
}
CYANBGBL (){
        echo -e "${cyanbgbl} $1${nc}"
}
CYANBG (){
        echo -e "${cyanbg} $1${nc}"
}
CYAN (){
        echo -e "${cyan} $1${nc}"
}
NC (){
        echo -e "${nc} $1${nc}"
}
WHITEB (){
        echo -e "${bwhite} $1${nc}"
}
# END COLOR FUNCTIONS

###################################################################################################
# PROMPT FUNCTIONS
skip (){
        sleep 0.2
        YELLOW "
    -->  Skipping.. "
}
reload (){
        sleep 0.2
        NC "

  --> [${green}Reloading${nc}] "
}
invalid (){
        sleep 0.2
        RED "
        --------------------------
        ###  ${yellow}Invalid Response  ${red}###
        --------------------------"
        reload
}
err_try (){
        sleep 0.2
        RED "
        --------------------------------------------
        ###  ${yellow}Errors occured. Please try again..  ${red}### 
        --------------------------------------------"
        reload
}
err_abort (){
        sleep 0.2
        RED "
        ------------------------
        ###  ${yellow}Errors occured  ${red}### 
        ------------------------"
        failure
}
line2 (){
        printf '\n\n'
}
line3 (){
        printf '\n\n\n'
}
unmount (){
        sleep 0.2
        line3
        REDBG "       ${yellow}------------------------- "
        REDBG "       ${yellow}[!] Unmount and Retry [!] "
        REDBG "       ${yellow}------------------------- "
        echo
        reload
        sleep 0.2
        NC "


${magenta}###${nc}-----------------------------------${magenta}[ ${bwhite}Unmount Filesystems${nc} ${magenta}]${nc}-----------------------------------${magenta}###${nc}
        "
    if umount -R /mnt > /dev/null 2>&1 ; then
        sleep 0.2
        NC "

        ------------------
        ### ${green}Unmount OK ${nc}###
        ------------------"
    else
        sleep 0.2
        RED "

        -----------------------------
        ###  ${yellow}Unmounting Failed..  ${red}### 
        -----------------------------"
        failure
    fi
}
unmount_noabort (){
        sleep 0.2
        line3
        REDBG "       ${yellow}------------------------- "
        REDBG "       ${yellow}[!] Unmount and Retry [!] "
        REDBG "       ${yellow}------------------------- "
        sleep 0.2
        NC "


${magenta}###${nc}-----------------------------------${magenta}[ ${bwhite}Unmount Filesystems${nc} ${magenta}]${nc}-----------------------------------${magenta}###${nc}
        "
    if umount -R /mnt > /dev/null 2>&1 ; then
        sleep 0.2
        NC "

        ------------------
        ### ${green}Unmount OK ${nc}###
        ------------------"
        reload
    else
        sleep 0.2
        RED "

        -----------------------------
        ###  ${yellow}Unmounting Failed..  ${red}### 
        -----------------------------"
        reload
    fi
}
umount_abort (){
        unmount
        reload
}
umount_manual (){
        unmount
        sleep 0.2
        NC "

  --> [Switching to ${green}Manual Mode${nc}]"
}
choice (){
        sleep 0.2
        RED "
        --------------------------------------------
        ###  ${yellow}Please make a choice to continue..  ${red}###
        --------------------------------------------"
        reload
}
y_n (){
        sleep 0.2
        RED "
        ----------------------------------------------
        ###  ${yellow}Please type 'y' or 'n' to continue..  ${red}###
        ----------------------------------------------"
        reload
}
yes_no (){
        sleep 0.2
        RED "
        -------------------------------------------------
        ###  ${yellow}Please type 'yes' or 'no' to continue..  ${red}###
        -------------------------------------------------"
        reload
}
ok (){
        sleep 0.2
        NC "

==> [${green}${prompt} OK${nc}] "
}
stage_ok (){
        sleep 0.2
        NC "

==> [${green}${stage_prompt} configuration OK${nc}] "
        sleep 2
}
stage_fail (){
        sleep 0.2
        line2
        REDBG "       ${yellow}[!] ${stage_prompt} configuration FAILED [!]"
        failure
}
completion_err (){
        sleep 0.2
        CYAN "



        [!] Please complete${nc} '${stage_prompt}' ${cyan}to continue
        "
}
intel (){
        line2
        BLUEBG "       --------------------------------- "
        BLUEBG "       ###  INTEL Graphics detected  ### "
        BLUEBG "       --------------------------------- "
        NC "

          *  ${vgacard}
        "
}
nvidia (){
        line2
        GREENBG "       ---------------------------------- "
        GREENBG "       ###  NVIDIA Graphics detected  ### "
        GREENBG "       ---------------------------------- "
        NC "

          *  ${vgacard}
        "
}
amd (){
        line2
        REDBG "       ------------------------------- "
        REDBG "       ###  AMD Graphics detected  ### "
        REDBG "       ------------------------------- "
        NC "

          *  ${vgacard}
        "
}
arch (){
        sleep 0.2
        line3
        BLUEBG "************************************************************************************************* "
        BLUEBG "                                                                                                  "
        BLUEBG "                            #####     Archlinux Installation     #####                            "
        BLUEBG "                                                                                                  "
        BLUEBG "************************************************************************************************* "
        line2
}
cnfg (){
        sleep 0.2
        line3
        MAGENTABG "------------------------------------------------------------------------------------------------- "
        MAGENTABG "                                  ###     Configuring...     ###                                  "
        MAGENTABG "------------------------------------------------------------------------------------------------- "
        echo
        sleep 0.2
}
completion (){
        sleep 0.2
        line3
        GREENBG "************************************************************************************************* "
        GREENBG "                                                                                                  "
        GREENBG "                              ###     Installation Completed     ###                              "
        GREENBG "                                                                                                  "
        GREENBG "************************************************************************************************* "
        line3
}
failure (){
        sleep 0.2
        line3
        REDBG "************************************************************************************************* "
        REDBG "                                                                                                  "
        REDBG "                               ###     Installation Aborted     ###                               "
        REDBG "                                                                                                  "
        REDBG "************************************************************************************************* "
        line3
        exit
}
# END PROMPT FUNCTIONS

###################################################################################################
# FUNCTIONS
first_check (){

    if [[ "${tty}" == *"tty"* && -f /usr/share/kbd/consolefonts/ter-v18b.psf.gz && -f /usr/share/kbd/consolefonts/ter-v32b.psf.gz ]]; then
        until slct_font; do : ; done
    elif [[ "${tty}" == *"pts"* && -f /usr/share/kbd/consolefonts/ter-v18b.psf.gz && -f /usr/share/kbd/consolefonts/ter-v32b.psf.gz ]]; then   
        MAGENTABG "      'Terminus Font' detected  >  Switch to console (tty) and re-run the installer to activate   "
        echo
    fi
    if [[ "${run_as}" == "root" ]]; then
        REDBGBL "                             ${yellow}----------------------------------------                             "
        REDBGBL "                             ${yellow}###  The Installer Runs In ROOT Mode ###                             "
        REDBGBL "                             ${yellow}----------------------------------------                             "
    else
        YELLOWBGBL "                             ----------------------------------------                             "
        YELLOWBGBL "                             ###  The Installer Runs In DEMO Mode ###                             "
        YELLOWBGBL "                             ----------------------------------------                             "
    fi
}
###################################################################################################
slct_font (){

        sleep 0.2
        NC "


${magenta}###${nc}-------------------------------------${magenta}[ ${bwhite}Font  Selection${nc} ${magenta}]${nc}--------------------------------------${magenta}###${nc}
        "
        YELLOW "

        >  Select a Font: "
        NC "

            [1]  Terminus Font

            [2]  HiDPI Terminus Font "
        BLUE "


Enter a number: "
        read -r -p "
==> " fontselect
        echo

    if [[ "${fontselect}" == "1" ]]; then
        setfont ter-v18b
    elif [[ "${fontselect}" == "2" ]]; then
        setfont ter-v32b
    else
        invalid
        return 1
    fi
        clear
}
###################################################################################################
uefi_check (){

        bootmode="$(cat /sys/firmware/efi/fw_platform_size)"
        local prompt="UEFI ${bootmode}-bit Mode"
        sleep 0.2
        NC "


${magenta}###${nc}---------------------------------${magenta}[ ${bwhite}UEFI Mode  Verification${nc} ${magenta}]${nc}---------------------------------${magenta}###${nc}
        "

    if [[ "${bootmode}" == "64" || "${bootmode}" == "32" ]]; then
        ok
    else
        RED "
        --------------------------
        ###  ${yellow}Not in UEFI Mode  ${red}###
        --------------------------"
        failure
    fi
}
###################################################################################################
connection_check (){

        local prompt="Internet Connection"
        sleep 0.2
        NC "


${magenta}###${nc}--------------------------------${magenta}[ ${bwhite}Internet Connection Check${nc} ${magenta}]${nc}--------------------------------${magenta}###${nc}
        "

    if ping -c 3 archlinux.org  > /dev/null 2>&1; then
        ok
    else
        RED "


        ----------------------------------------------------------------------
        ###  ${yellow}A connection to ${nc}'www.archlinux.org' ${yellow}could not be established  ${red}###
        ----------------------------------------------------------------------
        "
        failure
    fi
}
###################################################################################################
upd_clock (){

        local prompt="System Clock"
        sleep 0.2
        NC "


${magenta}###${nc}-----------------------------------${magenta}[ ${bwhite}System Clock Update${nc} ${magenta}]${nc}-----------------------------------${magenta}###${nc}


        "
        sleep 0.2
        timedatectl
        ok
}
###################################################################################################
dtct_microcode (){

        local prompt="Microcode"
        sleep 0.2
        NC "


${magenta}###${nc}-----------------------------------${magenta}[ ${bwhite}Microcode Detection${nc} ${magenta}]${nc}-----------------------------------${magenta}###${nc}
        "

        CPU="$(grep -E 'vendor_id' /proc/cpuinfo)"
    if [[ "${CPU}" == *"GenuineIntel"* ]]; then
        microcode="intel-ucode"
        nrg_plc="x86_energy_perf_policy"
        microname="Intel"
    else
        microcode="amd-ucode"
        microname="AMD"
    fi
        sleep 0.2
        YELLOW "

        ###  Detection completed, the ${microname} microcode will be installed
        "
        ok
}
###################################################################################################
main_menu (){

        sleep 0.2
        NC "


${magenta}###${nc}----------------------------------------${magenta}[ ${bwhite}Main Menu${nc} ${magenta}]${nc}----------------------------------------${magenta}###${nc}
        "
        YELLOW "

        >  Make a selection: "
        RED "

        ---------------------------------------------------------------------
        ###  ${yellow}Select ${bwhite}[4] ${nc}${yellow}for ${nc}'Guided Navigation' ${yellow}and ${nc}'Smart Partitioning'  ${red}###
        ---------------------------------------------------------------------"
        NC "

            [1]  Personalization

            [2]  System Configuration

            [3]  Disk Management

            [4]  Start Installation "
        BLUE "


Enter a number: "
        read -r -p "
==> " menu
        echo

    case "${menu}" in
        1)
            until persnl_submn; do : ; done ;;
        2)
            until sys_submn; do : ; done ;;
        3)
            until dsks_submn; do : ; done ;;
        4)
            until instl; do : ; done ;;
       "")
            sleep 0.2
            RED "
        ---------------------------------
        ###  ${yellow}Please select a Submenu  ${red}###
        ---------------------------------"
            reload
            return 1 ;;
        *)
            invalid
            return 1 ;;
    esac
}
###################################################################################################
persnl_submn (){

        sleep 0.2
        NC "


${magenta}###${nc}-------------------------------------${magenta}[ ${bwhite}Personalization${nc} ${magenta}]${nc}-------------------------------------${magenta}###${nc}
        "
        YELLOW "

        >  Select a Submenu: "
        NC "

            [1]  Locale & Keyboard Layout Setup

            [2]  User, Root User & Hostname Setup

            [ ]  Return to Main Menu "
        BLUE "


Enter a number: "
        read -r -p "
==> " persmenu
        echo

    case "${persmenu}" in
        1)
            until slct_locale; do : ; done
            until slct_kbd; do : ; done
            return 1 ;;
        2)
            until user_setup; do : ; done
            until rootuser_setup; do : ; done
            until slct_hostname; do : ; done
            return 1 ;;
       "")
            until main_menu; do : ; done ;;
        *)
            invalid
            return 1 ;;
    esac
}
###################################################################################################
slct_locale (){

        local prompt="Locale"
        sleep 0.2
        NC "


${magenta}###${nc}------------------------------------${magenta}[ ${bwhite}Locale  Selection${nc} ${magenta}]${nc}------------------------------------${magenta}###${nc}
        "
        YELLOW "

        >  Select your Locale 
        

        ###  [Enter ${nc}'l'${yellow} to list locales, then ${nc}'enter'${yellow} to search or ${nc}'q'${yellow} to quit]

        ###  Exclude '.UTF_8' suffix "
        BLUE "


Enter your Locale ${bwhite}(empty for 'en_US')${blue}: "
        read -r -p "
==> " LOCALESET
        echo

    if [[ -z "${LOCALESET}" ]]; then
        SETLOCALE="en_US.UTF-8"
        sleep 0.2
        YELLOW "

        ###  en_US.UTF-8 Locale has been selected
        "
    elif [[ "${LOCALESET}" == "l" ]]; then
        grep -E 'UTF-8' /usr/share/i18n/SUPPORTED | more
        return 1
    elif ! grep -q "^#\?$(sed 's/[].*[]/\\&/g' <<< "${LOCALESET}") " /usr/share/i18n/SUPPORTED; then
        invalid
        return 1
    else
        SETLOCALE="${LOCALESET}.UTF-8"
        sleep 0.2
        YELLOW "

        ###  ${SETLOCALE} Locale has been selected
        "
    fi
        ok
        lcl_slct="yes"
}
###################################################################################################
slct_kbd (){

        local prompt="Keyboard Layout"
        sleep 0.2
        NC "


${magenta}###${nc}--------------------------------${magenta}[ ${bwhite}Keyboard Layout Selection${nc} ${magenta}]${nc}--------------------------------${magenta}###${nc}
        "
        YELLOW "

        > Select your Keyboard Layout


        ###  [Enter ${nc}'l'${yellow} to list layouts, then ${nc}'enter'${yellow} to search or ${nc}'q'${yellow} to quit] "
        BLUE "


Enter your keyboard layout ${bwhite}(empty for 'us')${blue}: "
        read -r -p "
==> " SETKBD
        echo

    if [[ -z "${SETKBD}" ]]; then
        SETKBD="us"
        sleep 0.2
        YELLOW "

        ###  us Keyboard Layout has been selected
        "
    elif [[ "${SETKBD}" == "l" ]]; then
        localectl list-keymaps | more
        return 1
    elif ! localectl list-keymaps | grep -Fxq "${SETKBD}"; then
        invalid
        return 1
    else
        sleep 0.2
        YELLOW "

        ###  ${SETKBD} Keyboard Layout has been selected
        "
        loadkeys "${SETKBD}" > /dev/null 2>&1
    fi
        ok
}
###################################################################################################
user_setup (){

        local prompt="User"
        sleep 0.2
        NC "


${magenta}###${nc}---------------------------------------${magenta}[ ${bwhite}User  Setup${nc} ${magenta}]${nc}---------------------------------------${magenta}###${nc}
        "
        BLUE "

Enter a username: "
        read -r -p "
==> " USERNAME
        echo

    if [[ -z "${USERNAME}" ]]; then
        sleep 0.2
        RED "
        ---------------------------------------------
        ###  ${yellow}Please enter a username to continue  ${red}###
        ---------------------------------------------"
        reload
        return 1
    elif [[ "${USERNAME}" =~ [[:upper:]] ]]; then
        sleep 0.2
        RED "
        ------------------------------------------------------
        ###  ${yellow}Uppercase is not allowed. Please try again..  ${red}###
        ------------------------------------------------------"
        reload
        return 1
    fi

        BLUE "
Enter a password for${nc} ${cyan}${USERNAME}${blue}: "
        read -r -p "
==> " USERPASSWD
        echo

    if [[ -z "${USERPASSWD}" ]]; then
        sleep 0.2
        RED "
        ---------------------------------------------
        ###  ${yellow}Please enter a password to continue  ${red}###
        ---------------------------------------------"
        reload
        return 1
    fi

        BLUE "
Re-enter${nc} ${cyan}${USERNAME}'s ${blue}password: "
        read -r -p "
==> " USERPASSWD2
        echo

    if [[ "${USERPASSWD}" != "${USERPASSWD2}" ]]; then
        sleep 0.2
        RED "
        ---------------------------------------------------
        ###  ${yellow}Passwords don't match. Please try again..  ${red}###
        ---------------------------------------------------"
        reload
        return 1
    fi
        ok
}
###################################################################################################
rootuser_setup (){

        local prompt="Root User"
        sleep 0.2
        NC "


${magenta}###${nc}-------------------------------------${magenta}[ ${bwhite}Root User Setup${nc} ${magenta}]${nc}-------------------------------------${magenta}###${nc}
        "
        BLUE "

Enter a password for the${nc}${cyan} Root ${blue}user: "
        read -r -p "
==> " ROOTPASSWD
        echo

    if [[ -z "${ROOTPASSWD}" ]]; then
        sleep 0.2
        RED "
        ---------------------------------------------------------------
        ###  ${yellow}Please enter a password for the Root user to continue  ${red}###
        ---------------------------------------------------------------"
        reload
        return 1
    fi
        BLUE "

Re-enter${nc} ${cyan}Root ${blue}user's password: "
        read -r -p "
==> " ROOTPASSWD2
        echo
        
    if [[ "${ROOTPASSWD}" != "${ROOTPASSWD2}" ]]; then
        sleep 0.2
        RED "
        ---------------------------------------------------
        ###  ${yellow}Passwords don't match. Please try again..  ${red}###
        ---------------------------------------------------"
        reload
        return 1
    fi
        ok
}
###################################################################################################
slct_hostname (){

        local prompt="Hostname"
        sleep 0.2
        NC "


${magenta}###${nc}-------------------------------------${magenta}[ ${bwhite}Hostname  Setup${nc} ${magenta}]${nc}-------------------------------------${magenta}###${nc}
        "
        BLUE "

Enter a hostname: "
        read -r -p "
==> " HOSTNAME
        echo

    if [[ -z "${HOSTNAME}" ]]; then
        sleep 0.2
        RED "
        ---------------------------------------------
        ###  ${yellow}Please enter a hostname to continue  ${red}###
        ---------------------------------------------"
        reload
        return 1
    elif [[ "${HOSTNAME}" =~ [[:upper:]] ]]; then
        sleep 0.2
        RED "
        ----------------------------------------------------
        ###  ${yellow}Lowercase is preferred. Please try again..  ${red}###
        ----------------------------------------------------"
        reload
        return 1
    fi
        ok
}
###################################################################################################
sys_submn (){

        sleep 0.2
        NC "


${magenta}###${nc}----------------------------------${magenta}[ ${bwhite}System  Configuration${nc} ${magenta}]${nc}----------------------------------${magenta}###${nc}
        "
        YELLOW "

        >  Select a Submenu: "
        NC "

            [1]  Kernel, Bootloader & ESP Mountpoint Setup

            [2]  Filesystem & Swap Setup

            [3]  Graphics Setup

            [4]  Desktop Setup

            [5]  EFI Boot Entries Deletion

            [6]  Wireless Regulatory Domain Setup

            [ ]  Return to Main Menu "
        BLUE "


Enter a number: "
        read -r -p "
==> " sysmenu
        echo

    case "${sysmenu}" in
        1)
            until slct_krnl; do : ; done
            until ask_bootldr; do : ; done
            until slct_espmnt; do : ; done
            return 1 ;;
        2)
            until ask_fs; do : ; done
            until ask_swap; do : ; done
            return 1 ;;
        3)
            until dtct_hyper; do : ; done
            until dtct_vga; do : ; done
            return 1 ;;
        4)
            until slct_dsktp; do : ; done
            return 1 ;;
        5)
            until boot_entr; do : ; done
            return 1 ;;
        6)
            until wireless_rgd; do : ; done
            return 1 ;;
       "")
            until main_menu; do : ; done ;;
        *)
            invalid
            return 1 ;;
    esac
}
###################################################################################################
slct_krnl (){

        local prompt="Kernel"
        sleep 0.2
        NC "
   

${magenta}###${nc}------------------------------------${magenta}[ ${bwhite}Kernel  Selection${nc} ${magenta}]${nc}------------------------------------${magenta}###${nc}
        "
        YELLOW "

        >  Select a Kernel: "
        NC "

            [1]  Linux

            [2]  Linux LTS

            [3]  Linux Hardened

            [4]  Linux Zen "
        BLUE "


Enter a number: "
        read -r -p "
==> " kernelnmbr
        echo

    case "${kernelnmbr}" in
        1)
            kernel="linux"
            kernelname="Linux"
            entrname="Arch Linux" ;;
        2)
            kernel="linux-lts"
            kernelname="Linux LTS"
            entrname="Arch Linux LTS" ;;
        3)
            kernel="linux-hardened"
            kernelname="Linux Hardened"
            entrname="Arch Linux Hardened" ;;
        4)
            kernel="linux-zen"
            kernelname="Linux Zen"
            entrname="Arch Linux Zen" ;;
       "")
            sleep 0.2
            RED "
        --------------------------------
        ###  ${yellow}Please select a Kernel  ${red}###
        --------------------------------"
            reload
            return 1 ;;
        *)
            invalid
            return 1 ;;
    esac

        sleep 0.2
        YELLOW "

        ###  The ${kernelname} kernel has been selected
        "
    if [[ "${kernelnmbr}" == "3" ]]; then

        CYAN "
        [!] Swapping is not supported [!]
        "
    fi
        ok
    if [[ "${vga_slct}" == "yes" ]]; then
        local stage_prompt="Graphics Setup"
        completion_err
        until dtct_vga; do : ; done
    fi
}
###################################################################################################
ask_bootldr (){

        local prompt="Bootloader"
        sleep 0.2
        NC "


${magenta}###${nc}----------------------------------${magenta}[ ${bwhite}Bootloader  Selection${nc} ${magenta}]${nc}----------------------------------${magenta}###${nc}
        "
        YELLOW "

        >  Select a Bootloader: "
        NC "

            [1]  Systemd-boot

            [2]  Grub "
        BLUE "


Enter a number: "
        read -r -p "
==> " bootloader
        echo

    case "${bootloader}" in
        1)
            sleep 0.2
            YELLOW "

        ###  Systemd-boot has been selected
            " ;;
        2)
            sleep 0.2
            YELLOW "

        ###  Grub has been selected
            " ;;
       "")
            sleep 0.2
            RED "
        ------------------------------------
        ###  ${yellow}Please select a Bootloader  ${red}###
        ------------------------------------"
            reload
            return 1 ;;
        *)
            invalid
            return 1 ;;
    esac
        ok
}
###################################################################################################
slct_espmnt (){

        local prompt="ESP Mountpoint"
        sleep 0.2
        NC "


${magenta}###${nc}--------------------------------${magenta}[ ${bwhite}ESP  Mountpoint Selection${nc} ${magenta}]${nc}---------------------------------${magenta}###${nc}
        "
        YELLOW "

        >  Select a Mountpoint for the ESP: "
        NC "

            [1]  /mnt/efi

            [2]  /mnt/boot "
        BLUE "


Enter a number: "
        read -r -p "
==> " espmnt
        echo

    if [[ "${espmnt}" == "1" ]]; then
        esp_mount="/mnt/efi"
        btldr_esp_mount="/efi"
        if [[ "${bootloader}" == "1" ]]; then
            xbootloader="yes"
        fi
        sleep 0.2
        YELLOW "

        ###  '/mnt/efi' mountpoint has been selected
        "
    elif [[ "${espmnt}" == "2" ]]; then
        esp_mount="/mnt/boot"
        btldr_esp_mount="/boot"
        sleep 0.2
        YELLOW "

        ###  '/mnt/boot' mountpoint has been selected
        "
    else
        invalid
        return 1
    fi
        ok
    if [[ "${sanity}" == "no" ]]; then
        until sanity_check; do : ; done
    fi
}
###################################################################################################
ask_fs (){

        local prompt="Filesystem Setup"
        sleep 0.2
        NC "


${magenta}###${nc}----------------------------------${magenta}[ ${bwhite}Filesystem  Selection${nc} ${magenta}]${nc}----------------------------------${magenta}###${nc}
        "
        YELLOW "

        >  Select Filesystem to be used: "
        NC "

            [1]  Ext4

            [2]  Btrfs "
        BLUE "


Enter a number: "
        read -r -p "
==> " fs
        echo

    case "${fs}" in
        1)
            fsname="Ext4"
            fs_mod="ext4"
            fstools="e2fsprogs"
            roottype="/Root"
            sleep 0.2
            YELLOW "

        ###  NOTE: Keeping User Data on a separate /Home Partition is supported


        >  Make use of a dedicated /Home Partition ? [y/n] "
            BLUE "


Enter [y/n]: "
            read -r -p "
==> " sep_home
            echo

                case "${sep_home}" in
                    y)
                        sleep 0.2
                        YELLOW "

        ###  A /Home Partition will be created ";;
                    n)
                        skip 
                        echo;;
                   "")
                        sleep 0.2
                        y_n
                        return 1 ;;
                    *)
                        invalid
                        return 1 ;;
                esac
            sleep 0.2
            YELLOW "

        ###  ${fsname} has been selected
            " ;;
        2)
            fsname="Btrfs"
            fs_mod="btrfs"
            fstools="btrfs-progs"
            roottype="/@"
            btrfs_bootopts="rootflags=subvol=@ "
            sleep 0.2
            YELLOW "

        ###  ${fsname} has been selected "
            sleep 0.2
            YELLOW "

        >  Label your Btrfs snapshot directory: "
            BLUE "


Enter a name: "
            read -r -p "
==> " snapname
            echo

            if [[ -z "${snapname}" ]]; then
                invalid
                return 1
            fi ;;
       "")
            sleep 0.2
            RED "
        ------------------------------------
        ###  ${yellow}Please select a Filesystem  ${red}###
        ------------------------------------"
            reload
            return 1 ;;
        *)
            invalid
            return 1 ;;
    esac
        ok
}
###################################################################################################
ask_swap (){

        local prompt="Swap Setup"
        sleep 0.2
        NC "


${magenta}###${nc}-------------------------------------${magenta}[ ${bwhite}Swap  Selection${nc} ${magenta}]${nc}-------------------------------------${magenta}###${nc}
        "
        YELLOW "

        >  Select Swap type: "
        NC "

            [1]  Swap Partition

            [2]  Swapfile

            [3]  Zram Swap

            [4]  None "
        BLUE "


Enter a number: "
        read -r -p "
==> " swapmode
        echo

    case "${swapmode}" in
        1)
            if [[ "${kernelnmbr}" == "3" ]]; then
                sleep 0.2
                RED "
        -----------------------------------------------
        ###  ${yellow}Incompatible Kernel has been detected  ${red}###
        -----------------------------------------------"
                CYAN "
        [!] Swap type will default to ${nc}'None' [!]
                "
                sleep 2
                swapmode="4"
                skip
                ok
                if [[ "${vga_slct}" == "yes" ]]; then
                    local stage_prompt="Graphics Setup"
                    completion_err
                    until dtct_vga; do : ; done
                fi
                return 0
            fi
            swaptype="swappart"
            sleep 0.2
            YELLOW "

        ###  Swap Partition has been selected
            " ;;
        2)
            if [[ "${kernelnmbr}" == "3" ]]; then
                sleep 0.2
                RED "
        -----------------------------------------------
        ###  ${yellow}Incompatible Kernel has been detected  ${red}###
        -----------------------------------------------"
                CYAN "
        [!] Swap type will default to ${nc}'None' [!]
                "
                sleep 2
                swapmode="4"
                skip
                ok
                if [[ "${vga_slct}" == "yes" ]]; then
                    local stage_prompt="Graphics Setup"
                    completion_err
                    until dtct_vga; do : ; done
                fi
                return 0
            fi
            if [[ "${fs}" == "1" ]]; then
                swaptype="swapfile"
            elif [[ "${fs}" == "2" ]]; then
                swaptype="swapfile_btrfs"
            fi
            sleep 0.2
            YELLOW "

        ###  Swapfile has been selected

            "
            until set_swapsize; do : ; done ;;
        3)
            if [[ "${kernelnmbr}" == "3" ]]; then
                sleep 0.2
                RED "
        -----------------------------------------------
        ###  ${yellow}Incompatible Kernel has been detected  ${red}###
        -----------------------------------------------"
                CYAN "
        [!] Swap type will default to ${nc}'None' [!]
                "
                sleep 2
                swapmode="4"
                skip
                ok
                if [[ "${vga_slct}" == "yes" ]]; then
                    local stage_prompt="Graphics Setup"
                    completion_err
                    until dtct_vga; do : ; done
                fi
                return 0
            else
                zram="zram-generator"
                YELLOW "

        ###  Zram Swap has been selected
                "
            fi ;;
        4)
            sleep 0.2
            YELLOW "

        ###  No Swap will be used
            "
            skip ;;
       "")
            sleep 0.2
            choice
            return 1 ;;
        *)
            invalid
            return 1 ;;
    esac
        ok
    if [[ "${vga_slct}" == "yes" ]]; then
        local stage_prompt="Graphics Setup"
        completion_err
        until dtct_vga; do : ; done
    fi
}
###################################################################################################
set_swapsize (){

        local prompt="Swapsize"
        BLUE "

Enter Swap size ${bwhite}(in GB)${blue}: "
        read -r -p "
==> " swapsize
        echo

    if [[ -z "${swapsize}" ]]; then
        sleep 0.2
        RED "
        ------------------------------------------
        ###  ${yellow}Please enter a value to continue  ${red}###
        ------------------------------------------"
        reload
        line2
        return 1
    elif [[ "${swapsize}" =~ [[:digit:]] ]]; then
        ok
    else
        sleep 0.2
        RED "
        -------------------------------------------
        ###  ${yellow}Please use only digits as a value  ${red}###
        -------------------------------------------"
        reload
        line2
        return 1
    fi
}
###################################################################################################
dtct_hyper (){

        hypervisor="$(systemd-detect-virt)"
    if [[ "${hypervisor}" != "none" ]]; then
        vendor="Virtual Machine"
        vgaconf="n"
        vgapkgs=""
    fi
    case "${hypervisor}" in
        kvm)
            vmpkgs="spice spice-vdagent spice-protocol spice-gtk qemu-guest-agent"
            vm_services="qemu-guest-agent" ;;
        vmware)
            vmpkgs="open-vm-tools"
            vm_services="vmtoolsd vmware-vmblock-fuse" ;;
        oracle)
            vmpkgs="virtualbox-guest-utils"
            vm_services="vboxservice" ;;
        microsoft)
            vmpkgs="hyperv"
            vm_services="hv_fcopy_daemon hv_kvp_daemon hv_vss_daemon" ;;
    esac
}
###################################################################################################
dtct_vga (){

    if [[ "${hypervisor}" != "none" ]]; then
        return 0
    fi
    if [[ -z "${kernelnmbr}" ]]; then
        local stage_prompt="Kernel, Bootloader & ESP Mountpoint Setup"
        completion_err
        until slct_krnl; do : ; done
        until ask_bootldr; do : ; done
        until slct_espmnt; do : ; done
        return 1
    fi
    if [[ -z "${fs}" ]]; then
        local stage_prompt="Filesystem & Swap Setup"
        completion_err
        until ask_fs; do : ; done
        until ask_swap; do : ; done
        return 1
    fi
        sleep 0.2
        NC "


${magenta}###${nc}-------------------------------------${magenta}[ ${bwhite}Graphics  Setup${nc} ${magenta}]${nc}-------------------------------------${magenta}###${nc}
        "
    vgacount="$(lspci | grep -E -c 'VGA|Display|3D')"
    vgacard="$(lspci | grep -E 'VGA|Display|3D' | sed 's/^.*: //g')"
    intelcount="$(lspci | grep -E 'VGA|Display|3D' | grep -E -c 'Intel Corporation')"
    intelcards="$(lspci | grep -E 'VGA|Display|3D' | grep -E 'Intel Corporation'| sed 's/.*Corporation //g' | cat --number | sed 's/.[0-9]//')"
    amdcount="$(lspci | grep -E 'VGA|Display|3D' | grep -E -c 'Advanced Micro Devices')"
    amdcards="$(lspci | grep -E 'VGA|Display|3D' | grep -E 'Advanced Micro Devices' | sed 's/.*\[AMD\/ATI\] //g' | cat --number | sed 's/.[0-9]//')"
    nvidiacount="$(lspci | grep -E 'VGA|Display|3D' | grep -E -c 'NVIDIA Corporation')"
    nvidiacards="$(lspci | grep -E 'VGA|Display|3D' | grep -E 'NVIDIA Corporation'| sed 's/.*Corporation //g' | cat --number | sed 's/.[0-9]//')"

    if [[ "${vgacount}" == "1" ]]; then
        dtct_single_vga
    else
        dtct_multi_vga
    fi
}
###################################################################################################
dtct_single_vga (){

        local prompt="Graphics Setup"

    if [[ "${intelcount}" -eq "1" ]]; then
        vendor="Intel"
        sourcetype="Open-source"
        sleep 0.2
        intel
    elif [[ "${amdcount}" -eq "1" ]]; then
        vendor="AMD"
        sourcetype="Open-source"
        sleep 0.2
        amd
    elif [[ "${nvidiacount}" -eq "1" ]]; then
        vendor="Nvidia"
        sourcetype="Proprietary"
        nvidia
    fi

        YELLOW "
        ###  ${sourcetype} drivers will be used "
    if [[ "${vendor}" == "Nvidia" ]]; then
        sleep 0.2
        RED "
        ----------------------------------------------------
        ###  ${yellow}Only for NV110 (Maxwell) Graphics or newer  ${red}###
        ----------------------------------------------------"
    fi
        YELLOW "


        >  Configure the Graphics subsystem and enable HW acceleration ? [y/n] 
        "
    if [[ "${vendor}" == "Nvidia" ]]; then
        YELLOW "
        ###  Selecting 'n' defaults to the Open-source 'nouveau' driver"
    fi
        BLUE "


Enter [y/n]: "
        read -r -p "
==> " vgaconf

        vga_conf
}
###################################################################################################
dtct_multi_vga (){

        local prompt="Graphics Setup"

    if [[ "${vgacount}" == "2" ]]; then
        vga_setup="Dual"
    elif [[ "${vgacount}" == "3" ]]; then
        vga_setup="Triple"
    fi

        sleep 0.2
        YELLOW "

        ###  ${vga_setup} Graphics setup detected, consisting of: "
        NC "

        ____________________________________________________________________"

    if [[ "${intelcount}" -ge "1" ]]; then
        vendor1="Intel"
        NC "

        [${intelcount}]  Intel   Graphics device(s)

${intelcards}

        ____________________________________________________________________"
    fi

    if [[ "${amdcount}" -ge "1" ]]; then
        vendor2="AMD"
        NC "

        [${amdcount}]  AMD     Graphics device(s)

${amdcards}

        ____________________________________________________________________"
    fi

    if [[ "${nvidiacount}" -ge "1" ]]; then
        vendor3="Nvidia"
        NC "

        [${nvidiacount}]  Nvidia  Graphics device(s)

${nvidiacards}

        ____________________________________________________________________"
    fi

        YELLOW "


        >  Configure the Graphics subsystem and enable HW acceleration for : "

    if [[ -n "${vendor1}" && -n "${vendor2}" ]]; then
        NC "

            [1]  Intel

            [2]  AMD 

            [3]  None "
        BLUE "


Enter a number: "
        read -r -p "
==> " vendor_slct

        if [[ "${vendor_slct}" == "1" ]]; then
            vendor="Intel"
        elif [[ "${vendor_slct}" == "2" ]]; then
            vendor="AMD"
        else
            vendor="none"
        fi

    elif [[ -n "${vendor1}" && -n "${vendor3}" ]]; then
        NC "

            [1]  Intel

            [2]  Nvidia  ${red}[!] Only for NV110 (Maxwell) Graphics or newer [!]${nc}

            [3]  None "
        BLUE "


Enter a number: "
        read -r -p "
==> " vendor_slct

        if [[ "${vendor_slct}" == "1" ]]; then
            vendor="Intel"
        elif [[ "${vendor_slct}" == "2" ]]; then
            vendor="Nvidia"
        else
            vendor="none"
        fi

    elif [[ -n "${vendor2}" && -n "${vendor3}" ]]; then
        NC "

            [1]  Amd

            [2]  Nvidia  ${red}[!] Only for NV110 (Maxwell) Graphics or newer [!]${nc}

            [3]  None "
        BLUE "


Enter a number: "
        read -r -p "
==> " vendor_slct

        if [[ "${vendor_slct}" == "1" ]]; then
            vendor="AMD"
        elif [[ "${vendor_slct}" == "2" ]]; then
            vendor="Nvidia"
        else
            vendor="none"
        fi
    fi
    if [[ "${vendor}" == "Intel" || "${vendor}" == "AMD" ]]; then
        sourcetype="Open-source"
        vgaconf="y"
    elif [[ "${vendor}" == "Nvidia" ]]; then
        sourcetype="Proprietary"
        vgaconf="y"
    elif [[ "${vendor}" == "none" ]]; then
        sourcetype="No"
        vgaconf="n"
        vgapkgs=""
        echo
        skip
        ok
        return 0
    fi
        sleep 0.2
        YELLOW "
        
        
        ###  ${sourcetype} drivers will be used
        "
        vga_conf
}
###################################################################################################
vga_conf (){

        local prompt="Graphics Setup"

    if [[ "${vgaconf}" == "y" ]]; then
        if [[ "${vendor}" == "Intel" ]]; then
            perf_stream="dev.i915.perf_stream_paranoid = 0"
            vgapkgs="intel-media-driver intel-media-sdk libva-intel-driver vpl-gpu-rt vulkan-intel vulkan-mesa-layers"
        elif [[ "${vendor}" == "AMD" ]]; then
            vgapkgs="libva-mesa-driver mesa-vdpau vulkan-mesa-layers vulkan-radeon"
            sleep 0.2
            YELLOW "

        >  Enable 'amdgpu' driver support for: "
            NC "

            [1]  'Southern Islands' Graphics

            [2]  'Sea Islands' Graphics "
            BLUE "


Enter a number ${bwhite}(empty to skip)${blue}: "
            read -r -p "
==> " islands
            if [[ -z "${islands}" ]]; then
                skip
                echo
            elif [[ "${islands}" == "1" ]]; then
                NC "

==> [${green}Southern Islands OK${nc}]

                "
            elif [[ "${islands}" == "2" ]]; then
                NC "

==> [${green}Sea Islands OK${nc}]

                "
            else
                invalid
                return 1
            fi
        elif [[ "${vendor}" == "Nvidia" ]]; then
            sleep 0.2
            YELLOW "
        >  Select Nvidia architecture: "
            NC "

            [1]  NV110 (Maxwell) Graphics or newer

            [2]  NV160 (Turing) Graphics or newer "
            BLUE "


Enter a number: "
            read -r -p "
==> " family

            if [[ "${family}" == "1" ]]; then
                sleep 0.2
                NC "

==> [${green}Maxwell+ OK${nc}]
                "
            elif [[ "${family}" == "2" ]]; then
                sleep 0.2
                YELLOW "


        >  Select Nvidia driver: "
                NC "

            [1]  'Nvidia-Open' driver

            [2]  'Nvidia' driver "
                BLUE "


Enter a number: "
                read -r -p "
==> " nvdriver

                if [[ "${nvdriver}" == "1" ]]; then 
                    if [[ -n "${vendor2}" ]]; then
                        sleep 0.2
                        YELLOW "
                        
        ###  AMD Graphics have also been detected "
                        RED "
        ----------------------------------------------------------------------
        ###  ${yellow}There may be incompatibilities with the ${nc}'Nvidia-Open' ${yellow}driver  ${red}###
        ----------------------------------------------------------------------"
                        YELLOW "


        >  Please confirm your selection: "
                        NC "

            [1]  'Nvidia-Open' driver

            [2]  'Nvidia' driver "
                        BLUE "


Enter a number: "
                        read -r -p "
==> " nvdriver

                        if [[ "${nvdriver}" == "1" || "${nvdriver}" == "2" ]]; then
                            sleep 0.2
                            NC "

==> [${green}Driver Confirmed OK${nc}] "
                        else
                            echo
                            invalid
                            return 1
                        fi
                    fi
                    sleep 0.2
                    NC "

==> [${green}Turing+ OK${nc}]
                    "
                elif [[ "${nvdriver}" == "2" ]]; then
                    sleep 0.2
                    NC "

==> [${green}Turing+ OK${nc}]
                    "
                else
                    echo
                    invalid
                    return 1
                fi
            else
                echo
                invalid
                return 1
            fi
            if [[ "${kernelnmbr}" == "1" ]]; then
                if [[ "${family}" == "1" ]]; then
                    vgapkgs="libva-nvidia-driver libvdpau-va-gl nvidia nvidia-settings nvidia-utils opencl-nvidia"
                    nvname="nvidia"
                elif [[ "${family}" == "2" ]]; then
                    if [[ "${nvdriver}" == "1" ]]; then
                        vgapkgs="libva-nvidia-driver libvdpau-va-gl nvidia-open nvidia-settings nvidia-utils opencl-nvidia"
                        nvname="nvidia-open"
                    elif [[ "${nvdriver}" == "2" ]]; then
                        vgapkgs="libva-nvidia-driver libvdpau-va-gl nvidia nvidia-settings nvidia-utils opencl-nvidia"
                        nvname="nvidia"
                    fi
                fi
            elif [[ "${kernelnmbr}" == "2" ]]; then
                if [[ "${family}" == "1" ]]; then
                    vgapkgs="libva-nvidia-driver libvdpau-va-gl nvidia-lts nvidia-settings nvidia-utils opencl-nvidia"
                    nvname="nvidia-lts"
                elif [[ "${family}" == "2" ]]; then
                    if [[ "${nvdriver}" == "1" ]]; then
                        vgapkgs="libva-nvidia-driver libvdpau-va-gl nvidia-open-dkms nvidia-settings nvidia-utils opencl-nvidia"
                    elif [[ "${nvdriver}" == "2" ]]; then
                        vgapkgs="libva-nvidia-driver libvdpau-va-gl nvidia-lts nvidia-settings nvidia-utils opencl-nvidia"
                        nvname="nvidia-lts"
                    fi
                fi
            else
                if [[ "${family}" == "1" ]]; then
                    vgapkgs="libva-nvidia-driver libvdpau-va-gl nvidia-dkms nvidia-settings nvidia-utils opencl-nvidia"
                elif [[ "${family}" == "2" ]]; then
                    if [[ "${nvdriver}" == "1" ]]; then
                        vgapkgs="libva-nvidia-driver libvdpau-va-gl nvidia-open-dkms nvidia-settings nvidia-utils opencl-nvidia"
                    elif [[ "${nvdriver}" == "2" ]]; then
                        vgapkgs="libva-nvidia-driver libvdpau-va-gl nvidia-dkms nvidia-settings nvidia-utils opencl-nvidia"
                    fi
                fi
            fi
        sleep 0.2
        YELLOW "


        >  Enable Nvidia's 'Suspend-Hibernate-Resume' Video Memory Preserving feature ? [y/n] "
        BLUE "


Enter [y/n]: "
        read -r -p "
==> " nvidia_suspend
        echo

            if [[ "${nvidia_suspend}" == "n" ]]; then
                skip
            elif [[ "${nvidia_suspend}" == "y" ]] && [[ "${swapmode}" == "3" || "${swapmode}" == "4" ]]; then
                sleep 0.2
                RED "
        -----------------------------------------------------
        ###  ${yellow}Incompatible Swap setting has been detected  ${red}###
        -----------------------------------------------------"
                CYAN "
        [!] Nvidia's Video Memory Preserving feature will ${nc}NOT ${cyan}be enabled [!]
                "
                sleep 3
                nvidia_suspend="n"
                skip
            elif [[ "${nvidia_suspend}" == "y" ]]; then
                sleep 0.2
                YELLOW "

        ###  Nvidia's 'Suspend-Hibernate-Resume' Video Memory Preserving feature will be enabled "
            else
                echo
                invalid
                return 1
            fi
        fi
        sleep 0.2
        YELLOW "

        ###  ${vendor} Graphics will be automatically configured
        "
    elif [[ "${vgaconf}" == "n" ]]; then
        vgapkgs=""
        echo
        skip
    else
        invalid
        return 1
    fi
        vga_slct="yes"
        ok
}
###################################################################################################
slct_dsktp (){

        local prompt="Desktop Setup"
        custompkgs=""
        sleep 0.2
        NC "


${magenta}###${nc}--------------------------------------${magenta}[ ${bwhite}Desktop Setup${nc} ${magenta}]${nc}--------------------------------------${magenta}###${nc}
        "
        YELLOW "

        >  Make a selection: "
        NC "

            [1]  Plasma

            [2]  Custom Plasma & Systemd-boot & System Optimizations

            [3]  Gnome

            [4]  Custom Gnome & Systemd-boot & System Optimizations

            [5]  Xfce

            [6]  Cinnamon

            [7]  Deepin

            [8]  Budgie

            [9]  Lxqt

           [10]  Mate

           [11]  Basic Arch Linux (No GUI)

           [12]  Custom Arch Linux  ${red}[!] EXPERTS ONLY [!] "
        BLUE "


Enter a number: "
        read -r -p "
==> " packages
        echo

    case "${packages}" in
    	1)
            desktopname="Plasma" ;;
        2)
            desktopname="Custom Plasma (System Optimized)" ;;
        3)
            desktopname="Gnome" ;;
        4)
            desktopname="Custom Gnome (System Optimized)" ;;
        5)
            desktopname="Xfce" ;;
        6)
            desktopname="Cinnamon"
            sleep 0.2
            YELLOW "


        ###  NOTE: Cinnamon desktop lacks a native Terminal emulator by design

        ###  You can use linux console (ctrl+alt+F3) for shell access


        >  Install ${nc}'gnome-terminal' ${yellow}for convenience ? [y/n] "
            BLUE "


Enter [y/n]: "
            read -r -p "
==> " console

        case "${console}" in
            y)
                terminal="gnome-terminal"
                sleep 0.2
                NC "

==> [${green}Terminal OK${nc}] " ;;
            n)
                echo
                skip ;;
           "")
                sleep 0.2
                y_n
                return 1 ;;
            *)
                invalid
                return 1 ;;
        esac ;;

        7)
            desktopname="Deepin" ;;
        8)
            desktopname="Budgie"
            sleep 0.2
            YELLOW "


        ###  NOTE: Budgie desktop lacks a native Terminal emulator by design

        ###  You can use linux console (ctrl+alt+F3) for shell access


        >  Install ${nc}'gnome-terminal' ${yellow}for convenience ? [y/n] "
            BLUE "


Enter [y/n]: "
            read -r -p "
==> " console

        case "${console}" in
            y)
                terminal="gnome-terminal"
                sleep 0.2
                NC "

==> [${green}Terminal OK${nc}] " ;;
            n)
                echo
                skip ;;
           "")
                sleep 0.2
                y_n
                return 1 ;;
            *)
                invalid
                return 1 ;;
        esac ;;

        9)
            desktopname="Lxqt" ;;
       10)
            desktopname="Mate" ;;
       11)
            desktopname="Basic Arch Linux" ;;
       12)
            desktopname="Custom Arch Linux"
            until cust_sys; do :; done
            return 0 ;;
       "")
            choice
            return 1 ;;
        *)
            invalid
            return 1 ;;
    esac
        sleep 0.2
        YELLOW "


        ###  ${desktopname} has been selected


        ###  NOTE: 'base' meta-package does not include the tools needed for building packages

        >  Install ${nc}'base-devel' ${yellow}meta-package ? [y/n] "
        BLUE "


Enter [y/n]: "
        read -r -p "
==> " dev

    case "${dev}" in
        y)
            devel="base-devel"
            sleep 0.2
            NC "

==> [${green}base-devel OK${nc}] " ;;
        n)
            echo
            skip ;;
       "")
            sleep 0.2
            y_n
            return 1 ;;
        *)
            invalid
            return 1 ;;
    esac

        sleep 0.2
        YELLOW "


        ###  NOTE: Custom Kernel Parameters can be set at boot time

        >  Enter your own Kernel Parameters ? [y/n] "
        BLUE "


Enter [y/n]: "
        read -r -p "
==> " ask_param

        case "${ask_param}" in
            y)
                add_prmtrs ;;
            n)
                echo
                skip ;;
           "")
                sleep 0.2
                y_n
                return 1 ;;
            *)
                invalid
                return 1 ;;
        esac
        ok
}
###################################################################################################
cust_sys (){

        local prompt="Custom Arch Linux"
        until add_pkgs; do : ; done
        until add_services; do : ; done
        until add_prmtrs; do : ; done
        echo
        ok
}
###################################################################################################
add_pkgs (){

        local prompt="Add Packages"
        sleep 0.2
        NC "


${magenta}###${nc}------------------------------------${magenta}[ ${bwhite}Add Your Packages${nc} ${magenta}]${nc}------------------------------------${magenta}###${nc}
        "
        YELLOW "

        ###  base, linux-firmware (if on bare-metal), sudo & your current choices are already included 
        "
        BLUE "


Enter any additional packages ${bwhite}(space-seperated)${blue}: "
        read -r -p "
==> " custompkgs

    if [[ -z "${custompkgs}" ]]; then
        sleep 0.2
        RED "
        ---------------------------------------------
        ###  ${yellow}Please enter package(s) to continue  ${red}###
        ---------------------------------------------"
        reload
        return 1
    elif [[ "${custompkgs}" =~ "lightdm" ]]; then
        echo
        sleep 0.2
        NC "


${magenta}###${nc}--------------------------------${magenta}[ ${bwhite}LightDM Greeter Selection${nc} ${magenta}]${nc}--------------------------------${magenta}###${nc}
        "
        YELLOW "

        >  Select a Greeter: "
        NC "

            [1]  Gtk

            [2]  Slick 

            [3]  Deepin "
        BLUE "


Enter a number: "
        read -r -p "
==> " greeternmbr

        case "${greeternmbr}" in
            1)
                greeter="lightdm-gtk-greeter"
                sleep 0.2
                NC "

==> [${green}Lightdm Gtk Greeter OK${nc}] " ;;
            2)
                greeter="lightdm-slick-greeter"
                sleep 0.2
                NC "

==> [${green}Lightdm Slick Greeter OK${nc}] " ;;
            3)
                greeter="lightdm-deepin-greeter"
                sleep 0.2
                NC "

==> [${green}Lightdm Deepin Greeter OK${nc}] " ;;
           "")
                choice
                return 1 ;;
            *)
                invalid
                return 1 ;;
        esac
    else
        ok
    fi
}
###################################################################################################
add_services (){

        local prompt="Add Services"
        sleep 0.2
        NC "


${magenta}###${nc}------------------------------------${magenta}[ ${bwhite}Add Your Services${nc} ${magenta}]${nc}------------------------------------${magenta}###${nc}
        "
        YELLOW "

        ###  Empty to skip 
        "
        BLUE "


Enter services to be enabled ${bwhite}(space-seperated)${blue}: "
        read -r -p "
==> " customservices

    if [[ -z "${customservices}" ]]; then
        echo
        skip
    else
        ok
    fi
}
###################################################################################################
add_prmtrs (){

        local prompt="Kernel Parameters"
        sleep 0.2
        NC "


${magenta}###${nc}-------------------------------${magenta}[ ${bwhite}Add Your  Kernel Parameters${nc} ${magenta}]${nc}-------------------------------${magenta}###${nc}
        "
        YELLOW "

        ###  Empty to skip
        "
        BLUE "


Enter your Kernel parameters to be set at boot ${bwhite}(space-seperated)${blue}: "
        read -r -p "
==> " cust_bootopts

    if [[ -z "${cust_bootopts}" ]]; then
        echo
        skip
    else
        ok
    fi
}
###################################################################################################
boot_entr (){

    if [[ "${hypervisor}" != "none" ]]; then
        efi_entr_del="yes"
        return 0
    fi
        local prompt="Boot Entries"
        sleep 0.2
        NC "


${magenta}###${nc}--------------------------------${magenta}[ ${bwhite}EFI Boot Entries Deletion${nc} ${magenta}]${nc}--------------------------------${magenta}###${nc}
        "

        YELLOW "

        >  Select an EFI Boot Entry to Delete  ${red}[!] (CAUTION) [!]

        "
        sleep 0.2
        efibootmgr
        boot_entry=" "

    while [[ -n "${boot_entry}" ]]; do
        BLUE "


Enter a${nc} ${cyan}BootOrder${blue} number for Deletion ${bwhite}(empty to skip)${blue}: "
        read -r -p "
==> " boot_entry
        echo

            if [[ -n "${boot_entry}" ]]; then
                if [[ "${run_as}" != "root" ]]; then
                    sleep 0.2
                    RED "
        -----------------------------------
        ###  ${yellow}Root Privileges Missing..  ${red}###
        -----------------------------------"
                    reload
                    until sys_submn; do : ; done
                fi
                if efibootmgr -b "${boot_entry}" -B; then
                    sleep 0.2
                    NC "

==> [${green}Entry ${boot_entry} Deleted${nc}] "
                else
                    err_try
                    return 1
                fi
            else
                skip
                ok
            fi
    done
        efi_entr_del="yes"
}
###################################################################################################
wireless_rgd (){

    if [[ "${hypervisor}" != "none" ]]; then
        wrlss_rgd="yes"
        return 0
    fi
        local prompt="Wireless Regdom Setup"
        sleep 0.2
        NC "


${magenta}###${nc}----------------------------${magenta}[ ${bwhite}Wireless Regulatory  Domain Setup${nc} ${magenta}]${nc}----------------------------${magenta}###${nc}
        "

        YELLOW "

        >  Select your Country Code (e.g. US)


        ###  [Enter ${nc}'l'${yellow} to list country codes, then ${nc}'enter'${yellow} to search or ${nc}'q'${yellow} to quit] "
        BLUE "


Enter your Country Code, ie:${nc} ${cyan}US ${bwhite}(empty to skip)${blue}: "
        read -r -p "
==> " REGDOM

    if [[ -z "${REGDOM}" ]]; then
        echo
        skip
    elif [[ "${REGDOM}" == "l" ]]; then
        sed 's|^#WIRELESS_REGDOM=||g' /etc/conf.d/wireless-regdom |sed 's|"||g'| more
        return 1
    elif [[ "${REGDOM}" =~ [[:lower:]] ]]; then
        sleep 0.2
        RED "
        ------------------------------------------------------
        ###  ${yellow}Lowercase is not allowed. Please try again..  ${red}###
        ------------------------------------------------------"
        reload
        return 1
    elif ! grep \""${REGDOM}"\" /etc/conf.d/wireless-regdom > /dev/null 2>&1 ; then
        invalid
        return 1
    else
        wireless_reg="wireless-regdb"
        sleep 0.2
        YELLOW "

        ###  ${REGDOM} Country Code has been selected
        "
    fi
        ok
        wrlss_rgd="yes"
}
###################################################################################################
dsks_submn (){

        sleep 0.2
        NC "


${magenta}###${nc}-------------------------------------${magenta}[ ${bwhite}Disk Management${nc} ${magenta}]${nc}-------------------------------------${magenta}###${nc}
        "
        YELLOW "

        >  Select a Submenu: "
        NC "

            [1]  Disk GPT Manager

            [2]  Partition Manager

            [ ]  Return to Main Menu "
        BLUE "


Enter a number: "
        read -r -p "
==> " diskmenu
        echo

    case "${diskmenu}" in
        1)
            until gpt_mngr; do : ; done ;;
        2)
            until disk_mngr; do : ; done ;;
       "")
            until main_menu; do : ; done ;;
        *)
            invalid
            return 1 ;;
    esac
}
###################################################################################################
gpt_mngr (){

        local prompt="Disk GPT"
        sleep 0.2
        NC "


${magenta}###${nc}------------------------------------${magenta}[ ${bwhite}Disk  GPT Manager${nc} ${magenta}]${nc}------------------------------------${magenta}###${nc}
        "
        gpt_dsk_nmbr=" "

    while [[ -n "${gpt_dsk_nmbr}" ]]; do
        YELLOW "

        >  Select a disk to manage its GPT: 
        
        
        ###  [Type ${nc}'?'${yellow} for help, ${nc}'x'${yellow} for extra functionality or ${nc}'q'${yellow} to quit]"
        NC "

${disks}"
        BLUE "


Enter a disk number ${bwhite}(empty to skip)${blue}: "
        read -r -p "
==> " gpt_dsk_nmbr
        echo

        if [[ -n "${gpt_dsk_nmbr}" ]]; then
        gptdrive="$(echo "${disks}" | awk "\$1 == ${gpt_dsk_nmbr} { print \$2}")"
            if [[ -e "${gptdrive}" ]]; then
                if [[ "${run_as}" != "root" ]]; then
                    sleep 0.2
                    RED "
        -----------------------------------
        ###  ${yellow}Root Privileges Missing..  ${red}###
        -----------------------------------"
                    reload
                    until dsks_submn; do : ; done
                fi
                NC "
______________________________________________
                "
                gdisk "${gptdrive}"
                sleep 0.2
                NC "

==> [${green}${gptdrive} OK${nc}] 
                "
            else
                invalid
                return 1
            fi
        else
            skip
            ok

            if [[ "${install}" == "yes" ]]; then
                until instl_dsk; do : ; done
            else
                until dsks_submn; do : ; done
            fi
        fi
    done
}
###################################################################################################
ask_multibooting (){

        local prompt="MultiBoot Status"
        sleep 0.2
        NC "

${magenta}###${nc}-------------------------------------${magenta}[ ${bwhite}MultiBoot Status${nc} ${magenta}]${nc}-------------------------------------${magenta}###${nc}
        "
        YELLOW "

        >  Are you Multi-Booting with other OS's ? [y/n]"
        BLUE "


Enter [y/n]: "
        read -r -p "
==> " multibooting

    case "${multibooting}" in
        y)
            sleep 0.2
            YELLOW "

        ###  Multi-Boot selected
            " ;;
        n)  sleep 0.2
            YELLOW "

        ###  No Multi-Boot
            " ;;
       "")
            y_n
            return 1 ;;
        *)
            invalid
            return 1 ;;
    esac
        ok
}
###################################################################################################
disk_mngr (){

        if [[ "${multibooting}" == "y" ]]; then
            until manual_part; do : ; done
            return 0
        fi

        sleep 0.2
        NC "


${magenta}###${nc}------------------------------------${magenta}[ ${bwhite}Partition Manager${nc} ${magenta}]${nc}------------------------------------${magenta}###${nc}
        "
        YELLOW "

        >  Select a Mode: "
        NC "

            [1]  Automatic Partitioning

            [2]  Manual Partitioning "
        BLUE "


Enter a number: "
        read -r -p "
==> " part_mode

    case "${part_mode}" in
        1)
            until auto_part; do : ; done ;;
        2)
            until manual_part; do : ; done ;;
       "")
            sleep 0.2
            RED "
        ------------------------------
        ###  ${yellow}Please select a Mode  ${red}###
        ------------------------------"
            reload
            return 1 ;;
        *)
            invalid
            return 1 ;;
    esac
}
###################################################################################################
man_preset (){

        sleep 0.2
        NC "

${magenta}###${nc}------------------------------------${magenta}[ ${bwhite}Preset  Selection${nc} ${magenta}]${nc}------------------------------------${magenta}###${nc}       
        "
        YELLOW "

        >  Select a Partition Layout Preset: "
        NC "

          ${cyan}* Ext4${nc} compatible Layout

          ${magenta}* Btrfs${nc} compatible Layout

          ${red}* XBOOTLDR${nc} partition is only 'Systemd-boot' compatible



            [1]  Create 'ESP' and '/Root'                                   (${cyan}Ext4${nc},${magenta}Btrfs${nc})

            [2]  Create 'ESP', '/Root' and '/Swap'                          (${cyan}Ext4${nc},${magenta}Btrfs${nc})

            [3]  Create 'ESP', '/Root' and '/Home'                          (${cyan}Ext4${nc})

            [4]  Create 'ESP', '/Root', '/Home' and '/Swap'                 (${cyan}Ext4${nc})
            
            [5]  Create 'ESP', ${red}'XBOOTLDR' ${nc}and '/Root'                       (${cyan}Ext4${nc},${magenta}Btrfs${nc})
            
            [6]  Create 'ESP', ${red}'XBOOTLDR'${nc}, '/Root' and '/Swap'              (${cyan}Ext4${nc},${magenta}Btrfs${nc})
            
            [7]  Create 'ESP', ${red}'XBOOTLDR'${nc}, '/Root' and '/Home'              (${cyan}Ext4${nc})
            
            [8]  Create 'ESP', ${red}'XBOOTLDR'${nc}, '/Root', '/Home' and '/Swap'     (${cyan}Ext4${nc}) "
        BLUE "


Enter a Preset number ${bwhite}(empty to skip)${blue}: "
        read -r -p "
==> " preset
        echo
}
###################################################################################################
auto_part (){

        local prompt="Disk Partitions"
        local stage_prompt="Auto-Partitioning"
        sleep 0.2
        NC "


${magenta}###${nc}---------------------------------${magenta}[ ${bwhite}Automatic  Partitioning${nc} ${magenta}]${nc}---------------------------------${magenta}###${nc}
        "
        sleep 0.2
        line2
        REDBG "       ------------------------------------------------------------ "
        REDBG "       [!] WARNING: All data on selected disk will be destroyed [!] "
        REDBG "       ------------------------------------------------------------ "
        line2
        if [[ -e "${instl_drive}" && "${use_manpreset}" != "yes" ]]; then
            sleep 0.2
            RED "
        -------------------------------------------------------------------------
        ### >>>  ${yellow}Apply ${nc}'Smart Partitioning' ${yellow}on disk ${nc}'${instl_drive}'${yellow} ?   [y/n]  ${red}<<< ###
        -------------------------------------------------------------------------
            "
            read -r -p "
==> " smartpart
            echo

            if [[ "${smartpart}" == "y" ]]; then
                sgdsk_nmbr="${instl_dsk_nmbr}"
            elif [[ "${smartpart}" == "n" ]]; then
                sgdsk_nmbr="${instl_dsk_nmbr}"
                use_manpreset="yes"
                until man_preset; do : ; done
            else
                y_n
                return 1
            fi
        else
        YELLOW "
        >  Select a disk for Auto-Partitioning: "
        NC "

${disks}"
        BLUE "


Enter a disk number ${bwhite}(empty to skip)${blue}: "
        read -r -p "
==> " sgdsk_nmbr
        echo
        fi

        if [[ -n "${sgdsk_nmbr}" ]]; then
            sgdrive="$(echo "${disks}" | awk "\$1 == ${sgdsk_nmbr} {print \$2}")"
            if [[ -e "${sgdrive}" ]]; then
                capacity="$(fdisk -l "${sgdrive}" | grep -E 'bytes' | grep -E 'Disk' | awk "{print \$5}")"
                cap_gib="$((capacity/1024000000))"
                rootsize="$((capacity*25/100/1024000000))"
                if [[ "${run_as}" != "root" ]]; then
                    sleep 0.2
                    RED "
        -----------------------------------
        ###  ${yellow}Root Privileges Missing..  ${red}###
        -----------------------------------"
                    reload
                    until dsks_submn; do : ; done
                fi

                if [[ -z "${use_manpreset}" ]]; then
                    if [[ "${fs}" == "2" ]]; then
                        if [[ "${xbootloader}" == "yes" && "${swapmode}" == "1" ]]; then
                            preset="6"
                        elif [[ "${xbootloader}" == "yes" && "${swapmode}" != "1" ]]; then
                            preset="5"
                        elif [[ "${swapmode}" == "1" ]]; then
                            preset="2"
                        elif [[ "${swapmode}" != "1" ]]; then
                            preset="1"
                        fi
                    elif [[ "${fs}" == "1" ]] ; then
                        if [[ "${xbootloader}" == "yes" && "${sep_home}" == "y" && "${swapmode}" == "1" ]]; then
                            preset="8"
                        elif [[ "${xbootloader}" == "yes" && "${sep_home}" == "y" && "${swapmode}" != "1" ]]; then
                            preset="7"
                        elif [[ "${xbootloader}" == "yes" && "${sep_home}" == "n" && "${swapmode}" == "1" ]]; then
                            preset="6"
                        elif [[ "${xbootloader}" == "yes" && "${sep_home}" == "n" && "${swapmode}" != "1" ]]; then
                            preset="5"
                        elif [[ "${sep_home}" == "y" && "${swapmode}" == "1" ]]; then
                            preset="4"
                        elif [[ "${sep_home}" == "y" && "${swapmode}" != "1" ]]; then
                            preset="3"
                        elif [[ "${sep_home}" == "n" && "${swapmode}" == "1" ]]; then
                            preset="2"
                        elif [[ "${sep_home}" == "n" && "${swapmode}" != "1" ]]; then
                            preset="1"
                        fi
                    else
                        until man_preset; do : ; done
                    fi
                elif [[ -z "${preset}" ]] ; then
                    until manual_part; do : ; done
                    return 0
                fi
                
                if [[ "${preset}" == "3" || "${preset}" == "4" || "${preset}" == "7" || "${preset}" == "8" ]] ; then
                    sleep 0.2
                    YELLOW "


        ###  Total detected capacity of disk ${nc}${sgdrive} ${yellow}is ${nc}${cap_gib} GiB${yellow}


        ###  Default ${nc}/Root${yellow} Partition's size is aprox. ${nc}25%${yellow} of total disk capacity  ${nc}[${rootsize} GiB]${yellow}



        >  Set /Root Partition's Percentage to a custom value ? "
                    BLUE "


Enter a Custom Percentage number ${nc}e.g. 30 ${bwhite}(empty to skip)${blue}: "
                    read -r -p "
==> " prcnt
                    echo
                fi

                if [[ "${preset}" == "3" || "${preset}" == "4" || "${preset}" == "7" || "${preset}" == "8" ]] ; then
                    if [[ "${prcnt}" == [[:alpha:]] ]]; then
                        sleep 0.2
                        RED "
        -------------------------------------------
        ###  ${yellow}Please use only digits as a value  ${red}###
        -------------------------------------------"
                        reload
                        return 1
                    elif [[ -z "${prcnt}" ]]; then
                        sleep 0.2
                        YELLOW "

        ###  Default /Root Partition's size selected  ${nc}[${rootsize} GiB]
                        "
                    elif [[ "${prcnt}" -gt "0" && "${prcnt}" -lt "100" ]]; then
                        rootsize="$((capacity*"${prcnt}"/100/1024000000))"
                        sleep 0.2
                        YELLOW "

        ###  Custom /Root Partition's size selected  ${nc}[${rootsize} GiB]
                        "
                    elif [[ "${prcnt}" == "100" ]]; then
                        sleep 0.2
                        RED "
        -----------------------------------------------------
        ###  ${yellow}WARNING: No space left for other partitions  ${red}###
        -----------------------------------------------------"
                        reload
                        return 1
                    else
                        invalid
                        return 1
                    fi
                fi

                case "${preset}" in
                    1)
                            sgdisk -o "${sgdrive}" > /dev/null 2>&1 || stage_fail
                            sgdisk -n 1:0:+512M -t 1:ef00 -c 1:ESP "${sgdrive}" > /dev/null 2>&1 || stage_fail
                            sgdisk -n 2:0:0 -t 2:8304 -c 2:Root "${sgdrive}" > /dev/null 2>&1 || stage_fail
                            if [[ "${install}" == "yes" ]]; then
                                autopart="yes"
                                until sanity_check; do : ; done
                            else
                                ok
                            fi ;;
                    2)
                            until set_swapsize; do : ; done
                            sgdisk -o "${sgdrive}" > /dev/null 2>&1 || stage_fail
                            sgdisk -n 1:0:+512M -t 1:ef00 -c 1:ESP "${sgdrive}" > /dev/null 2>&1 || stage_fail
                            sgdisk -n 2:0:+"${swapsize}"G -t 2:8200 -c 2:Swap "${sgdrive}" > /dev/null 2>&1 || stage_fail
                            sgdisk -n 3:0:0 -t 3:8304 -c 3:Root "${sgdrive}" > /dev/null 2>&1 || stage_fail
                            if [[ "${install}" == "yes" ]]; then
                                autopart="yes"
                                until sanity_check; do : ; done
                            else
                                ok
                            fi ;;
                    3)
                            sgdisk -o "${sgdrive}" > /dev/null 2>&1 || stage_fail
                            sgdisk -n 1:0:+512M -t 1:ef00 -c 1:ESP "${sgdrive}" > /dev/null 2>&1 || stage_fail
                            sgdisk -n 2:0:+"${rootsize}"G -t 2:8304 -c 2:Root "${sgdrive}" > /dev/null 2>&1 || stage_fail
                            sgdisk -n 3:0:0 -t 3:8302 -c 3:Home "${sgdrive}" > /dev/null 2>&1 || stage_fail
                            if [[ "${install}" == "yes" ]]; then
                                autopart="yes"
                                until sanity_check; do : ; done
                            else
                                ok
                            fi ;;
                    4)
                            until set_swapsize; do : ; done
                            sgdisk -o "${sgdrive}" > /dev/null 2>&1 || stage_fail
                            sgdisk -n 1:0:+512M -t 1:ef00 -c 1:ESP "${sgdrive}" > /dev/null 2>&1 || stage_fail
                            sgdisk -n 2:0:+"${swapsize}"G -t 2:8200 -c 2:Swap "${sgdrive}" > /dev/null 2>&1 || stage_fail
                            sgdisk -n 3:0:+"${rootsize}"G -t 3:8304 -c 3:Root "${sgdrive}" > /dev/null 2>&1 || stage_fail
                            sgdisk -n 4:0:0 -t 4:8302 -c 4:Home "${sgdrive}" > /dev/null 2>&1 || stage_fail
                            if [[ "${install}" == "yes" ]]; then
                                autopart="yes"
                                until sanity_check; do : ; done
                            else
                                ok
                            fi ;;
                    5)
                            sgdisk -o "${sgdrive}" > /dev/null 2>&1 || stage_fail
                            sgdisk -n 1:0:+200M -t 1:ef00 -c 1:ESP "${sgdrive}" > /dev/null 2>&1 || stage_fail
                            sgdisk -n 2:0:+300M -t 2:ea00 -c 2:XBOOTLDR "${sgdrive}" > /dev/null 2>&1 || stage_fail
                            sgdisk -n 3:0:0 -t 3:8304 -c 3:Root "${sgdrive}" > /dev/null 2>&1 || stage_fail
                            if [[ "${install}" == "yes" ]]; then
                                autopart="yes"
                                until sanity_check; do : ; done
                            else
                                ok
                            fi ;;
                    6)
                            until set_swapsize; do : ; done
                            sgdisk -o "${sgdrive}" > /dev/null 2>&1 || stage_fail
                            sgdisk -n 1:0:+200M -t 1:ef00 -c 1:ESP "${sgdrive}" > /dev/null 2>&1 || stage_fail
                            sgdisk -n 2:0:+300M -t 2:ea00 -c 2:XBOOTLDR "${sgdrive}" > /dev/null 2>&1 || stage_fail
                            sgdisk -n 3:0:+"${swapsize}"G -t 3:8200 -c 3:Swap "${sgdrive}" > /dev/null 2>&1 || stage_fail
                            sgdisk -n 4:0:0 -t 4:8304 -c 4:Root "${sgdrive}" > /dev/null 2>&1 || stage_fail
                            if [[ "${install}" == "yes" ]]; then
                                autopart="yes"
                                until sanity_check; do : ; done
                            else
                                ok
                            fi ;;
                    7)
                            sgdisk -o "${sgdrive}" > /dev/null 2>&1 || stage_fail
                            sgdisk -n 1:0:+200M -t 1:ef00 -c 1:ESP "${sgdrive}" > /dev/null 2>&1 || stage_fail
                            sgdisk -n 2:0:+300M -t 2:ea00 -c 2:XBOOTLDR "${sgdrive}" > /dev/null 2>&1 || stage_fail
                            sgdisk -n 3:0:+"${rootsize}"G -t 3:8304 -c 3:Root "${sgdrive}" > /dev/null 2>&1 || stage_fail
                            sgdisk -n 4:0:0 -t 4:8302 -c 4:Home "${sgdrive}" > /dev/null 2>&1 || stage_fail
                            if [[ "${install}" == "yes" ]]; then
                                autopart="yes"
                                until sanity_check; do : ; done
                            else
                                ok
                            fi ;;
                    8)
                            until set_swapsize; do : ; done
                            sgdisk -o "${sgdrive}" > /dev/null 2>&1 || stage_fail
                            sgdisk -n 1:0:+200M -t 1:ef00 -c 1:ESP "${sgdrive}" > /dev/null 2>&1 || stage_fail
                            sgdisk -n 2:0:+300M -t 2:ea00 -c 2:XBOOTLDR "${sgdrive}" > /dev/null 2>&1 || stage_fail
                            sgdisk -n 3:0:+"${swapsize}"G -t 3:8200 -c 3:Swap "${sgdrive}" > /dev/null 2>&1 || stage_fail
                            sgdisk -n 4:0:+"${rootsize}"G -t 4:8304 -c 4:Root "${sgdrive}" > /dev/null 2>&1 || stage_fail
                            sgdisk -n 5:0:0 -t 5:8302 -c 5:Home "${sgdrive}" > /dev/null 2>&1 || stage_fail
                            if [[ "${install}" == "yes" ]]; then
                                autopart="yes"
                                until sanity_check; do : ; done
                            else
                                ok
                            fi ;;
                   "")
                        if [[ "${smartpart}" == "n" ]]; then
                            reload
                            until disk_mngr; do : ; done
                            return 0
                        fi
                        sleep 0.2
                        RED "
        --------------------------------
        ###  ${yellow}Please select a Preset  ${red}###
        --------------------------------"
                        reload
                        return 1 ;;
                    *)
                        invalid
                        return 1 ;;
                esac
                
                if [[ "${install}" == "yes" ]]; then
                    return 0
                fi
                until dsks_submn; do : ; done
            else
                invalid
                return 1
            fi
        else
            skip
            reload

            if [[ -z "${sanity}" ]]; then
                until dsks_submn; do : ; done
            elif [[ "${sanity}" == "no" ]]; then
                until sanity_check; do : ; done
            elif [[ "${revision}" == "yes" ]]; then
                return 0
            elif [[ "${sanity}" == "ok" ]]; then
                if [[ "${install}" == "yes" ]]; then
                    return 0
                fi
                until dsks_submn; do : ; done
            fi
        fi
}
###################################################################################################
manual_part (){

        local prompt="Disks"
        stage_prompt="Partitioning"
        sleep 0.2
        NC "


${magenta}###${nc}-----------------------------------${magenta}[ ${bwhite}Manual Partitioning${nc} ${magenta}]${nc}-----------------------------------${magenta}###${nc}
        "
        cgdsk_nmbr=" "
    while [[ -n "${cgdsk_nmbr}" ]]; do
        line3
        NC "                           SUPPORTED PARTITION TYPES & MOUNTPOINTS: "
        line2
        REDBG "      ------------------------------------------------------------------------------------------- "
        REDBG "      ###  Linux Root x86-64 Partition  [ GUID Code: 8304 ]            Mountpoint:  /         ### "
        REDBG "      ------------------------------------------------------------------------------------------- "
        echo
        BLUEBG "      ------------------------------------------------------------------------------------------- "
        BLUEBG "      ###  EFI System Partition  [ GUID Code: ef00 ]           Mountpoint:  /efi or /boot     ### "
        BLUEBG "      ------------------------------------------------------------------------------------------- "
        echo
        GREENBG "      ------------------------------------------------------------------------------------------- "
        GREENBG "      ###  Linux Home Partition  [ GUID Code: 8302 ]                   Mountpoint:  /home     ### "
        GREENBG "      ------------------------------------------------------------------------------------------- "
        echo
        YELLOWBG "      ------------------------------------------------------------------------------------------- "
        YELLOWBG "      ###  Linux Swap Partition  [ GUID Code: 8200 ]                   Mountpoint:  /swap     ### "
        YELLOWBG "      ------------------------------------------------------------------------------------------- "
        echo
        MAGENTABG "      ------------------------------------------------------------------------------------------- "
        MAGENTABG "      ###  Linux Extended Boot Partition  [ GUID Code: ea00 ]          Mountpoint:  /boot     ### "
        MAGENTABG "      ------------------------------------------------------------------------------------------- "
        YELLOW "



        >  Select a disk to Manage: "
        NC "

${disks}"
        BLUE "


Enter a disk number ${bwhite}(empty to skip)${blue}: "
        read -r -p "
==> " cgdsk_nmbr

        if [[ -n "${cgdsk_nmbr}" ]]; then
            cgdrive="$(echo "${disks}" | awk "\$1 == ${cgdsk_nmbr} {print \$2}")"
            if [[ -e "${cgdrive}" ]]; then
                    if [[ "${run_as}" != "root" ]]; then
                        sleep 0.2
                        RED "
        -----------------------------------
        ###  ${yellow}Root Privileges Missing..  ${red}###
        -----------------------------------"
                        reload
                        until dsks_submn; do : ; done
                    fi
                cgdisk "${cgdrive}"
                clear
                sleep 0.2
                NC "


==> [${green}Disk ${cgdrive} OK${nc}] "
                return 1
            else
                invalid
                return 1
            fi
        else
            skip

            if [[ "${partok}" == "n" ]]; then
                until sanity_check; do : ; done
            elif [[ -z "${sanity}" ]]; then
                until dsks_submn; do : ; done
            elif [[ "${sanity}" == "no" ]]; then
                until sanity_check; do : ; done
            elif [[ "${revision}" == "yes" ]]; then
                return 0
            elif [[ "${sanity}" == "ok" ]]; then
                if [[ "${install}" == "yes" ]]; then
                    return 0
                fi
                until dsks_submn; do : ; done
            fi
        fi
    done
}
###################################################################################################
instl_dsk (){

        sleep 0.2
        NC "


${magenta}###${nc}-------------------------------${magenta}[ ${bwhite}Installation Disk Selection${nc} ${magenta}]${nc}-------------------------------${magenta}###${nc}
        "
        YELLOW "

        >  Select a disk to Install to: "
        NC "

${disks}"
        BLUE "


Enter a disk number: "
        read -r -p "
==> " instl_dsk_nmbr
        echo

    if [[ -n "${instl_dsk_nmbr}" ]]; then
        instl_drive="$(echo "${disks}" | awk "\$1 == ${instl_dsk_nmbr} {print \$2}")"
        if [[ -e "${instl_drive}" ]]; then
            if [[ "${run_as}" != "root" ]]; then
                sleep 0.2
                RED "
        -----------------------------------
        ###  ${yellow}Root Privileges Missing..  ${red}###
        -----------------------------------"
                reload
                until dsks_submn; do : ; done
            fi
            volumes="$(fdisk -l | grep '^/dev' | cat --number)"
            rota="$(lsblk "${instl_drive}" --nodeps --noheadings --output=rota | awk "{print \$1}")"
            if [[ "${rota}" == "0" ]]; then
                sbvl_mnt_opts="rw,noatime,compress=zstd:1"
                trim="fstrim.timer"
            else
                sbvl_mnt_opts="rw,compress=zstd"
            fi
            parttable="$(fdisk -l "${instl_drive}" | grep '^Disklabel type' | awk "{print \$3}")"
            if [[ "${parttable}" != "gpt" ]]; then
                sleep 0.2
                RED "
        ---------------------------------------
        ###  ${yellow}No GPT found on selected disk  ${red}###
        ---------------------------------------"
                reload
                until gpt_mngr; do : ; done
                return 0
            fi
            if [[ -z "${multibooting}" ]]; then
                until ask_multibooting; do : ; done
            fi
            until sanity_check; do : ; done
        else
            invalid
            return 1
        fi
    else
        choice
        return 1
    fi
}
###################################################################################################
sanity_check (){

        sleep 0.2
        NC "

${magenta}###${nc}--------------------------------------${magenta}[ ${bwhite}Sanity  Check${nc} ${magenta}]${nc}--------------------------------------${magenta}###${nc}
        "
        rootcount="$(fdisk -l "${instl_drive}" | grep -E -c 'root' | awk "{print \$1}")"
        root_dev="$(fdisk -l "${instl_drive}" | grep -E 'root' | awk "{print \$1}")"
        multi_root="$(fdisk -l "${instl_drive}" | grep -E 'root' | awk "{print \$1}" | cat --number)"
        root_comply="$(fdisk -l "${instl_drive}" | grep -E 'root' | awk "{print \$1}" | cat --number | grep -E '1[[:blank:]]' | awk "{print \$2}")"
        espcount="$(fdisk -l "${instl_drive}" | grep -E -c 'EFI' | awk "{print \$1}")"
        esp_dev="$(fdisk -l "${instl_drive}" | grep -E 'EFI' | awk "{print \$1}")"
        multi_esp="$(fdisk -l "${instl_drive}" | grep -E 'EFI' | awk "{print \$1}" | cat --number)"
        esp_comply="$(fdisk -l "${instl_drive}" | grep -E 'EFI' | awk "{print \$1}" | cat --number | grep -E '1[[:blank:]]' | awk "{print \$2}")"
        xbootcount="$(fdisk -l "${instl_drive}" | grep -E -c 'extended' | awk "{print \$1}")"
        xboot_dev="$(fdisk -l "${instl_drive}" | grep -E 'extended' | awk "{print \$1}")"
        multi_xboot="$(fdisk -l "${instl_drive}" | grep -E 'extended' | awk "{print \$1}" | cat --number)"
        xboot_comply="$(fdisk -l "${instl_drive}" | grep -E 'extended' | awk "{print \$1}" | cat --number | grep -E '1[[:blank:]]' | awk "{print \$2}")"
        homecount="$(fdisk -l "${instl_drive}" | grep -E -c 'home' | awk "{print \$1}")"
        home_dev="$(fdisk -l "${instl_drive}" | grep -E 'home' | awk "{print \$1}")"
        multi_home="$(fdisk -l "${instl_drive}" | grep -E 'home' | awk "{print \$1}" | cat --number)"
        home_comply="$(fdisk -l "${instl_drive}" | grep -E 'home' | awk "{print \$1}" | cat --number | grep -E '1[[:blank:]]' | awk "{print \$2}")"
        swapcount="$(fdisk -l "${instl_drive}" | grep -E -c 'swap' | awk "{print \$1}")"
        swap_dev="$(fdisk -l "${instl_drive}" | grep -E 'swap' | awk "{print \$1}")"
        multi_swap="$(fdisk -l "${instl_drive}" | grep -E 'swap' | awk "{print \$1}" | cat --number)"
        swap_comply="$(fdisk -l "${instl_drive}" | grep -E 'swap' | awk "{print \$1}" | cat --number | grep -E '1[[:blank:]]' | awk "{print \$2}")"

    if [[ "${rootcount}" -gt "1" ]]; then
        local stage_prompt="Partition"
        sleep 0.2
        RED "
        ----------------------------------------------------------------------------
        ###  ${yellow}WARNING: Multiple Linux x86-64 /Root Partitions have been detected  ${red}###
        ----------------------------------------------------------------------------
        "
        sleep 0.2
        YELLOW "
###------------------------------------------------[ DISK OVERVIEW ]------------------------------------------------###

        "
        fdisk -l "${instl_drive}" | grep -E --color=no 'Dev|dev' |GREP_COLORS='mt=01;36' grep -E --color=always 'EFI System|$'|GREP_COLORS='mt=01;32' grep -E --color=always 'Linux root|$'|GREP_COLORS='mt=01;35' grep -E --color=always 'Linux home|$'|GREP_COLORS='mt=01;33' grep -E --color=always 'Linux swap|$'|GREP_COLORS='mt=01;31' grep -E --color=always 'Linux extended boot|$'
        YELLOW "

###-----------------------------------------------------------------------------------------------------------------###"
        NC "
     Linux x86-64 /Root Partitions:
     
     ------------------------------
${multi_root}
     ------------------------------
        "
        YELLOW "

        ###  Only the 1st Linux x86-64 /Root partition on a selected disk can be auto-assigned as a valid /Root partition


        ###  Partition ${nc}${root_comply} ${yellow}is auto-assigned as such and will be ${red}[!] FORMATTED [!]
                "
        BLUE "


        >  Proceed ? [y/n]"
        read -r -p "
==> " autoroot

        if [[ "${autoroot}" == "y" ]]; then
            root_dev="${root_comply}"
            multiroot_opts="root=PARTUUID=$(blkid -s PARTUUID -o value "${root_dev}") "
        elif [[ "${autoroot}" == "n" ]]; then
            stage_fail
        else
            y_n
            return 1
        fi
    fi

    if [[ "${espcount}" -gt "1" ]]; then
        local stage_prompt="Partition"
        sleep 0.2
        RED "
        --------------------------------------------------------------------
        ###  ${yellow}WARNING: Multiple EFI System Partitions have been detected  ${red}###
        --------------------------------------------------------------------
        "
        sleep 0.2
        YELLOW "
###------------------------------------------------[ DISK OVERVIEW ]------------------------------------------------###

        "
        fdisk -l "${instl_drive}" | grep -E --color=no 'Dev|dev' |GREP_COLORS='mt=01;36' grep -E --color=always 'EFI System|$'|GREP_COLORS='mt=01;32' grep -E --color=always 'Linux root|$'|GREP_COLORS='mt=01;35' grep -E --color=always 'Linux home|$'|GREP_COLORS='mt=01;33' grep -E --color=always 'Linux swap|$'|GREP_COLORS='mt=01;31' grep -E --color=always 'Linux extended boot|$'
        YELLOW "

###-----------------------------------------------------------------------------------------------------------------###"
        NC "
     Linux EFI System Partitions:
     
     ----------------------------
${multi_esp}
     ----------------------------
        "
        YELLOW "

        ###  Only the 1st EFI partition on a selected disk can be auto-assigned as a valid EFI partition
        "
        if [[ "${multibooting}" == "n" ]]; then
            YELLOW "
        ###  Partition ${nc}${esp_comply} ${yellow}is auto-assigned as such and will be ${red}[!] FORMATTED [!]
            "
        elif [[ "${multibooting}" == "y" ]]; then
            YELLOW "
        ###  Partition ${nc}${esp_comply} ${yellow}is auto-assigned as such
            "
        fi
        BLUE "


        >  Proceed ? [y/n]"
        read -r -p "
==> " autoesp

        if [[ "${autoesp}" == "y" ]]; then
            esp_dev="${esp_comply}"
        elif [[ "${autoesp}" == "n" ]]; then
            stage_fail
        else
            y_n
            return 1
        fi
    fi
    
    if [[ "${xbootcount}" -gt "1" ]]; then
        local stage_prompt="Partition"
        sleep 0.2
        RED "
        -----------------------------------------------------------------------------
        ###  ${yellow}WARNING: Multiple Linux Extended Boot Partitions have been detected  ${red}###
        -----------------------------------------------------------------------------
        "
        sleep 0.2
        YELLOW "
###------------------------------------------------[ DISK OVERVIEW ]------------------------------------------------###

        "
        fdisk -l "${instl_drive}" | grep -E --color=no 'Dev|dev' |GREP_COLORS='mt=01;36' grep -E --color=always 'EFI System|$'|GREP_COLORS='mt=01;32' grep -E --color=always 'Linux root|$'|GREP_COLORS='mt=01;35' grep -E --color=always 'Linux home|$'|GREP_COLORS='mt=01;33' grep -E --color=always 'Linux swap|$'|GREP_COLORS='mt=01;31' grep -E --color=always 'Linux extended boot|$'
        YELLOW "

###-----------------------------------------------------------------------------------------------------------------###"
        NC "
     Linux Extended Boot Partitions:
     
     ----------------------------
${multi_xboot}
     ----------------------------
        "
        YELLOW "

        ###  Only the 1st Linux Extended Boot partition on a selected disk can be auto-assigned as a valid XBOOTLDR partition


        ###  Partition ${nc}${xboot_comply} ${yellow}is auto-assigned as such and will be ${red}[!] FORMATTED [!]
                "
        BLUE "


        >  Proceed ? [y/n]"
        read -r -p "
==> " autoxboot

        if [[ "${autoxboot}" == "y" ]]; then
            xboot_dev="${xboot_comply}"
        elif [[ "${autoxboot}" == "n" ]]; then
            stage_fail
        else
            y_n
            return 1
        fi
    fi

    if [[ ${fs} == "1" && ${sep_home} == "y" && "${homecount}" -gt "1" ]]; then
        local stage_prompt="Partition"
        sleep 0.2
        RED "
        ---------------------------------------------------------------------
        ###  ${yellow}WARNING: Multiple Linux /Home Partitions have been detected  ${red}###
        ---------------------------------------------------------------------
        "
        sleep 0.2
        YELLOW "
###------------------------------------------------[ DISK OVERVIEW ]------------------------------------------------###

        "
        fdisk -l "${instl_drive}" | grep -E --color=no 'Dev|dev' |GREP_COLORS='mt=01;36' grep -E --color=always 'EFI System|$'|GREP_COLORS='mt=01;32' grep -E --color=always 'Linux root|$'|GREP_COLORS='mt=01;35' grep -E --color=always 'Linux home|$'|GREP_COLORS='mt=01;33' grep -E --color=always 'Linux swap|$'|GREP_COLORS='mt=01;31' grep -E --color=always 'Linux extended boot|$'
        YELLOW "

###-----------------------------------------------------------------------------------------------------------------###"
        NC "
     Linux /Home Partitions:
     
     -----------------------
${multi_home}
     -----------------------
        "
        YELLOW "

        ###  Only the 1st Linux /Home partition on a selected disk can be auto-assigned as a valid /Home partition


        ###  Partition ${nc}${home_comply} ${yellow}is auto-assigned as such and will be ${red}[!] FORMATTED [!]
        "
        BLUE "


        >  Proceed ? [y/n]"
        read -r -p "
==> " autohome

        if [[ "${autohome}" == "y" ]]; then
            home_dev="${home_comply}"
        elif [[ "${autohome}" == "n" ]]; then
            stage_fail
        else
            y_n
            return 1
        fi
    fi

    if [[ ${swapmode} == "1" && "${swapcount}" -gt "1" ]]; then
        local stage_prompt="Partition"
        sleep 0.2
        RED "
        ---------------------------------------------------------------------
        ###  ${yellow}WARNING: Multiple Linux /Swap Partitions have been detected  ${red}###
        ---------------------------------------------------------------------
        "
        sleep 0.2
        YELLOW "
###------------------------------------------------[ DISK OVERVIEW ]------------------------------------------------###

        "
        fdisk -l "${instl_drive}" | grep -E --color=no 'Dev|dev' |GREP_COLORS='mt=01;36' grep -E --color=always 'EFI System|$'|GREP_COLORS='mt=01;32' grep -E --color=always 'Linux root|$'|GREP_COLORS='mt=01;35' grep -E --color=always 'Linux home|$'|GREP_COLORS='mt=01;33' grep -E --color=always 'Linux swap|$'|GREP_COLORS='mt=01;31' grep -E --color=always 'Linux extended boot|$'
        YELLOW "

###-----------------------------------------------------------------------------------------------------------------###"
        NC "
      Linux /Swap Partitions:

     ------------------------
${multi_swap}
     ------------------------
        "
        YELLOW "

        ###  Only the 1st Linux /Swap partition on a selected disk can be auto-assigned as a valid /Swap partition


        ###  Partition ${nc}${swap_comply} ${yellow}is auto-assigned as such and will be ${red}[!] FORMATTED [!]
                "
        BLUE "


        >  Proceed ? [y/n]"
        read -r -p "
==> " autoswap

        if [[ "${autoswap}" == "y" ]]; then
            swap_dev="${swap_comply}"
        elif [[ "${autoswap}" == "n" ]]; then
            stage_fail
        else
            y_n
            return 1
        fi
    fi
#--------------------------------------------------------------------------------------------------
    if [[ -e "${root_dev}" ]]; then
        rootprt="ok"
        if [[ "${autoroot}" == "y" ]]; then
            local prompt="Confirm /Root Partition"
            ok
        else
            sleep 0.2
            NC "

==> [Linux x86-64 /Root ${green}OK${nc}] "
        fi
    else
        rootprt="fail"
        sleep 0.2
        RED "
        ---------------------------------------------------
        ###  ${yellow}Linux x86-64 /Root Partition not detected  ${red}###
        ---------------------------------------------------"
    fi

    if [[ ${xbootloader} == "yes" ]]; then
        if [[ -e "${xboot_dev}" ]]; then
            xbootprt="ok"
            if [[ "${autoxboot}" == "y" ]]; then
                local prompt="Confirm /XBOOTLDR Partition"
                ok
            else
                sleep 0.2
                NC "

==> [Linux Extended Boot ${green}OK${nc}] "
            fi
        else
            xbootprt="fail"
            sleep 0.2
            RED "
        ----------------------------------------------------
        ###  ${yellow}Linux Extended Boot Partition not detected  ${red}###
        ----------------------------------------------------"
        fi
    fi

    if [[ -e "${esp_dev}" ]]; then
        espsize="$(lsblk -b "${esp_dev}" --noheadings --output=size)"
        if [[ "${espsize}" -lt "209715200" ]]; then
            if [[ "${bootloader}" == "1" ]]; then
                if [[ "${espmnt}" == "1" ]]; then
                    if [[ "${xbootprt}" == "ok" ]]; then
                        espprt="ok"
                        sleep 0.2
                        NC "

==> [EFI System Partition ${green}OK${nc}] "
                    elif [[ "${xbootprt}" == "fail" ]]; then
                        espprt="fail"
                    fi
                elif [[ "${espmnt}" == "2" ]]; then
                    espprt="fail"
                fi
            elif [[ "${bootloader}" == "2" ]]; then
                if [[ "${espmnt}" == "1" ]]; then
                    espprt="ok"
                    sleep 0.2
                    NC "

==> [EFI System Partition ${green}OK${nc}] "
                elif [[ "${espmnt}" == "2" ]]; then
                    espprt="fail"
                fi
            fi
        elif [[ "${espsize}" -ge "209715200" ]]; then
            if [[ "${bootloader}" == "1" ]]; then
                if [[ "${espmnt}" == "1" ]]; then
                    if [[ "${xbootprt}" == "ok" ]]; then
                        espprt="ok"
                        sleep 0.2
                        NC "

==> [EFI System Partition ${green}OK${nc}] "
                    elif [[ "${xbootprt}" == "fail" ]]; then
                        espprt="fail"
                    fi
                elif [[ "${espmnt}" == "2" ]]; then
                    espprt="ok"
                    sleep 0.2
                    NC "

==> [EFI System Partition ${green}OK${nc}] "
                fi
            elif [[ "${bootloader}" == "2" ]]; then
                if [[ "${espmnt}" == "1" ]]; then
                    espprt="ok"
                    sleep 0.2
                    NC "

==> [EFI System Partition ${green}OK${nc}] "
                elif [[ "${espmnt}" == "2" ]]; then
                    espprt="ok"
                fi
            fi  
        fi

        if [[ "${espprt}" == "fail" && "${espsize}" -lt "209715200" ]]; then
            sleep 0.2
            RED "
        ---------------------------------------------
        ###  ${yellow}WARNING: ESP's size is not adequate  ${red}###
        ---------------------------------------------"
        fi
    else
        espprt="fail"
        sleep 0.2
        RED "
        -------------------------------------------
        ###  ${yellow}EFI System Partition not detected  ${red}###
        -------------------------------------------"
    fi

    if [[ "${fs}" == "1" ]]; then
        if [[ "${sep_home}" == "y" ]]; then
            if [[ -e "${home_dev}" ]]; then
                homeprt="ok"
                if [[ "${autohome}" == "y" ]]; then
                    local prompt="Confirm /Home Partition"
                    ok
                else
                    sleep 0.2
                    NC "

==> [Linux /Home ${green}OK${nc}] "
                    fi
            else
                homeprt="fail"
                sleep 0.2
                RED "
        --------------------------------------------
        ###  ${yellow}Linux /Home Partition not detected  ${red}###
        --------------------------------------------"
            fi
        fi
    fi

    if [[ "${swapmode}" == "1" ]]; then
        if [[ -e "${swap_dev}" ]]; then
            swapprt="ok"
            if [[ "${autoswap}" == "y" ]]; then
                local prompt="Confirm /Swap Partition"
                ok
            else
                sleep 0.2
                NC "

==> [Linux /Swap ${green}OK${nc}] "
            fi
        else
            swapprt="fail"
            sleep 0.2
            RED "
        --------------------------------------------
        ###  ${yellow}Linux /Swap Partition not detected  ${red}###
        --------------------------------------------"
        fi
    fi

    if [[ ${rootprt} == "fail" ]] || [[ "${espprt}" == "fail" ]] || [[ "${xbootprt}" == "fail" ]] || [[ ${homeprt} == "fail" ]] || [[ ${swapprt} == "fail" ]]; then
            sanity="no"
    else
            sanity="ok"
    fi
#--------------------------------------------------------------------------------------------------    
    if [[ "${sanity}" == "ok" ]]; then
        if [[ "${autopart}" == "yes" ]]; then
            sleep 0.2
            NC "

==> [${green}Disk ${sgdrive} Smart-Partitioned OK${nc}] "
        fi
        sleep 0.2
        NC "

        -----------------------
        ### ${green}SANITY CHECK OK${nc} ###
        -----------------------"
        sleep 0.2
        YELLOW "


###------------------------------------------------[ DISK OVERVIEW ]------------------------------------------------###

        "
        fdisk -l "${instl_drive}" | grep -E --color=no 'Dev|dev' |GREP_COLORS='mt=01;36' grep -E --color=always 'EFI System|$'|GREP_COLORS='mt=01;32' grep -E --color=always 'Linux root|$'|GREP_COLORS='mt=01;35' grep -E --color=always 'Linux home|$'|GREP_COLORS='mt=01;33' grep -E --color=always 'Linux swap|$'|GREP_COLORS='mt=01;31' grep -E --color=always 'Linux extended boot|$'
        YELLOW "

###-----------------------------------------------------------------------------------------------------------------### "
        BLUE "


        >  Proceed using the ${nc}${cyan}current ${blue}partitioning layout ? [y/n]
        "
        read -r -p "
==> " partok
        echo

        local prompt="Confirm Disk"
        local stage_prompt="Partitioning"
        if [[ "${partok}" == "y" ]]; then
            ok
            return 0
        elif [[ "${partok}" == "n" ]]; then
                reload
                until manual_part; do : ; done
        else
            y_n
            return 1
        fi
#--------------------------------------------------------------------------------------------------
    elif [[ "${sanity}" == "no" ]]; then
        sleep 0.2
        RED "

        -----------------------------
        ###  ${yellow}SANITY CHECK FAILED${red}  ###
        -----------------------------"
        NC "



                                      ${bwhite}Press any key to continue${nc}


        "
        read -r -s -n 1
        
        if [[ "${multibooting}" == "y" ]]; then
            if [[ "${espprt}" == "fail" && -e "${esp_dev}" ]]; then
                sleep 0.2
                CYAN "
        ---------------------------------------------------
        ###  ${yellowl}/ESP: Not all prerequisites are satisfied  ${nc}${cyan}###
        ---------------------------------------------------"
                if [[ "${espmnt}" == "2" ]]; then
                    sleep 0.2
                    NC "

        ----------------------------------------------------
        >>>  ${cyan}Select ${yellowl}/mnt/efi ${nc}${cyan}as the mountpoint for your ${yellowl}/ESP ${nc}${nc}
        ----------------------------------------------------"
                fi
                if [[ "${xbootprt}" == "fail" ]]; then
                    sleep 0.2
                    NC "
        ------------------------------------------------------------------------------------------
        >>>  ${cyan}Systemd-boot:${nc}

        >>>  ${cyan}Create a ${yellowl}300M ${nc}${cyan}(at minimum) Linux Extended Boot Partition ${nc}(XBOOTLDR) ${yellowl}[GUID CODE: ea00] ${nc}${nc}
        ------------------------------------------------------------------------------------------"
                fi
                NC "


                                      ${bwhite}Press any key to continue${nc}
                "
                read -r -s -n 1

                if [[ "${espmnt}" == "2" ]]; then
                    until slct_espmnt; do : ; done
                fi
                if [[ "${xbootprt}" == "fail" ]]; then
                    until manual_part; do : ; done
                fi
            elif [[ "${espprt}" == "fail" && ! -e "${esp_dev}" ]]; then
                reload
                until manual_part; do : ; done
            elif [[ "${homeprt}" == "fail" || "${swapprt}" == "fail" ]]; then
                reload
                until manual_part; do : ; done
            fi
        elif [[ "${multibooting}" == "n" ]]; then
            if [[ "${smartpart}" == "n" && -z "${preset}" ]] ; then
                reload
                until manual_part; do : ; done
            elif [[ "${smartpart}" == "n" && -n "${preset}" ]] ; then
                local stage_prompt="Partitioning"
                line2
                stage_fail
            else
                reload
                until auto_part; do : ; done
            fi
        fi
    fi
}
###################################################################################################
ask_crypt (){

        local prompt="Encryption Setup"
        sleep 0.2
        NC "


${magenta}###${nc}------------------------------------${magenta}[ ${bwhite}Encryption  Setup${nc} ${magenta}]${nc}------------------------------------${magenta}###${nc}
        "
        BLUE "

        >  Enable${nc} ${cyan}${roottype} ${blue}Encryption? [LUKS] "
        NC "

            * Type '${cyan}no${nc}' to proceed without encryption

            * Type '${cyan}yes${nc}' to encrypt your ${roottype}
        "
        read -r -p "
==> " encrypt
        echo

    if [[ "${encrypt}" == "no" ]]; then
        skip
        ok
        return 0
    elif [[ "${encrypt}" == "yes" ]]; then
        sleep 0.2
        YELLOW "
        >  Enter a name for your Encrypted ${roottype} Partition: "
        BLUE "


Enter a name: "
        read -r -p "
==> " ENCROOT
        echo

        if [[ -z "${ENCROOT}" ]]; then
            sleep 0.2
            RED "
        -----------------------------------------
        ###  ${yellow}Please enter a name to continue  ${red}###
        -----------------------------------------"
            reload
            return 1
        elif [[ "${ENCROOT}" =~ [[:upper:]] ]]; then
            sleep 0.2
            RED "
        ------------------------------------------------------
        ###  ${yellow}Uppercase is not allowed. Please try again..  ${red}###
        ------------------------------------------------------"
            reload
            return 1
        elif [[ -n "${ENCROOT}" ]]; then
            sleep 0.2
            NC "

==> [${green}Encrypted ${roottype} Label OK${nc}] "
        fi

        if [[ -e "${home_dev}" ]]; then
            if [[ "${sep_home}" == "y" ]]; then
                sleep 0.2
                YELLOW "


        ###  A /Home Partition has been detected "
                sleep 0.2
                BLUE "


        >  Encrypt${nc} ${nc}/Home ${blue}partition? [LUKS] "
                NC "

            * Type '${cyan}no${nc}' to proceed without encryption

            * Type '${cyan}yes${nc}' to encrypt your /Home
                "
                read -r -p "
==> " homecrypt
                echo

                if [[ "${homecrypt}" == "no" ]]; then
                    skip
                elif [[ "${homecrypt}" == "yes" ]]; then
                    sleep 0.2
                    YELLOW "
        >  Enter a name for your Encrypted /Home Partition: "
                    BLUE "


Enter a name: "
                    read -r -p "
==> " ENCRHOME
                    echo

                        if [[ -z "${ENCRHOME}" ]]; then
                            sleep 0.2
                            RED "
        -----------------------------------------
        ###  ${yellow}Please enter a name to continue  ${red}###
        -----------------------------------------"
                            reload
                            return 1
                        elif [[ "${ENCRHOME}" =~ [[:upper:]] ]]; then
                            sleep 0.2
                            RED "
        ------------------------------------------------------
        ###  ${yellow}Uppercase is not allowed. Please try again..  ${red}###
        ------------------------------------------------------"
                            reload
                            return 1
                        elif [[ -n "${ENCRHOME}" ]]; then
                            sleep 0.2
                            NC "

==> [${green}Encrypted /Home Label OK${nc}] "
                        fi
                else
                    yes_no
                    return 1
                fi
            fi
        fi
        ok
    else
        yes_no
        return 1
    fi
}
###################################################################################################
instl (){

        install="yes"
    if [[ -z "${lcl_slct}" ]]; then
        sleep 0.2
        CYAN "


        [!] Please complete ${nc}'Locale & Keyboard Layout Selection'${cyan} to continue
        "
        until slct_locale; do : ; done
        until slct_kbd; do : ; done
    fi

    if [[ -z "${USERNAME}" ]]; then
        local stage_prompt="User, Root User & Hostname Setup"
        completion_err
        until user_setup; do : ; done
        until rootuser_setup; do : ; done
        until slct_hostname; do : ; done
    fi

    if [[ -z "${kernelnmbr}" ]]; then
        local stage_prompt="Kernel, Bootloader & ESP Mountpoint Setup"
        completion_err
        until slct_krnl; do : ; done
        until ask_bootldr; do : ; done
        until slct_espmnt; do : ; done
    fi

    if [[ -z "${fs}" ]]; then
        local stage_prompt="Filesystem & Swap Setup"
        completion_err
        until ask_fs; do : ; done
        until ask_swap; do : ; done
    fi

    if [[ -z "${hypervisor}" ]]; then
        until dtct_hyper; do : ; done
        if [[ "${hypervisor}" == "none" ]]; then
            local stage_prompt="Graphics Setup"
            completion_err
            until dtct_vga; do : ; done
        fi
    fi

    if [[ -z "${packages}" ]]; then
        local stage_prompt="Desktop Setup"
        completion_err
        until slct_dsktp; do : ; done
    fi

    if [[ "${hypervisor}" == "none" ]]; then
        if [[ -z "${efi_entr_del}" ]]; then
            local stage_prompt="EFI Boot Entries Deletion"
            completion_err
            until boot_entr; do : ; done
        fi
    fi

    if [[ "${hypervisor}" == "none" ]]; then
        if [[ -z "${wrlss_rgd}" ]]; then
            local stage_prompt="Wireless Regulatory Domain Setup"
            completion_err
            until wireless_rgd; do : ; done
        fi
    fi

        until instl_dsk; do : ; done
        until ask_crypt; do : ; done

    if [[ "${swapmode}" == "1" ]]; then
        until "${swaptype}"; do : ; done
    fi

    if [[ "${encrypt}" == "no" ]]; then
        until set_mode; do : ; done
        until confirm_status; do : ; done
    elif [[ "${encrypt}" == "yes" ]]; then
        until sec_erase; do : ; done
        until luks; do : ; done
        until opt_pcmn; do : ; done
        until pacstrap_system; do : ; done
        if [[ "${swapmode}" == "2" ]]; then
            until "${swaptype}"; do : ; done
        fi
        if [[ -n "${REGDOM}" ]]; then
            until wireless_regdom; do : ; done
        fi
        chroot_conf
    fi
}
###################################################################################################
swappart (){

        local stage_prompt="Swap Partition"
        sleep 0.2
        NC "


${magenta}###${nc}----------------------------------${magenta}[ ${bwhite}Swap  Partition Setup${nc} ${magenta}]${nc}----------------------------------${magenta}###${nc}
        "
    if mkswap "${swap_dev}" > /dev/null 2>&1 ; then
        stage_ok
    else
        stage_fail
    fi
}
###################################################################################################
set_mode (){

    if [[ "${rootcount}" -gt "1" || "${espcount}" -gt "1" || "${xbootcount}" -gt "1" || "${homecount}" -gt "1" || "${swapcount}" -gt "1" ]]; then
        line2
        until auto_mode; do : ; done
        sleep 0.2
        NC "

==> [${green}Filesystems OK${nc}]
        "
        sleep 0.2
        YELLOW "
###---------------------------------------------[ FILESYSTEM OVERVIEW ]---------------------------------------------###

       "
        lsblk -f|GREP_COLORS='mt=01;36' grep -E --color=always 'vfat|$'|GREP_COLORS='mt=01;32' grep -E --color=always 'ext4|$'|GREP_COLORS='mt=01;35' grep -E --color=always 'btrfs|$'|GREP_COLORS='mt=01;31' grep -E --color=always 'ntfs|$'|GREP_COLORS='mt=01;33' grep -E --color=always 'swap|$'
        YELLOW "

###-----------------------------------------------------------------------------------------------------------------###"
        echo
        sleep 0.2
        return 0
    fi

        sleep 0.2
        NC "


${magenta}###${nc}-------------------------------------${magenta}[ ${bwhite}Mode  Selection${nc} ${magenta}]${nc}-------------------------------------${magenta}###${nc}
        "
        YELLOW "

        >  Select a Mode to continue: "
        NC "

            [1]  Auto     (Automatically Format, Label & Mount partitions)

            [2]  Manual   (Manually Format, Label & Mount partitions) "
        BLUE "


Enter a Mode number: "
        read -r -p "
==> " setmode
        echo

    case "${setmode}" in
        1)
            until auto_mode; do : ; done ;;
        2)
            until manual_mode; do : ; done ;;
       "")
            RED "
        ------------------------------------------
        ###  ${yellow}Please select a Mode to continue  ${red}###
        ------------------------------------------"
            reload
            return 1 ;;
        *)
            invalid
            return 1 ;;
    esac

        sleep 0.2
        NC "

==> [${green}Filesystems OK${nc}]
        "
        sleep 0.2
        YELLOW "
###---------------------------------------------[ FILESYSTEM OVERVIEW ]---------------------------------------------###

               "
        lsblk -f|GREP_COLORS='mt=01;36' grep -E --color=always 'vfat|$'|GREP_COLORS='mt=01;32' grep -E --color=always 'ext4|$'|GREP_COLORS='mt=01;35' grep -E --color=always 'btrfs|$'|GREP_COLORS='mt=01;31' grep -E --color=always 'ntfs|$'|GREP_COLORS='mt=01;33' grep -E --color=always 'swap|$'
        YELLOW "

###-----------------------------------------------------------------------------------------------------------------###"
        echo
        sleep 0.2
}
###################################################################################################
auto_mode (){

        sleep 0.2
        NC "
${magenta}###${nc}----------------------------------------${magenta}[ ${bwhite}Auto Mode${nc} ${magenta}]${nc}----------------------------------------${magenta}###${nc}
        "
        sleep 0.2
        YELLOW "

        >  Auto Mode Selected

        "
        sleep 0.2
        espfs="$(lsblk -f --noheadings "${esp_dev}" | awk "{print \$2}")"

    if [[ "${fs}" == "1" ]]; then
        if mkfs.ext4 -F -L Root "${root_dev}" > /dev/null 2>&1 ; then
            mount "${root_dev}" /mnt > /dev/null 2>&1 || err_abort
            sleep 0.2
            NC "
==> [${green}/Root OK${nc}]
            "
        else
            umount_manual
            until form_root; do : ; done
            until mount_mnt; do : ; done
        fi
#--------------------------------------------------------------------------------------------------
    elif [[ "${fs}" == "2" ]]; then
        if mkfs.btrfs -f -L Root "${root_dev}" > /dev/null 2>&1 ; then
            mount "${root_dev}" /mnt > /dev/null 2>&1 || err_abort
            btrfs subvolume create /mnt/@ > /dev/null 2>&1 || err_abort
            btrfs subvolume create /mnt/@home > /dev/null 2>&1 || err_abort
            btrfs subvolume create /mnt/@cache > /dev/null 2>&1 || err_abort
            btrfs subvolume create /mnt/@log > /dev/null 2>&1 || err_abort
            btrfs subvolume create /mnt/@tmp > /dev/null 2>&1 || err_abort
            btrfs subvolume create /mnt/@snapshots > /dev/null 2>&1 || err_abort
                if [[ "${swapmode}" == "2" ]]; then
                    btrfs subvolume create /mnt/@swap > /dev/null 2>&1 || err_abort
                fi
            umount /mnt > /dev/null 2>&1 || err_abort
            mount -o "${sbvl_mnt_opts}",subvol=@ "${root_dev}" /mnt > /dev/null 2>&1 || err_abort
                if [[ "${swapmode}" == "2" ]]; then
                    mount --mkdir -o rw,nodatacow,subvol=@swap "${root_dev}" /mnt/swap > /dev/null 2>&1 || err_abort
                fi
            mount --mkdir -o "${sbvl_mnt_opts}",subvol=@cache "${root_dev}" /mnt/var/cache > /dev/null 2>&1 || err_abort
            mount --mkdir -o "${sbvl_mnt_opts}",subvol=@home "${root_dev}" /mnt/home > /dev/null 2>&1 || err_abort
            mount --mkdir -o "${sbvl_mnt_opts}",subvol=@log "${root_dev}" /mnt/var/log > /dev/null 2>&1 || err_abort
            mount --mkdir -o "${sbvl_mnt_opts}",subvol=@snapshots "${root_dev}" /mnt/"${snapname}" > /dev/null 2>&1 || err_abort
            mount --mkdir -o "${sbvl_mnt_opts}",subvol=@tmp "${root_dev}" /mnt/var/tmp > /dev/null 2>&1 || err_abort
            sleep 0.2
            NC "
==> [${green}/@ OK${nc}]
            "
        else
            umount_manual
            until form_root; do : ; done
            until mount_mnt; do : ; done
        fi
    fi
        sleep 0.2
#--------------------------------------------------------------------------------------------------
    if [[ "${multibooting}" == "n" ]]; then
        if mkfs.fat -F 32 -n ESP "${esp_dev}" > /dev/null 2>&1 ; then
            mount --mkdir "${esp_dev}" "${esp_mount}" > /dev/null 2>&1 || err_abort
            sleep 0.2
            NC "
==> [${green}/ESP OK${nc}]
            "
        else
            umount_manual
            until form_esp; do : ; done
            until mount_mnt; do : ; done
            until mount_esp; do : ; done
        fi
    elif [[ "${multibooting}" == "y" && "${espfs}" == "vfat" ]]; then
        if mount --mkdir "${esp_dev}" "${esp_mount}" > /dev/null 2>&1 ; then
            sleep 0.2
            NC "
==> [${green}Unformatted /ESP OK${nc}]
            "
        else
            umount_manual
            until mount_mnt; do : ; done
            until mount_esp; do : ; done
        fi
    elif [[ "${multibooting}" == "y" && "${espfs}" != "vfat" ]]; then
        if mkfs.fat -F 32 -n ESP "${esp_dev}" > /dev/null 2>&1 ; then
            mount --mkdir "${esp_dev}" "${esp_mount}" > /dev/null 2>&1 || err_abort
            sleep 0.2
            NC "
==> [${green}/ESP OK${nc}]
            "
        else
            umount_manual
            until form_esp; do : ; done
            until mount_mnt; do : ; done
            until mount_esp; do : ; done
        fi
    fi
            sleep 0.2
#--------------------------------------------------------------------------------------------------
        if [[ ${xbootloader} == "yes" ]]; then
            if mkfs.fat -F 32 -n XBOOTLDR "${xboot_dev}" > /dev/null 2>&1 ; then
                mount --mkdir "${xboot_dev}" /mnt/boot > /dev/null 2>&1 || err_abort
                sleep 0.2
                NC "
==> [${green}/XBOOTLDR OK${nc}]
                "
            else
                umount_manual
                until form_xboot; do : ; done
                until mount_mnt; do : ; done
                until mount_esp; do : ; done
                until mount_xboot; do : ; done
            fi
        fi
            sleep 0.2
#--------------------------------------------------------------------------------------------------
    if [[ ${fs} == "1" && -e "${home_dev}" && "${sep_home}" == "y" ]]; then
        if [[ "${smartpart}" == "y" ]]; then
            homeform="y"
        elif [[ "${preset}" == "3" || "${preset}" == "4" || "${preset}" == "7" || "${preset}" == "8" ]]; then
            homeform="y"
        elif [[ -z "${smartpart}" ]] || [[ -z "${preset}" ]]; then
            BLUE "


        >  A ${nc}/Home ${blue}partition has been detected. Format as ${nc}${fsname}${blue} ? [y/n]

            "
            read -r -p "
==> " homeform
            echo
        fi
                
        if [[ "${homeform}" == "y" ]]; then
            if mkfs.ext4 -F -L Home "${home_dev}" > /dev/null 2>&1 ; then
                mount --mkdir "${home_dev}" /mnt/home > /dev/null 2>&1 || err_abort
                sleep 0.2
                NC "
==> [${green}/Home OK${nc}]
                "
            else
                umount_manual
                until manual_part; do : ; done
                until form_home; do : ; done
                until mount_mnt; do : ; done
                until mount_esp; do : ; done
                    if [[ "${xbootloader}" == "yes" ]]; then
                        until mount_xboot; do : ; done
                    fi
                until mount_home; do : ; done
            fi
        elif [[ "${homeform}" == "n" ]]; then
            skip
        else
            y_n
            until ask_homepart_form; do : ; done
        fi
    fi
}
###################################################################################################
manual_mode (){

        volumes="$(fdisk -l | grep '^/dev' | cat --number)"
        until form_esp; do : ; done
            if [[ "${xbootloader}" == "yes" ]]; then
                until form_xboot; do : ; done
            fi
        until form_root; do : ; done
            if [[ -e "${home_dev}" && "${sep_home}" == "y" ]]; then
                until form_home; do : ; done
            fi
        until mount_mnt; do : ; done
        until mount_esp; do : ; done
            if [[ "${xbootloader}" == "yes" ]]; then
                until mount_xboot; do : ; done
            fi
            if [[ -e "${home_dev}" && "${sep_home}" == "y" ]]; then
                until mount_home; do : ; done
            fi
}
###################################################################################################
form_esp (){

        sleep 0.2
        NC "


${magenta}###${nc}-------------------------------${magenta}[ ${bwhite}Format EFI System Partition${nc} ${magenta}]${nc}-------------------------------${magenta}###${nc}
        "
        form_esp_nmbr=" "

    while [[ -n "${form_esp_nmbr}" ]]; do
        YELLOW "

        >  Select an EFI System Partition to format as vfat "
        NC "

${volumes}"
        BLUE "


Enter a partition number ${bwhite}(empty to skip and proceed)${blue}: "
        read -r -p "
==> " form_esp_nmbr

    if [[ -n "${form_esp_nmbr}" ]]; then
        esppart="$(echo "${volumes}" | awk "\$1 == ${form_esp_nmbr} { print \$2}")"
        manespfs="$(lsblk -f --noheadings "${esppart}" | awk "{print \$2}")"
        if [[ -e "${esppart}" ]]; then
            if [[ "${multibooting}" == "n" ]]; then
                if mkfs.fat -F 32 -n ESP "${esppart}" > /dev/null 2>&1 ; then
                    sleep 0.2
                    NC "

==> [${green}Format & Label /ESP OK${nc}] "
                    return 0
                else
                    umount_abort
                    until manual_part; do : ; done
                    until form_esp; do : ; done
                    return 0
                fi
            elif [[ "${multibooting}" == "y" && "${manespfs}" == "vfat" ]]; then
                sleep 0.2
                NC "

==> [${green}/Unformatted ESP OK${nc}] "
                return 0
            elif [[ "${multibooting}" == "y" && "${manespfs}" != "vfat" ]]; then
                if mkfs.fat -F 32 -n ESP "${esppart}" > /dev/null 2>&1 ; then
                    sleep 0.2
                    NC "

==> [${green}Format & Label /ESP OK${nc}] "
                    return 0
                else
                    umount_abort
                    until manual_part; do : ; done
                    until form_esp; do : ; done
                    return 0
                fi
            fi
        else
            invalid
            return 1
        fi
    fi
        RED "
        ---------------------------------------------------
        ###  ${yellow}WARNING: PARTITION HAS NOT BEEN FORMATTED  ${red}###
        ---------------------------------------------------"
        sleep 2
        skip
    done
}
###################################################################################################
form_xboot (){

        sleep 0.2
        NC "


${magenta}###${nc}--------------------------${magenta}[ ${bwhite}Format  Linux Extended Boot Partition${nc} ${magenta}]${nc}--------------------------${magenta}###${nc}
        "
        form_xboot_nmbr=" "

    while [[ -n "${form_xboot_nmbr}" ]]; do
        YELLOW "

        >  Select a Linux Extended Boot Partition to format as vfat "
        NC "

${volumes}"
        BLUE "


Enter a partition number ${bwhite}(empty to skip and proceed)${blue}: "
        read -r -p "
==> " form_xboot_nmbr

    if [[ -n "${form_xboot_nmbr}" ]]; then
    xbootpart="$(echo "${volumes}" | awk "\$1 == ${form_xboot_nmbr} { print \$2}")"
        if [[ -e "${xbootpart}" ]]; then
            if mkfs.fat -F 32 -n XBOOTLDR "${xbootpart}" > /dev/null 2>&1 ; then
                sleep 0.2
                NC "

==> [${green}Format & Label /XBOOTLDR OK${nc}] "
                return 0
            else
                umount_abort
                until manual_part; do : ; done
                until form_xboot; do : ; done
                return 0
            fi
        else
            invalid
            return 1
        fi
    fi
        RED "
        ---------------------------------------------------
        ###  ${yellow}WARNING: PARTITION HAS NOT BEEN FORMATTED  ${red}###
        ---------------------------------------------------"
        sleep 2
        skip
    done
}
###################################################################################################
form_root (){

        sleep 0.2
        NC "


${magenta}###${nc}----------------------------------${magenta}[ ${bwhite}Format Root Partition${nc} ${magenta}]${nc}----------------------------------${magenta}###${nc}
        "
        form_root_nmbr=" "

    while [[ -n "${form_root_nmbr}" ]]; do
        YELLOW "

        >  Select a ${roottype} Partition to format as ${fsname} "
        NC "

${volumes}"
        BLUE "


Enter a partition number ${bwhite}(empty to skip and proceed)${blue}: "
        read -r -p "
==> " form_root_nmbr

    if [[ -n "${form_root_nmbr}" ]]; then
    rootpart="$(echo "${volumes}" | awk "\$1 == ${form_root_nmbr} { print \$2}")"
        if [[ -e "${rootpart}" ]]; then
#--------------------------------------------------------------------------------------------------
            if [[ "${fs}" == "1" ]]; then
                if mkfs.ext4 -F "${rootpart}" > /dev/null 2>&1 ; then
                    sleep 0.2
                    NC "


==> [${green}Format ${roottype} OK${nc}] "
                else
                    umount_abort
                    until manual_part; do : ; done
                    until form_root; do : ; done
                    return 0
                fi
#--------------------------------------------------------------------------------------------------
            elif [[ "${fs}" == "2" ]]; then
                if mkfs.btrfs -f "${rootpart}" > /dev/null 2>&1 ; then
                    mount "${rootpart}" /mnt > /dev/null 2>&1 || err_abort
                    btrfs subvolume create /mnt/@ > /dev/null 2>&1 || err_abort
                    btrfs subvolume create /mnt/@home > /dev/null 2>&1 || err_abort
                    btrfs subvolume create /mnt/@cache > /dev/null 2>&1 || err_abort
                    btrfs subvolume create /mnt/@log > /dev/null 2>&1 || err_abort
                    btrfs subvolume create /mnt/@tmp > /dev/null 2>&1 || err_abort
                    btrfs subvolume create /mnt/@snapshots > /dev/null 2>&1 || err_abort
                    if [[ "${swapmode}" == "2" ]]; then
                        btrfs subvolume create /mnt/@swap > /dev/null 2>&1 || err_abort
                    fi
                    umount /mnt > /dev/null 2>&1 || err_abort
                    sleep 0.2
                    NC "


==> [${green}Format ${roottype} OK${nc}] "
                else
                    umount_abort
                    until manual_part; do : ; done
                    until form_root; do : ; done
                    return 0
                fi
            fi
        else
            invalid
            return 1
        fi

            YELLOW "

        >  Label the ${roottype} Partition "
            BLUE "


Enter a name ${bwhite}(empty to skip and proceed)${blue}: "
            read -r -p "
==> " rootpartname

        if [[ -n "${rootpartname}" ]]; then
            if [[ "${fs}" == "1" ]]; then
                if e2label "${rootpart}" "${rootpartname}" > /dev/null 2>&1 ; then
            	    sleep 0.2
            	    NC "

==> [${green}Label ${roottype} OK${nc}] "
            	    return 0
            	else
            	    err_try
            	    return 1
            	fi
            elif [[ "${fs}" == "2" ]]; then
                mount "${rootpart}" /mnt || err_abort
                btrfs filesystem label /mnt "${rootpartname}" > /dev/null 2>&1 || err_abort
                umount /mnt || err_abort
            	sleep 0.2
            	NC "

==> [${green}Label ${roottype} OK${nc}] "
            	return 0
            fi
        fi
        skip
        return 0
    else
        RED "
        ---------------------------------------------------
        ###  ${yellow}WARNING: PARTITION HAS NOT BEEN FORMATTED  ${red}###
        ---------------------------------------------------"
        sleep 2
        skip
        return 0
    fi
  	done
}
###################################################################################################
ask_homepart_form (){

    if [[ ${fs} == "1" && -e "${home_dev}" && "${sep_home}" == "y" ]]; then
        if [[ "${smartpart}" == "y" ]]; then
            homeform="y"
        elif [[ "${preset}" == "3" || "${preset}" == "4" || "${preset}" == "7" || "${preset}" == "8" ]]; then
            homeform="y"
        elif [[ -z "${smartpart}" ]] || [[ -z "${preset}" ]]; then
            BLUE "


        >  A${nc} ${cyan}/Home ${blue}partition has been detected. Format as ${nc}${fsname}${blue} ? [y/n]

            "
            read -r -p "
==> " homeform
            echo
        fi
                
        if [[ "${homeform}" == "y" ]]; then
            if mkfs.ext4 -F -L Home "${home_dev}" > /dev/null 2>&1 ; then
                mount --mkdir "${home_dev}" /mnt/home > /dev/null 2>&1 || err_abort
                sleep 0.2
                NC "
==> [${green}/Home OK${nc}]
                "
            else
                umount_manual
                until manual_part; do : ; done
                until form_home; do : ; done
                until mount_mnt; do : ; done
                until mount_esp; do : ; done
                    if [[ "${xbootloader}" == "yes" ]]; then
                        until mount_xboot; do : ; done
                    fi
                until mount_home; do : ; done
            fi
        elif [[ "${homeform}" == "n" ]]; then
            skip
        else
            y_n
            return 1
        fi
    fi
}
###################################################################################################
form_home (){

        sleep 0.2
        NC "


${magenta}###${nc}----------------------------------${magenta}[ ${bwhite}Format Home Partition${nc} ${magenta}]${nc}----------------------------------${magenta}###${nc}
        "
        form_home_nmbr=" "

    while [[ -n "${form_home_nmbr}" ]]; do
        YELLOW "

        >  Select a /Home Partition to format as Ext4 "
        NC "


${volumes} "
        BLUE "


Enter a partition number ${bwhite}(empty to skip and proceed)${blue}: "
        read -r -p "
==> " form_home_nmbr

        if [[ -n "${form_home_nmbr}" ]]; then
        homepart="$(echo "${volumes}" | awk "\$1 == ${form_home_nmbr} { print \$2}")"
            if [[ -e "${homepart}" ]]; then
                if mkfs.ext4 -F "${homepart}" > /dev/null 2>&1 ; then
                    sleep 0.2
                    NC "


==> [${green}Format /Home OK${nc}] "
                else
                    umount_abort
                    until manual_part; do : ; done
                    until form_home; do : ; done
                    return 0
                fi
            else
                invalid
                return 1
            fi
            YELLOW "

        >  Label the /Home Partition "
            BLUE "


Enter a name ${bwhite}(empty to skip and proceed)${blue}: "
            read -r -p "
==> " homepartname

            if [[ -n "${homepartname}" ]]; then
                if e2label "${homepart}" "${homepartname}" > /dev/null 2>&1 ;then
                    sleep 0.2
                    NC "

==> [${green}Label /Home OK${nc}] "
                    return 0
                else
                    err_try
                    return 1
                fi
            fi
            skip
            return 0
        else
            RED "
        ---------------------------------------------------
        ###  ${yellow}WARNING: PARTITION HAS NOT BEEN FORMATTED  ${red}###
        ---------------------------------------------------"
            skip
            return 0
        fi
    done
}
###################################################################################################
mount_mnt (){

        local prompt="Mount ${roottype}"
        sleep 0.2
        NC "


${magenta}###${nc}----------------------------------${magenta}[ ${bwhite}Mount  Root Partition${nc} ${magenta}]${nc}----------------------------------${magenta}###${nc}
        "
        YELLOW "

        >  Select a ${roottype} Partition to mount to ${nc}/mnt "
        NC "


${volumes} "
        BLUE "


Enter your${nc} ${cyan}${roottype} ${blue}partition number: "
        read -r -p "
==> " mntroot_nmbr
        echo

    if [[ -n "${mntroot_nmbr}" ]]; then
    rootpart="$(echo "${volumes}" | awk "\$1 == ${mntroot_nmbr} { print \$2}")"
        if [[ -e "${rootpart}" ]]; then
#--------------------------------------------------------------------------------------------------
            if [[ "${fs}" == "1" ]]; then
                if mount "${rootpart}" /mnt > /dev/null 2>&1 ; then
                    sleep 0.2
                    ok
                    return 0
                else
                    umount_abort
                    until mount_mnt; do : ; done
                fi                		
#--------------------------------------------------------------------------------------------------
            elif [[ "${fs}" == "2" ]]; then
                if mount -o "${sbvl_mnt_opts}",subvol=@ "${rootpart}" /mnt > /dev/null 2>&1 ; then
                    if [[ "${swapmode}" == "2" ]]; then
                        mount --mkdir -o rw,nodatacow,subvol=@swap "${rootpart}" /mnt/swap > /dev/null 2>&1 || err_abort
                    fi
                    mount --mkdir -o "${sbvl_mnt_opts}",subvol=@cache "${rootpart}" /mnt/var/cache > /dev/null 2>&1 || err_abort
                    mount --mkdir -o "${sbvl_mnt_opts}",subvol=@home "${rootpart}" /mnt/home > /dev/null 2>&1 || err_abort
                    mount --mkdir -o "${sbvl_mnt_opts}",subvol=@log "${rootpart}" /mnt/var/log > /dev/null 2>&1 || err_abort
                    mount --mkdir -o "${sbvl_mnt_opts}",subvol=@snapshots "${rootpart}" /mnt/"${snapname}" > /dev/null 2>&1 || err_abort
                    mount --mkdir -o "${sbvl_mnt_opts}",subvol=@tmp "${rootpart}" /mnt/var/tmp > /dev/null 2>&1 || err_abort
                    sleep 0.2
                    ok
                    return 0
                else
                    umount_abort
                    until mount_mnt; do : ; done
                fi
            fi
#--------------------------------------------------------------------------------------------------
        else
            invalid
            return 1
        fi
    else
        choice
        return 1
    fi
}
###################################################################################################
mount_esp (){

        local prompt="Mount ESP"
        sleep 0.2
        NC "


${magenta}###${nc}-----------------------------------${magenta}[ ${bwhite}Mount ESP Partition${nc} ${magenta}]${nc}-----------------------------------${magenta}###${nc}
        "
        YELLOW "

        >  Select an EFI System Partition to mount to ${nc}${esp_mount} "
        NC "


${volumes}"
        BLUE "


Enter your${nc} ${cyan}/ESP ${blue}partition number: "
        read -r -p "
==> " mntesp_nmbr
        echo

    if [[ -n "${mntesp_nmbr}" ]]; then
    esppart="$(echo "${volumes}" | awk "\$1 == ${mntesp_nmbr} { print \$2}")"
        if [[ -e "${esppart}" ]]; then
            if mount --mkdir "${esppart}" "${esp_mount}" > /dev/null 2>&1 ; then
                ok
                return 0
            else
                umount_abort
                until mount_mnt; do : ; done
                until mount_esp; do : ; done
            fi
        else
            invalid
            return 1
        fi
    else
        choice
        return 1
    fi
}
###################################################################################################
mount_xboot (){

        local prompt="Mount XBOOTLDR"
        sleep 0.2
        NC "


${magenta}###${nc}--------------------------------${magenta}[ ${bwhite}Mount XBOOTLDR  Partition${nc} ${magenta}]${nc}--------------------------------${magenta}###${nc}
        "
        YELLOW "

        >  Select a Linux Extended Boot Partition to mount to ${nc}/mnt/boot "
        NC "


${volumes}"
        BLUE "


Enter your${nc} ${cyan}/XBOOTLDR ${blue}partition number: "
        read -r -p "
==> " mntxboot_nmbr
        echo

    if [[ -n "${mntxboot_nmbr}" ]]; then
    xbootpart="$(echo "${volumes}" | awk "\$1 == ${mntxboot_nmbr} { print \$2}")"
        if [[ -e "${xbootpart}" ]]; then
            if mount --mkdir "${xbootpart}" /mnt/boot > /dev/null 2>&1 ; then
                ok
                return 0
            else
                umount_abort
                until mount_mnt; do : ; done
                until mount_esp; do : ; done
                until mount_xboot; do : ; done
            fi
        else
            invalid
            return 1
        fi
    else
        choice
        return 1
    fi
}
###################################################################################################
mount_home (){

        local prompt="Mount /Home"
        sleep 0.2
        NC "


${magenta}###${nc}----------------------------------${magenta}[ ${bwhite}Mount  Home Partition${nc} ${magenta}]${nc}----------------------------------${magenta}###${nc}
        "
        YELLOW "

        >  Select a /Home Partition to mount to ${nc}/mnt/home "
        NC "


${volumes}"
        BLUE "


Enter your${nc} ${cyan}/Home ${blue}partition number: "
        read -r -p "
==> " mnthome_nmbr
        echo

    if [[ -n "${mnthome_nmbr}" ]]; then
    homepart="$(echo "${volumes}" | awk "\$1 == ${mnthome_nmbr} { print \$2}")"
        if [[ -e "${homepart}" ]]; then
            if mount --mkdir "${homepart}" /mnt/home > /dev/null 2>&1 ; then
                ok
                return 0
            else
                umount_abort
                until mount_mnt; do : ; done
                until mount_esp; do : ; done
                until mount_xboot; do : ; done
                until mount_home; do : ; done
            fi
        else
            invalid
            return 1
        fi
    else
        choice
        return 1
    fi
}
###################################################################################################
confirm_status (){

        local prompt="System Ready"
        sleep 0.2
        NC "


${magenta}###${nc}-------------------------------${magenta}[ ${bwhite}Confirm Installation Status${nc} ${magenta}]${nc}-------------------------------${magenta}###${nc}
        "
        BLUE "

        >  Proceed ? "
        NC "

            * Type '${cyan}yes${nc}' to continue installation

            * Type '${cyan}no${nc}' to revise installation

        "
        read -r -p "
==> " agree

    if [[ "${agree}" == "yes" ]]; then
        ok
        until opt_pcmn; do : ; done
        until pacstrap_system; do : ; done
        if [[ "${swapmode}" == "2" ]]; then
            until "${swaptype}"; do : ; done
        fi
        if [[ -n "${REGDOM}" ]]; then
        until wireless_regdom; do : ; done
        fi
        chroot_conf
    elif [[ "${agree}" == "no" ]]; then
        unmount
        until revise; do : ; done
    else
        yes_no
        return 1
    fi
}
###################################################################################################
revise (){

        revision="yes"
        xbootloader=""
        vgaconf=""
        vendor_slct=""
        packages=""
        custompkgs=""
        customservices=""
        cust_bootopts=""
        REGDOM=""
        preset=""
        until slct_krnl; do : ; done
        until ask_bootldr; do : ; done
        until slct_espmnt; do : ; done
        until ask_fs; do : ; done
        until ask_swap; do : ; done
        until dtct_vga; do : ; done
        until slct_dsktp; do : ; done
        until boot_entr; do : ; done
        until wireless_rgd; do : ; done
        until instl_dsk; do : ; done
        until ask_crypt; do : ; done
        if [[ "${swapmode}" == "1" ]]; then 
            until "${swaptype}"; do : ; done
        fi      
    if [[ "${encrypt}" == "no" ]]; then
        until set_mode; do : ; done
        until confirm_status; do : ; done
    elif [[ "${encrypt}" == "yes" ]]; then
        until sec_erase; do : ; done
        until luks; do : ; done
        until opt_pcmn; do : ; done
        until pacstrap_system; do : ; done
        if [[ "${swapmode}" == "2" ]]; then
            until "${swaptype}"; do : ; done
        fi
        if [[ -n "${REGDOM}" ]]; then
            until wireless_regdom; do : ; done
        fi
        chroot_conf
    fi
}
###################################################################################################
sec_erase (){

        local prompt="Secure Erasure"
        sleep 0.2
        NC "


${magenta}###${nc}-----------------------------------${magenta}[ ${bwhite}Secure Disk Erasure${nc} ${magenta}]${nc}-----------------------------------${magenta}###${nc}
        "
        erase_dsk_nmbr=" "

    while [[ -n "${erase_dsk_nmbr}" ]]; do
        YELLOW "

        >  Select a disk for Secure Erasure  ${red}[!] (CAUTION) [!]${yellow} "
        RED "
        --------------------------------------------------------------------------
        ###  ${yellow}A reboot is ${yellowl}mandatory ${nc}${yellow}and will take effect ${yellowl}immediately ${nc}${yellow}when done  ${red}###
        --------------------------------------------------------------------------"
        NC "


${disks}"
        BLUE "


Enter a disk number ${bwhite}(empty to skip)${blue}: "
        read -r -p "
==> " erase_dsk_nmbr
        echo

        if [[ -n "${erase_dsk_nmbr}" ]]; then
        erasedrive="$(echo "${disks}" | awk "\$1 == ${erase_dsk_nmbr} {print \$2}")"
            if [[ -e "${erasedrive}" ]]; then
                cryptsetup open --type plain -d /dev/urandom "${erasedrive}" temp || err_abort
                dd if=/dev/zero of=/dev/mapper/temp status=progress bs=1M oflag=direct || err_abort
                cryptsetup close temp || err_abort
                sleep 0.2
                NC "

==> [${green}Drive ${erasedrive} Erased OK${nc}] "

                sleep 0.2
                NC "

==> [${green}Rebooting${nc}] "
                sleep 1
                reboot
            else
                invalid
                return 1
            fi
        else
            skip
            ok
        fi
    done
}
###################################################################################################
luks (){

        espfs="$(lsblk -f --noheadings "${esp_dev}" | awk "{print \$2}")"
        sleep 0.2
        NC "


${magenta}###${nc}-------------------------------------${magenta}[ ${bwhite}LUKS Encryption${nc} ${magenta}]${nc}-------------------------------------${magenta}###${nc}



        "
    if cryptsetup -y -v luksFormat --label CRYPTROOT "${root_dev}"; then
        if [[ "${rota}" == "0" ]]; then
            cryptsetup --perf-no_read_workqueue --perf-no_write_workqueue --persistent luksOpen "${root_dev}" "${ENCROOT}" || err_abort
        else
            cryptsetup luksOpen "${root_dev}" "${ENCROOT}" || err_abort
        fi
#------------------------------------------------------------------------------------------
        if [[ "${fs}" == "1" ]]; then
            mkfs.ext4 -F -L Root /dev/mapper/"${ENCROOT}" > /dev/null 2>&1 || err_abort
            mount /dev/mapper/"${ENCROOT}" /mnt > /dev/null 2>&1 || err_abort
            sleep 0.2
            NC "
==> [${green}Encrypted /Root OK${nc}]
            "
#------------------------------------------------------------------------------------------
        elif [[ "${fs}" == "2" ]]; then
            mkfs.btrfs -L Root /dev/mapper/"${ENCROOT}" > /dev/null 2>&1 || err_abort
            mount /dev/mapper/"${ENCROOT}" /mnt > /dev/null 2>&1 || err_abort
            btrfs subvolume create /mnt/@ > /dev/null 2>&1 || err_abort
            btrfs subvolume create /mnt/@home > /dev/null 2>&1 || err_abort
            btrfs subvolume create /mnt/@cache > /dev/null 2>&1 || err_abort
            btrfs subvolume create /mnt/@log > /dev/null 2>&1 || err_abort
            btrfs subvolume create /mnt/@snapshots > /dev/null 2>&1 || err_abort
            btrfs subvolume create /mnt/@tmp > /dev/null 2>&1 || err_abort
            if [[ "${swapmode}" == "2" ]]; then
                btrfs subvolume create /mnt/@swap > /dev/null 2>&1 || err_abort
            fi
            umount /mnt > /dev/null 2>&1 || err_abort
            mount -o "${sbvl_mnt_opts}",subvol=@ /dev/mapper/"${ENCROOT}" /mnt > /dev/null 2>&1 || err_abort
            if [[ "${swapmode}" == "2" ]]; then
                mount --mkdir -o rw,nodatacow,subvol=@swap /dev/mapper/"${ENCROOT}" /mnt/swap > /dev/null 2>&1 || err_abort
            fi
            mount --mkdir -o "${sbvl_mnt_opts}",subvol=@cache /dev/mapper/"${ENCROOT}" /mnt/var/cache > /dev/null 2>&1 || err_abort
            mount --mkdir -o "${sbvl_mnt_opts}",subvol=@home /dev/mapper/"${ENCROOT}" /mnt/home > /dev/null 2>&1 || err_abort
            mount --mkdir -o "${sbvl_mnt_opts}",subvol=@log /dev/mapper/"${ENCROOT}" /mnt/var/log > /dev/null 2>&1 || err_abort
            mount --mkdir -o "${sbvl_mnt_opts}",subvol=@snapshots /dev/mapper/"${ENCROOT}" /mnt/"${snapname}" > /dev/null 2>&1 || err_abort
            mount --mkdir -o "${sbvl_mnt_opts}",subvol=@tmp /dev/mapper/"${ENCROOT}" /mnt/var/tmp > /dev/null 2>&1 || err_abort
            sleep 0.2
            NC "
==> [${green}Encrypted /@ OK${nc}]
            "
        fi
    else
        line2
        err_try
        unmount_noabort
        return 1
    fi
#--------------------------------------------------------------------------------------------------
        line3
    if [[ -e "${swap_dev}" ]]; then
        if cryptsetup -y -v luksFormat --label CRYPTSWAP "${swap_dev}"; then
            if [[ "${rota}" == "0" ]]; then
                cryptsetup --perf-no_read_workqueue --perf-no_write_workqueue --persistent luksOpen "${swap_dev}" swap || err_abort
            else
                cryptsetup luksOpen "${swap_dev}" swap || err_abort
            fi
            mkswap /dev/mapper/swap > /dev/null 2>&1 || err_abort
            sleep 0.2
            NC "
==> [${green}Encrypted /Swap OK${nc}]
            "
        else
            line2
            err_try
            unmount_noabort
            return 1
        fi
    fi
#--------------------------------------------------------------------------------------------------
        line3
    if [[ "${homecrypt}" == "yes" ]]; then
        if cryptsetup -y -v luksFormat --label CRYPTHOME "${home_dev}"; then
            if [[ "${rota}" == "0" ]]; then
                cryptsetup --perf-no_read_workqueue --perf-no_write_workqueue --persistent luksOpen "${home_dev}" "${ENCRHOME}" || err_abort
            else
                cryptsetup luksOpen "${home_dev}" "${ENCRHOME}" || err_abort
            fi
            mkfs.ext4 -F -L Home /dev/mapper/"${ENCRHOME}" > /dev/null 2>&1 || err_abort
            mount --mkdir /dev/mapper/"${ENCRHOME}" /mnt/home > /dev/null 2>&1 || err_abort
            sleep 0.2
            NC "
==> [${green}Encrypted /Home OK${nc}]
            "
        else
            line2
            err_try
            unmount_noabort
            return 1
        fi
    elif [[ "${homecrypt}" == "no" ]]; then
        BLUE "

        >  A ${nc}/Home ${blue}partition has been detected. Format as${nc} ${fsname}${blue}? [y/n]

        "
        read -r -p "
==> " homeform
        echo

        if [[ "${homeform}" == "y" ]]; then
            if mkfs.ext4 -F -L Home "${home_dev}" > /dev/null 2>&1 ; then
                mount --mkdir "${home_dev}" /mnt/home > /dev/null 2>&1 || err_abort
                sleep 0.2
                NC "
==> [${green}/Home OK${nc}]
                "
            else
                line2
                err_try
                unmount_noabort
                return 1
            fi
        elif [[ "${homeform}" == "n" ]]; then
            skip
        else
            y_n
            return 1
        fi
    fi
#--------------------------------------------------------------------------------------------------
    if [[ "${multibooting}" == "n" ]]; then
        if mkfs.fat -F 32 -n ESP "${esp_dev}" > /dev/null 2>&1 ; then
            mount --mkdir "${esp_dev}" "${esp_mount}" > /dev/null 2>&1 || err_abort
            sleep 0.2
            NC "
==> [${green}/ESP OK${nc}]
            "
        else
            umount_abort
            until luks; do : ; done
        fi
    elif [[ "${multibooting}" == "y" && "${espfs}" == "vfat" ]]; then
        if mount --mkdir "${esp_dev}" "${esp_mount}" > /dev/null 2>&1 ; then
            sleep 0.2
            NC "
==> [${green}Unformatted /ESP OK${nc}]
            "
        else
            line2
            err_try
            unmount_noabort
            return 1
        fi
    elif [[ "${multibooting}" == "y" && "${espfs}" != "vfat" ]]; then
        if mkfs.fat -F 32 -n ESP "${esp_dev}" > /dev/null 2>&1 ; then
            mount --mkdir "${esp_dev}" "${esp_mount}" > /dev/null 2>&1 || err_abort
            sleep 0.2
            NC "
==> [${green}/ESP OK${nc}]
            "
        else
            umount_abort
            until luks; do : ; done
        fi
    fi
#--------------------------------------------------------------------------------------------------    
    if [[ "${xbootloader}" == "yes" ]] ; then
        if mkfs.fat -F 32 -n XBOOTLDR "${xboot_dev}" > /dev/null 2>&1 ; then
            mount --mkdir "${xboot_dev}" /mnt/boot > /dev/null 2>&1 || err_abort
            sleep 0.2
            NC "
==> [${green}/XBOOTLDR OK${nc}]
            "
        else
            line2
            err_try
            unmount_noabort
            return 1
        fi
    fi
#--------------------------------------------------------------------------------------------------
        sleep 0.2
        NC "
==> [${green}Encryption OK${nc}]"
        sleep 0.2
        NC "

==> [${green}Filesystems OK${nc}]
        "
        sleep 0.2
        YELLOW "
###---------------------------------------------[ FILESYSTEM OVERVIEW ]---------------------------------------------###

        "
        lsblk -f|GREP_COLORS='mt=01;36' grep -E --color=always 'vfat|$'|GREP_COLORS='mt=01;32' grep -E --color=always 'ext4|$'|GREP_COLORS='mt=01;35' grep -E --color=always 'btrfs|$'|GREP_COLORS='mt=01;31' grep -E --color=always 'ntfs|$'|GREP_COLORS='mt=01;33' grep -E --color=always 'swap|$'
        YELLOW "

###-----------------------------------------------------------------------------------------------------------------###
        "
        sleep 0.2
}
###################################################################################################
opt_pcmn (){

        local prompt="PacMan"
        sleep 0.2
        NC "


${magenta}###${nc}-----------------------------------${magenta}[ ${bwhite}Pacman Optimization${nc} ${magenta}]${nc}-----------------------------------${magenta}###${nc}
        "
        YELLOW "

        >  Select a Country for your Arch Mirrors:


        ###  [Enter ${nc}'l' ${yellow}to list Countries, then ${nc}'enter' ${yellow}to search or ${nc}'q' ${yellow}to quit] "
        BLUE "


Enter country name or country code ${bwhite}(Empty for Defaults)${blue}: "
        read -r -p "
==> " COUNTRY
        echo

    if [[ -z "${COUNTRY}" ]] ; then
        sleep 0.2
        NC "

==> [${green}Default Mirrors OK${nc}] "
    elif [[ "${COUNTRY}" == "l" ]]; then
        reflector --list-countries | more
        return 1
    elif [[ -n "${COUNTRY}" ]] ; then
        line2
        if reflector --verbose -c "${COUNTRY}" -l 10 -p https -f 10 --sort rate --save /etc/pacman.d/mirrorlist ; then
            sleep 0.2
            NC "

==> [${green}${COUNTRY}'s Mirrors OK${nc}] "
        else
            err_try
            return 1
        fi
    fi

        YELLOW "


        >  Enable Pacman's 'Parallel Downloads' feature? [y/n] "
        BLUE "


Enter [y/n]: "
        read -r -p "
==> " parallel
        echo

    if [[ "${parallel}" == "y" ]]; then
        sleep 0.2
        YELLOW "

        >  Select number of Parallel Downloads [2-5] "
        NC "

        ${green}**${nc} [2]

            ${cyan}***${nc} [3]

                ${yellow}****${nc} [4]

                    ${red}*****${nc} [5] "
        BLUE "


Enter a number: "
        read -r -p "
==> " parallelnmbr
        echo

        if [[ "${parallelnmbr}" =~ ^(2|3|4|5)$ ]]; then
            sed -i "s|#ParallelDownloads = 5|ParallelDownloads = ${parallelnmbr}|g" /etc/pacman.conf > /dev/null 2>&1 || err_abort
        else
            invalid
            return 1
        fi
        sleep 0.2
        NC "

==> [${green}${parallelnmbr} Parallel Downloads OK${nc}]"
    elif [[ "${parallel}" == "n" ]]; then
        skip
    else
        y_n
        return 1
    fi
        ok
}
###################################################################################################
pacstrap_system (){

        local prompt="Pacstrap System"
        sleep 0.2
        NC "


${magenta}###${nc}-------------------------------------${magenta}[ ${bwhite}Pacstrap System${nc} ${magenta}]${nc}-------------------------------------${magenta}###${nc}
        "
        cnfg
    if [[ "${bootloader}" == "2" ]]; then
        if [[ "${fs}" == "1" ]]; then
            bootldr_pkgs="efibootmgr grub os-prober"
        elif [[ "${fs}" == "2" ]]; then
            bootldr_pkgs="efibootmgr grub-btrfs os-prober"
        fi
    fi
    if [[ "${vendor}" == "Virtual Machine" ]]; then
        basepkgs="base pkgstats nano sudo vim ${bootldr_pkgs} ${fstools} ${kernel} ${microcode} ${vmpkgs} ${devel} ${zram}"
    elif [[ "${vendor}" == "Nvidia" ]]; then
        basepkgs="base linux-firmware pkgstats nano sudo vim ${bootldr_pkgs} ${fstools} ${kernel} ${kernel}-headers ${microcode} ${vgapkgs} ${wireless_reg} ${devel} ${zram}"
    else
        basepkgs="base linux-firmware pkgstats nano sudo vim ${bootldr_pkgs} ${fstools} ${kernel} ${microcode} ${vgapkgs} ${wireless_reg} ${devel} ${zram}"
    fi
    case "${packages}" in

        1)  # Plasma Desktop:
            deskpkgs="${basepkgs} plasma konsole"
            displaymanager="sddm"
            bluetooth="bluetooth"
            network="NetworkManager" ;;

        2)  # Custom Plasma & Systemd-boot & Optimized System:
            deskpkgs="${basepkgs} alsa-firmware alsa-utils arj ark bluedevil breeze-gtk ccache cups-pdf cups-pk-helper dolphin-plugins e2fsprogs efibootmgr exfatprogs fdkaac ffmpegthumbs firefox git glibc-locales gst-libav gst-plugin-libcamera gst-plugin-msdk gst-plugin-opencv gst-plugin-pipewire gst-plugin-qmlgl gst-plugin-va gst-plugin-wpe gst-plugins-ugly gstreamer-vaapi htop icoutils ipp-usb kamera kamoso kate kcalc kde-gtk-config kdegraphics-mobipocket kdegraphics-thumbnailers kdenetwork-filesharing kdeplasma-addons kdesdk-kio kdesdk-thumbnailers kdialog keditbookmarks kget kimageformats kinit kio-admin kio-gdrive kio-zeroconf kompare konsole kscreen kvantum kwrited libappimage libfido2 libktorrent libmms libnfs libva-utils lirc lrzip lua52-socket lzop mac man-db man-pages mesa-demos mesa-utils mold nano-syntax-highlighting nss-mdns ntfs-3g okular opus-tools p7zip packagekit-qt6 pacman-contrib partitionmanager pbzip2 pdfmixtool pigz pipewire-alsa pipewire-pulse plasma-browser-integration plasma-desktop plasma-disks plasma-firewall plasma-nm plasma-pa plasma-wayland-protocols power-profiles-daemon powerdevil powerline powerline-fonts print-manager python-pyqt6 python-reportlab qbittorrent qt6-imageformats qt6-scxml qt6-virtualkeyboard realtime-privileges reflector rng-tools sddm-kcm skanlite sof-firmware sox spectacle sshfs system-config-printer terminus-font timidity++ ttf-ubuntu-font-family unarchiver unrar unzip usb_modeswitch usbutils vdpauinfo vlc vorbis-tools vorbisgain wget xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-kde xsane zip zsh zsh-autosuggestions zsh-completions zsh-syntax-highlighting ${nrg_plc}" ;;

        3)  # Gnome Desktop:
            deskpkgs="${basepkgs} gnome networkmanager"
            displaymanager="gdm"
            bluetooth="bluetooth"
            network="NetworkManager" ;;

        4)  # Custom Gnome & Systemd-boot & Optimized System:
            deskpkgs="${basepkgs} evince file-roller gdm gnome-calculator gnome-clocks gnome-console gnome-control-center gnome-disk-utility gnome-keyring gnome-menus gnome-session gnome-shell-extensions gnome-shell-extension-appindicator gnome-system-monitor gnome-text-editor gnome-tweaks gvfs gvfs-afc gvfs-mtp loupe malcontent nautilus networkmanager power-profiles-daemon simple-scan sushi system-config-printer xdg-desktop-portal-gnome xdg-user-dirs-gtk alsa-firmware alsa-utils ccache cups-pdf e2fsprogs efibootmgr exfatprogs fdkaac git glib2-devel glibc-locales gnome-browser-connector gparted gst-libav gst-plugin-libcamera gst-plugin-msdk gst-plugin-opencv gst-plugin-pipewire gst-plugin-qmlgl gst-plugin-va gst-plugin-wpe gst-plugins-ugly gstreamer-vaapi htop icoutils ipp-usb libfido2 libva-utils lrzip mac man-db man-pages meld mesa-utils mold nano-syntax-highlighting nss-mdns ntfs-3g p7zip pacman-contrib pbzip2 pdfmixtool pigz pipewire-alsa pipewire-pulse powerline powerline-fonts qbittorrent realtime-privileges reflector rng-tools sof-firmware sox terminus-font ttf-ubuntu-font-family unrar unzip usb_modeswitch usbutils vdpauinfo vlc wget zip zsh zsh-autosuggestions zsh-completions zsh-syntax-highlighting ${nrg_plc}" ;;
            
        5)  # Xfce Desktop:
            deskpkgs="${basepkgs} xfce4 lightdm-gtk-greeter network-manager-applet"
            displaymanager="lightdm"
            network="NetworkManager" ;;

        6)  # Cinnamon Desktop:
            deskpkgs="${basepkgs} cinnamon blueberry lightdm-slick-greeter system-config-printer gnome-keyring ${terminal}"
            displaymanager="lightdm"
            bluetooth="bluetooth"
            network="NetworkManager" ;;

        7)  # Deepin Desktop:
            deskpkgs="${basepkgs} deepin deepin-terminal deepin-kwin networkmanager"
            displaymanager="lightdm"
            network="NetworkManager" ;;

        8)  # Budgie Desktop:
            deskpkgs="${basepkgs} budgie lightdm-gtk-greeter arc-gtk-theme papirus-icon-theme network-manager-applet ${terminal}"
            displaymanager="lightdm"
            network="NetworkManager" ;;

        9)  # Lxqt Desktop:
            deskpkgs="${basepkgs} lxqt breeze-icons network-manager-applet sddm xscreensaver"
            displaymanager="sddm"
            network="NetworkManager" ;;

       10)  # Mate Desktop:
            deskpkgs="${basepkgs} mate mate-terminal mate-media blueman network-manager-applet mate-power-manager system-config-printer lightdm-gtk-greeter"
            displaymanager="lightdm"
            bluetooth="bluetooth"
            network="NetworkManager" ;;

       11) # Base System:
            deskpkgs="${basepkgs} networkmanager"
            network="NetworkManager" ;;

       12) # Custom System:
            if [[ "${vendor}" == "Virtual Machine" ]]; then
                deskpkgs="base sudo ${bootldr_pkgs} ${custompkgs} ${fstools} ${kernel} ${microcode} ${vmpkgs} ${greeter}"
            else
                deskpkgs="base linux-firmware sudo ${bootldr_pkgs} ${custompkgs} ${fstools} ${kernel} ${microcode} ${vgapkgs} ${wireless_reg} ${greeter}"
            fi ;;
    esac
        
    if pacstrap -K -i /mnt ${deskpkgs} ; then
        if [[ "${fs}" == "2"  ]]; then
            genfstab -t PARTUUID /mnt >> /mnt/etc/fstab || err_abort
            sleep 0.2
            NC "

==> [${green}Fstab OK${nc}] "
        fi
        ok
    else
        failure
    fi
}
###################################################################################################
swapfile (){

        local stage_prompt="Swapfile"
        sleep 0.2
        NC "


${magenta}###${nc}-------------------------------------${magenta}[ ${bwhite}Swapfile  Setup${nc} ${magenta}]${nc}-------------------------------------${magenta}###${nc}
        "
    if arch-chroot /mnt <<-SWAP > /dev/null 2>&1 ; then
        mkswap -U clear --size ${swapsize}G --file /swapfile > /dev/null 2>&1 || exit
SWAP
	    cat >> /mnt/etc/fstab <<-FSTAB || err_abort
	        /swapfile none swap defaults 0 0
FSTAB
	    stage_ok
    else
        stage_fail
    fi
}
###################################################################################################
swapfile_btrfs (){

        local stage_prompt="Btfrs Swapfile"
        sleep 0.2
        NC "


${magenta}###${nc}----------------------------------${magenta}[ ${bwhite}Btrfs Swapfile  Setup${nc} ${magenta}]${nc}----------------------------------${magenta}###${nc}
        "
    if arch-chroot /mnt <<-SWAP > /dev/null 2>&1 ; then
        btrfs filesystem mkswapfile --size ${swapsize}g --uuid clear /swap/swapfile > /dev/null 2>&1 || exit
SWAP
        cat >> /mnt/etc/fstab <<-FSTAB || err_abort
            /swap/swapfile none swap defaults 0 0
FSTAB
        stage_ok
    else
        stage_fail
    fi
}
###################################################################################################
wireless_regdom (){

        local stage_prompt="Wireless Regdom"
        sleep 0.2
        NC "


${magenta}###${nc}--------------------------${magenta}[ ${bwhite}Setting Up Wireless Regulatory Domain${nc} ${magenta}]${nc}--------------------------${magenta}###${nc}
        "
    if sed -i "/^#WIRELESS_REGDOM=\"${REGDOM}\"/s/^#//" /mnt/etc/conf.d/wireless-regdom ; then
        stage_ok
    else
        stage_fail
    fi
}
###################################################################################################
btldr_conf (){

    if [[ "${bootloader}" == "1" ]]; then
        cnfg
        local stage_prompt="Systemd-boot"
        if [[ "${espmnt}" == "1" ]]; then
            if arch-chroot /mnt <<-XBOOTCTL > /dev/null 2>&1 ; then
                bootctl --esp-path=/efi --boot-path=/boot install || exit
                echo "default arch.conf" > /boot/loader/loader.conf || exit
                echo "
                title ${entrname}
                linux /vmlinuz-${kernel}
                initrd /initramfs-${kernel}.img
                options rw ${boot_opts}" | tee /boot/loader/entries/arch.conf || exit
                systemctl enable systemd-boot-update || exit
XBOOTCTL
                stage_ok
            else
                stage_fail
            fi
        elif [[ "${espmnt}" == "2" ]]; then
            if arch-chroot /mnt <<-BOOTCTL > /dev/null 2>&1 ; then
                bootctl install || exit
                echo "default arch.conf" > /boot/loader/loader.conf || exit
                echo "
                title ${entrname}
                linux /vmlinuz-${kernel}
                initrd /initramfs-${kernel}.img
                options rw ${boot_opts}" | tee /boot/loader/entries/arch.conf || exit
                systemctl enable systemd-boot-update || exit
BOOTCTL
                stage_ok
            else
                stage_fail
            fi
        fi
    elif [[ "${bootloader}" == "2" ]]; then
        cnfg
        local stage_prompt="Grub"
        if arch-chroot /mnt <<-GRUB > /dev/null 2>&1 ; then
            grub-install --target=x86_64-efi --efi-directory=${btldr_esp_mount} --bootloader-id=GRUB || exit
            sed -i \
            -e 's|^GRUB_CMDLINE_LINUX_DEFAULT.*|GRUB_CMDLINE_LINUX_DEFAULT="${boot_opts}"|g' \
            -e "/^#GRUB_DISABLE_OS_PROBER=false/s/^#//" \
            /etc/default/grub || exit
            grub-mkconfig -o /boot/grub/grub.cfg || exit
GRUB
			stage_ok
		else
			stage_fail
		fi
        if [[ "${fs}" == "2" ]]; then
            cnfg
            local stage_prompt="Grub-Btrfsd"
            if arch-chroot /mnt <<-GRUB_BTRFSD > /dev/null 2>&1 ; then
                systemctl enable grub-btrfsd || exit
GRUB_BTRFSD
				stage_ok
			else
				stage_fail
			fi
        fi
        if [[ "${vgaconf}" == "y" && "${vendor}" == "Nvidia" ]]; then
            cnfg
            local stage_prompt="Grub-Nvidia"
            if arch-chroot /mnt <<-NVIDIA_GRUB > /dev/null 2>&1 ; then
                sed -i "/^#GRUB_TERMINAL_OUTPUT=console/s/^#//" /etc/default/grub || exit
                grub-mkconfig -o /boot/grub/grub.cfg || exit
NVIDIA_GRUB
				stage_ok
			else
				stage_fail
			fi
        fi
    fi
}
###################################################################################################
trim_conf (){

    if [[ -n "${trim}" ]]; then
        cnfg
        local stage_prompt="Trim Service"
        if arch-chroot /mnt <<-TRIM > /dev/null 2>&1 ; then
            systemctl enable ${trim} || exit
TRIM
			stage_ok
		else
			stage_fail
		fi
    fi
}
###################################################################################################
vm_serv_conf (){

    if [[ -n "${vm_services}" ]]; then
        cnfg
        local stage_prompt="VM Service(s)"
        if arch-chroot /mnt <<-VM > /dev/null 2>&1 ; then
            systemctl enable ${vm_services} || exit
VM
			stage_ok
		else
			stage_fail
		fi
    fi
}
###################################################################################################
nvidia_serv_conf (){

    if [[ -n "${nvidia_services}" ]]; then
        cnfg
        local stage_prompt="Nvidia Services"
        if arch-chroot /mnt <<-NVIDIA_SERV > /dev/null 2>&1 ; then
            systemctl enable ${nvidia_services} || exit
NVIDIA_SERV
			stage_ok
		else
			stage_fail
		fi
    fi
}
###################################################################################################
zram_conf (){

    if [[ -n "${zram}" ]]; then
        cnfg
        local stage_prompt="Zram Swap"
        zram_service="systemd-zram-setup@zram0.service"
        if arch-chroot /mnt <<-ZRAM > /dev/null 2>&1 ; then
            mkdir -p /etc/systemd/zram-generator.conf.d
            echo "
            [zram0]
            zram-size = ram / 2
            compression-algorithm = zstd" | tee /etc/systemd/zram-generator.conf.d/zram.conf || exit
            systemctl daemon-reload || exit
            systemctl start ${zram_service} || exit
ZRAM
	        stage_ok
        else
	        stage_fail
        fi
    fi
}
###################################################################################################
nvidia_hook_conf (){

    if [[ "${vgaconf}" == "y" && "${vendor}" == "Nvidia" ]]; then
        if [[ "${kernelnmbr}" == "1" ]] || [[ "${kernelnmbr}" == "2" && "${family}" == "1" ]] || [[ "${kernelnmbr}" == "2" && "${family}" == "2" && "${nvdriver}" == "2" ]]; then
            cnfg
            local stage_prompt="Nvidia-Hook"
        	if arch-chroot /mnt <<-NVIDIA_HOOK > /dev/null 2>&1 ; then
                mkdir -p /etc/pacman.d/hooks/ || exit
                echo "
                [Trigger]
                Operation=Install
                Operation=Upgrade
                Operation=Remove
                Type=Package
                Target=${nvname}
                Target=${kernel}

                [Action]
                Description=Update NVIDIA module in initcpio
                Depends=mkinitcpio
                When=PostTransaction
                NeedsTargets
                Exec=/bin/sh -c 'while read -r trg; do case $trg in linux*) exit 0; esac; done; /usr/bin/mkinitcpio -P' " | tee /etc/pacman.d/hooks/nvidia.hook || exit
NVIDIA_HOOK
				stage_ok
			else
				stage_fail
			fi
        fi
    fi
}
###################################################################################################
main_chroot (){

        stage_prompt="Base System"
    if arch-chroot /mnt <<-CONF > /dev/null 2>&1 ; then
        sed -i "/^#${SETLOCALE}/s/^#//" /etc/locale.gen || exit
        locale-gen || exit
        echo LANG=${SETLOCALE} > /etc/locale.conf || exit
        export LANG=${SETLOCALE} || exit
        echo KEYMAP=${SETKBD} > /etc/vconsole.conf || exit
        echo "
        ${mkinitcpio_mods}
        ${mkinitcpio_hooks}" | tee /etc/mkinitcpio.conf.d/mkinitcpiod.conf || exit
        mkinitcpio -P || exit
        ln -sf /usr/share/zoneinfo/$(curl -s http://ip-api.com/line?fields=timezone) /etc/localtime || exit
        hwclock --systohc || exit
        echo ${HOSTNAME} > /etc/hostname || exit
        echo "
        127.0.0.1 localhost
        ::1 localhost
        127.0.1.1 ${HOSTNAME}.localdomain ${HOSTNAME}" >> /etc/hosts || exit
        echo root:${ROOTPASSWD2} | chpasswd || exit
        useradd -m -G wheel -s /bin/bash ${USERNAME} || exit
        echo ${USERNAME}:${USERPASSWD2} | chpasswd || exit
        echo "%wheel ALL=(ALL) ALL" | tee /etc/sudoers.d/sudoersd || exit
        visudo -c /etc/sudoers.d/sudoersd || exit
CONF
		stage_ok
	else
		stage_fail
	fi
}
###################################################################################################
chroot_conf (){

        sleep 0.2
        NC "


${magenta}###${nc}--------------------------------${magenta}[ ${bwhite}Chroot & Configure System${nc} ${magenta}]${nc}--------------------------------${magenta}###${nc}
        "
    # Linux-Hardened = No Swap
    if [[ "${kernelnmbr}" == "3" ]]; then
        swapmode="4"
    fi

    #### Encrypted Setup Vars
    if [[ "${encrypt}" == "yes" ]]; then
        # Encrypted Root Device
        encr_root_dev="/dev/mapper/${ENCROOT}"
        # Encrypted Root Options
        encr_root_opts="rd.luks.name=$(blkid -s UUID -o value "${root_dev}")=${ENCROOT}"
        # Encrypted Kernel Boot Options
        encr_root_bootopts="root=${encr_root_dev} ${encr_root_opts} "

        ### Encrypted Swap Setup
        ## Encrypted Swap Partition
        if [[ "${swapmode}" == "1" ]]; then
            # Encrypted Swap Partition Options
            encr_swap_opts="rd.luks.name=$(blkid -s UUID -o value "${swap_dev}")=swap"
            # Encrypted Swap Partition Kernel Main Boot Options
            encr_swap_bootopts="resume=/dev/mapper/swap ${encr_swap_opts} "
        ## Encrypted Swapfile
        elif [[ "${swapmode}" == "2" ]]; then
            # Ext4 Offset
            if [[ "${fs}" == "1" ]]; then
                offst="$(filefrag -v /mnt/swapfile | awk '$1=="0:" {print substr($4, 1, length($4)-2)}')"
            # Btrfs Offset
            elif [[ "${fs}" == "2" ]]; then
                offst="$(btrfs inspect-internal map-swapfile -r /mnt/swap/swapfile)"
            fi
            # Encrypted Swapfile Kernel Boot Options
            encr_swap_bootopts="resume=${encr_root_dev} resume_offset=${offst} "
        ## Zram Swap
        elif [[ "${swapmode}" == "3" ]]; then
            # Zram Swap Kernel Boot Options
            zram_bootopts="zswap.enabled=0"
        ## No Swap
        elif [[ "${swapmode}" == "4" ]]; then
            # No Swap Kernel Boot Options
            encr_swap_bootopts=""
        fi

        ### Graphics Setup (Encryption)
        ## Configuration = 'Yes'
        if [[ "${vgaconf}" == "y" ]]; then
            # Intel
            if [[ "${vendor}" == "Intel" ]]; then
                # Mkinitcpio Modules (Encryption)
                mkinitcpio_mods="MODULES=(i915 ${fs_mod})"
                # Mkinitcpio Hooks (Encryption)
                mkinitcpio_hooks="HOOKS=(systemd keyboard autodetect microcode modconf kms sd-vconsole block sd-encrypt filesystems fsck)"
            # Nvidia
            elif [[ "${vendor}" == "Nvidia" ]]; then
                # Mkinitcpio Hooks (Encryption)
                mkinitcpio_hooks="HOOKS=(systemd keyboard autodetect microcode modconf sd-vconsole block sd-encrypt filesystems fsck)"
                # Preserve-Nvidia-Video-Memory after suspend/hibernate/resume
                if [[ ${nvidia_suspend} == "y" ]]; then
                    # Mkinitcpio Modules (Encryption) [No Early Nvidia KMS]
                    mkinitcpio_mods="MODULES=(nvidia_modeset nvidia_uvm nvidia_drm ${fs_mod})"
                    # Nvidia Services
                    nvidia_services="nvidia-suspend nvidia-hibernate nvidia-resume"
                        if [[ ${fs} == "1" ]]; then
                            # Set Custom '/Temp' path
                            vga_bootopts="nvidia_drm.modeset=1 nvidia_drm.fbdev=1 nvidia.NVreg_UsePageAttributeTable=1 nvidia.NVreg_PreserveVideoMemoryAllocations=1 nvidia.NVreg_TemporaryFilePath=/var/tmp "
                        else
                            # Set Default '/Temp' path
                            vga_bootopts="nvidia_drm.modeset=1 nvidia_drm.fbdev=1 nvidia.NVreg_UsePageAttributeTable=1 nvidia.NVreg_PreserveVideoMemoryAllocations=1 "
                        fi
                # No Preserve-Nvidia-Video-Memory after suspend/hibernate/resume
                else
                    # Mkinitcpio Modules (Encryption) [Early Nvidia KMS]
                    mkinitcpio_mods="MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm ${fs_mod})"
                    # Graphics Kernel Boot Options
                    vga_bootopts="nvidia_drm.modeset=1 nvidia_drm.fbdev=1 nvidia.NVreg_UsePageAttributeTable=1  "
                fi
            # Amd
            elif [[ "${vendor}" == "AMD" ]]; then
                # Mkinitcpio Modules (Encryption)
                mkinitcpio_mods="MODULES=(amdgpu radeon ${fs_mod})"
                # Mkinitcpio Hooks (Encryption)
                mkinitcpio_hooks="HOOKS=(systemd keyboard autodetect microcode modconf kms sd-vconsole block sd-encrypt filesystems fsck)"
                # 'Southern Islands' support
                if [[ "${islands}" == "1" ]]; then
                    # Graphics Kernel Boot Options
                    vga_bootopts="radeon.si_support=0 amdgpu.si_support=1 amdgpu.dc=1 "
                # 'Sea Islands' support
                elif [[ "${islands}" == "2" ]]; then
                    # Graphics Kernel Boot Options
                    vga_bootopts="radeon.cik_support=0 amdgpu.cik_support=1 amdgpu.dc=1 "
                elif [[ -z "${islands}" ]]; then
                    # Graphics Kernel Boot Options
                    vga_bootopts="amdgpu.dc=1 "
                fi
            fi
        ## Configuration = 'No'
        elif [[ "${vgaconf}" == "n" ]]; then
            # Mkinitcpio Hooks (Encryption)
        	mkinitcpio_hooks="HOOKS=(systemd keyboard autodetect microcode modconf kms sd-vconsole block sd-encrypt filesystems fsck)"
        	# Nvidia
            if [[ "${vendor}" == "Nvidia" ]]; then
                # Mkinitcpio Modules (Encryption)
                mkinitcpio_mods="MODULES=(${fs_mod} nouveau)"
            # Other Vendors
            else
                # Mkinitcpio Modules (Encryption)
                mkinitcpio_mods="MODULES=(${fs_mod})"
            fi
        fi
        ### Kernel Boot Options (Encryption)
        boot_opts="${encr_root_bootopts}${encr_swap_bootopts}${vga_bootopts}${cust_bootopts}${btrfs_bootopts}${zram_bootopts}"
#-------------------------------------------------------------------------------------------------------------

    #### Unencrypted Setup Vars
    elif [[ "${encrypt}" == "no" ]]; then
        ### Swap Setup
        ## Zram Swap
        if [[ "${swapmode}" == "3" ]]; then
            # Zram Swap Kernel Boot Options
            zram_bootopts="zswap.enabled=0"
        fi
        ### Graphics Setup
        ## Configuration = 'Yes'
        if [[ "${vgaconf}" == "y" ]]; then
            # Intel
            if [[ "${vendor}" == "Intel" ]]; then
                # Mkinitcpio Modules
                mkinitcpio_mods="MODULES=(i915)"
                # Mkinitcpio Hooks
                mkinitcpio_hooks="HOOKS=(systemd autodetect microcode modconf kms keyboard sd-vconsole block filesystems fsck)"
            # Nvidia
            elif [[ "${vendor}" == "Nvidia" ]]; then
                # Mkinitcpio Hooks
                mkinitcpio_hooks="HOOKS=(systemd autodetect microcode modconf keyboard sd-vconsole block filesystems fsck)"
                # Preserve-Nvidia-Video-Memory after suspend/hibernate/resume
                if [[ ${nvidia_suspend} == "y" ]]; then
                    # Mkinitcpio Modules [No Early Nvidia KMS]
                    mkinitcpio_mods="MODULES=(nvidia_modeset nvidia_uvm nvidia_drm)"
                    # Nvidia Services
                    nvidia_services="nvidia-suspend nvidia-hibernate nvidia-resume"
                        if [[ ${fs} == "1" ]]; then
                            # Set Custom '/Temp' path
                            vga_bootopts="nvidia_drm.modeset=1 nvidia_drm.fbdev=1 nvidia.NVreg_UsePageAttributeTable=1 nvidia.NVreg_PreserveVideoMemoryAllocations=1 nvidia.NVreg_TemporaryFilePath=/var/tmp "
                        else
                            # Set Default '/Temp' path
                            vga_bootopts="nvidia_drm.modeset=1 nvidia_drm.fbdev=1 nvidia.NVreg_UsePageAttributeTable=1 nvidia.NVreg_PreserveVideoMemoryAllocations=1 "
                        fi
                # NO Preserve-Nvidia-Video-Memory after suspend/hibernate/resume
                else
                    # Mkinitcpio Modules [Early Nvidia KMS]
                    mkinitcpio_mods="MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)"
                    # Graphics Kernel Boot Options
                    vga_bootopts="nvidia_drm.modeset=1 nvidia_drm.fbdev=1 nvidia.NVreg_UsePageAttributeTable=1  "
                fi
            # Amd
            elif [[ "${vendor}" == "AMD" ]]; then
                # Mkinitcpio Modules
                mkinitcpio_mods="MODULES=(amdgpu radeon)"
                # Mkinitcpio Hooks
                mkinitcpio_hooks="HOOKS=(systemd autodetect microcode modconf kms keyboard sd-vconsole block filesystems fsck)"
                # 'Southern Islands' support
                if [[ "${islands}" == "1" ]]; then
                    # Graphics Kernel Boot Options
                    vga_bootopts="radeon.si_support=0 amdgpu.si_support=1 amdgpu.dc=1 "
                # 'Sea Islands' support
                elif [[ "${islands}" == "2" ]]; then
                    # Graphics Kernel Boot Options
                    vga_bootopts="radeon.cik_support=0 amdgpu.cik_support=1 amdgpu.dc=1 "
                elif [[ -z "${islands}" ]]; then
                    # Graphics Kernel Boot Options
                    vga_bootopts="amdgpu.dc=1 "
                fi
            fi
        ## Configuration = 'No'
        elif [[ "${vgaconf}" == "n" ]]; then
            # Mkinitcpio Hooks
        	mkinitcpio_hooks="HOOKS=(systemd autodetect microcode modconf kms keyboard sd-vconsole block filesystems fsck)"
        	# Nvidia
            if [[ "${vendor}" == "Nvidia" ]]; then
                # Mkinitcpio Modules
                mkinitcpio_mods="MODULES=(nouveau)"
            # Other Vendors
            else
                # Mkinitcpio Modules
                mkinitcpio_mods="MODULES=()"
            fi
        fi
        
        if [[ "${autoroot}" == "y" ]]; then
            ### Kernel Boot Options [Multi-Root Disk] (No Encryption)
            boot_opts="${multiroot_opts}${vga_bootopts}${cust_bootopts}${btrfs_bootopts}${zram_bootopts}"
        else
            ### Kernel Boot Options [Single Root Disk] (No Encryption)
            boot_opts="${vga_bootopts}${cust_bootopts}${btrfs_bootopts}${zram_bootopts}"
        fi
            
    fi
#--------------------------------------------------------------------------------------------------

    # 'Vanilla' Configuration:
    if [[ "${packages}" =~ ^(1|3|5|6|7|8|9|10|11)$ ]]; then
        cnfg
        main_chroot
        if [[ -f /mnt/etc/lightdm/lightdm.conf ]]; then
            cnfg
            if [[ "${packages}" == "7" ]]; then 
                stage_prompt="Deepin Greeter"
                if arch-chroot /mnt <<-DEEPIN > /dev/null 2>&1 ; then
                    sed -i 's|^#greeter-session=example-gtk-gnome|greeter-session=lightdm-deepin-greeter|g' /etc/lightdm/lightdm.conf || exit
DEEPIN
					stage_ok
				else
					stage_fail
				fi
            elif [[ "${packages}" == "5" || "${packages}" == "8" || "${packages}" == "10" ]]; then
                stage_prompt="GTK Greeter"
                if arch-chroot /mnt <<-GTK > /dev/null 2>&1 ; then
                    sed -i 's|^#greeter-session=example-gtk-gnome|greeter-session=lightdm-gtk-greeter|g' /etc/lightdm/lightdm.conf || exit
GTK
					stage_ok
				else
					stage_fail
				fi
            elif [[ "${packages}" == "6" ]]; then
                stage_prompt="Slick Greeter"
                if arch-chroot /mnt <<-SLICK > /dev/null 2>&1 ; then
                    sed -i 's|^#greeter-session=example-gtk-gnome|greeter-session=lightdm-slick-greeter|g' /etc/lightdm/lightdm.conf || exit
SLICK
					stage_ok
				else
					stage_fail
				fi
            fi
        fi
        if [[ -n "${bluetooth}" ]]; then
            cnfg
            stage_prompt="Bluetooth Service"
            if arch-chroot /mnt <<-BLUETOOTH > /dev/null 2>&1 ; then
                systemctl enable ${bluetooth} || exit
BLUETOOTH
				stage_ok
			else
				stage_fail
			fi
        fi
        if [[ -n "${displaymanager}" ]]; then
            cnfg
            stage_prompt="Display Manager Service"
            if arch-chroot /mnt <<-DM_SERVICE > /dev/null 2>&1 ; then
                systemctl enable ${displaymanager} || exit
DM_SERVICE
				stage_ok
			else
				stage_fail
			fi
        fi
        if [[ -n "${network}" ]]; then
            cnfg
            stage_prompt="Network Manager Service"
            if arch-chroot /mnt <<-NETWORK > /dev/null 2>&1 ; then
                systemctl enable ${network} || exit
NETWORK
				stage_ok
			else
				stage_fail
			fi
        fi
        btldr_conf
        trim_conf
        vm_serv_conf
        nvidia_serv_conf
        zram_conf
        nvidia_hook_conf
        completion
    fi
#--------------------------------------------------------------------------------------------------
    # 'Custom System' Configuration:
    if [[ "${packages}" == "12" ]]; then
        cnfg
        main_chroot
        if [[ -f /mnt/etc/lightdm/lightdm.conf ]]; then
            cnfg
        	if [[ "${greeternmbr}" == "1" ]]; then
        	    stage_prompt="GTK Greeter"
                if arch-chroot /mnt <<-GTK > /dev/null 2>&1 ; then
                    sed -i 's|^#greeter-session=example-gtk-gnome|greeter-session=lightdm-gtk-greeter|g' /etc/lightdm/lightdm.conf || exit
GTK
					stage_ok
				else
					stage_fail
				fi
            elif [[ "${greeternmbr}" == "2" ]]; then
                stage_prompt="Slick Greeter"
                if arch-chroot /mnt <<-SLICK > /dev/null 2>&1 ; then
                    sed -i 's|^#greeter-session=example-gtk-gnome|greeter-session=lightdm-slick-greeter|g' /etc/lightdm/lightdm.conf || exit
SLICK
					stage_ok
				else
					stage_fail
				fi
            elif [[ "${greeternmbr}" == "3" ]]; then
                stage_prompt="Deepin Greeter"
                if arch-chroot /mnt <<-DEEPIN > /dev/null 2>&1 ; then
                    sed -i 's|^#greeter-session=example-gtk-gnome|greeter-session=lightdm-deepin-greeter|g' /etc/lightdm/lightdm.conf || exit
DEEPIN
					stage_ok
				else
					stage_fail
				fi
            fi
        fi
        if [[ -n "${customservices}" ]]; then
            cnfg
            stage_prompt="Custom Service(s)"
            if arch-chroot /mnt <<-CUSTOM_SERV > /dev/null 2>&1 ; then
                systemctl enable ${customservices} || exit
CUSTOM_SERV
				stage_ok
			else
				stage_fail
			fi
        fi
        btldr_conf
        trim_conf
        vm_serv_conf
        nvidia_serv_conf
        zram_conf
        nvidia_hook_conf
        completion
    fi
#--------------------------------------------------------------------------------------------------
    # Plasma / Gnome & Systemd-boot Optimized System Configuration:
    if [[ "${packages}" == "2" || "${packages}" == "4" ]]; then
        stage_prompt="Custom System"
        cnfg
        if [[ "${packages}" == "2" ]]; then
            displaymanager="sddm"
        elif [[ "${packages}" == "4" ]]; then
            displaymanager="gdm"
        fi
        if [[ -n "${nrg_plc}" ]]; then
            arch-chroot /mnt <<-NRG > /dev/null 2>&1
            ${nrg_plc} performance
NRG
        fi
        if arch-chroot /mnt <<-CUSTOM_CONF > /dev/null 2>&1 ; then
            sed -i "/^#${SETLOCALE}/s/^#//" /etc/locale.gen || exit
            locale-gen || exit
            echo LANG=${SETLOCALE} > /etc/locale.conf || exit
            export LANG=${SETLOCALE} || exit
            echo KEYMAP=${SETKBD} > /etc/vconsole.conf || exit
            sed -i "/^#Color/s/^#//" /etc/pacman.conf || exit
            update-pciids || exit
            echo '
            ${mkinitcpio_mods}
            ${mkinitcpio_hooks}
            COMPRESSION="zstd"
            COMPRESSION_OPTIONS=(-c -T$(nproc) --auto-threads=logical -)
            MODULES_DECOMPRESS="yes"' | tee /etc/mkinitcpio.conf.d/mkinitcpiod.conf || exit
            mkinitcpio -P || exit
		    echo '
		    CFLAGS="-march=native -O2 -pipe -fno-plt -fexceptions -Wp,-D_FORTIFY_SOURCE=3 -Wformat -Werror=format-security -fstack-clash-protection -fcf-protection -fno-omit-frame-pointer -mno-omit-leaf-frame-pointer"
            LDFLAGS="-Wl,-O1 -Wl,--sort-common -Wl,--as-needed -Wl,-z,relro -Wl,-z,now -Wl,-z,pack-relative-relocs,-fuse-ld=mold"
	        RUSTFLAGS="-C force-frame-pointers=yes -C opt-level=3 -C target-cpu=native -C link-arg=-fuse-ld=mold"
	        MAKEFLAGS="-j$(nproc)"
	        BUILDENV=(!distcc color ccache check !sign)
	        OPTIONS=(strip docs !libtool !staticlibs emptydirs zipman purge !debug lto)
	        COMPRESSGZ=(pigz -c -f -n)
	        COMPRESSBZ2=(pbzip2 -c -f)
	        COMPRESSZST=(zstd -c -T0 --auto-threads=logical -)' | tee /etc/makepkg.conf.d/makepkgd.conf || exit
            ln -sf /usr/share/zoneinfo/$(curl -s http://ip-api.com/line?fields=timezone) /etc/localtime || exit
            hwclock --systohc || exit
            echo ${HOSTNAME} > /etc/hostname || exit
            echo "
            127.0.0.1 localhost
            ::1 localhost
            127.0.1.1 ${HOSTNAME}.localdomain ${HOSTNAME}" >> /etc/hosts || exit
            echo "
            net.core.netdev_max_backlog = 16384
            net.core.somaxconn = 8192
            net.core.rmem_default = 1048576
            net.core.rmem_max = 16777216
            net.core.wmem_default = 1048576
            net.core.wmem_max = 16777216
            net.core.optmem_max = 65536
            net.ipv4.tcp_rmem = 4096 1048576 2097152
            net.ipv4.tcp_wmem = 4096 65536 16777216
            net.ipv4.udp_rmem_min = 8192
            net.ipv4.udp_wmem_min = 8192
            net.ipv4.tcp_fastopen = 3
            net.ipv4.tcp_max_syn_backlog = 8192
            net.ipv4.tcp_max_tw_buckets = 2000000
            net.ipv4.tcp_tw_reuse = 1
            net.ipv4.tcp_fin_timeout = 10
            net.ipv4.tcp_slow_start_after_idle = 0
            net.ipv4.tcp_keepalive_time = 60
            net.ipv4.tcp_keepalive_intvl = 10
            net.ipv4.tcp_keepalive_probes = 6
            net.ipv4.tcp_mtu_probing = 1
            net.ipv4.tcp_sack = 1
            net.core.default_qdisc = cake
            net.ipv4.tcp_congestion_control = bbr
            net.ipv4.ip_local_port_range = 30000 65535
            net.ipv4.conf.default.rp_filter = 1
            net.ipv4.conf.all.rp_filter = 1
            vm.vfs_cache_pressure = 50
            vm.mmap_min_addr = 65536
            kernel.printk = 0 0 0 0
            ${perf_stream}" | tee /etc/sysctl.d/99-sysctld.conf || exit
            echo "
            [defaults]
            ntfs:ntfs3_defaults=uid=1000,gid=1000,windows_names
            ntfs:ntfs3_allow=uid=1000,gid=1000,umask,dmask,fmask,iocharset,discard,nodiscard,sparse,nosparse,hidden,nohidden,sys_immutable,nosys_immutable,showmeta,noshowmeta,prealloc,noprealloc,hide_dot_files,nohide_dot_files,windows_names,nocase,case" | tee /etc/udisks2/mount_options.conf || exit
            echo '
            // Original rules: https://github.com/coldfix/udiskie/wiki/Permissions
            // Changes: Added org.freedesktop.udisks2.filesystem-mount-system, as this is used by Dolphin.
            polkit.addRule(function(action, subject) {
            var YES = polkit.Result.YES;
            var permission = {
                // required for udisks1:
                "org.freedesktop.udisks.filesystem-mount": YES,
                "org.freedesktop.udisks.luks-unlock": YES,
                "org.freedesktop.udisks.drive-eject": YES,
                "org.freedesktop.udisks.drive-detach": YES,
                // required for udisks2:
                "org.freedesktop.udisks2.filesystem-mount": YES,
                "org.freedesktop.udisks2.encrypted-unlock": YES,
                "org.freedesktop.udisks2.eject-media": YES,
                "org.freedesktop.udisks2.power-off-drive": YES,
                // Dolphin specific:
                "org.freedesktop.udisks2.filesystem-mount-system": YES,
                // required for udisks2 if using udiskie from another seat (e.g. systemd):
                "org.freedesktop.udisks2.filesystem-mount-other-seat": YES,
                "org.freedesktop.udisks2.filesystem-unmount-others": YES,
                "org.freedesktop.udisks2.encrypted-unlock-other-seat": YES,
                "org.freedesktop.udisks2.encrypted-unlock-system": YES,
                "org.freedesktop.udisks2.eject-media-other-seat": YES,
                "org.freedesktop.udisks2.power-off-drive-other-seat": YES
            };
            if (subject.isInGroup("wheel")) {
                return permission[action.id];
            }
            });' | tee /etc/polkit-1/rules.d/99-udisks2.rules || exit
            mkdir -p /etc/systemd/journald.conf.d > /dev/null 2>&1 || exit
            echo "
            [Journal]
            SystemMaxUse=100M" | tee /etc/systemd/journald.conf.d/00-journald.conf || exit
            mkdir -p /etc/systemd/user.conf.d > /dev/null 2>&1 || exit
            echo "
            [Manager]
            DefaultTimeoutStopSec=5s
            DefaultTimeoutAbortSec=5s" | tee /etc/systemd/user.conf.d/00-userd.conf || exit
            sed -i 's|^hosts.*|hosts: mymachines mdns_minimal resolve [!UNAVAIL=return] files myhostname dns|g' /etc/nsswitch.conf || exit
            sed -i 's/ interface = [^ ]*/ interface = all/g' /etc/ipp-usb/ipp-usb.conf || exit
            sed -i "/# set linenumbers/"'s/^#//' /etc/nanorc || exit
            echo tcp_bbr | tee /etc/modules-load.d/modulesd.conf || exit
            echo "
            country=${REGDOM}
            wps_cred_add_sae=1
            pmf=2" | tee /etc/wpa_supplicant/wpa_supplicant.conf || exit
            bootctl install || exit
            echo "default arch.conf" > /boot/loader/loader.conf || exit
            echo "
            title ${entrname}
            linux /vmlinuz-${kernel}
            initrd /initramfs-${kernel}.img
            options rw ${boot_opts}" | tee /boot/loader/entries/arch.conf || exit
            echo root:${ROOTPASSWD2} | chpasswd || exit
            chsh -s /bin/zsh || exit
            useradd -m -G wheel,realtime -s /bin/zsh ${USERNAME} || exit
            echo ${USERNAME}:${USERPASSWD2} | chpasswd || exit
            echo "
            Defaults pwfeedback
            Defaults editor=/usr/bin/nano
            %wheel ALL=(ALL) ALL" | tee /etc/sudoers.d/sudoersd || exit
            visudo -c /etc/sudoers.d/sudoersd || exit
            systemctl enable avahi-daemon bluetooth cups ipp-usb NetworkManager rngd systemd-boot-update ${displaymanager} ${trim} ${vm_services} ${nvidia_services} || exit
CUSTOM_CONF
			stage_ok
		else
            stage_fail
		fi
        zram_conf
        nvidia_hook_conf
        completion
    fi
        umount -R /mnt
        exit
}
# END FUNCTIONS
###################################################################################################

        run_as="$(whoami)"
        tty="$(tty)"
        disks="$(lsblk --nodeps --paths --noheadings --output=name,size,model | cat --number)"
        LOCALESET=""
        SETLOCALE=""
        lcl_slct=""
        USERNAME=""
        kernelnmbr=""
        fs=""
        vgaconf=""
        vga_setup=""
        vendor1=""
        vendor2=""
        vendor3=""
        vendor_slct=""
        packages=""
        efi_entr_del=""
        wrlss_rgd=""
        sanity=""
        install=""
        bootldr_pkgs=""
        devel=""
        REGDOM=""
        vga_bootopts=""
        btrfs_bootopts=""
        trim=""
        swapmode=""
        homecrypt=""
        greeter=""
        revision=""
        greeternmbr=""
        cust_bootopts=""
        bluetooth=""
        vmpkgs=""
        vm_services=""
        perf_stream=""
		displaymanager=""
		wireless_reg=""
		bootmode=""
		trg=""
		s=""
		bootloader=""
		vga_slct=""
		nvidia_services=""
		nvidia_suspend=""
		autoroot=""
		autoesp=""
		autoxboot=""
		autohome=""
		autoswap=""
		espsize=""
		rootprt=""
		espprt=""
		xbootprt=""
		homeprt=""
		swapprt=""
		smartpart=""
		partok=""
		use_manpreset=""
		instl_drive=""
		sgdsk_nmbr=""
		part_mode=""
		preset=""
		capacity=""
		cap_gib=""
		rootsize=""
		sgdrive=""
		cgdrive=""
		sep_home=""
		autopart=""
		prcnt=""
		roottype=""
		stage_prompt=""
		zram=""
		zram_bootopts=""
		xbootloader=""
		multibooting=""
		hypervisor=""
		mkinitcpio_mods=""

        clear
        first_check
        sleep 0.2
        line3
        CYANBG "************************************************************************************************* "
        CYANBG "                                                                                                  "
        CYANBG "                                 ###     Amelia Installer     ###                                 "
        CYANBG "                                                                                                  "
        CYANBG "************************************************************************************************* "
        NC "








                                        ${bwhite}Press any key to start${nc} "
        read -r -s -n 1
        clear
        arch
        uefi_check
        connection_check
        upd_clock
        dtct_microcode
        until main_menu; do : ; done
