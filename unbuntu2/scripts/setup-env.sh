#!/bin/bash

cd /home/software/root/bin/
source thisroot.sh
cd /home/software/geant4.10.7.4/bin/
source geant4.sh
cd /home/


RAT_ENV=/rat/env.sh
if [ -f "$RAT_ENV" ]; then
    source $RAT_ENV
else
    printf "\nCould not find /rat/env.sh\nIf youre building RAT, please ignore.\nOtherwise, ensure RAT is mounted to /rat\n"
fi
