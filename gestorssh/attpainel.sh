#!/bin/bash
clear
echo "America/Sao_Paulo" > /etc/timezone
ln -fs /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime > /dev/null 2>&1
dpkg-reconfigure --frontend noninteractive tzdata > /dev/null 2>&1
clear
update_start() {
rm /bin/pweb > /dev/null 2>&1
cd /bin || exit
wget https://github.com/nandoslayer/plusnssh/raw/ntech/gestorssh/pweb > /dev/null 2>&1
chmod 777 pweb > /dev/null 2>&1
clear
[[ ! -d /bin/ppweb ]] && mkdir /bin/ppweb
cd /bin/ppweb || exit
rm *.sh versao* > /dev/null 2>&1
wget https://github.com/nandoslayer/plusnssh/raw/ntech/gestorssh/install.sh > /dev/null 2>&1
wget https://github.com/nandoslayer/plusnssh/raw/ntech/gestorssh/ubuinst.sh > /dev/null 2>&1
wget https://github.com/nandoslayer/plusnssh/raw/ntech/gestorssh/senharoot.sh > /dev/null 2>&1
wget https://github.com/nandoslayer/plusnssh/raw/ntech/gestorssh/restbanco.sh > /dev/null 2>&1
wget https://github.com/nandoslayer/plusnssh/raw/ntech/gestorssh/restbanco18.sh > /dev/null 2>&1
wget https://github.com/nandoslayer/plusnssh/raw/ntech/gestorssh/empresa.sh > /dev/null 2>&1
wget https://github.com/nandoslayer/plusnssh/raw/ntech/gestorssh/updatepainel.sh > /dev/null 2>&1
wget https://github.com/nandoslayer/plusnssh/raw/ntech/gestorssh/updatepainel18.sh > /dev/null 2>&1
wget https://github.com/nandoslayer/plusnssh/raw/ntech/gestorssh/updatepainelarm.sh > /dev/null 2>&1
wget https://github.com/nandoslayer/plusnssh/raw/ntech/gestorssh/updatepainelarm18.sh > /dev/null 2>&1
wget https://github.com/nandoslayer/plusnssh/raw/ntech/gestorssh/versao > /dev/null 2>&1
chmod 777 *.sh > /dev/null 2>&1
echo ""
echo ""
echo -e "        \033[1;33m • \033[1;32mINSTALAÇÃO CONCLUÍDA\033[1;33m • \033[0m"
echo ""
echo -e "\033[1;31m \033[1;33mCOMANDO PRINCIPAL: \033[1;32mpweb\033[0m"
echo -e "\033[1;33m MAIS INFORMAÇÕES \033[1;31m(\033[1;36mTELEGRAM\033[1;31m): \033[1;37m@nandoslayer\033[0m"
echo ""
echo -ne "\n\033[1;31mENTER \033[1;33mpara retornar ao \033[1;32mPWEB! \033[0m"; read
cat /dev/null > ~/.bash_history && history -c
pweb
}
update_start