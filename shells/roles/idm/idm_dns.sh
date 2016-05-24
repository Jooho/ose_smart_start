kinit admin
ipa dnszone-add cloudapps.aperture.lab --admin-email=root@aperture.lab --minimum=3000 --dynamic-update=true
ipa dnsrecord-add cloudapps.aperture.lab '*' --a-rec 192.168.122.135
ipa dnsrecord-add cloudapps.aperture.lab '*' --a-rec 192.168.122.136
ipa dnszone-mod --allow-transfer='192.168.122.0;127.0.0.1' aperture.lab
}
