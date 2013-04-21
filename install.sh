# we want to store the directory in which the user executed the script from
# the script is going to assume they are in the root of the base_install directory
CURRENT_DIR=`pwd`

# store the home directory if not defined
# on some systems, it is but this is for compatibility reasons
if [ "$HOME" = "" ]
   then HOME=~
fi

#create user bin dir if needed
mkdir -p ~/bin

#add this user bin dir to the path only if it's not already in the path
# foundEntry is a variable we define to store the return value of the previous command
# if foundEntry is not equal to 0, we append onto the end of .bashrc 
# (grep returns 0 if found, 1 if not, >1 if errored)
# (-q in grep -q silences the output)
echo $PATH | grep -q "$HOME/bin"
foundEntry=$?
if [ $foundEntry -ne 0 ]
    then 
         echo "export PATH=\"\$PATH:$HOME/bin\"" >> ~/.bashrc
         . ~/.bashrc
fi

# copy git-top over to my bin dir so it gets on the path
cp git-top ~/bin/

#set up custom git aliases


# if the alias block is not defined, define it
grep alias ~/.gitconfig
foundAlias=$?
if [ $foundAlias -ne 0 ]
   then echo "[alias]" >> ~/.gitconfig
fi

# for each line of the new config file
#   check to see if the command exists
#   if it doesn't, insert the line into the alias block
while read alias; do
    field=`echo $alias | cut -d " " -f1 | tr -d ' '`

    git config --get-regexp alias | grep "alias.$field " 
    isLineFound=$?

    if [ $isLineFound -ne 0 ]
        then 
            theBlock="{G;s/$/    $alias/;}"
            sed -i.bak "/\[alias\]/$theBlock" ~/.gitconfig
    fi
done < config.aliases

# finally replace all AND_COMMAND instances with &&
sed -i.bak "s/AND_COMMAND/\&\&/g" ~/.gitconfig

# replace all ARG_(digits) with the actual arguments
sed -i.bak 's/ARG_\([[:digit:]]*\)/\\"\$\1\\"/g' ~/.gitconfig

#as a safety measure, create an android workspace
mkdir -p ~/andw

# make a class directory
mkdir -p ~/and

# finally checkout all other repositories
CLONE_REPOS_SCRIPT="$1"

# invoke a subshell (the parens invoke a subshell)
#  cd into ~/and in the subshell
#  call the $CLONE_REPOS_SCRIPT in directory $CURRENT_DIR
#  $CURRENT_DIR is the the same directory as base_install
( cd ~/and; "$CURRENT_DIR/$CLONE_REPOS_SCRIPT" )

