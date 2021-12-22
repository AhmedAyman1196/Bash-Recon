# Bash-Recon

Install all tools
1-	Install go
a.	https://go.dev/doc/install 
2-	Project discovery tools
a.	Chaos project discover (already made public recon
i.	GO111MODULE=on go get -v github.com/projectdiscovery/chaos-client/cmd/chaos
b.	Subfinder
i.	go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
c.	Httpx
i.	go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
d.	Shuffledns
i.	GO111MODULE=on go get -v github.com/projectdiscovery/shuffledns/cmd/shuffledns
e.	Naabu
i.	go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest
f.	Nuclei
i.	go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest	
3-	Tomnomnom tools
a.	Waybackurls
i.	go get github.com/tomnomnom/waybackurls
ii.	go install -v github.com/tomnomnom/waybackurls@latest
b.	httpropbe (similar to https but I don’t think httpx checks port 80)
i.	go get -u github.com/tomnomnom/httprobe
c.	Asset finder ( gets subdomains related to org)
i.	go get -u github.com/tomnomnom/assetfinder
d.	Unfurl ( get info from url list like all domains, paths, etc …)
i.	go get -u github.com/tomnomnom/unfurl
Chaos project discovery
Manual part , there is a cli tool but easier to just download the subdomains part.
https://chaos.projectdiscovery.io/#/ 
SubFinder
https://github.com/projectdiscovery/subfinder 
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest

subfinder -d epicgames.com --silent --recursive -o subfinder.epicgames.com.out
Combine with httpx:
subfinder -d hackerone.com -silent| httpx -probe

Httpx
https://github.com/projectdiscovery/httpx 
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest

httpx -list subfinder.epicgames.com.out   -o httpx-min.epicgames.out
httpx -list subfinder.epicgames.com.out   -title -tech-detect -status-code -server -ip -cdn -o httpx-full.epicgames.out
Shuffledns
https://github.com/projectdiscovery/shuffledns
•	shuffleDNS is a wrapper around massdns written in go that allows you to enumerate valid subdomains using active bruteforce as well as resolve subdomains with wildcard handling and easy input-output support.
GO111MODULE=on go get -v github.com/projectdiscovery/shuffledns/cmd/Shuffledns

Resolver list
https://github.com/blechschmidt/massdns/blob/master/lists/resolvers.txt
wget https://raw.githubusercontent.com/blechschmidt/massdns/master/lists/resolvers.txt -O resolvers.txt

Bruteforce list
https://gist.github.com/jhaddix/86a06c5dc309d08580a018c66354a056 
wget https://gist.githubusercontent.com/jhaddix/86a06c5dc309d08580a018c66354a056/raw/96f4e51d96b2203f19f6381c8c545b278eaa0837/all.txt
 -O all.txt

Subdomain resolving
cat subfinder.epicgames.com.out | shuffledns -d epicgames.com -o shuffledns.resolve-epicgames.com.out -r resolvers.txt   


Bruteforcing
shuffledns -d epicgames.com -w all.txt -r resolvers.txt -o shuffledns.brute-epicgames.com.out  

Combine subdomains
Before subdomain brute forcing
cat subfinder.epicgames.com.out > tmp.txt ; cat shuffledns.resolve-epicgames.com.out >> tmp.txt ; uniq tmp.txt > epicgames.com.subdomains.txt ; rm -rf tmp.txt;
after brute force
cat subfinder.epicgames.com.out > tmp.txt ; cat shuffledns.resolve-epicgames.com.out >> tmp.txt ; cat shuffledns.brute-epicgames.com.out   >> tmp.txt ; sort tmp.txt | uniq  > epicgames.com.subdomains.txt ; rm -rf tmp.txt;



Naabu
https://github.com/projectdiscovery/naabu 
go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest

naabu -list subfinder.epicgames.com.out -o naabu.epicgames.com.out     
Nuclei
https://github.com/projectdiscovery/nuclei 
go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest

nuclei -list httpx-min.epicgames.out -o nuclei-epicgames.com.out
Waybackurls
https://github.com/tomnomnom/waybackurls 
go get github.com/tomnomnom/waybackurls
go install -v github.com/tomnomnom/waybackurls@latest

cat httpx-min.epicgames.out | waybackurls | tee waybacurls.epicgames.com-out
Httprobe
https://github.com/tomnomnom/httprobe
go get -u github.com/tomnomnom/httprobe
cat epicgames.com.subdomains.txt | httprobe -c 50 | tee httprobe-epicgames.com.out

Asset finder
Find domains and subdomains potentially related to a given domain
go get -u github.com/tomnomnom/assetfinder

assetfinder --subs-only epicgames.com | tee assetfinder-epicgames.com.out
Unfurl
Pull out bits of URLs provided on stdin
https://github.com/tomnomnom/unfurl 
go get -u github.com/tomnomnom/unfurl
cat urls.txt | unfurl domains
cat urls.txt | unfurl --unique domains
cat waybackurls.txt | unfurl paths > tmp.txt; sort tmp.txt | uniq | tee unfurl.paths.out; rm -rf tmp.txt;
cat urls.txt | unfurl keys > tmp.txt; sort tmp.txt | uniq | tee unfurl.keys.out; rm -rf tmp.txt;
cat urls.txt | unfurl values > tmp.txt; sort tmp.txt | uniq | tee unfurl.values.out; rm -rf tmp.txt;
cat urls.txt | unfurl keypairs > tmp.txt; sort tmp.txt | uniq | tee unfurl.keypair.out; rm -rf tmp.txt;
 
