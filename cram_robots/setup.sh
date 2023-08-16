#!/usr/bin/env bash

path=$(readlink -f "${BASH_SOURCE:-$0}")
path=${path%%setup.sh}
file="${path}scripts/init_pm.sh"

cd "$path"

for dir in cram_*; do
    cd "$dir"
    find -name "cram_*" -exec touch  {}/CATKIN_IGNORE \;
    cd "$path"
done



if [ -d "scripts" ]; then
    echo "
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
It seems like you have executed the setup script before.
Avoid executing it multiple times to avoid cluttering your bashrc.
If you wanted to swap between available process modules, use the 'cram_swap_processmodules' command.
Do you want to proceed? (yes/no)
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
"
    read -r proceed

    if [[ ! "$proceed" == "yes" ]]; then
        return 0
    fi
fi

mkdir -p "scripts"
touch "scripts/CATKIN_IGNORE"

echo "/scripts" >> .gitignore

echo "alias cram_swap_processmodules='${file}'" >> ~/.bashrc

cat <<EOM >>$file
#!/usr/bin/bash

cd "$path"

find -name "cram_*" -exec touch  {}/CATKIN_IGNORE \;

robots=()
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
    read -r -p "Please enter the Robot you are using: " robot

    if [[ " \${robots[*]} " == *" \$robot "* ]]; then
        break
    else
        echo "\$robot not found. Please select from the available robots."
    fi
done

cd cram_"\$robot"

find -name "cram_*" -not -ipath "*_process_modules" -exec rm {}/CATKIN_IGNORE \;

pms=()
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
    read -r -p "Please enter the process module you want to use: " pm

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

echo "
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
Please remember to build the workspace again for the changes to take effect
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
"

EOM

chmod +x "${file}"

cd ../../..

echo "
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
You can now swap between available process modules using the 'cram_swap_processmodules' command
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
"

source ~/.bashrc
