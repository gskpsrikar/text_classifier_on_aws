echo "Executing dependencies.sh..."
#!/bin/bash
echo "$PWD"
cd ..
echo "$PWD"

#search_dir=/the/path/to/base/dir/
#for entry in "$search_dir"/*
#do
#  echo "$entry"
#done

walk_dir () {
    shopt -s nullglob dotglob

    for pathname in "$1"/*; do
#        if [ -d "$pathname" ]; then
#            walk_dir "$pathname"
#        else
         printf '%s\n' "$pathname"
#        fi
    done
}

walk_dir "$PWD"
# pip install -r requirements.txt

#cd $path_cwd
#dir_name=lambda_dist_pkg/
#mkdir $dir_name
#echo $dir_name + "Hey there !"
#
## Create and activate virtual environment...
#virtualenv -p $runtime env_$function_name
#source $path_cwd/env_$function_name/bin/activate
#
## Installing python dependencies...
#FILE=$path_cwd/lambdas/get_model_details/requirements.txt
#
#if [ -f "$FILE" ]; then
#  echo "Installing dependencies..."
#  echo "From: requirement.txt file exists..."
#  pip install -r "$FILE"
#
#else
#  echo "Error: requirements.txt does not exist!"
#fi
#
## Deactivate virtual environment...
#deactivate
#
## Create deployment package...
#echo "Creating deployment package..."
#cd env_$function_name/lib/$runtime/site-packages/
#cp -r . $path_cwd/$dir_name
#cp -r $path_cwd/lambda_function/ $path_cwd/$dir_name
#
## Removing virtual environment folder...
#echo "Removing virtual environment folder..."
#rm -rf $path_cwd/env_$function_name
#
echo "Finished script execution!"