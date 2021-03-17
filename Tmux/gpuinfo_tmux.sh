#!/bin/bash

# ====================================#
#                                     #
# GPU Usage Viewer for tmux by kskdev #
#                                     #
# ====================================#

# environment : bash and zsh

# require command :'nvidia-smi'

# return strings
# with GPU    : "GPU${GPU_ID}:${USED}/${TOTAL}[MB] GPU..."
# without GPU : "No GPU"

# Exception behavior : Not support... (future work)


# get gpu info by 'nvidia-smi' command
INFO=$(nvidia-smi --query-gpu=index,name,uuid,serial,utilization.gpu,utilization.memory,memory.total,memory.free,memory.used --format=csv)

# init various
IS_EXIST=0
COUNTER=0
RTN_STR=""

# processing each one line
IFS=$'\n'
for LINE in ${INFO}
do
    if [ ${COUNTER} = 0 ]; then
        COUNTER=$(expr ${COUNTER} + 1)
        continue
    fi
    if [ ${IS_EXIST} = 0 ]; then
        IS_EXIST=1
    fi

    # Split Info
    GPU_ID=$(echo ${LINE} | cut -d ',' -f 1)
    GPU_NAME=$( echo ${LINE} | cut -d ',' -f 2)
    GPU_UUID=$( echo ${LINE} | cut -d ',' -f 3)
    GPU_SERIAL=$( echo ${LINE} | cut -d ',' -f 4)
    GPU_UTIL_GPU=$( echo ${LINE} | cut -d ',' -f 5)
    GPU_UTIL_MEM=$(echo ${LINE} | cut -d ',' -f 6)
    GPU_MEM_TOTAL=$(echo ${LINE} | cut -d ',' -f 7)
    GPU_MEM_FREE=$(echo ${LINE} | cut -d ',' -f 8)
    GPU_MEM_USED=$(echo ${LINE} | cut -d ',' -f 9)

    # extract info
    USED="$(echo ${GPU_MEM_USED} | cut -d ' ' -f 2)"
    TOTAL="$(echo ${GPU_MEM_TOTAL} | cut -d ' ' -f 2)"

    # concatenate str
    # ----- MB表示
    # RTN_STR=${RTN_STR}"["${GPU_ID}":"${USED}"/"${TOTAL}"MB]"
    # ----- GB表示 (bcコマンドが必須)
    # U=`echo "scale=1; ${USED} / 1000.0" | bc`
    # T=`echo "scale=1; ${TOTAL} / 1000.0" | bc`
    # RTN_STR=${RTN_STR}" "${GPU_ID}":"${U}"/"${T}"G"
    # ----- %表示 (bcコマンドが必須)
    P=`echo "scale=1; ${USED} / ${TOTAL} * 100" | bc`
    P=`echo ${P} | grep --only-matching '^[0-9]*'`
    RTN_STR=${RTN_STR}" "${GPU_ID}":"${P}"%"
done

if [ ${IS_EXIST} = 1 ]; then
    echo "GPU"${RTN_STR}
else
    echo "No GPU"
fi
