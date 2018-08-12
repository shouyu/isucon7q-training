.PHONY: main bench mysql nginx app

main: mysql nginx app bench 
	jq .score < /home/isucon/isubata/bench/result.json
	

mysql:
	sudo rm -f /etc/mysql/mysql.conf.d/mysqld.cnf
	sudo ln -s $(PWD)/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf
	sudo rm -f /var/log/mysql/*
	
	sudo systemctl restart mysql.service
	echo "set global slow_query_log = off;"| mysql -h127.0.0.1 -uroot isubata
#	echo "set global slow_query_log = on;"| mysql -h127.0.0.1 -uroot isubata
	echo "set global slow_query_log_file = '/var/log/mysql/mysql-slow.log';"| mysql -h127.0.0.1 -uroot isubata
	echo "set global long_query_time = 0.01;"| mysql -h127.0.0.1 -uroot isubata
	sudo ls /var/log/mysql/
	
nginx: 
	sudo rm -f /etc/nginx/nginx.conf
	sudo ln -s $(PWD)/nginx.conf /etc/nginx/nginx.conf
	
	sudo rm -f /etc/nginx/sites-enabled/nginx.conf 
	sudo ln -s $(PWD)/nginx.app.conf /etc/nginx/sites-enabled/nginx.conf 
	
	sudo rm -f /var/log/nginx/access.log /var/log/nginx/error.log
	sudo systemctl reload nginx.service
	sudo ls /var/log/nginx/
	
app: 
	sudo systemctl stop isubata.python.service
	sudo systemctl start isubata.python.service
	
bench:
	cd /home/isucon/isubata/bench && ./bin/bench -remotes=127.0.0.1 -output result.json
	
stat:
	sudo alp --sum -r -f /var/log/nginx/access.log > alp.txt
	sudo mysqldumpslow -s c /var/log/mysql/mysql-slow.log > dump-slow.txt



 