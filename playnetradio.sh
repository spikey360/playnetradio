list="stations.list"
if [ ! -f $list ]
then
echo -e "Fill" $list "in format \e[1m<name;url>\e[0m"
echo > $list
exit 1
fi
flags=""
#options to add
while getopts "aq" opts
do
	case $opts in
		a)
			echo -e "\e[36mStation?\e[0m"
			read add_station
			echo -e "\e[36mURL?\e[0m"
			read add_url
			echo "$add_station;$add_url" >> $list
			echo -e "\e[36m\e[1mAdded\e[0m" $add_station
			exit 0
			;;
		q)
			#quiet mode
			echo "Quiet mode selected.."
			flags=-q

	esac
done
shift $(($OPTIND-1))
#print station list
echo -e "................\e[1mStations\e[0m................"
#cat stations.list
while IFS= read -r line
do
IFS=";"
test=($line)
echo -e "\t>" "${test[0]}"
done < "$list"
echo "........................................"
echo -e "\e[1m\e[36mStation?\e[0m"
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
echo -e "\e[31mInvalid..\e[0m"
exit 1
fi
#All in order, play
echo -e "Playing \e[1m" $url "\e[0m"
cvlc $flags $url
echo -e "\n" "\e[1mDone playing net radio\e[0m"
