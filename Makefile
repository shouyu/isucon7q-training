.PHONY: bench

main: mysql nginx bench
	jq .score < /home/isucon/isubata/bench/result.json
	

mysql:
	sudo rm -f /etc/mysql/mysql.conf.d/mysqld.cnf
	sudo ln -s $(PWD)/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf
	sudo rm -f /var/log/mysql/*
	sudo systemctl restart mysql.service
	sudo ls /var/log/mysql/
	
nginx: 
	sudo rm -f /etc/nginx/nginx.conf
	sudo ln -s $(PWD)/nginx.conf /etc/nginx/nginx.conf
	sudo rm -f /var/log/nginx/access.log /var/log/nginx/error.log
	sudo systemctl reload nginx.service
	sudo ls /var/log/nginx/
	
bench:
	cd /home/isucon/isubata/bench && ./bin/bench -remotes=127.0.0.1 -output result.json



 