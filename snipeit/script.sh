##Install SnipeIT by using docker-compose
##This script is using for the personal purposes, which can be install via vagrant, using eth1 for the Bridge connection
  ##Install prerequisites packages
  apt-get update \
  && apt-get -y upgrade
  apt-get install -y apt-utils \
  wget \
  git \
  curl \
  tree \
  locales \
  net-tools \
  nano \
  net-tools \
  && timedatectl set-timezone Asia/Ho_Chi_Minh
  #Remove previous docker version
  apt-get remove -y docker docker-engine docker.io containerd runc
  #Install Docker, docker-compose
  apt-get install -y ca-certificates \
  curl \
  gnupg \
  lsb-release
  mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  apt-get update
  apt-get install -y docker.io docker-ce docker-ce-cli containerd.io docker-compose docker-compose-plugin
  ##Manage Docker as a non-root user
  groupadd docker
  usermod -aG docker vagrant
  #Install zsh with vagrant user instead of root
  su -c -m "vagrant" "wget -qO- https://gist.githubusercontent.com/tamld/7be6595bbffe5f9812ee448569c2b09c/raw/install-zsh.sh | bash"

### Download SnipeIT
if [ -d "snipe-it" ]; then
  echo Snipe-IT is exist
  cd snipe-it
  docker-compose down
  yes | docker network prune
  yes | docker volume prune
  cd .. & rm -rf snipe-it
  git clone https://github.com/snipe/snipe-it.git
  sudo chown vagrant:vagrant -R snipe-it
else
  echo "Folder does not exist"
  git clone https://github.com/snipe/snipe-it.git
  sudo chown vagrant:vagrant -R snipe-it
fi
sed -i 's/Dockerfile.alpine/Dockerfile/' docker-compose.yml
sed -i 's/8000:80/80:80/' docker-compose.yml
sed -i '/\    container_name: snipeit/a\    restart: always' docker-compose.yml
mkdir db-backup
sed -i '/var/www/html/storage/logs/a\    - /home/vagrant/snipe-it/db-backup/:/var/lib/snipeit/dumps/' docker-compose.yml
sed -i 's/.logs/var/\    - /home/vagrant/snipe-it/logs/' docker-compose.yml
sed -i '/\  mariadb:/a\    container_name: mariadb' docker-compose.yml
sed -i '/\    container_name: mariadb/a\    restart: always' docker-compose.yml
sed -i '/\  redis:/a\    container_name: redis' docker-compose.yml
sed -i '/\    container_name: redis/a\    restart: always' docker-compose.yml
sed -i '/\  mailhog:/a\    container_name: mailhog' docker-compose.yml
sed -i '/\    container_name: mailhog/a\    restart: always' docker-compose.yml
# sed -i '/db: {}/a\  log: {}' docker-compose.yml
sed -i 's/develop/production/' .env.docker
sed -i 's/UTC/Asia\/\Ho_Chi_Minh/' .env.docker

### Get eth1 (bridged) IP Address
ip="$(ifconfig eth1 | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*')"
sed -i "s/localhost:8000/$ip/" .env.docker
sed -i '/DB_CONNECTION=mysql/a DB_PORT=3306' .env.docker
sed -i '/APP_KEY=/d' .env.docker
### Build the enviroment file
docker-compose run --rm snipeit
key=$(docker-compose run --rm snipeit php artisan key:generate --show)
echo $key
## In case of the APP_KEY can not generate, run twice
key=$(docker-compose run --rm snipeit php artisan key:generate --show)
echo $key
sed -i "/APP_URL/i APP_KEY=$key" .env.docker
docker-compose down
docker-compose up -d
docker-compose stop
docker-compose up -d
docker container exec snipeit chown -R docker ./storage/logs/
echo "SnipeIT has APP_KEY=:$key"
echo "SnipeIT app can access via IP: $ip"