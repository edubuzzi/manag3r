#!/bin/bash

principal () {
ROT=$(id -u)
if [ $ROT -ne 0 ]
then
echo
echo "Hello $USER, unfortunately you are not root."
echo "Please log in as root to access the tool."
echo
exit
fi
echo
echo -e "Script \033[01;34mmanag3r\033[01;00m created by: \033[01;32mEduardo Buzzi\033[01;00m"
echo -e "More Scripts in => \033[01;31mhttps://github.com/edubuzzi\033[01;00m"
echo
echo "Do you want to Manage"
echo
echo "[1] User(s)"
echo "[2] Group(s)"
echo "[3] Exit"
echo
read -p "Your choice => " CHOICE
echo
case $CHOICE in
1) portaluser;;
2) portalgroup;;
3) exit;;
*) sleep 0.5 && principal;;
esac
}

portaluser () {
echo "[1] List All Users"
echo "[2] Add User"
echo "[3] Change Username"
echo "[4] Change User ID (UID)"
echo "[5] Change User Password"
echo "[6] Remove User"
echo "[7] Back"
echo
read -p "Your choice => " CHOICE
case $CHOICE in
1) listallusers;;
2) addduser;;
3) changeuser;;
4) changeuid;;
5) changepassword;;
6) removeuser;;
7) principal;;
*) sleep 0.5 && portaluser;;
esac
}

portalgroup () {
echo "[1] List All Groups"
echo "[2] Add Group"
echo "[3] Change Group name"
echo "[4] Change Group ID (GID)"
echo "[5] Change Group Password"
echo "[6] Remove Group"
echo "[7] Back"
echo
read -p "Your choice => " CHOICE
case $CHOICE in
1) listallgroups;;
2) adddgroup;;
3) changegroup;;
4) changegid;;
5) changegrouppassword;;
6) removegroup;;
7) principal;;
*) sleep 0.5 && portaluser;;
esac
}

listallusers () {
echo
LINES=$(wc -l /etc/passwd | cut -d ' ' -f1)
for i in `seq 1 $LINES`
do
USER=$(cat /etc/passwd | head -n$i | tail -n1 | cut -d ':' -f1)
USERID=$(cat /etc/passwd | head -n$i | tail -n1 | cut -d ':' -f3)
GROUPID=$(cat /etc/passwd | head -n$i | tail -n1 | cut -d ':' -f4)
HOMEDIR=$(cat /etc/passwd | head -n$i | tail -n1 | cut -d ':' -f6)
echo "User: $USER | User ID: $USERID | Group ID: $GROUPID | Home Directory: $HOMEDIR"
done
echo
portaluser
}

listallgroups () {
echo
LINES=$(wc -l /etc/group | cut -d ' ' -f1)
for i in `seq 1 $LINES`
do
GROUP=$(cat /etc/group | head -n$i | tail -n1 | cut -d ':' -f1)
GROUPID=$(cat /etc/group | head -n$i | tail -n1 | cut -d ':' -f3)
echo "Group: $GROUP | Group ID: $GROUPID"
done
echo
portalgroup
}

addduser () {
echo
read -p "Name to be given to the User => " USERNAME
if [ -z $USERNAME ]
then
echo
echo "You need to enter a Username"
addduser
fi
read -p "ID that will be given to the User => " USERID
if [ -z $USERID ]
then
USERID=""
else
USERID="--uid $USERID"
fi
read -p "Group ID to be given to the User => " GROUPID
if [ -z $GROUPIP ]
then
GROUPID=""
else
GROUPID="--gid $GROUPID"
fi
homedir
}

adddgroup () {
echo
read -p "Name to be given to the Group => " GROUPNAME
if [ -z $GROUPNAME ]
then
echo
echo "You need to enter a Group name"
adddgroup
fi
read -p "ID that will be given to the Group => " GROUPID
if [ -z $GROUPID ]
then
GROUPID=""
else
GROUPID="--gid $GROUPID"
fi
addgroup $GROUPID $GROUPNAME
echo
portalgroup
}

homedir () {
echo
echo "[1] Let me choose the Home Directory"
echo "[2] Home Directory default (/home/$USERNAME)"
echo "[3] Create User without Home Directory"
echo "[4] Back and change information (User name, user ID or user group ID)"
echo "[5] Back to User Menu"
echo
read -p "Your choice => " CHOICE
case $CHOICE in
1) choosehomedir;;
2) homedirdefault;;
3) withouthomedir;;
4) addduser;;
5) portaluser;;
*) sleep 0.5 && homedir;;
esac
}

choosehomedir () {
echo
read -p "Inform the path (ex: '/yourchoice/$USERNAME') => " PATTH
HOMEDIR="--home $PATTH"
if [ -z $PATTH ]
then
HOMEDIR="--home /home/$USERNAME"
fi
shell
}

homedirdefault () {
HOMEDIR="--home /home/$USERNAME"
shell
}

withouthomedir () {
HOMEDIR="--no-create-home"
}

