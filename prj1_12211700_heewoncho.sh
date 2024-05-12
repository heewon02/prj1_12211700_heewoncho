#! /bin/bash
if [[ $1 = "teams.csv" && $2 = "players.csv" && $3 = "matches.csv" ]]; then
	
	echo "************OSS1-Project1************"
	echo "        StudentID : 12211700         "
	echo "         Name : heewon cho           "
	echo "*************************************"
stop="n"
until [ "$stop" = "y" ]
do
	echo "[MENU]"
	echo "1. Get the data of Heung-Min Son's Current Club, Appearances, Goals, Assists in
players.csv"
	echo "2. Get the team data to enter a league position in teams.csv"
	echo "3. Get the Top-3 Attendance matches in mateches.csv"
	echo "4. Get the team's league position and team's top scorer in teams.csv & players.csv"
	echo "5. Get the modified format of date_GMT in matches.csv"
	echo "6. Get the data of the winning team by the largest difference on home stadium in teams.csv& matches.csv"
	echo "7. Exit"
	read -p "Enter your CHOICE (1~7) :" choice

	case "$choice" in
		1)
			read -p "Do you want to get the Heung-Min Son's data? (y/n) :" answer
			if [ "$answer" = "y" ]
			then
				cat players.csv | awk -F, '$1~"Heung"{printf("Team:%s,Apperance:%s,Goal:%s,Assist:%s\n",$4, $6, $7, $8)}'
			fi
			;;
		2)
			read -p "What do you want to get the team data of league_position[1~20] :" answer
			cat teams.csv | awk -F, -v num=$answer '$6==num{print $6, $1, $2/($2+$3+$4)}'
			;;
		3)
			read -p "Do you want to know Top-3 attendance data and average attendance? (y/n) :" answer
			if [ "$answer" = "y" ]
			then
				echo "***Top-3 Attendance Match***"
				echo
				cat matches.csv | sort -t, -r -n -k 2 | head -n 3 | awk -F, '{printf("%s vs %s (%s)\n%s %s\n\n",$3,$4,$1,$2,$7)}' 
			fi
			;;
		4)
			read -p "Do you want to get each team's ranking and the highest-scoring player? (y/n) :" answer
			if [ "$answer" = "y" ]
			then
				IFS=,
				counter=1
				while (( counter <= 20 ))
				do
					for var in $(sed '1d' teams.csv | sort -t, -n -k 6 | cut -d "," -f1 | sed -n "$counter"p);
					do
						max=`awk -F, -v a=$var '$4~a{print $7}' players.csv | sort -n | tail -1`
						awk -F, -v a=$var -v b=$max -v c=$counter '$4~a&&$7==b{printf("%s %s\n%s %s\n", c, a, $1, b)}' players.csv | head -n 2
					done
					echo
					counter=$(( counter+1 ))
				done
			fi
			;;
		5)
			read -p "Do you want to modify the format of date? (y/n) :" answer
			if [ "$answer" = "y" ]
                        then
				sed '1d' matches.csv | head -n 10 | sed 's/Aug/08/' | cut -d "," -f1 | awk '{printf("%s/%s/%s %s\n",$3, $1, $2, $5)}'
                        fi
			;;
		6)
			sed '1d' teams.csv | awk -F, '{printf("%s) %s\n",NR, $1)}'
			read -p "Enter your team number :" answer
			IFS=,
			for var in $(sed '1d' teams.csv | cut -d "," -f1 |sed -n "$answer"p);do
				max=`awk -F, -v a=$var '$3~a{print $5-$6}' matches.csv | sort -n | tail -1`
				awk -F, -v a=$var -v b=$max '$3~a&&$5-$6==b{printf("\n%s\n%s %s vs %s %s\n", $1, $3, $5, $6, $4)}' matches.csv
                                done
				echo
			;;
		7)
			echo "Bye!"
			stop="y"
			;;
		*)
			echo "Error: Invalid option"
		esac
	done
else
	echo "usage: ./2024-OSS-Project1.sh file1 file2 file3"
fi
