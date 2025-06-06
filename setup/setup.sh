#!/bin/bash

#SETUP COMFYUI
cd $HOME/app
git clone https://github.com/comfyanonymous/ComfyUI .
git pull

cp -f /setup/extra_models_paths.yaml $HOME/app/extra_models_paths.yaml && chmod 777 $HOME/app/extra_models_paths.yaml

pip install --no-cache-dir -r requirements.txt

cd $HOME/app
# folders relink

if [[ -L $HOME/app/models ]]
then
   echo "MODELS is a symlink to a directory"
else
  echo "MODELS is a not symlink to a directory"
  rm -rf models/
  ln -sf /data/models $HOME/app
  ls -la .
fi

if [[ -L $HOME/app/custom_nodes ]]
then
   echo "custom_nodes is a symlink to a directory"
else
  echo "custom_nodes is a not symlink to a directory"
  rm -rf custom_nodes/
  ln -sf /data/custom_nodes $HOME/app
  ls -la .
  cd $HOME/app/custom_nodes
  git clone https://github.com/ltdrdata/ComfyUI-Manager comfyui-manager

  cd comfyui-manager
  pip install -r requirements.txt
fi

pip install xformers!=0.0.18 --no-cache-dir -r requirements.txt --extra-index-url https://download.pytorch.org/whl/cu121
ls -la .

# edit security config
cd $HOME/app
sed -i "s@normal@weak@g" $HOME/app/user/default/ComfyUI-Manager/config.ini
cat $HOME/app/user/default/ComfyUI-Manager/config.ini

rm -rf /.comfyui-init