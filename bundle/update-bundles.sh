dir=`pwd`
for f in `find $dir -d 1 -type d -not -name '.*'`
do
  echo "Updating $f"
  cd $f
  env git co master
  env git fetch
  env git pull origin master
  cd $dir
done