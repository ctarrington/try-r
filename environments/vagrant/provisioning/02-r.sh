#!/bin/bash

echo "***************** Installing R ***********"
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
add-apt-repository 'deb [arch=amd64,i386] https://cran.rstudio.com/bin/linux/ubuntu xenial/'
apt-get update
apt-get -y install r-base
R --version

echo "***************** Installing R Studio ***********"
apt-get install gdebi-core
wget https://download2.rstudio.org/rstudio-server-1.1.423-amd64.deb
gdebi --n rstudio-server-1.1.423-amd64.deb
rm rstudio-server-1.1.423-amd64.deb
rstudio-server verify-installation

echo "***************** NOTE ***********"
echo "You must add a user from the vagrant shell, as in sudo adduser yourname"

echo "***************** NOTE ***********"
echo "After you create a user install packages:"
cat ./provisioning/install-packages.R
