
#!/bin/bash
# Amazon Linux 2 userdata script for setting up Nginx with ProxyPass

bash

# Update packages
sudo yum update -y

# Install Nginx
sudo yum install -y nginx

# Start and enable Nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# Install SSM Agent
sudo yum install -y amazon-ssm-agent

# Start and enable SSM Agent
sudo systemctl start amazon-ssm-agent
sudo systemctl enable amazon-ssm-agent

# Configure ProxyPass in Nginx
cat << EOF > /etc/nginx/conf.d/proxy.conf
server {
    listen 80;
    server_name web.mycomet.link;

    # Proxy path configuration (e.g., /app)
    location /app {
        proxy_pass http://${alb_dns}/;
    }

    # Log settings (optional)
    error_log /var/log/nginx/mark_error.log;
    access_log /var/log/nginx/mark_access.log combined;
}

server {
    listen 443;
    server_name web.mycomet.link;

    # Proxy path configuration (e.g., /app)
    location /app {
        proxy_pass http://${alb_dns}/;
    }

    # Log settings (optional)
    error_log /var/log/nginx/mark_error.log;
    access_log /var/log/nginx/mark_access.log combined;
}
EOF


# 토큰 생성
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600" -s)

# 메타데이터 사용하여 각 정보 조회
RZAZ=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
IID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/instance-id)
LIP=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/local-ipv4)

# HTML 파일에 정보 삽입
cat << EOF > /usr/share/nginx/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>Web Server</title>
    <style>
        body {
            font-family: Arial, sans-serif; /* 폰트 스타일 */
            font-size: 50px; /* 기본 폰트 크기 */
            margin: 0;
            padding: 20px; /* 내용과 화면 가장자리 사이에 간격 추가 */
        }
        h1 {
            font-weight: bold; /* h1 태그는 볼드체 */
            font-size: 50px; /* h1 태그의 폰트 크기 */
            margin: 0 0 20px 0; /* 제목 아래에 여백 추가 */
        }
        .info {
            font-weight: normal; /* 정보 텍스트는 일반 두께 */
            font-size: 40px; /* 정보 텍스트의 폰트 크기 */
            line-height: 1.5; /* 줄 간격 설정 */
        }
        .info br {
            margin-bottom: 10px; /* <br> 태그 아래 마진 추가 */
        }
    </style>
</head>
<body>
    <h1>Web Server</h1> <!-- 제목은 볼드체로 왼쪽 상단에 표시 -->
    <div class="info">
        Region/AZ: $RZAZ<br>
        Instance ID: $IID<br>
        Private IP: $LIP<br>
    </div>
</body>
</html>

EOF

# Nginx 재시작
sudo systemctl restart nginx
