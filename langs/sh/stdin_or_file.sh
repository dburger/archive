if [ $# == 1 ]; then
  exec 0<$1
fi

while read line
do
  echo $line
done
