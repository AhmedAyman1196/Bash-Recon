#!/bin/bash

# show all output
exec 2>&1
# Exit on error
set -e

# Tools (Currently all only need go)

# Chaos project Cli - currently not used in the Recon script, just use the website to download the subdomains file if there is one.
GO111MODULE=on go get -v github.com/projectdiscovery/chaos-client/cmd/chaos
# subfinder (Subdomain scrapping)
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
# httpx (Porbes port 443 to check for live urls)
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
# ShuffleDns (Subdomain resolving and bruteforcing)
GO111MODULE=on go get -v github.com/projectdiscovery/shuffledns/cmd/shuffledns
# Naabu (nmap wannabe but faster and simple)
go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest
# Nuclei (Vulnerability discovery)
go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
# WaybackUrls (fetches urls found in waybackmachine)
go get github.com/tomnomnom/waybackurls
# Httprobe (Similar to https but I don’t think httpx checks port 80, might be redunant)
go get -u github.com/tomnomnom/httprobe
# AssetFinder (Get domains related to the organization)
go get -u github.com/tomnomnom/assetfinder
# Unfurl (Gets specifi info from list of urls like domains, paths, keys, etc..)
go get -u github.com/tomnomnom/unfurl

# Wordlists

# Resolvers.txt (used currently in shuffledns)
# https://github.com/blechschmidt/massdns/blob/master/lists/resolvers.txt
wget https://raw.githubusercontent.com/blechschmidt/massdns/master/lists/resolvers.txt -O resolvers.txt

# Jason Haddix all.txt used for subdomain bruteforcing
# https://gist.github.com/jhaddix/86a06c5dc309d08580a018c66354a056 
wget https://gist.githubusercontent.com/jhaddix/86a06c5dc309d08580a018c66354a056/raw/96f4e51d96b2203f19f6381c8c545b278eaa0837/all.txt -O all.txt

# Aquatone (better to install it by yourself)
# https://github.com/michenriksen/aquatone/releases/tag/v1.7.0

# wget https://github.com/michenriksen/aquatone/releases/download/v1.7.0/aquatone_linux_amd64_1.7.0.zip -O aquatone.zip
# unzip aquatone.zip
# chmod +X aquatone

