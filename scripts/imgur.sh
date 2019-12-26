#!/bin/bash
#
################### imgur.sh ###########################################
# Take screenshots and upload them to Imgur.
# This can be to an existing account, or anonymously.
#
# Credentials and access token for an account can be set up.
#
# Settings (settings.conf) and credentials (credentials.conf}) files are created in \
# $HOME/.config/imgur/
#
# The script returns BB-Code for the direct image link, and a linked thumbnail.
# YAD dialogs are used for user interaction.
#
# Kudos to the writer of the script at https://github.com/jomo/imgur-screenshot,
# which has provided most of the OAuth2 and Imgur API functions adapted here.
# ("imgur-screenshot" is featured in https://imgur.com/tools.)
########################################################################
# Copyright (C) 2019 damo   <damo@bunsenlabs.org>
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#######################################################################
#
### REQUIRES:  yad, jq, xprop, wmctrl, wget, curl, scrot, gio(in gvfs package)
#
########################################################################
BL_COMMON_LIBDIR='/usr/lib/bunsen/common'
USR_CFG_DIR="$HOME/.config/imgur"
CREDENTIALS_FILE="${USR_CFG_DIR}/credentials.conf"
SETTINGS_FILE="${USR_CFG_DIR}/settings.conf"
SCRIPT=$(basename "$0")
#IMG_VIEWER="x-www-browser" && export IMG_VIEWER   # used by show_image()

#### YAD ###
DIALOG="yad --center --borders=20 --window-icon=distributor-logo-bunsenlabs --fixed"
TITLE="--title=Image BBCode"
T="--text="
DELETE="--button=Delete:2"
CLOSE="--button=gtk-close:1"
CANCEL="--button=gtk-cancel:1"
OK="--button=OK:0"
### USAGE ###
read -d '' USAGE <<EOF
  imgur.sh [option]... [file]...

  With no script args, ${SCRIPT} will upload a screenshot of
  the full desktop, as anonymous user
  
  -h, --help                   Show this help, exit
  -l, --login                  Upload to Imgur account
  -c, --connect                Show connected Imgur account, exit
  -s, --select                 Take screenshot in select mode
  -w, --window                 Take screenshot in active window mode
  -f, --full                   Take screenshot in full desktop mode
  -d, --delay <seconds>        Delay in integer seconds, before taking screenshot
  -a, --album <album_title>    Upload to specified album
  -t, --title <image title>    Label uploaded image
  --file  <filepath/filename>  Upload specified image. Overrides scrot options
  
  The final dialog displays forum BB-Code for both the direct image link and
  the linked image thumbnail. These can be copy/pasted as desired.

  Options to delete uploaded and/or local screenshot images before exiting script.

EOF

### required programs ###
declare -a APPS
APPS=( "yad" "xprop" "wmctrl" "wget" "curl" "scrot" "gio" )

