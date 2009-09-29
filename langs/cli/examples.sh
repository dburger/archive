# examples, examples, and more examples?

# rename a bunch of files from a prefix + number to just the number
ls QuizUI_* | sed 's/Quiz\(UI_[0-9][0-9]\.png\)/mv Quiz\1 \1/' | sh

# another fancy rename
ls *consolidated.xls | sed 's/\(.*\)-consolidated.xls/mv \0 consolidated-\1.xls/' | sh

# remove from { to } in a text file spanning multiple lines, used to clean up
# an informix DDL for usage with SQL Server, derived from sed one liners page
sed -e ':a;s/{[^}]*}//g;/{/N;/{/ba' input.ddl

# fetchmail forward to dburger@camberhawaii.org every 5 minutes from dburger
# account at ip
fetchmail -d 300 --smtpname dburger@camberhawaii.org -p POP3 -u dburger 172.16.100.7

# syntax colorization
source-highlight Test.java -f html

# set up ethernet card from command line
sudo ifconfig eth0 netmask 255.255.255.0 72.235.74.144
route add default gw 72.235.74.1
sudo ifconfig eth0 up

# checkout a git repo
git clone ssh://git.camberhawaii.org/var/data/repos/first.git

# make a local branch also remote
git push origin local-branch-name
