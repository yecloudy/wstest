resource "aws_security_group" "sg_inst" {
  name        = "sginst"
  description = "HTTPS SSH HTTP"
  vpc_id      = var.vpc_id
  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "ws"
  }
}

resource "aws_instance" "ws-inst" {
    count      = length(var.cidrlist)
    ami        = var.ami
    instance_type   = "t2.micro"
    key_name        = var.key_name
    subnet_id         = var.subnet_id[count.index]
    availability_zone = var.availability_zone[count.index]
    vpc_security_group_ids = [aws_security_group.sg_inst.id]
    user_data  =  <<-EOF
                    #!/bin/bash
                    sudo yum update -y
                    sudo yum install nginx  -y
                    sudo mkdir -p /etc/nginx/ca
                    echo "${var.mysql_ip}" > /home/ec2-user/test
                    echo "Instance id is: ${count.index}">>/usr/share/nginx/html/index.html
                    echo "-----BEGIN CERTIFICATE-----" > /etc/nginx/ca/server.crt
                    echo "MIIDWzCCAkMCFFDGnLyRFTCMhcNmhJbtym3oU0MhMA0GCSqGSIb3DQEBCwUAMGox" >> /etc/nginx/ca/server.crt
                    echo "CzAJBgNVBAYTAkNOMREwDwYDVQQIDAhTaGFuZ2hhaTERMA8GA1UEBwwIU2hhbmdo" >> /etc/nginx/ca/server.crt
                    echo "YWkxDTALBgNVBAoMBGNldGMxDTALBgNVBAsMBGNldGMxFzAVBgNVBAMMDmdpdGxh" >> /etc/nginx/ca/server.crt
                    echo "Yi5jZXRjLmNuMB4XDTI0MDkyNjAzNDQ1MVoXDTI1MDkyNjAzNDQ1MVowajELMAkG" >> /etc/nginx/ca/server.crt
                    echo "A1UEBhMCQ04xETAPBgNVBAgMCFNoYW5naGFpMREwDwYDVQQHDAhTaGFuZ2hhaTEN" >> /etc/nginx/ca/server.crt
                    echo "MAsGA1UECgwEY2V0YzENMAsGA1UECwwEY2V0YzEXMBUGA1UEAwwOZ2l0bGFiLmNl" >> /etc/nginx/ca/server.crt
                    echo "dGMuY24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCkDAGC8BVpLUiJ" >> /etc/nginx/ca/server.crt
                    echo "1IwNHODvQ3x4QCIoNpINnTyugJCvbIezrep+F5/gKmg9VTtAnuNCukB0LvWTVoUj" >> /etc/nginx/ca/server.crt
                    echo "4OwblerIByqXuqxeRDZajqjjI6ijfTjCIy/v4Y3Ndle1pF3+HzTSpJrpzYglsckX" >> /etc/nginx/ca/server.crt
                    echo "UI3YRGoi9RdONx7vjHyB8UGUIt9KH0ki1YdfLIubO1Rg5E/uQq6JapH+6fB7so4I" >> /etc/nginx/ca/server.crt
                    echo "z5PaG4ObzWDMp9nwhF/D0Xc6VuTr6FBDcXqhPtrTpGNase2csvumi726BifqGY6S" >> /etc/nginx/ca/server.crt
                    echo "GtvP0zDCSfffEHtn0ABSF4466wkiSrVNdZn9qo9+e3F48DUa2nERJLwDAKPBCNfd" >> /etc/nginx/ca/server.crt
                    echo "p4N+76N5AgMBAAEwDQYJKoZIhvcNAQELBQADggEBAHVVucEMuJq/lb3JH0MxzaKI" >> /etc/nginx/ca/server.crt
                    echo "UnHrQBu1w59w6Xc8/Ni6K394LHre8nDUV/+TFsoMnqMzKLcnINFtxqCijpKM19Xz" >> /etc/nginx/ca/server.crt
                    echo "ffX6KC44M+gIMjHD1arVixDm9m2lo4+a1v3ofn3GPoRqfA7NPZhOsL7IxK4XOvcy" >> /etc/nginx/ca/server.crt
                    echo "w+P6uOQbXbratiPgvrebJLVf1GIRm59gC4z5KpHT6Mgp57jky+sjw/vBeWTL2grB" >> /etc/nginx/ca/server.crt
                    echo "F39+vFzfavya3DeNyJCqFmtLI9cDcEkoU0zhKC7LEaX3ll8JNxBif+VUQIZwWR43" >> /etc/nginx/ca/server.crt
                    echo "TbwFJWir3yH7Ys7mgkoZhDWh3Y3NPZtRIucTG7UyslT87OvJn3rN1sD6eVbcKY4=" >> /etc/nginx/ca/server.crt
                    echo "-----END CERTIFICATE-----" >> /etc/nginx/ca/server.crt
                    echo "-----BEGIN PRIVATE KEY-----" > /etc/nginx/ca/server.key
                    echo "MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCkDAGC8BVpLUiJ" >> /etc/nginx/ca/server.key
                    echo "1IwNHODvQ3x4QCIoNpINnTyugJCvbIezrep+F5/gKmg9VTtAnuNCukB0LvWTVoUj" >> /etc/nginx/ca/server.key
                    echo "4OwblerIByqXuqxeRDZajqjjI6ijfTjCIy/v4Y3Ndle1pF3+HzTSpJrpzYglsckX" >> /etc/nginx/ca/server.key
                    echo "UI3YRGoi9RdONx7vjHyB8UGUIt9KH0ki1YdfLIubO1Rg5E/uQq6JapH+6fB7so4I" >> /etc/nginx/ca/server.key
                    echo "z5PaG4ObzWDMp9nwhF/D0Xc6VuTr6FBDcXqhPtrTpGNase2csvumi726BifqGY6S" >> /etc/nginx/ca/server.key
                    echo "GtvP0zDCSfffEHtn0ABSF4466wkiSrVNdZn9qo9+e3F48DUa2nERJLwDAKPBCNfd" >> /etc/nginx/ca/server.key
                    echo "p4N+76N5AgMBAAECggEAP3yR/S2S67BluUmzpcN+Xbp9akBPt8ZewbwPZu1EkU9s" >> /etc/nginx/ca/server.key
                    echo "OSJedMwJyIRA8TOSCdEz3HgeR5iA27OJNThvx8E+Kolzd2L8IEM/0c4SGE2NjzAA" >> /etc/nginx/ca/server.key
                    echo "Dkn13F0rNs/M4/QnmBhVpgukFEXBoezrCQXYz1CyzrKRgWidpVF2QgevPHg+d/2C" >> /etc/nginx/ca/server.key
                    echo "5D1JE9bqjrRKu84TTXbTbhGHPP/IpTTv17zqaoEkPwpWZtEHdGDdDKCT5J57QOCR" >> /etc/nginx/ca/server.key
                    echo "365aNlo21NSAcQKd+OkkYitzXtTHObZgnGrBzfn3zb60HShBVPXM6274+iDlB9XK" >> /etc/nginx/ca/server.key
                    echo "zB9ffdSlD7/2UOLNtWUru9mD4p1nKoORcrDchcunHQKBgQDUgGke9PhF6fgIom6T" >> /etc/nginx/ca/server.key
                    echo "HVdRl5LnRsogL76OEtb/6LCtw1dyylT/+ytJYb91dV8A07nKMShdDqzqEKeAIsZ4" >> /etc/nginx/ca/server.key
                    echo "hZyMrr+93vgkCERL2wVvGvMcFK2N3Nt/5/6ZxTyLLKOrWrKo9cEhuNDdTV7FQhfn" >> /etc/nginx/ca/server.key
                    echo "yFKYV2KCpm+7bUvIPZVLCUCApwKBgQDFoHQV9dOsidG4VAlc+TDgr3VSx6M+dOV2" >> /etc/nginx/ca/server.key
                    echo "/Gm+ePoLKtj442SaYCx9g0/S8aXxkMpCCgG3MAiY3hXbI3Wyhg3FNAQaerYZx6zD" >> /etc/nginx/ca/server.key
                    echo "L8RsKgg+q3dP4Ms/qHutnaRaD2uuUWbJK+2P7Qk6KBkrbGZHzzIsESUsOoxY9e7I" >> /etc/nginx/ca/server.key
                    echo "Hub6Y3Qe3wKBgAOzHKFqWGw3L5dO5KfxCdUk02ztYZV/30xv7YhVD8ZmsT4RYbt3" >> /etc/nginx/ca/server.key
                    echo "LwC/D+tGmNnV1dU8V9yO5dnJYnErqdLtWJVmcXYnzKAr+KxtasHNcVAa2A6xOq0W" >> /etc/nginx/ca/server.key
                    echo "Z+tbcLtnko3oLVYduTgSFKjVsQG0LeBeL3nxg4iMx0M3GuuojtHYnmPfAoGARsYV" >> /etc/nginx/ca/server.key
                    echo "jJ/CtHGOx4Jg8AjVtkFftMuF7KIUYy41+F5+vW0U0t0sdBSpGjHiblrX4NDHfirz" >> /etc/nginx/ca/server.key
                    echo "PlVXXtd54EasqchUOiFMrubvPABEIIqEv2+2ECt7yQFqCFwgHqbr6szG9WB1fOnc" >> /etc/nginx/ca/server.key
                    echo "Y8Sxn0Ao82IYpvLOtvVU6Kf3Bwzb/JMEiPsA5OUCgYEAiiXwkHnHmf+PqszjK6MR" >> /etc/nginx/ca/server.key
                    echo "Ks0lOXzFmruJe6F+k/qx1mv28j48ng2jFuoAIG8xBL2tQfu6XVh1BiIMoBX7fWxP" >> /etc/nginx/ca/server.key
                    echo "8/pohlHXkvoiMsEFihPnHlAJ4ktVuuSL08A903oWNYrt9BjzpIGxV34DnJNQnZbk" >> /etc/nginx/ca/server.key
                    echo "H1Uoyi66g8NKO2WbO7Z2hMs=" >> /etc/nginx/ca/server.key
                    echo "-----END PRIVATE KEY-----" >> /etc/nginx/ca/server.key
                    echo "404 error" > /usr/share/nginx/html/404.html
                    sudo sed -i "44a return 301 https://\$host\$request_uri;" /etc/nginx/nginx.conf
                    sudo sed -i "58a server {" /etc/nginx/nginx.conf
                    sudo sed -i "59a listen       443 ssl http2;" /etc/nginx/nginx.conf
                    sudo sed -i "60a listen       [::]:443 ssl http2;" /etc/nginx/nginx.conf
                    sudo sed -i "61a server_name  _;" /etc/nginx/nginx.conf
                    sudo sed -i "62a root         /usr/share/nginx/html;" /etc/nginx/nginx.conf
                    sudo sed -i "63a ssl_certificate \"/etc/nginx/ca/server.crt\";" /etc/nginx/nginx.conf
                    sudo sed -i "64a ssl_certificate_key \"/etc/nginx/ca/server.key\";" /etc/nginx/nginx.conf
                    sudo sed -i "65a ssl_session_cache shared:SSL:1m;" /etc/nginx/nginx.conf
                    sudo sed -i "66a ssl_session_timeout  10m;" /etc/nginx/nginx.conf
                    sudo sed -i "67a ssl_ciphers PROFILE=SYSTEM;" /etc/nginx/nginx.conf
                    sudo sed -i "68a ssl_prefer_server_ciphers on;" /etc/nginx/nginx.conf
                    sudo sed -i "69a include /etc/nginx/default.d/*.conf;" /etc/nginx/nginx.conf
                    sudo sed -i "70a error_page 404 /404.html;" /etc/nginx/nginx.conf
                    sudo sed -i "71a location = /404.html {" /etc/nginx/nginx.conf
                    sudo sed -i "72a }" /etc/nginx/nginx.conf
                    sudo sed -i "73a location = /getdb {" /etc/nginx/nginx.conf
                    sudo sed -i "74a proxy_pass http://${var.mysql_ip}:5000/;" /etc/nginx/nginx.conf
                    sudo sed -i "75a }" /etc/nginx/nginx.conf
                    sudo sed -i "76a error_page 500 502 503 504 /50x.html;" /etc/nginx/nginx.conf
                    sudo sed -i "77a location = /50x.html {" /etc/nginx/nginx.conf
                    sudo sed -i "78a }" /etc/nginx/nginx.conf
                    sudo sed -i "79a }" /etc/nginx/nginx.conf
                    sudo systemctl start nginx
                    sudo systemctl enable nginx
    EOF


    tags  = {
        Name = "ws-${var.availability_zone[count.index]}"
    }
}

resource "aws_eip" "ws-eip" {
  instance = aws_instance.ws-inst[count.index].id
  count   = length(aws_instance.ws-inst)
  vpc     = true
}
