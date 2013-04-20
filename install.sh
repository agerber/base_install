CURRENT_DIR=`pwd`

#create user bin dir if needed
#mkdir -p ~/bin

#add this user bin dir to the path
#PATH="~/bin:$PATH"
#export PATH

# copy git-top over to my bin dir so it gets on the path
#cp git-top ~/bin/

#set up custom git aliases
cat my.config.git >> ~/.gitconfig

#as a safety measure, create an android workspace
mkdir -p ~/andw

# make a class directory and change to it
mkdir -p ~/and
cd ~/and

# finally checkout all other repositories
CLONE_REPOS_SCRIPT="$1"
CLONE_REPOS_CMD="$CURRENT_DIR/$CLONE_REPOS_SCRIPT"
$CLONE_REPOS_CMD

