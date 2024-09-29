resource "aws_security_group" "instance" {
  name = "sg_mysql"
  vpc_id = var.vpc_id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "mysql" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  key_name      = var.key_name
  subnet_id = var.subnet_id
  vpc_security_group_ids = [aws_security_group.instance.id]
  user_data  =  <<-EOF
     #!/bin/bash
     sudo yum update -y
     sudo yum install mariadb-server -y
     sudo yum install pip -y
     sudo pip install pymysql
     sudo pip install flask-sqlalchemy
     sudo systemctl start mariadb
     sudo systemctl enable mariadb
     sudo mysql -e "CREATE DATABASE wsdb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
     sudo mysql -e "GRANT ALL PRIVILEGES ON wsdb.* TO 'ws'@'localhost' IDENTIFIED BY 'ws12345';FLUSH PRIVILEGES;"
     sudo mysql -e "CREATE TABLE wsdb.users (id INT AUTO_INCREMENT PRIMARY KEY,username VARCHAR(50) NOT NULL,email VARCHAR(100) NOT NULL);"
     sudo mysql -e "INSERT INTO wsdb.users (username,email) values ('ws','dsh@afa.com');"
     echo "from flask import Flask" >/home/ec2-user/ws.py
     echo "from flask_sqlalchemy import SQLAlchemy" >>/home/ec2-user/ws.py
     echo "app = Flask(__name__)" >>/home/ec2-user/ws.py
     echo "app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://ws:ws12345@127.0.0.1:3306/wsdb'" >>/home/ec2-user/ws.py
     echo "db = SQLAlchemy(app)" >>/home/ec2-user/ws.py
     echo "@app.route('/')" >>/home/ec2-user/ws.py
     echo "def test():" >>/home/ec2-user/ws.py
     echo "    with db.engine.connect() as conn:" >>/home/ec2-user/ws.py
     echo "        rs = conn.execute(\"select email from wsdb.users\")" >>/home/ec2-user/ws.py
     echo "    return ''.join(str(record) for record in rs)" >>/home/ec2-user/ws.py
     echo "if __name__ == '__main__':" >>/home/ec2-user/ws.py
     echo "    app.run(host='0.0.0.0')" >>/home/ec2-user/ws.py
     sudo nohup python /home/ec2-user/ws.py &
   EOF
   tags  = {
     Name = "mysql"
    }
}


resource "aws_eip" "mysql-eip" {
  instance = aws_instance.mysql.id
  vpc     = true
}
