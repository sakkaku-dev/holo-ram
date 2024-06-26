GAME_NAME="$1"

if [ -z $GAME_NAME ]; then
    echo "Specify game name"
    exit 1
fi

echo "Setting game name to $GAME_NAME"
sed -e "/config\/name/ s/\".*\"/\"$GAME_NAME\"/" -i project.godot
sed -e "/GAME=/ s/\".*\"/\"$GAME_NAME\"/" -i scripts/publish.sh

# sed -i "s/##VAR_GAME_NAME/$GAME_NAME/g" project.godot
# sed -i "s/##VAR_GAME_NAME/$GAME_NAME/g" .github/workflows/release.yml
# sed -i "s/##VAR_GAME_NAME/$GAME_NAME/g" scripts/publish.sh

echo "#$GAME_NAME" > README.md