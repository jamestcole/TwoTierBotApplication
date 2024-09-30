sudo apt install pymysql


/var/www/html/app$ cat /home/ubuntu/nohup.out

sudo lsof -t -i:5000



To ensure that your database is accessible on port 5000, we need to clarify that databases typically listen on their own specific ports (like MySQL on 3306, PostgreSQL on 5432, etc.) rather than the application ports like 5000. However, if you're trying to ensure that your application can communicate with the database, follow these steps:

Step 1: Verify Database Service Configuration
Check the Database Listening Port:
Use lsof or similar commands to see which port your database is listening on. For MySQL, it should be 3306:
bash
Copy code
sudo lsof -i -P -n | grep mysqld
Step 2: Configure Your Database for External Access
If your application needs to connect to the database from another server or a different network interface, you’ll need to:

Edit the Database Configuration File:

For MySQL, edit /etc/mysql/mysql.conf.d/mysqld.cnf or similar configuration file.
Look for the line that starts with bind-address. Change it to:
plaintext
Copy code
bind-address = 0.0.0.0
This allows the database to accept connections from any IP address.
Restart the Database Service:

bash
Copy code
sudo systemctl restart mysql