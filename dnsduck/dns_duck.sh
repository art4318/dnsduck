#!/bin/bash

	function runMenu()
	{
		echo ""
		echo "Usage: $0 {target specification} [Scan Type(s)]"
		echo "TARGET SPECIFICATION:"
		echo "  You can only pass DNS."
		echo "  Ex: google.com, amazon.com, facebook.com, nasa.gov"
		echo "  For the script to understand that you want to pass a target..."
		echo "  you should use the -t flag"
		echo "SCAN TYPE:"
		echo "  -r: Range Ips     - discovers the ip block belonging to the target corporation"
		echo "  -z: Zone Transfer - Force zone transfer"
		echo "  -i: Index Of      - search for panels, directories and files"
		echo "  -s: Subdomains    - subdomain search"
		echo "  -A: All           - performs all functions"
		echo "EXAMPLES:"
		echo "  $0 -t myschool.com -rz"
		echo "  $0 -t vulnerablesite.com -i"
		echo "  $0 -t nasa.com -A"
		echo "TIP:"
		echo "  you can run this script using the proxychains..."
		echo "  for a more realistic environment"
		echo "  EX: sudo $0 proxychains -t seualvo.com.br -A 2>/dev/null"
		echo "  [WARNING]: RUN THIS SCRIPT ONLY FOR SITES YOU HAVE PERMISSION! "
		echo ""
      	exit 1
	}

	if [ $# -lt 1 ]; then
		runMenu
		exit 1
	fi

	echo ""
	echo ""
	echo ""
	echo -e " \033[1;33m  ██████╗ ███╗   ██╗███████╗ \033[0m""\033[0;36m ██████╗ ██╗   ██╗ ██████╗██╗  ██╗ \033[0m"
	echo -e " \033[1;33m  ██╔══██╗████╗  ██║██╔════╝ \033[0m""\033[0;36m ██╔══██╗██║   ██║██╔════╝██║ ██╔╝ \033[0m"
	echo -e " \033[1;33m  ██║  ██║██╔██╗ ██║███████╗ \033[0m""\033[0;36m ██║  ██║██║   ██║██║     █████╔╝  \033[0m"
	echo -e " \033[1;33m  ██║  ██║██║╚██╗██║╚════██║ \033[0m""\033[0;36m ██║  ██║██║   ██║██║     ██╔═██╗  \033[0m"
	echo -e " \033[1;33m  ██████╔╝██║ ╚████║███████║ \033[0m""\033[0;36m ██████╔╝╚██████╔╝╚██████╗██║  ██╗ \033[0m"
	echo -e " \033[1;33m  ╚═════╝ ╚═╝  ╚═══╝╚══════╝ \033[0m""\033[0;36m ╚═════╝  ╚═════╝  ╚═════╝╚═╝  ╚═╝ \033[0m"
	echo ""
	echo ""
	echo -e "\033[0;36m ====================================================================\033[0m"
	echo -e "\033[0;36m ǁ                  DNSDUCK - DNS query script                      ǁ\033[0m"
	echo -e "\033[0;36m ǁ                      Welcome to DNS DUCK                         ǁ\033[0m"
	echo -e "\033[0;36m ǁ                   https://github.com/art4318        by:Arthur.S  ǁ\033[0m"
	echo -e "\033[0;36m ====================================================================\033[0m"
	echo -e "								\033[0;30m1.0\033[0m"
		
	function resolveDNS()
	{
		echo ""
		TARGET=$(host $dns_target | grep "has address" | cut -d " " -f4);
		echo -e " Target IP:"" \033[41;1;37m$TARGET\033[0m"
		echo ""
	}

	function whoIs()
	{
		range=$(whois $TARGET | grep "inetnum" | cut -d ":" -f2 | sed 's/        //');
		echo -e " IP Block:"" \033[41;1;37m$range\033[0m"	
		echo ""
		echo ""
	}

	function zoneTransfer()
	{
		echo -e " [\033[05;31m*\033[00;37m]"" Forcing DNS Zone Transfer"
		echo ""
		for server in $(host -t ns $dns_target | cut -d " " -f4 | sed 's/has address/ ===>/'); do
			host -l $dns_target $server;
		done
		echo ""
	}

	function searchIndexOf()
	{
		echo -e " [\033[05;31m*\033[00;37m]"" Searching Files & Directories"
		echo ""
		for keyword in $(cat arq_dir.txt); do
		resp1=$(curl -s -o /dev/null -w "%{http_code}" $dns_target/$keyword/)
		if [ $resp1 == "200" ]; then
			echo -e " \033[1;34mDirectories\033[0m""\033[1;37m --> \033[0m""www.$dns_target/$keyword"
			# echo "Directories ==> www.$dns_target/$keyword"
		fi
		resp2=$(curl -s -o /dev/null -w "%{http_code}" $dns_target/$keyword)
		if [ $resp2 == "200" ]; then
			echo -e " \033[1;35mFiles\033[0m""\033[1;37m --> \033[0m""www.$dns_target/$keyword"
			# echo "Files ==> www.$dns_target/$keyword"
		fi
		done
	}

	function searchSubdomains()
	{
		echo -e " [\033[05;31m*\033[00;37m]"" Searching subdomains"
		echo ""	
		for url in $(cat subdomains.txt); do
			host $url.$dns_target | grep "has address" | sed 's/has address/	--> /';
		done
		echo ""
	}

   function duck()
   {
		echo -e "     \033[0;33m       ,~~.          \033[0m"
		echo -e "     \033[0;33m      (  9 )-_,      \033[0m"
		echo -e "     \033[0;33m (\___ )=='          \033[0m""   \033[0;33m   _      _      _    \033[0m"
		echo -e "     \033[0;33m  \ .   ) )          \033[0m""   \033[0;33m >(.)__ <(.)__ =(.)__ \033[0m"
		echo -e "     \033[0;33m   \ '-' /           \033[0m""   \033[0;33m  (___/  (___/  (___/ \033[0m"
		echo -e "     \033[0;33m    '~j-'  DNS duck  \033[0m"
		echo -e "     \033[0;33m      ''=:           \033[0m"

		# echo -e "\033[0;33m   _      _      _    \033[0m"
		# echo -e "\033[0;33m >(.)__ <(.)__ =(.)__ \033[0m"
		# echo -e "\033[0;33m  (___/  (___/  (___/ \033[0m"

   }

      while getopts "ht:Arzispd" OPTION
   do
      case $OPTION in
         h) runMenu
            ;;
         t) dns_target=$OPTARG
            ;;
         A) resolveDNS; whoIs; zoneTransfer; searchIndexOf; searchSubdomains;
            ;;
         r) resolveDNS; whoIs; 
            ;;
         z) zoneTransfer
            ;;
         i) searchIndexOf
            ;;
         s) searchSubdomains 
            ;;
         d) duck
			;;
         ?) runMenu
            ;;
      esac

   done
   shift $((OPTIND-1))