shell () {
echo
echo "[1] Bash Shell"
echo "[2] SH Shell"
echo "[3] ZSH Shell"
echo "[4] No Shell"
echo "[5] Back and change the Home Directory"
echo
read -p "Your choice => " CHOICE
echo
case $CHOICE in
1) bashshell;;
2) shshell;;
3) zshshell;;
4) noshell;;
5) homedir;;
*) sleep 0.5 && shell;;
esac
}

bashshell () {
SHELL="--shell /bin/bash"
password
}

shshell () {
SHELL="--shell /bin/sh"
password
}

zshshell () {
SHELL="--shell /bin/zsh"
password
}

noshell () {
SHELL=""
password
}

password () {
echo "Put Password on the User?"
echo
echo "[1] Yes"
echo "[2] No"
echo "[3] Back and change the Shell choice"
echo
read -p "Your choice => " CHOICE
echo
case $CHOICE in
1) passyes;;
2) passno;;
3) shell;;
*) sleep 0.5 && password;;
esac
}

passyes () {
PASSWORD=""
usercomment
}

passno () {
PASSWORD="--disabled-password"
usercomment
}

usercomment () {
echo "[1] Add Comment"
echo "[2] Do not Add Comment"
echo "[3] Back and change the Password choice"
echo
read -p "Your choice => " CHOICE
echo
case $CHOICE in
1) addcomment;;
2) noaddcomment;;
3) password;;
*) sleep 0.5 && usercomment;;
esac
}

addcomment () {
read -p "Comment => " COMMENT
COMMENT='-c "$COMMENT"'
echo
echo "[1] Continue, Finish and Create User"
echo "[2] Back and change the Comment choice"
echo
read -p "Your choice => " CHOICE
echo
case $CHOICE in
1) createuser;;
2) usercomment;;
*) sleep 0.5 && addcomment;;
esac
}

noaddcomment () {
COMMENT=""
echo "[1] Continue, Finish and Create User"
echo "[2] Back and change the Comment choice"
echo
read -p "Your choice => " CHOICE
echo
case $CHOICE in
1) createuser;;
2) usercomment;;
*) sleep 0.5 && noaddcomment;;
esac
}

createuser () {
adduser --quiet $HOMEDIR $SHELL $PASSWORD $COMMENT $USERID $GROUPID $USERNAME
echo
portaluser
}

changeuser () {
echo
read -p "Name of the User who wants to change the name => " USERNAME
if [ -z $USERNAME ]
then
echo
echo "You need put a Username ..."
changeuser
fi
pkill -9 -u $USERNAME
read -p "New Username => " NEWUSERNAME
if [ -z $NEWUSERNAME ]
then
echo
echo "You need put a New Username ..."
changeuser
fi
usermod -l $NEWUSERNAME $USERNAME
echo
portaluser
}

changegroup () {
echo
read -p "Name of the Group who wants to change the name => " GROUPNAME
if [ -z $GROUPNAME ]
then
echo
echo "You need put a Group name ..."
changegroup
fi
read -p "New Group name => " NEWGROUPNAME
if [ -z $NEWGROUPNAME ]
then
echo
echo "You need put a New Group name ..."
changegroup
fi
groupmod --new-name $NEWGROUPNAME $GROUPNAME
echo
portalgroup
}

changeuid () {
echo
read -p "Name of the User who wants to change the ID => " USERNAME
if [ -z $USERNAME ]
then
echo
echo "You need put a Username ..."
changeuid
fi
read -p "New User ID (ex: 582) => " NEWUID
if [ -z $NEWUID ]
then
echo
echo "You need put a New User ID ..."
changeuid
fi
usermod -u $NEWUID $USERNAME
echo
portaluser
}

changegid () {
echo
read -p "Name of the Group who wants to change the ID => " GROUPNAME
if [ -z $GROUPNAME ]
then
echo
echo "You need put a Group name ..."
changegid
fi
read -p "New Group ID (ex: 582) => " NEWGID
if [ -z $NEWGID ]
then
echo
echo "You need put a New Group ID ..."
changegid
fi
groupmod -g $NEWGID $GROUPNAME
echo
portalgroup
}

changepassword () {
echo
read -p "Name of the User who wants to change the Password => " USERNAME
if [ -z $USERNAME ]
then
echo
echo "You need put a Username ..."
changepassword
fi
echo
passwd $USERNAME
echo
portaluser
}

changegrouppassword () {
echo
read -p "Name of the Group who wants to change the Password => " GROUPNAME
if [ -z $GROUPNAME ]
then
echo
echo "You need put a Group name ..."
changegrouppassword
fi
echo
gpasswd $GROUPNAME
echo
portalgroup
}

removeuser () {
echo
read -p "Name of the User to be Deleted => " USERNAME
if [ -z $USERNAME ]
then
echo
echo "You need put a Username ..."
removeuser
fi
killall -u $USERNAME
userdel -f $USERNAME
echo
portaluser
}

removegroup () {
echo
read -p "Name of the Group to be Deleted => " GROUPNAME
if [ -z $GROUPNAME ]
then
echo
echo "You need put a Group name ..."
removegroup
fi
groupdel -f $GROUPNAME
echo
portalgroup
}
principal
