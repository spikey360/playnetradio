list="stations.list"
if [ ! -f $list ]
then
echo "Fill" $list "in format <name;url>"
echo > $list
exit 1
fi
#options to add
while getopts "a" opts
do
	case $opts in
		a)
			echo "Station?"
			read add_station
			echo "URL?"
			read add_url
			echo "$add_station;$add_url" >> $list
			echo "Added" $add_station
			exit 0
			;;
	esac
done
shift $(($OPTIND-1))
#print station list
echo "................Stations................"
#cat stations.list
while IFS= read -r line
do
IFS=";"
test=($line)
echo -e "\t>" "${test[0]}"
done < "$list"
echo "........................................"
echo "Station?"
read station
flag=0
while IFS= read -r line
do
IFS=";"
test=($line)
if [ "${test[0]}" = $station ]
then
flag=1
url="${test[1]}"
fi
done < "$list"
if [ $flag -eq 0 ]
then
echo "Invalid.."
exit 1
fi
#All in order, play
echo "Playing" $url
cvlc $url
echo "Done playing net radio"