### FUNCTIONS  #########################################################
### Get script args ###
function getargs(){
    if (( $# == 0 ));then               # no args, so run with anonymous, full desktop scrot
        echo -e "\n\tAnonymous upload\n"
        AUTH_MODE="A"
        SCROT="${SCREENSHOT_FULL_COMMAND}"
    fi
    while [[ ${#} != 0 ]]; do
        case "$1" in
            -h | --help)    echo -e "\n${USAGE}\n"
                            exit 0
                            ;;
            -l | --login)   ID="${CLIENT_ID}" # run as auth user; username set in settings.conf
                            AUTH="Authorization: Bearer ${ACCESS_TOKEN}"  # in curl command
                            AUTH_MODE="L"
                            ;;
            -c | --connect) ID="${CLIENT_ID}"
                            AUTH_MODE="L"
                            load_access_token "${ID}"
                            fetch_account_info
                            exit 0
                            ;;
            -s | --select)  SCROT="${SCREENSHOT_SELECT_COMMAND}"
                            ;;
            -w | --window)  SCROT="${SCREENSHOT_WINDOW_COMMAND}"
                            ;;
            -f | --full)    SCROT="${SCREENSHOT_FULL_COMMAND}"
                            ;;
            -d | --delay)   if [[ $2 != ?(-)+([0-9]) ]];then
                                message="\n\tDelay value must be an integer\n\tExiting script...\n"
                                echo -e "${message}"
                                yad_error "${message}"
                                exit 1
                            else
                                DELAY="$2"
                            fi
                            shift
                            ;;
            -a | --album)   ALBUM_TITLE="$2"    # override settings.conf
                            shift
                            ;;
            -t | --title)   IMG_TITLE="$2"
                            shift
                            ;;
            --file)         FNAME="$2"
                            shift
                            F_FLAG=1
                            ;;
                         *) message="\n\tFailed to parse options\n\tExiting script...\n"
                            echo -e "${message}" >&2
                            yad_error "${message}"
                            exit 1
                            ;;
        esac || { echo "Failed to parse options" >&2 && exit 1; }
        shift
    done
}
### Check required programs are installed ###
function check_required(){
    local message
    declare -a BAD_APPS # array to hold missing commands
    APPS+=( "${IMG_VIEWER}" )

    for app in "${APPS[@]}";do
        if type "${app}" >/dev/null 2>&1;then
            continue
        else
            echo >&2 "${app} not installed."
            BAD_APPS+=( "${app}" )
        fi
    done
    if (( ${#BAD_APPS[@]} > 0 ));then
        message="\n  You need to install\n"
        for app in "${BAD_APPS[@]}";do
            message="${message}  "\'"${app}"\'","
        done
        message="${message}\n  before proceeding.\n"
        echo -e "${message}"
        yad_error "${message}"
        exit
    fi
}
### Initialize settings.conf config  ###
function settings_conf(){
    ! [[ -d "${USR_CFG_DIR}" ]] && mkdir -p "${USR_CFG_DIR}" 2>/dev/null

    if ! [[ -f "${SETTINGS_FILE}" ]] 2>/dev/null;then
        touch "${SETTINGS_FILE}" && chmod 600 "${SETTINGS_FILE}"
        cat <<EOF > "${SETTINGS_FILE}"
### IMGUR SCREENSHOT DEFAULT CONFIG ####
### Read by ${SCRIPT} ###################
# Most of these settings can be overridden with script args

# Imgur settings
ANON_ID="ea6c0ef2987808e"
CLIENT_ID=""
CLIENT_SECRET=""
USER_NAME=""
ALBUM_TITLE=""
IMGUR_ICON_PATH=""
IMG_VIEWER="bl-image-viewer"

# Local file settings
# User directory to save image:
FILE_DIR="$(xdg-user-dir PICTURES)"
FILE_NAME="imgur-%Y_%m_%d-%H:%M:%S"
# possible formats are png | jpg | tiff | gif
# Max size is 20MB; PNG > 5MB will be converted to JPEG
FILE_FORMAT="png"   

# Screenshot scrot commands
SCREENSHOT_SELECT_COMMAND="scrot -s "
SCREENSHOT_WINDOW_COMMAND="scrot -u -b "
SCREENSHOT_FULL_COMMAND="scrot "

EOF
    fi
source "${SETTINGS_FILE}"
}
### File and Image functions ###
function getimage(){
    local message ret
    
    [[ ${AUTH_MODE} = "A" ]] && ANON="Anonymous "
    if ! [[ -z ${DELAY} ]] 2>/dev/null && ! [[ ${SCROT} == "${SCREENSHOT_SELECT_COMMAND}" ]] 2>/dev/null;then
        SCROT="${SCROT} -d ${DELAY} "
        message="\n\tNo image file provided...\n\tProceed with ${ANON}screenshot?\n \
        \n\tThere will be a pause of ${DELAY}s, to select windows etc\n"
    else
        SCROT="${SCROT} -d 1 "   # need a pause so YAD dialog can leave the scene
        message="\n\tNo image file provided...\n\tProceed with ${ANON}screenshot?\n"
    fi

    if [[ -z "$1" ]] 2>/dev/null; then
        yad_common_args+=("--image=dialog-question")
        yad_question "${message}"
        ret="$?"
        yad_common_args+=("--image=0")
        if (( ret == 1 ));then
            exit 0
        elif (( ret == 0 )) && [[ ${SCROT} == *"-s"* ]];then    # scrot command contains "-s" to select area
            yad_common_args+=("--image=dialog-info")
            yad_info "\n\tDrag cursor to select area for screenshot\n"
        elif (( ret == 0 )) && [[ ${SCROT} == *"-u"* ]];then            # scrot command contains "-u" 
            yad_info "\n\tSelect window to be Active, then click 'OK'\n" #for active window
        fi
        yad_common_args+=("--image=0")
        # new filename with date
        img_file="$(date +"${FILE_NAME}.${FILE_FORMAT}")"
        img_file="${FILE_DIR}/${img_file}"
        take_screenshot "${img_file}"
    else
        # upload file instead of screenshot
        img_file="$1"
    fi
    
    # check if file exists
    if ! [[ -f "${img_file}" ]] 2>/dev/null; then
        message="\n\tfile '${img_file}' doesn't exist!\n\n\tExiting script...\n"
        echo -e "${message}"
        yad_error "${message}"
        exit 1
    fi
}

function delete_image() {
    local message response
    
    response="$(curl --compressed -X DELETE  -fsSL --stderr - -H "${AUTH}" \
    "https://api.imgur.com/3/image/$1")"
    if (( $? == 0 )) && [[ $(jq -r .success <<< ${response}) == "true" ]]; then
        message="\n\tUploaded image successfully deleted.\n\n\tdelete hash: $1\n"
        yad_common_args+=("--image=dialog-info")
        yad_info "${message}"
        yad_common_args+=("--image=0")
    else
        message="\n\tThe image could not be deleted:\n\t${response}.\n"
        yad_error "${message}"
    fi
    echo -e "${message}"
    delete_local
}

function delete_local(){
    local message ret
    
    if (( F_FLAG == 1));then    # local file was uploaded
        message="\n\tMove local uploaded image to 'Trash'?\n\n\t${img_file}\n"
    else
        message="\n\tMove local screenshot image to 'Trash'?\n\n\t${img_file}\n"
    fi
    yad_common_args+=("--image=dialog-question")
    yad_question "${message}"
    ret="$?"
    yad_common_args+=("--image=0")
    if (( ret == 0 )); then
        if type "/usr/bin/gio" > /dev/null;then # 'gio' is part of 'gvfs' package
            gio trash "${img_file}"
        else
            rm "${img_file}"
        fi
    fi
}

function take_screenshot() {
    local cmd_scrot shot_err message
    
    cmd_scrot="${SCROT}$1"
    shot_err="$(${cmd_scrot} &>/dev/null)" #takes a screenshot
    if [ "$?" != "0" ]; then
        message="\n\tFailed to take screenshot of\n\t'$1':\n\n\tError: '${shot_err}'"
        echo -e "${message}"
        yad_error "${message}"
        exit 1
    fi
}

function show_image(){  # display image using viewer set in settings.conf
    # if image viewer not set, then default to browser
    [[ -z "${IMG_VIEWER}" ]] && IMG_VIEWER="x-www-browser"
    ${IMG_VIEWER} "$img_link"
    switch_to_active
}
### END Image Functions ################################################

### OAuth Credentials Functions ########################################
### Adapted from https://github.com/jomo/imgur-screenshot ##############

function check_oauth2_client_secrets() {
    local message dlg ret

    if [ -z "${CLIENT_ID}" ] || [ -z "${CLIENT_SECRET}" ]; then
        message='
            Your CLIENT_ID and CLIENT_SECRET are not set.
            
            You need to register an imgur application at:
            https://api.imgur.com/oauth2/addclient
        '
        dlg=$(${DIALOG} "${TITLE}" ${T}"${message}" --button="Get Credentials:0" ${CLOSE}) 2>/dev/null
        ret=$?
        (( ret == 0 )) && get_oauth2_client_secrets || exit 1
    fi
}

function get_oauth2_client_secrets(){
    #url = "https://api.imgur.com/oauth2/addclient"
    local message dlg ans dlg_msg dlg_err
    
    message='
        Your CLIENT_ID and CLIENT_SECRET are not set.
        To register an imgur application:

        1: "Run browser"
        2: Select "OAuth 2 authorization without a callback url" and fill out the form.
        3: Then, set the CLIENT_ID and CLIENT_SECRET in your settings.conf,
           or paste them in the fields below, and click "OK"
    '
    dlg=$(${DIALOG} --form --image=dialog-question --image-on-top \
    --title="Get Imgur authorization" --text="${message}" \
    --fixed --center --borders=20 \
    --sticky --on-top \
    --width=650 \
    --field="Client ID:" --field="Client Secret:" "" "" \
    --button="Run browser":"/bin/bash -c 'run_browser addclient'" \
    ${OK} ${CANCEL}
    ) 2>/dev/null
    ans="$?"
    [[ ${ans} == 1 ]] && exit 0
    C_ID="$(echo ${dlg} | awk -F '|' '{print $1}')" # 'pipe' separators
    C_SECRET="$(echo ${dlg} | awk -F '|' '{print $2}')"
    
    # check returned values
    if [[ -z "${C_ID}" ]] || (( ${#C_ID} != 15 )) || ! [[ ${C_ID} =~ ^[a-fA-F0-9]+$ ]];then
        err_msg_1="Client ID is wrong!"
    fi
    if [[ -z "${C_ID}" ]] || (( ${#C_SECRET} != 40 )) || ! [[ ${C_SECRET} =~ ^[a-fA-F0-9]+$ ]];then
        err_msg_2="Client Secret is wrong!"
    fi
    if [[ ${err_msg_1} ]] || [[ ${err_msg_2} ]]; then
        dlg_msg="\n${err_msg_1}\n${err_msg_2}\n\nTry again or Exit script?\n"
        dlg_err=$(${DIALOG} --text="${dlg_msg}" --undecorated \
        --image="dialog-question" --button="Exit:1" ${OK}) 2>/dev/null
        ans=$?
        if (( ans == 0 )); then
            get_oauth2_client_secrets
        else
            exit
        fi
    fi

    # write credentials to settings.conf
    # sed: change line containing <string> to <stringvar>
    C_ID_LINE="CLIENT_ID="\""${C_ID}\""
    C_SECRET_LINE="CLIENT_SECRET="\""${C_SECRET}\""
    sed -i "s/^CLIENT_ID.*/${C_ID_LINE}/" "${SETTINGS_FILE}"
    sed -i "s/^CLIENT_SECRET.*/${C_SECRET_LINE}/" "${SETTINGS_FILE}"
    source "${SETTINGS_FILE}"
}

function load_access_token() {
    local CURRENT_TIME PREEMPTIVE_REFRESH_TIME EXPIRED
    TOKEN_EXPIRE_TIME=0
    ID="$1"     # CLIENT_ID

    if [[ ${ID} == "${ANON_ID}" ]];then # user has used '-l' or '-c' args, without credentials
        message="\n\tSorry, you need to Register an Imgur account\n\tbefore being able to log in!\n"
        echo -e "${message}"
        yad_error "${message}" #&& exit
        get_oauth2_client_secrets
    else
        AUTH_MODE="L"
    fi 
    # check for saved ACCESS_TOKEN and its expiration date
    if [[ -f "${CREDENTIALS_FILE}" ]] 2>/dev/null; then
        source "${CREDENTIALS_FILE}"
    else
        acquire_access_token "${CLIENT_ID}"
        save_access_token
    fi
    if [[ ! -z "${REFRESH_TOKEN}" ]] 2>/dev/null; then    # token already set
        CURRENT_TIME="$(date +%s)"
        PREEMPTIVE_REFRESH_TIME="600" # 10 minutes
        EXPIRED=$((CURRENT_TIME > (TOKEN_EXPIRE_TIME - PREEMPTIVE_REFRESH_TIME)))
        if [[ ${EXPIRED} == "1" ]]; then      # token expired
            refresh_access_token
        fi
    else
        acquire_access_token "${CLIENT_ID}"
        save_access_token
    fi
}

function acquire_access_token() {
    local URL PARAMS PARAM_NAME PARAM_VALUE message ans ret cmd
    local ID="$1"
    read -d '' message <<EOF
You need to authorize ${SCRIPT} to upload images.

To grant access to this application visit the link below, by clicking "Run browser".

"https://api.imgur.com/oauth2/authorize?client_id=${ID}&amp;response_type=token"

Then copy and paste the URL from your browser. 
It should look like "https://imgur.com/#access_token=..."

EOF
    # need to expand variable in dialog
    cmd="$(printf '/bin/bash -c "run_browser token %s"' "${ID}")"
    
    ret=$($DIALOG --form --image=dialog-info --image-on-top \
    --title="Get Imgur authorization" --text="${message}" \
    --fixed --sticky --on-top --center --borders=20 \
    --width=650  \
    --field="Paste here: " "" \
    --button="Run browser":"${cmd}" \
    --button="Save token:0" ${CANCEL}
    )
    ans="$?"
    [[ ${ans} == 1 ]] && exit 0
    URL="${ret:0:-1}"   # cut 'pipe' char from end of string
    if ! [[ ${URL} =~ "access_token=" ]] 2>/dev/null; then
        message="\n\tERROR: That URL doesn't look right, please start script again\n"
        yad_error "${message}"
        exit 1
    fi
    URL="$(echo "${URL}" | cut -d "#" -f 2-)"   # remove leading 'https://imgur.com/#'
    PARAMS=("${URL//&/ }")                      # add remaining sections to array
    
    for param in "${PARAMS[@]}"; do
        PARAM_NAME="$(echo "${param}" | cut -d "=" -f 1)"
        PARAM_VALUE="$(echo "${param}" | cut -d "=" -f 2-)"
        
        case "${PARAM_NAME}" in
            access_token)   ACCESS_TOKEN="${PARAM_VALUE}"
                            ;;
            refresh_token)  REFRESH_TOKEN="${PARAM_VALUE}"
                            ;;
            expires_in)     TOKEN_EXPIRE_TIME=$(( $(date +%s) + PARAM_VALUE ))
                            ;;
        esac
    done
    if [[ -z "${ACCESS_TOKEN}" ]] || [[ -z "${REFRESH_TOKEN}" ]] || [[ -z "${TOKEN_EXPIRE_TIME}" ]]; then
        message="\n\tERROR: Failed parsing the URL.\n\n\tDid you copy the full URL?\n"
        yad_error "${message}"
        exit 1
    fi
    save_access_token
    AUTH="Authorization: Bearer ${ACCESS_TOKEN}"
}

function save_access_token() {
    # create dir if not exist
    mkdir -p "$(dirname "${CREDENTIALS_FILE}")" 2>/dev/null
    touch "${CREDENTIALS_FILE}" && chmod 600 "${CREDENTIALS_FILE}"
    cat <<EOF > "${CREDENTIALS_FILE}"
# This file is generated by ${SCRIPT}
# Do not modify it here - it will be overwritten
ACCESS_TOKEN="${ACCESS_TOKEN}"
REFRESH_TOKEN="${REFRESH_TOKEN}"
TOKEN_EXPIRE_TIME="${TOKEN_EXPIRE_TIME}"
EOF
}

function refresh_access_token() {
    local TOKEN_URL EXPIRES_IN response
    
    echo -e "\nRefreshing access token..."
    TOKEN_URL="https://api.imgur.com/oauth2/token"
    # exchange the refresh token for ACCESS_TOKEN and REFRESH_TOKEN
    response="$(curl --compressed -fsSL --stderr - -F "client_id=${ID}" \
    -F "client_secret=${CLIENT_SECRET}" -F "grant_type=refresh_token" \
    -F "refresh_token=${REFRESH_TOKEN}" "${TOKEN_URL}")"
    if [ ! "${?}" -eq "0" ]; then       # curl failed
        handle_upload_error "${response}" "${TOKEN_URL}"
        exit 1
    fi
    
    if ! jq -re .access_token >/dev/null <<<"${response}"; then
        # server did not send access_token
        echo -e "\nError: Something is wrong with your credentials:"
        echo "${response}"
        exit 1
    fi
    
    ACCESS_TOKEN="$(jq -r .access_token <<<"${response}")"
    REFRESH_TOKEN="$(jq -r .refresh_token <<<"${response}")"
    EXPIRES_IN="$(jq -r .expires_in <<<"${response}")"
    TOKEN_EXPIRE_TIME=$(( $(date +%s) + EXPIRES_IN ))
    save_access_token
}

function fetch_account_info() {
    local response username message
    yad_common_args+=("--image=dialog-info")
    
    response="$(curl -sH "Authorization: Bearer ${ACCESS_TOKEN}" https://api.imgur.com/3/account/me)"
    if (( $? == 0 )) && [[ $(jq -r .success <<<"${response}") = "true" ]]; then
        username="$(jq -r .data.url <<<"${response}")"
        message="\n\tLogged in as ${username}. \
        \n\n\thttps://${username,,}.imgur.com\n"
        echo -e "${message}"
        yad_info "${message}"
    else
        message="\n\tFailed to fetch info: ${response}\n"
        echo -e "${message}"
        yad_info "${message}"
    fi
    yad_common_args+=("--image=0")
}

function run_browser(){     # run browser with API url, and switch to attention-seeking browser tab
    local api_call="$1"     # function called from button in dialog
    local ID_arg="$2"
    [[ ${api_call} = "addclient" ]] && api_url="https://api.imgur.com/oauth2/addclient"
    [[ ${api_call} = "token" ]] && \
    api_url="https://api.imgur.com/oauth2/authorize?client_id=${ID_arg}&response_type=token"

    x-www-browser "${api_url}" 2>/dev/null
    switch_to_active
}

function switch_to_active(){   # switch to new browser tab
    local id
    for id in $(wmctrl -l | awk '{ print $1 }'); do
        # filter only windows demanding attention 
        xprop -id "$id" | grep -q "_NET_WM_STATE_DEMANDS_ATTENTION"
        if (( $? == 0 )); then
            wmctrl -i -a "$id"
            exit 0
        fi
    done
}

#### End OAuth Functions ###
    
function main(){
    settings_conf   # set up settings.conf if necessary

    # set defaults, if login not specified in script args
    ID="${ANON_ID}"                 # 
    AUTH="Authorization: Client-ID ${ID}"           # in curl command
    AUTH_MODE="A"                   # Anonymous flag
    F_FLAG=0                        # Flag for local image file upload
    SCROT="${SCREENSHOT_FULL_COMMAND}"        

    export -f run_browser   # to be used as YAD button command
    export -f switch_to_active # switch to active window
    export -f show_image        # to be used as YAD button command
    
    IMG_VIEWER=$(grep -oP '(?<=VIEWER=").*(?=")' "${SETTINGS_FILE}")
    [[ -z "$IMG_VIEWER" ]] && export IMG_VIEWER="bl-image-viewer"   # fallback to default. Used by show_image()

    if ! . "${BL_COMMON_LIBDIR}/yad-includes" 2> /dev/null; then
        echo "Error: Failed to source yad-includes in ${BL_COMMON_LIBDIR}" >&2
        exit 1
    elif ! . "${SETTINGS_FILE}" 2> /dev/null; then
        echo "Error: Failed to source ${SETTINGS_FILE} in ${USR_CFG_DIR}/" >&2
        exit 1
    elif ! . "${CREDENTIALS_FILE}" 2> /dev/null; then
        echo "Error: Failed to source ${CREDENTIALS_FILE} in ${USR_CFG_DIR}/" >&2
        if ! [[ -z "${CLIENT_ID}" ]] && [[ ${AUTH_MODE} == "L" ]];then
            load_access_token "${CLIENT_ID}"
        elif ! [[ -z "${CLIENT_ID}" ]] && [[ ${AUTH_MODE} == "A" ]];then
            load_access_token "${ANON_ID}"
        fi
    fi
    
    check_required  # check required programs are installed
    getargs "${@}"
    getimage "${FNAME}"
    
    if [[ "${AUTH_MODE}" = "L" ]];then        # logged in as user
        check_oauth2_client_secrets
        load_access_token
        if ! [[ -z "${ALBUM_TITLE}" ]];then   # upload to specified album
            ## get album id
            response=$(curl -sH --location --request GET \
            "https://api.imgur.com/3/account/${USER_NAME}/albums/ids" \
            --header "${AUTH}")
            declare -a ids 
            ids+=("$(jq -r '.data[]' <<< "${response}")")
        
            # match album ids with chosen album title
            for (( i=0;i<=${#ids[@]};i++ ));do
                ID="${ids[$i]}"
                response=$(curl -sH --location --request \
                GET "https://api.imgur.com/3/account/${USER_NAME}/album/${ID}" --header "${AUTH}")
        
                title="$(jq -r '.data.title' <<< "${response}")"
                if [[ "${title}" = "${ALBUM_TITLE}" ]];then
                    album_ID="${ids[$i]}"
                else
                    continue
                fi
            done
            response="$(curl  -sH "${AUTH}" -F "image=@\"${img_file}\"" \
            -F "title=${IMG_TITLE}" -F "album=${album_ID}" https://api.imgur.com/3/image)"
        else    # don't upload to an album
            response="$(curl  -sH "${AUTH}" -F "image=@\"${img_file}\"" \
            -F "title=${IMG_TITLE}" https://api.imgur.com/3/image)"
        fi
    else    # anonymous upload
        response="$(curl -sH "${AUTH}" -F "image=@\"${img_file}\"" \
        -F "title=${IMG_TITLE}" https://api.imgur.com/3/image)"
    fi
    del_hash="$(jq -r '.data | .deletehash' <<< "${response}")"
    img_link="$(jq -r '.data.link' <<< "${response}")" && export img_link  # used by show_image()
    img_link_filename="${img_link%.*}"
    img_file_ext="${img_link##*.}"
    img_thumb="${img_link_filename}t.${img_file_ext}"
    
    bb_direct_link="[img]${img_link}[/img]"
    bb_thumb_linked="[url=${img_link}][img]${img_thumb}[/img][/url]"
    
    # download image thumbnail, for display in YAD dialog
    thumb_tempfile="${HOME}/tmp/thumb.jpg"
    wget -q -O "${thumb_tempfile}" "${img_thumb}"
    
    # Display BB Codes for uploaded image
    text="\tBB Code - Image thumbnail Linked \n
    \tUse Ctrl-C/Ctrl-V to copy/paste the selection \n"

    ret=$(${DIALOG} --image-on-top --image="${thumb_tempfile}" "${TITLE}" \
        --form \
        --field='BB Code - Thumbnail linked':TXT "${bb_thumb_linked}" \
        --field='BB Code - Direct image link':TXT "${bb_direct_link}" \
        --button="Show Image":"/bin/bash -c 'show_image'" \
        ${DELETE} ${CLOSE}  --width=680 ${T}"${text}" --text-align=left \
        ) 2>/dev/null
    
    ret="$?"
    if (( ret == 2 ));then
        delete_image "${del_hash}"
    else
        delete_local
    fi
    
    rm "${thumb_tempfile}"
}
### END FUNCTIONS ######################################################

main "$@"
exit

