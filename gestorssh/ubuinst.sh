#!/bin/bash
msg() {
   BRAN='\033[1;37m' && RED='\e[31m' && GREEN='\e[32m' && YELLOW='\e[33m'
  BLUE='\e[34m' && MAGENTA='\e[35m' && MAG='\033[1;36m' && BLACK='\e[1m' && SEMCOR='\e[0m'
  case $1 in
  -ne) cor="${RED}${BLACK}" && echo -ne "${cor}${2}${SEMCOR}" ;;
  -ama) cor="${YELLOW}${BLACK}" && echo -e "${cor}${2}${SEMCOR}" ;;
  -verm) cor="${YELLOW}${BLACK}[!] ${RED}" && echo -e "${cor}${2}${SEMCOR}" ;;
  -azu) cor="${MAG}${BLACK}" && echo -e "${cor}${2}${SEMCOR}" ;;
  -verd) cor="${GREEN}${BLACK}" && echo -e "${cor}${2}${SEMCOR}" ;;
  -bra) cor="${RED}" && echo -ne "${cor}${2}${SEMCOR}" ;;
  -nazu) cor="${COLOR[6]}${BLACK}" && echo -ne "${cor}${2}${SEMCOR}" ;;
  -gri) cor="\e[5m\033[1;100m" && echo -ne "${cor}${2}${SEMCOR}" ;;
  "-bar2" | "-bar") cor="${RED}————————————————————————————————————————————————————" && echo -e "${SEMCOR}${cor}${SEMCOR}" ;;
  esac
}
print_center() {
  if [[ -z $2 ]]; then
    text="$1"
  else
    col="$1"
    text="$2"
  fi

  while read line; do
    unset space
    x=$(((54 - ${#line}) / 2))
    for ((i = 0; i < $x; i++)); do
      space+=' '
    done
    space+="$line"
    if [[ -z $2 ]]; then
      msg -azu "$space"
    else
      msg "$col" "$space"
    fi
  done <<<$(echo -e "$text")
}
dependencias() {
  soft="apache2 cron curl unzip dirmngr apt-transport-https add-apt-repository ppa:ondrej/php update php7.4 php7.2-cli libapache2-mod-php7.4 php7.4-xml php7.4-mcrypt php7.4-curl php7.4-mbstring mariadb-server php7.4-mysql"
   for i in $soft; do
    leng="${#i}"
    puntos=$((21 - $leng))
    pts="."
    for ((a = 0; a < $puntos; a++)); do
      pts+="."
    done
    msg -nazu "    Instalando $i$(msg -ama "$pts")"
    if apt install $i -y &>/dev/null; then
      msg -verd " INSTALADO"
    else
      msg -verm2 " ERRO"
      sleep 2
      tput cuu1 && tput dl1
      print_center -ama "aplicando fix a $i"
      dpkg --configure -a &>/dev/null
      sleep 2
      tput cuu1 && tput dl1

      msg -nazu "    Instalando $i$(msg -ama "$pts")"
      if apt install $i -y &>/dev/null; then
        msg -verd " INSTALADO"
      else
        msg -verm2 " ERRO"
      fi
    fi
  done
}
os_system() {
  system=$(cat -n /etc/issue | grep 1 | cut -d ' ' -f6,7,8 | sed 's/1//' | sed 's/      //')
  distro=$(echo "$system" | awk '{print $1}')

  case $distro in
  Debian) vercion=$(echo $system | awk '{print $3}' | cut -d '.' -f1) ;;
  Ubuntu) vercion=$(echo $system | awk '{print $2}' | cut -d '.' -f1,2) ;;
  esac
}
install_() {
  os_system
  msg -bar
  echo -e "      \e[5m\033[1;100m   INSTALANDO PACOTES   \033[1;37m"
  msg -bar
  print_center -ama "$distro $vercion"
  print_center -verd "INSTALANDO DEPENDÊNCIAS"
  msg -bar3
  dependencias
  msg -bar3
  print_center -azu "Removendo pacotes obsoletos"
  apt autoremove -y &>/dev/null
  sleep 2
  tput cuu1 && tput dl1
  msg -bar
  print_center -ama "Se algumas das dependências falharem!!!\nQuando terminar, você pode tentar instalar\no mesmo manualmente usando o seguinte comando\napt install nome_do_pacote"
  msg -bar
  read -t 60 -n 1 -rsp $'\033[1;39m       << Pressione enter para continuar >>\n'
}
inst_base() {
systemctl restart apache2
cd || exit
mysqladmin -u root password "$pwdroot"
mysql -u root -p"$pwdroot" -e "UPDATE mysql.user SET Password=PASSWORD('$pwdroot') WHERE User='root'"
mysql -u root -p"$pwdroot" -e "DELETE FROM mysql.user WHERE User=''"
mysql -u root -p"$pwdroot" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'"
mysql -u root -p"$pwdroot" -e "FLUSH PRIVILEGES"
mysql -u root -p"$pwdroot" -e "CREATE USER 'sshplus'@'localhost';'"
mysql -u root -p"$pwdroot" -e "CREATE DATABASE sshplus;"
mysql -u root -p"$pwdroot" -e "GRANT ALL PRIVILEGES ON sshplus.* To 'sshplus'@'localhost' IDENTIFIED BY '$pwdroot';"
mysql -u root -p"$pwdroot" -e "FLUSH PRIVILEGES"
echo '[mysqld]
max_connections = 1000' >> /etc/mysql/my.cnf
phpenmod mcrypt
systemctl restart apache2
ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin
apt install php7.4-ssh2 -y > /dev/null 2>&1
php -m | grep ssh2 > /dev/null 2>&1
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
chmod +x /usr/local/bin/composer
cd /var/www/html || exit
wget https://github.com/nandoslayer/plusnssh/raw/ntech/gestorssh/gestorssh18.zip > /dev/null 2>&1
apt-get install unzip > /dev/null 2>&1
unzip gestorssh18.zip > /dev/null 2>&1
(echo yes; echo yes; echo yes; echo yes) | composer install > /dev/null 2>&1
(echo yes; echo yes; echo yes; echo yes) | composer require phpseclib/phpseclib:~2.0 > /dev/null 2>&1
ln -s /usr/share/phpmyadmin/ /var/www/html > /dev/null 2>&1
chmod 777 -R /var/www/html > /dev/null 2>&1
rm gestorssh18.zip index.html > /dev/null 2>&1
systemctl restart mysql
clear
}
phpmadm() {
cd /usr/share || exit
wget https://files.phpmyadmin.net/phpMyAdmin/5.1.0/phpMyAdmin-5.1.0-all-languages.zip > /dev/null 2>&1
unzip phpMyAdmin-5.1.0-all-languages.zip > /dev/null 2>&1
mv phpMyAdmin-5.1.0-all-languages phpmyadmin
chmod -R 0755 phpmyadmin
ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin
systemctl restart apache2 
rm phpMyAdmin-5.1.0-all-languages.zip
cd /root || exit
}

pconf() { 
sed "s/1020/$pwdroot/" /var/www/html/pages/system/pass.php > /tmp/pass
mv /tmp/pass /var/www/html/pages/system/pass.php

}
inst_db() { 
cd || exit
wget https://github.com/nandoslayer/plusnssh/raw/ntech/gestorssh/bdgestorssh.sql > /dev/null 2>&1
sleep 1
if [[ -e "$HOME/bdgestorssh.sql" ]]; then
    mysql -h localhost -u sshplus -p"$pwdroot" --default_character_set utf8 sshplus < bdgestorssh.sql
    rm /root/bdgestorssh.sql
else
    clear
    echo -e "\033[1;31m ERRO CRÍTICO\033[0m"
    sleep 2
    systemctl restart apache2 > /dev/null 2>&1
cat /dev/null > ~/.bash_history && history -c
rm /root/*.sh* > /dev/null 2>&1
clear
    exit
pweb
fi
clear
}
cron_set() {
crontab -l > cronset
echo "
0 */12 * * * cd /var/www/html/pages/system/ && bash cron.backup.sh && cd /root
5 */6 * * * cd /var/www/html/pages/system/ && /usr/bin/php cron.backup.php && cd /root
* * * * * cd /var/www/html/pages/system/ && bash cron.userteste.sh && cd /root
2 */6 * * * cd /var/www/html/pages/system/ && bash cron.autobackup.sh && cd /root
* * * * * /usr/bin/php /var/www/html/pages/system/cron.online.ssh.php
@daily /usr/bin/php /var/www/html/pages/system/cron.rev.php
* * * * * /usr/bin/php /var/www/html/pages/system/cron.ssh.php
* * * * * /usr/bin/php /var/www/html/pages/system/cron.php
@monthly /usr/bin/php /var/www/html/pages/system/cron.limpeza.php" > cronset
crontab cronset && rm cronset
}
fun_swap() {
			swapoff -a
            rm -rf /bin/ram.img > /dev/null 2>&1
            fallocate -l 4G /bin/ram.img > /dev/null 2>&1
            chmod 600 /bin/ram.img > /dev/null 2>&1
            mkswap /bin/ram.img > /dev/null 2>&1
            swapon /bin/ram.img > /dev/null 2>&1
            echo 50  > /proc/sys/vm/swappiness
            echo '/bin/ram.img none swap sw 0 0' | sudo tee -a /etc/fstab > /dev/null 2>&1
            sleep 2
}
tst_bkp() {
cd || exit
_key=$(echo $(openssl rand -hex 5))
sed -i "s;49875103u;$_key;g" /var/www/html/pages/system/config.php > /dev/null 2>&1
sed -i "s;localhost;$IP;g" /var/www/html/pages/system/config.php > /dev/null 2>&1
}
IP=$(wget -qO- ipv4.icanhazip.com)
echo "America/Sao_Paulo" > /etc/timezone
ln -fs /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime > /dev/null 2>&1
dpkg-reconfigure --frontend noninteractive tzdata > /dev/null 2>&1
clear
echo -e "\E[44;1;37m    INSTALAR PAINELWEB GESTOR-SSH     \E[0m" 
echo ""
echo -e "                 \033[1;31mBy @nandoslayer\033[1;36m"
echo ""
read -p "DIGITE SUA SENHA ROOT: " pwdroot
echo "root:$pwdroot" | chpasswd
echo -e "\n\033[1;36mINICIANDO INSTALAÇÃO \033[1;33mAGUARDE..."
sleep 6
clear
echo "INSTALANDO DEPENDÊNCIAS"
sleep 2
dependencias
inst_base
phpmadm
pconf
inst_db
cron_set
fun_swap
tst_bkp
clear
echo -e "\033[1;32m GESTOR-SSH INSTALADO COM SUCESSO!"
echo ""
echo -e "                 \033[1;31mBy @nandoslayer\033[1;36m"
echo ""
echo -e "\033[1;36m SEU PAINEL:\033[1;37m http://$IP/admin\033[0m"
echo -e "\033[1;36m USUÁRIO:\033[1;37m admin\033[0m"
echo -e "\033[1;36m SENHA:\033[1;37m admin\033[0m"
echo ""
echo -e "\033[1;36m LOJA DE APPS:\033[1;37m http://$IP/apps\033[0m"
echo ""
echo -e "\033[1;36m LOJA DE APPS:\033[1;37m http://$IP/phpmyadmin\033[0m"
echo -e "\033[1;36m USUÁRIO:\033[1;37m sshplus\033[0m"
echo -e "\033[1;36m SENHA:\033[1;37m $pwdroot\033[0m"
echo ""
echo -e "\033[1;33m MAIS INFORMAÇÕES \033[1;31m(\033[1;36mTELEGRAM\033[1;31m): \033[1;37m@nandoslayer\033[0m"
echo ""
sed -i "s;upload_max_filesize = 2M;upload_max_filesize = 64M;g" /etc/php/7.4/apache2/php.ini > /dev/null 2>&1
sed -i "s;post_max_size = 8M;post_max_size = 64M;g" /etc/php/7.4/apache2/php.ini > /dev/null 2>&1
echo -e "\033[1;36m REINICIANDO\033[1;37m EM 20 SEGUNDOS\033[0m"
sleep 20
shutdown -r now
cat /dev/null > ~/.bash_history && history -c
clear
exit