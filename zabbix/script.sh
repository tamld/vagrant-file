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
  curl -fsSL https://get.docker.com -o get-docker.sh
  sh ./get-docker.sh
  ##Manage Docker as a non-root user
  groupadd docker
  usermod -aG docker vagrant
  #Install zsh with vagrant user instead of root
  su -c -m "vagrant" "wget -qO- https://gist.githubusercontent.com/tamld/7be6595bbffe5f9812ee448569c2b09c/raw/install-zsh.sh | bash"