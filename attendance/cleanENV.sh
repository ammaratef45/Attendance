#! /bin/bash -
if [[ ! -e adminsdk.json ]]; then
    touch adminsdk.json
    echo $ADMIN_SDK > adminsdk.json
fi
if [[ -e exportEnvVars.sh ]]; then
    chmod +x exportEnvVars.sh
    . ./exportEnvVars.sh
fi
cp firebase_token_generator.py test/
cp adminsdk.json test/
