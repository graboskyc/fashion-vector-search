#!/bin/bash

source .env
datehash=`date | md5sum | cut -d" " -f1`

if [ $# -ne 1 ]
    then
    echo
    echo "You must provide an argument of either local or docker or encode to this script"
    echo
    exit 1
fi

if [ $1 = "docker" ]
    then

    abbrvhash=${datehash: -8}

    echo 
    echo "Building container using tag ${abbrvhash}"
    echo

    echo "Using args ${MDBURI}"
    echo "Using args ${MDBDB}"
    echo "Using args ${MDBCOL}"
    echo
    echo "+================================"
    echo "| START: Fashion"
    echo "+================================"
    echo

    if [ -d "./encoder/images" ]
        then
        echo
        echo "Image directory exists, begining docker build"
        echo
        docker build -t graboskyc/mdbvectorfashion:latest -t graboskyc/mdbvectorfashion:${abbrvhash} .
        EXITCODE=$?

        if [ $EXITCODE -eq 0 ]
            then

            docker stop mdbvectorfashion
            docker rm mdbvectorfashion
            docker run -t -i -d -p 5010:5010 --name mdbvectorfashion -e "MDBURI=${MDBURI}" -e "MDBDB=${MDBDB}" -e "MDBCOL=${MDBCOL}" --restart unless-stopped graboskyc/mdbvectorfashion:latest

            echo
            echo "+================================"
            echo "| END: Fashion"
            echo "+================================"
            echo

        else
            echo
            echo "+================================"
            echo "| ERROR: Build failed"
            echo "+================================"
            echo
        fi
    else 
        echo
        echo "+================================"
        echo "| ERROR: Missing image directory"
        echo "+================================"
        echo
        echo "Read the README.md to see how to download the images from Kaggle "
        echo
        exit 3
    fi
    
elif [ $1 = "encode" ]
    then
    echo 
    echo "Running encoding"
    echo

    echo "Using args ${MDBURI}"
    echo "Using args ${MDBDB}"
    echo "Using args ${MDBCOL}"
    echo

    if [ -x "$(command -v python3)" ]
        then
        if [ -d "./encoder/images" ]
            then
            echo
            echo "Image directory exists, begining encoding"
            echo
            python3 -m pip install requirements.txt
            cd encoder
            python3 encoder_and_loader.py
        else 
            echo
            echo "+================================"
            echo "| ERROR: Missing image directory"
            echo "+================================"
            echo
            echo "Read the README.md to see how to download the images from Kaggle "
            echo
            exit 3
        fi
    else
        echo
        echo "+================================"
        echo "| ERROR: Python3 not installed or in path"
        echo "+================================"
        echo
        exit 2
    fi
else
    echo 
    echo "Running locally"
    echo

    echo "Using args ${MDBURI}"
    echo "Using args ${MDBDB}"
    echo "Using args ${MDBCOL}"
    echo

    if [ -x "$(command -v python3)" ]
        then
        python3 -m pip install requirements.txt
        cd webapp
        python3 flask_server.py
    else
        echo
        echo "+================================"
        echo "| ERROR: Python3 not installed or in path"
        echo "+================================"
        echo
        exit 2
    fi
fi