list="stations.list"
tmplist=".tmplist"
cplist=".cplist"
if [ ! -f $list ]
then
echo -e "Fill" $list "in format \e[1m<genre;name;url>\e[0m"
echo > $list
exit 1
fi
#Initialise variables
genre=""
flags=""
delete=0
#options to add
while getopts "aqd" opts
do
	case $opts in
		a)
			echo -e "\e[36mStation?\e[0m"
			read add_station
			echo -e "\e[36mURL?\e[0m"
			read add_url
			echo -e "\e[36mGenre?\e[0m"
			read add_genre
			echo "$add_genre;$add_station;$add_url" >> $list
			echo -e "\e[36m\e[1mAdded\e[0m" $add_station
			exit 0
			;;
		q)
			#quiet mode
			echo "Quiet mode selected.."
			flags=-q
			;;
		d)
			#station delete mode
			echo "Station delete mode.."
			delete=1
			;;

	esac
done
shift $(($OPTIND-1))
#print station list
echo -e "................\e[1mStations\e[0m................"
#sort station list into temporary
sort $list > $tmplist
while IFS= read -r line
do
IFS=";"
test=($line)
currgen="${test[0]}"
if [ "$currgen" != "$genre" ]
then
genre="${test[0]}"
echo -e "\e[1m" $genre "\e[0m"
fi
echo -e "\t" "${test[1]}"
done < "$tmplist"
echo "........................................"
echo -e "\e[1m\e[36mStation?\e[0m"
read station
flag=0
while IFS= read -r line
do
IFS=";"
test=($line)
if [ "${test[1]}" = "$station" ]
then
flag=1
url="${test[2]}"
fi
done < "$list"
if [ $flag -eq 0 ]
then
echo -e "\e[31mInvalid, Exiting..\e[0m"
rm $tmplist
exit 1
fi
#All in order, play or delete
if [ "$delete" == "1" ]
then
echo -e "\e[31m\e[1mDeleting\e[0m\e[1m" $station "\e[0m"
cp $list .cplist
rm $list
(cat $cplist | grep -v $station) | cat > $list
rm $cplist
else
echo -e "Playing \e[1m" $url "\e[0m"
cvlc $flags $url
echo -e "\n" "\e[1mDone playing net radio\e[0m"
fi
#cleanup
rm $tmplist
