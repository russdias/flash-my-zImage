#! /bin/bash

# Flash My zImage	
# Author: Russell Dias
# Version: 1.0.3
# Date: June 4, 2013
# Contact: russell.dias98@gmail.com

#Cleaning Output Folder(if ANy)
clear
echo "Cleaning Output Folder(if Any)"
sleep 1
if test -e target
  then
   rm -rf target
echo
echo "Removed"
else
  echo
  echo "There is no output folder. Good to go."
fi
#Removing Existine Ramdisk Folder
echo
echo "Removing Existine Ramdisk Folder"
sleep 1
if test -e ramdisk-1
  then
   rm -rf ramdisk-1
echo
echo "Removed"
else
  echo
  echo "There is no Ramdisk folder. Good to go."
fi
#Removing Existing zImage Folder
echo
echo "Removing Existing zImage Folder"
sleep 1
if test -e zImage-1
  then
   rm -rf zImage-1
echo
echo "Removed"
else
  echo
  echo "There is no zImage folder. Good to go."
fi
#Finding your boot.img
echo
echo "Finding your boot.img"
sleep 1
if test -e boot_img/boot.img ; then
  echo
  echo "Found boot.img"
else
  echo "Could not Find boot.img"
  echo
  echo "Quitting"
  exit
fi
#Finding your zImage
echo
echo "Finding your zImage"
sleep 1
if test -e zImage/zImage ; then
  echo
  echo "Found zImage"
  echo
else
  echo "Could not Find zImage"
  echo
  echo "Quitting"
  exit
fi
#Making Needed Folders
echo "Making Needed Folders"
echo
sleep 1
mkdir -p zImage-1
mkdir -p ramdisk-1
mkdir -p tempo
echo "Done"
echo
#Getting ready to unpack boot.img
echo "Getting ready to unpack boot.img"
echo
sleep 1
echo "Unpacking boot.img"
echo
sleep .4
   ./tools/unpackbootimg -i boot_img/boot.img -o tempo
   cp tempo/boot.img-zImage zImage-1/zImage
   rm -rf tempo/boot.img-zImage
   cd ramdisk-1
sleep .4
   echo
   echo "Unpacking Ramdisk"
   echo
   gzip -dc ../tempo/boot.img-ramdisk.gz | cpio -i
   cd ..
   rm -rf tempo
#Packing with your zImage
echo
echo "Packing with your zImage"
sleep 1
if test -e zImage/zImage
echo   
then echo "Found your zImage"
else 
   echo
   echo "Please place your zImage in the zImage Folder"
   exit
fi
sleep 1
if test -d ramdisk-1
echo
then echo "Found Ramdisk" 
echo
else echo "Sorry. We did not find your ramdisk"
exit 
fi
sleep 1
echo "Making ramdisk.gz"
echo
./tools/mkbootfs ramdisk-1 | gzip > ramdisk.gz
sleep 1
echo "Done"
echo
sleep 1
echo "Making boot.img with your zImage"
echo
sleep 1
mkdir -p target
./tools/mkbootimg --kernel zImage/zImage --ramdisk ramdisk.gz -o target/boot.img --base 10000000
rm ramdisk.gz
echo "Done Making boot.img"
echo
sleep 1
#making Flashable zip
echo "Going to make a flashable zip"
echo
echo "Please Add the modules to /tools/system/lib/modules and press enter"
read ANS
echo "All Good"
echo
echo "Making Zip"
cd target
cp -r ../tools/META-INF META-INF
cp -r ../tools/system system
cp ../tools/signapk.jar signapk.jar 
cp ../tools/testkey.x509.pem testkey.x509.pem
cp ../tools/testkey.pk8 testkey.pk8
echo
zip -r Flash-My-zImage.zip META-INF system boot.img 
echo
echo "ZIP Ready, signing it"
java -jar signapk.jar testkey.x509.pem testkey.pk8 Flash-My-zImage.zip Flash-My-zImage-SIGNED.zip
rm Flash-My-zImage.zip
rm *.jar
rm *.pk8
rm *.pem
rm -r META-INF 
rm -r system
rm -r boot.img
s1=`ls -lh Flash-My-zImage-SIGNED.zip | sed -e 's/.* [ ]*\([0-9]*\.[0-9]*[MK]\) .*/\1/g'`
echo
echo "Size of Zip is = $s1"
echo 
echo "Flash My zImage by russelldias"
echo
sleep 1
echo "Thanks for using Flash My zImage"
echo
sleep 1
echo "Please press [Enter] to exit."
read ANS
   
