#!/bin/bash

#----------------TOOLS

#overwrite shared varaiables for testing
#GAMEDIR="/home/gameuser/gameserver"
#GAME="mh"

#gather config info from linuxgsm about this game
GAME_DETAILS=$(sudo -u gameuser $GAMEDIR/${GAME}server details)
CONFIG_PATH=$(echo "$GAME_DETAILS" | grep "Config file:" | grep -o "/.*")
GSM_CONFIG=$(echo "$GAME_DETAILS" | grep -A1 'Change ports by editing the parameters in:' | grep -v 'Change ports by editing the parameters in:')

PROMPT_TAGS=(
"SERVERNAME"
"SERVERPASSWORD"
"PUBLIC"
"UPNP"
"RCONPASSWORD"
)

#converts list to array outputs result in variable LST_ARR
lst_to_arr() {
LST_ARR=()
while read -r line; do LST_ARR+=("$line"); done <<< "$1"
}

display_result() {
echo 
echo "Location : $CONFIG_PATH"
echo
cat $CONFIG_PATH
echo

echo ------------------------------------
echo "Supported environment variables : "
echo ------------------------------------
echo

for DISPLAY_KEY in ${SUPPORTED_ENV_VAR[*]} ; do 
echo "$DISPLAY_KEY"
done
}

#check if a variable exists for every key in the config
#if it does modify the value in the config for the value of the environment variable 
modify_game_config() {
lst_to_arr "$CONFIG_KEYS"
for CONFIG_KEY in ${LST_ARR[*]} ; do
    ENV_VAR_NAME=$(echo 'GEN_'${CONFIG_KEY} | tr [a-z] [A-Z])
    SUPPORTED_ENV_VAR+=("$ENV_VAR_NAME") #displays supported generated variables
    is_promptable $ENV_VAR_NAME
    if [[ -v ${ENV_VAR_NAME} ]] ; then
         sed_pattern
         run_as_user "$SED_PATTERN"
    fi
done
}


#if gsm_config is a directory work on linuxgsm config files 
modify_gsm_config() {
#these should stay the same 
GSM_CONFIGS=$(cat "$GSM_CONFIG/_default.cfg" | grep -o '.*=')
GSM_CONFIG_KEYS=$(echo "$GSM_CONFIGS" | cut -d '=' -f 1)
lst_to_arr "$GSM_CONFIG_KEYS"
for GSM_CONFIG_KEY in ${LST_ARR[*]} ; do 
    GSM_ENV_VAR_NAME=$(echo 'GEN_GSM_'${GSM_CONFIG_KEY} | tr [a-z] [A-Z])
    SUPPORTED_ENV_VAR+=("$GSM_ENV_VAR_NAME") #displays supported generated variables
    is_promptable $GSM_ENV_VAR_NAME
    if [[ -v ${GSM_ENV_VAR_NAME} ]] ; then 
        #key="value"
        run_as_user "echo ${GSM_CONFIG_KEY}=${!GSM_ENV_VAR_NAME} >> ${GSM_CONFIG}/${GAME}server.cfg"
    fi
done
}

is_promptable(){
for PTAG in ${PROMPT_TAGS[*]} ; do
    COMP_PTAG=$(echo $1 | tr [a-z] [A-Z])
    if [[ $COMP_PTAG =~ $PTAG  ]] ; then
        #if variable is empty 
        if [ -z ${!COMP_PTAG} ]; then
        #echo "$COMP_PTAG : $PTAG"
        generate_prompt $PTAG
        fi
    fi 
done    
}

generate_prompt() {
case $1 in 
    "SERVERNAME")
        read -p "Server name : " -e -i $(hostname) ${COMP_PTAG} || ${COMP_PTAG}='error'
        echo
        ;;
    "SERVERPASSWORD")
        read -p "Server password : " ${COMP_PTAG} || ${COMP_PTAG}='error'
        echo
        ;;
    "PUBLIC")
        until [[ ${COMP_PTAG} == "true" || ${COMP_PTAG} == "false" ]]; do
        read -p "Server public (true|false) : " -e -i 'true' ${COMP_PTAG}
        echo
        done
        ;;
    "UPNP")
        until [[ ${COMP_PTAG} == "true" || ${COMP_PTAG} == "false" ]]; do
        read -p "Server upnp (true|false) : " -e -i 'true' ${COMP_PTAG}
        echo
        done
        ;;
    "RCONPASSWORD")
        read -s -p "Set RCON password : " ${COMP_PTAG} || ${COMP_PTAG}='error'
        echo
        ;;
    "*")
        echo "prompt generation error"
        ;;
esac
}

#--------------SCRIPT START

#parse config file WARNING keep rich text
CONFIGS=$(cat $CONFIG_PATH | grep -o '.*=')
CONFIG_KEYS=$(echo "$CONFIGS" | cut -d '=' -f 1) #needs a list of the keys in game config

sed_pattern() {
SED_PATTERN="sed -i 's/${CONFIG_KEY}=.*/${CONFIG_KEY}=${!ENV_VAR_NAME}/' \"${CONFIG_PATH}\""
#echo "DEBUG: $SED_PATTERN"
}

#to test a variable run_as_user is used and must be launched from auto_install
#GEN_SERVERNAME="test"
#GEN_GSM_PORT="0101"

if [[ -d $GSM_CONFIG ]] ; then
    modify_gsm_config
fi

modify_game_config

display_result
