RACINE=/chemin/vers/dossier
DEST=/chemin/vers/dossier

cd $RACINE
find . -type d | while read dossier; do
    mkdir -p "$DEST/$dossier"
done
