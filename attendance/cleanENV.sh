#! /bin/bash -
if [[ ! -e adminsdk.json ]]; then
    touch adminsdk.json
    echo $ADMIN_SDK > adminsdk.json
fi
cp firebase_token_generator.py test/
cp adminsdk.json test/
