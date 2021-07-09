#!/bin/bash

#overwrite shared varaiables for testing
#GAMEDIR="/home/gameuser/gameserver"
#GAME="dst"

CONFIG_PATH=$(sudo -u gameuser $GAMEDIR/${GAME}server details | grep "Config file:" | grep -o "/.*")

#parse config file
CONFIGS=$(cat $CONFIG_PATH | grep '.* =' )
CONFIG_KEYS=$(echo "$CONFIGS" | cut -d ' ' -f 1 )

#convert list to array 
#while read -r line; do ARR_CONFIGS+=("$line"); done <<<"$CONFIGS"
while read -r line; do ARR_CONFIG_KEYS+=("$line"); done <<<"$CONFIG_KEYS"

#GEN_IS_MASTER="test2"
#echo $GEN_IS_MASTER

echo 
echo "$CONFIG_PATH"
cat $CONFIG_PATH
echo

echo ------------------------------------
echo "Supported environment variables : "
echo ------------------------------------
echo
#check if a variable exists for every key in the config
for CONFIG_KEY in $CONFIG_KEYS; do
    #echo $CONFIG_KEY
    #lookup if env variable is set ex: GEN_IS_MASTER
    ENV_VAR_NAME=$(echo 'GEN_'${CONFIG_KEY} | tr [a-z] [A-Z])
    echo "$ENV_VAR_NAME"
    # if variable exists
    if [[ -v ${ENV_VAR_NAME} ]] ; then
        #display value
         echo ${!ENV_VAR_NAME}
        #replace key value in config file 
        #pattern: = > = 
        SED_PATTERN="sed -i 's/${CONFIG_KEY} = .*/${CONFIG_KEY} = ${!ENV_VAR_NAME}/' \"${CONFIG_PATH}\"" 
        #echo $SED_PATTERN
        run_as_user "$SED_PATTERN"
    fi

done
