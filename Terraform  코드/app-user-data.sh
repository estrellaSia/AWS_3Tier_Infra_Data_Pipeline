bin/bash
# Use this for your user data (script from top to bottom)
# install nginx, php (Amazon Linux 2 version)

bash

# Update packages
sudo yum update -y

# Install Apache and PHP
sudo yum install -y nginx php php-mysqlnd

# Enable necessary Apache modules
sudo systemctl start nginx
sudo systemctl enable nginx

# Install SSM Agent
sudo yum install -y amazon-ssm-agent

# Start and enable SSM Agent
sudo systemctl start amazon-ssm-agent
sudo systemctl enable amazon-ssm-agent

# Install MySQL client
sudo yum install -y mariadb105

echo "rds = ${rds_endpoint}"
echo "${host}"

# RDS에 접속하여 쿼리 실행
mysql -h "${host}" -P 3306 -u "${username}" -p${password} "${db}" -e "CREATE TABLE IF NOT EXISTS info (
    name VARCHAR(50) PRIMARY KEY,
    email VARCHAR(50),
    age INT
);"

mysql -h "${host}" -P 3306 -u "${username}" -p${password} "${db}" -e "INSERT INTO info (name, email, age) VALUES ('mk', 'mk@google.com', 23);"


cat << EOF > /usr/share/nginx/html/test.php
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf8">
</head>
<body>
<?php
  phpinfo();
?>
</body>
</html>
EOF

cat << EOF > /usr/share/nginx/html/db.php
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
</head>
<body>
<h1>DB page</h1>
<?php

    // 데이터베이스 연결
    \$conn = new mysqli("${host}", "${username}", "${password}", "${db}", 3306);

    // 연결 확인
    if (\$conn->connect_error) {
        die("Connection failed: " . \$conn->connect_error);
    }

    \$sql = "SELECT name, email, age FROM info";

    \$result = \$conn->query(\$sql);

    if (\$result->num_rows > 0) {
        // 결과 행을 출력
        while(\$row = \$result->fetch_assoc()) {
            echo "Name: " . \$row["name"] . " - Email: " . \$row["email"] . " - Age: " . \$row["age"] . "<br>";
        }
    } 
    else {
        echo "0 results";
    }

    // 연결 닫기
    \$conn->close();
?>
</body>
</html>
EOF

# Restart Nginx
sudo systemctl restart nginx

