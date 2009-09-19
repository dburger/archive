# examples, examples, and more examples?

# rename a bunch of files from a prefix + number to just the number
ls QuizUI_* | sed 's/Quiz\(UI_[0-9][0-9]\.png\)/mv Quiz\1 \1/' | sh

# remove from { to } in a text file spanning multiple lines, used to clean up
# an informix DDL for usage with SQL Server, derived from sed one liners page
sed -e ':a;s/{[^}]*}//g;/{/N;/{/ba' input.ddl
