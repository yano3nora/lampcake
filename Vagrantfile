# Using Vagrant 1.9.1
SERVER_IP       = "192.168.33.10"  # TODO
SERVER_IP_CLASS = "192.168.33.0\\/24"
SERVER_NAME     = "example.test"   # TODO
PROJECT_ROOT    = "/var/www"
WEB_ROOT        = "/var/www/public"
XDEBUG_PORT     = "9000"
Vagrant.configure("2") do |config|
  config.vm.box = "bento/centos-6.7"
  config.vbguest.auto_update = false
  config.vbguest.no_remote = true
  config.vm.network "private_network", ip: SERVER_IP
  config.vm.hostname = SERVER_NAME
  config.hostsupdater.aliases = [SERVER_NAME]
  config.vm.synced_folder ".", PROJECT_ROOT
  config.vm.provision "shell", inline: <<-SHELL
    # Update yum.
    sudo yum -y update --exclude=kernel*
    sudo yum -y install wget
    # Adding third-party repositories.
    sudo wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
    sudo wget http://mirror.fairway.ne.jp/dag/redhat/el6/en/x86_64/rpmforge/RPMS/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
    sudo wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
    sudo rpm -Uvh epel-release-latest-6.noarch.rpm
    sudo rpm -Uvh rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
    sudo rpm -Uvh remi-release-6.rpm
    sudo sed -i -e 's/enabled *= *1/enabled=0/g' /etc/yum.repos.d/epel.repo
    sudo sed -i -e 's/enabled *= *1/enabled=0/g' /etc/yum.repos.d/rpmforge.repo
    sudo sed -i -e 's/enabled *= *1/enabled=0/g' /etc/yum.repos.d/remi.repo
    sudo sed -i -e "1i options single-request-reopen" /etc/resolv.conf
    # Setup server local time.
    sudo rm /etc/localtime
    sudo ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
    # Install utilities - crond / telnet / vim / postfix / mlocate / zip / unzip / expect / vsftpd / ntpd.
    sudo yum -y install --enablerepo=remi,epel,rpmforge install crontabs
    sudo chkconfig crond on
    sudo service crond start
    sudo yum -y install telnet
    sudo yum --enablerepo=remi,epel,rpmforge install -y vim
    sudo yum install -y postfix
    sudo sh -c "echo 'smtp_tls_CAfile = /etc/pki/tls/cert.pem' >> /etc/postfix/main.cf"
    sudo sh -c "echo 'smtp_tls_security_level = may' >> /etc/postfix/main.cf"
    sudo sh -c "echo 'smtp_tls_loglevel = 1' >> /etc/postfix/main.cf"
    sudo chkconfig postfix on
    sudo service postfix start
    sudo yum install -y mlocate
    sudo updatedb
    sudo yum install -y unzip
    sudo yum install -y expect
    sudo yum install -y zip
    sudo yum -y install vsftpd
    sudo chkconfig vsftpd on
    sudo service vsftpd start
    # Install git
    cd /usr/local/src
    sudo yum -y install git curl-devel expat-devel gettext-devel openssl-devel zlib-devel gcc perl-ExtUtils-MakeMaker
    sudo git clone git://git.kernel.org/pub/scm/git/git.git
    cd git
    sudo make prefix=/usr/local all
    sudo make prefix=/usr/local install
    sudo yum remove -y git
    sudo ln -s /usr/local/bin/git /bin/git
    sudo ln -s /usr/local/bin/git /usr/bin/git
    git --version
    cd ~
    sudo yum -y install ntp
    sudo ntpdate ntp.nict.jp
    sudo sed -i -e "s|0.centos.pool.ntp.org iburst|-4 ntp.nict.jp|" /etc/ntp.conf
    sudo sed -i -e "s|1.centos.pool.ntp.org iburst|-4 ntp1.jst.mfeed.ad.jp|" /etc/ntp.conf
    sudo sed -i -e "s|2.centos.pool.ntp.org iburst|-4 ntp2.jst.mfeed.ad.jp|" /etc/ntp.conf
    sudo sed -i -e "s|3.centos.pool.ntp.org iburst|-4 ntp3.jst.mfeed.ad.jp|" /etc/ntp.conf
    sudo service ntpd start
    sudo chkconfig ntpd on
    # Install PHP / Xdebug / Imagick / graphviz / httpd.
    sudo yum --enablerepo=remi,epel,rpmforge -y install ImageMagick ImageMagick-late ImageMagick-devel
    sudo yum --enablerepo=remi,epel,rpmforge -y install graphviz graphviz-graphs graphviz-gd graphviz-devel
    sudo yum --enablerepo=remi,epel,rpmforge,remi-php71 -y install php php-devel php-mbstring php-mcrypt php-mysqlnd php-intl
    sudo yum --enablerepo=remi,epel,rpmforge,remi-php71 -y install php-pecl-imagick php-pecl-xdebug php-gd 
    # Edit php.ini / xdebug.
    sudo sed -i -e "s|;error_log = syslog|error_log = /var/log/php.log|" /etc/php.ini
    sudo sed -i -e "s|;mbstring.language = Japanese|mbstring.language = Japanese|" /etc/php.ini
    sudo sed -i -e "s|;mbstring.internal_encoding = EUC-JP|mbstring.internal_encoding = UTF-8|" /etc/php.ini
    sudo sed -i -e "s|;mbstring.http_input = auto|mbstring.http_input = auto|" /etc/php.ini
    sudo sed -i -e "s|;mbstring.detect_order = auto|mbstring.detect_order = auto|" /etc/php.ini
    sudo sed -i -e "s|expose_php = On|expose_php = Off|" /etc/php.ini
    sudo sed -i -e "s|;date.timezone =|date.timezone = Asia/Tokyo|" /etc/php.ini
    sudo sed -i -e "s|display_errors = Off|display_errors = On|" /etc/php.ini
    sudo sed -i '$a xdebug.idekey=\"vagrant\"' /etc/php.ini
    sudo sed -i '$a xdebug.remote_log=\"\/var\/log\/xdebug\/xdebug.log\"' /etc/php.ini
    sudo sed -i '$a xdebug.remote_enable=1' /etc/php.ini
    sudo sed -i '$a xdebug.remote_handler=\"dbgp\"' /etc/php.ini
    sudo sed -i '$a xdebug.remote_mode=\"req\"' /etc/php.ini
    sudo sed -i '$a xdebug.remote_host=127.0.0.1' /etc/php.ini
    sudo sed -i '$a xdebug.remote_connect_back=1' /etc/php.ini
    sudo sed -i '$a xdebug.remote_port=#{XDEBUG_PORT}' /etc/php.ini
    sudo sed -i '$a xdebug.remote_autostart=true' /etc/php.ini
    sudo mkdir -p /var/log/xdebug
    sudo touch /var/log/xdebug/xdebug.log
    sudo chown -R apache:apache /var/log/xdebug
    sudo chmod -R 777 /var/log/xdebug
    # Edit httpd.conf
    sudo mkdir -p #{WEB_ROOT}
    sudo sed -i 's_DocumentRoot \"/var/www/html\"_DocumentRoot \"#{WEB_ROOT}\"_' /etc/httpd/conf/httpd.conf
    sudo sed -i -e "s/ServerSignature On/ServerSignature Off/g" /etc/httpd/conf/httpd.conf
    sudo sed -i -e "s/ServerTokens OS/ServerTokens Prod/g" /etc/httpd/conf/httpd.conf
    sudo sed -i -e "s/AllowOverride None/AllowOverride All/g" /etc/httpd/conf/httpd.conf
    sudo sed -i '$a\EnableMMAP off' /etc/httpd/conf/httpd.conf
    sudo sed -i '$a\EnableSendfile off' /etc/httpd/conf/httpd.conf
    sudo service httpd start
    sudo chkconfig httpd on
    # disabled SELinux
    sudo setenforce 0
    sudo sed -e 's/SELINUX=permissive/SELINUX=disabled/' /etc/selinux/config
    # Install mysql / phpMyAdmin and delete mariadb-lib.
    sudo yum -y remove mariadb-libs
    sudo yum -y install http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm
    sudo yum -y install mysql-client mysql-server
    sudo yum --enablerepo=remi,epel,rpmforge,remi-php71 -y install phpMyAdmin php-pdo php-mysql php-mcrypt
    sudo sed -i 's/Allow from 127.0.0.1/Allow from #{SERVER_IP_CLASS}/g' /etc/httpd/conf.d/phpMyAdmin.conf
    # Set mysql to non-strict mode.
    # sudo sed -i -e "s|sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES|sql_mode=''|" /etc/my.cnf
    # Set mysql data storage to export.
    # sudo service mysqld stop
    # sudo mkdir -p /export
    # sudo chmod -R 755 /export
    # sudo mkdir -p /export/mysql
    # sudo chmod -R 755 /export/mysql
    # sudo chown -R mysql:mysql /export/mysql
    # sudo cp -pRf /var/lib/mysql/* /export/mysql
    # sudo sed -i -e "s|datadir=/var/lib/mysql|datadir=/export/mysql|" /etc/my.cnf
    # sudo service mysqld start
    sudo chkconfig mysqld on
    sudo service mysqld start
    # @Todo Create mkswap for production env. #######
    # dd if=/dev/zero of=/swapfile bs=1M count=1024
    # mkswap /swapfile
    # swapon /swapfile
    # vi /etc/fstab < /swapfile swap swap defaults 0 0
    #################################################
    # Install nodejs and npm.
    cd ~
    sudo yum remove -y nodejs npm
    rpm -i https://rpm.nodesource.com/pub_6.x/el/7/x86_64/nodesource-release-el7-1.noarch.rpm
    sudo yum install -y nodejs
    npm install -g n
    n 8.*
    npm install -g source-map-explorer
    # Install composer.
    sudo yum -y --enablerepo=remi,epel,rpmforge install composer
    # Change permission for provisioning files.
    sudo chmod -R 755 #{PROJECT_ROOT}/.provision
    sudo usermod -aG vagrant apache
  SHELL
  config.vm.provision :shell, :path => "./.provision/00_SetupSecureNetwork.sh", :privileged => true
  config.vm.provision :shell, :path => "./.provision/01_MysqlSecureInstallation.sh", :privileged => true
  config.vm.provision :shell, :path => "./.provision/02_SettingTimeZone.sh", :privileged => true
  config.vm.provision :shell, :path => "./.provision/03_CreateDatabase.sh", :privileged => true
  config.vm.provision :shell, :path => "./.provision/04_CreateTestDatabase.sh", :privileged => true
  config.vm.provision :shell, :path => "./.provision/05_CreateCakeProject.sh", :privileged => true
  # Run always.
  config.vm.provision :shell, run: "always", :path => "./.provision/06_BuildApplication.sh", :privileged => true
  config.vm.provision :shell, run: "always", :inline => <<-EOT
    sudo setenforce 0
    sudo service httpd restart
    sudo service mysqld restart
    sudo date
  EOT
end