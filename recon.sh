#!/bin/bash

# show all output
exec 2>&1
# Exit on error
set -e

# input
if [ $# -eq 0 ]
  then
    echo "No arguments supplied, Insert domain to be hunted"
fi

domain="$1"

echo "Staring Recon on $domain"

# Output format
# <toolename>-<toolfunction?>.<domain>.out

# Subfinder
subfinder -d $domain --silent --recursive -o subfinder.$domain.out
# subfinder -d hackerone.com -silent| httpx -probe
echo "Subfinder finished on $domain"


# Shuffledns
# Subdomain resolving
cat subfinder.$domain.out | shuffledns -d $domain.out -r resolvers.txt -o shuffledns.resolve-$domain.out   
# Subdomain Bruteforcing (!Currenlty omitted as it is the longest process, recommend to use it on its own at the end from the terminal)
# shuffledns -d $domain.out -w all.txt -r resolvers.txt -o shuffledns.brute-$domain.out
echo "Shuffledns finished on $domain"


# Combine subdomains
# If no subdomain brute forcing
cat subfinder.$domain.out > tmp.txt ; cat shuffledns.resolve-$domain.out >> tmp.txt ; uniq tmp.txt > subdomains.$domain.out; rm -rf tmp.txt;
# If you used brute force (uncomment the below and comment the above line if you activated the subdomain brute forcing from shuffledns)
# cat subfinder.$domain.out > tmp.txt ; cat shuffledns.resolve-$domain.out >> tmp.txt ; cat shuffledns.brute-$domain.out   >> tmp.txt ; sort tmp.txt | uniq  > $domain.out.subdomains.txt ; rm -rf tmp.txt;
echo "Subdomains Combined"

# Httpx
httpx -list subdomains.$domain.out   -o httpx-min.$domain.out
# This one shows addintional information
httpx -list subdomains.$domain.out  -title -tech-detect -status-code -server -ip -cdn -o httpx-full.$domain.out

# Naabu
naabu -list subdomains.$domain.out -o naabu.$domain.out     

# Nulcei
nuclei -list httpx-min.$domain.out -o nuclei-$domain.out

# Waybackurls
cat httpx-min.$domain.out | waybackurls | tee waybacurls.$domain.out

# httprobe
cat $subdomains.$domain.out | httprobe -c 50 | tee httprobe-$domain.out

# assset finder
assetfinder --subs-only $domain.out | tee assetfinder-$domain.out

# Unfurl
cat waybacurls.$domain.out | unfurl paths > tmp.txt; sort tmp.txt | uniq | tee unfurl-paths.$domain.out; rm -rf tmp.txt;
cat waybacurls.$domain.out | unfurl keys > tmp.txt; sort tmp.txt | uniq | tee unfurl-keys.$domain.out; rm -rf tmp.txt;
cat waybacurls.$domain.out | unfurl values > tmp.txt; sort tmp.txt | uniq | tee unfurl-values.$domain.out; rm -rf tmp.txt;
cat waybacurls.$domain.out | unfurl keypairs > tmp.txt; sort tmp.txt | uniq | tee unfurl-keypair.$domain.out; rm -rf tmp.txt;


# Aquatone
mkdir aquatone-out
cat httpx-min.$domain.out | aquatone -out aquatone-out