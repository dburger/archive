# examples, examples, and more examples?

# rename a bunch of files from a prefix + number to just the number
ls QuizUI_* | sed 's/Quiz\(UI_[0-9][0-9]\.png\)/mv Quiz\1 \1/' | sh

# chop up a web page changing a <option> list into a couple of columns
sed -e 's/<option value=\(....\)>\(.*\)/put(\1, "\2");/g' countries.txt

# in place edit with backup remove single space in CSV column
sed -i[bak] -e 's/, ,/,,/g' hotspot-list2.txt

# another fancy rename making *-consolidated.xls consolidated-*.xls
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

# mail with sendmail compatible send
mail -s 'pagemon report' to@addr.com -- -F'David J. Burger' --ffrom@addr.com

# simple loop
for i in *; do ....; .....; done

# remove files from a directory older than 30 days
find /home/you/backup/ -mtime +30 -exec rm {} \;

# sort a CSV file by a column, here by column 7
sort -t',' -k 7 hotspot-list2.txt  > foo.txt

# set up a tunnel, local box listening on lport hitting rport on tohost,
# through throughhost
ssh -L  lport:tohost:rport throughhost

# chown a symlink, pass -h
chown -h user:group symlink

# email a picture to your flickr addr
(cat description.txt; uuencode laura.jpg laura.jpg) | mail -s 'subject' flickraddr@photos.flickr.com

# checkout every revision of a file from subversion
svn log -q ./src/java/com/bigtribe/sync/adapter/SimpleCsvReader.java | \
    grep "^r[0-9]\+ " | awk '{ print substr($1, 2) }' | \
    while read rev; do svn cat -r $rev src/java/com/bigtribe/sync/adapter/SimpleCsvReader.java > $rev.txt; done

# awk to print second column identify longest line
awk 'BEGIN {FS=","}; {print $2}' hotspot-list2.txt | wc -L

# awk to pull ip address from box
ifconfig | grep 'Bcast' | awk '{print $2' | awk 'BEGIN {FS=":"} ; {print $2}'

# send through netcat
tar cvf  - * | nc target 12345
# receive through netcat
nc -lp 12345 | tar xvf -

# cause hit to port 80 to hit 9080 with iptables
sudo iptables -t nat -A OUTPUT -d 127.0.0.1 -p tcp --dport 80 -j REDIRECT --to-port 9080
# and port 443 to 9443
sudo iptables -t nat -A OUTPUT -d 127.0.0.1 -p tcp --dport 443 -j REDIRECT --to-port 9443

# andy actually did this with an xinetd setup:
service geohana{
        type            = unlisted
        socket_type     = stream
        protocol        = tcp
        user            = root
        wait            = no
        port            = 80
        redirect        = localhost 9080
        disable         = no
}

# on OS X using firewall rules having 80 hit 9080
ipfw add 100 fwd 127.0.0.1,9080 tcp from any to any 80 in
