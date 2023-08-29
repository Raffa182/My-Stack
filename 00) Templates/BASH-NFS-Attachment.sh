# Adding at end of file

cat << EOF >> /etc/fstab
pgsap<smallsid>eastusnfs.file.core.windows.net:/pgsap<smallsid>eastusnfs/sap<smallsid> /<dirname> nfs vers=4,minorversion=1,sec=sys,nofail 0 0
pgsap<smallsid>eastusnfs.file.core.windows.net:/pgsap<smallsid>eastusnfs/<smallsid>trans /<dirname> nfs vers=4,minorversion=1,sec=sys,nofail 0 0
EOF