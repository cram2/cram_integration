#!/usr/bin/env bash

path=$(readlink -f "${BASH_SOURCE:-$0}")
path=${path%%setup.sh}
file="${path}scripts/init_pm.sh"

cd "$path"

find -name "*_process_modules" -exec touch  {}/CATKIN_IGNORE \;

mkdir "scripts"
touch "scripts/CATKIN_IGNORE"

echo "/scripts" >>".gitignore"
echo "CATKIN_IGNORE" >>".gitignore"

echo "alias cram_swap_processmodules='${file}'" >> ~/.bashrc

/bin/cat <<EOM >>$file
#!/usr/bin/bash

cd "$path"

find -name "*_process_modules" -exec touch  {}/CATKIN_IGNORE \;

for dir in cram_*; do
    robot=\${dir#cram_}

    if [[ "\$robot" != *"*"* ]]; then
	robots+=("\$robot")
    fi
done

if [ \${#robots[@]} -eq 0 ]; then
    echo "No robots found."
    exit 1
fi

options=\$(IFS=,; echo "\${robots[*]}")

while true; do
    echo "The following robots are currently available:"
    echo
    echo "\$options"
    echo
    echo
    echo "Please Enter the Robot you are using"
    read robot

    if [[ " \${robots[*]} " == *" \$robot "* ]]; then
        break
    else
        echo "\$robot not found. Please select from the available robots."
    fi

done

cd cram_"\$robot"

for dir in *_process_modules; do

    if [[ "\$dir" == "cram_\${robot}_process_modules" ]]; then
	pms+=("realworld")
    else
	pm=\${dir#cram_pr2_}
	pm=\${pm%%process_modules}
	pm=\${pm%%_}
	if [[ "\$pm" != *"*"* ]]; then
	    pms+=("\$pm")
	fi
    fi
done

if [ \${#pms[@]} -eq 0 ]; then
    echo "No processmodules found."
    exit 1
fi

options=\$(IFS=,; echo "\${pms[*]}")

while true; do
    echo
    echo
    echo "For \$robot, the following process modules are available:"
    echo
    echo "\$options"
    echo
    echo
    echo "Please Enter the process module you want to use:"
    read pm

    if [[ " \${pms[*]} " == *" \$pm "* ]]; then
        break
    else
        echo "\$pm not found. Please select from the available process modules."
    fi
done

if [[ "\$pm" == "realworld" ]]; then
        cd "cram_\${robot}_process_modules"
    else
        cd "cram_\${robot}_\${pm}_process_modules"
    fi

rm CATKIN_IGNORE

echo
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo 
echo "Please remember to build the workspace again in order for the changes to take effect"
echo
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

EOM

chmod +x "${file}"

rm "${path}setup.sh"

echo
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo
echo "You can now swap between available processmodules using the 'cram_swap_processmodules' command"
echo
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

source ~/.bashrc
