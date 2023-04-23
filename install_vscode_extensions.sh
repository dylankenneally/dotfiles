cat vscode.extensions | while read line || [[ -n $line ]];
do
   "code --install-extension $line"
done
