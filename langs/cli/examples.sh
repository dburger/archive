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

# mail with sendmail compatible send
mail -s 'pagemon report' to@addr.com -- -F'David J. Burger' --ffrom@addr.com"

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
