#!/bin/bash

export color_hex="$1"

hex_to_rgb() {
    hex=$1
    r=$(printf "%d" 0x${hex:0:2})
    g=$(printf "%d" 0x${hex:2:2})
    b=$(printf "%d" 0x${hex:4:2})
    echo "$r,$g,$b"
}

export to_rgb=`hex_to_rgb ${color_hex}`

export color_rgb=${to_rgb}
echo $color_rgb


export name="system-candy-${color_hex}"

mkdir ${name}
mkdir ${name}/apps/scalable -p
mkdir ${name}/categories/scalable -p
mkdir ${name}/devices/scalable -p
mkdir ${name}/emblems/{8,16,22,symbolic} -p
mkdir ${name}/mimetypes/scalable -p
mkdir ${name}/places/{16,32,48} -p
mkdir ${name}/preferences/scalable -p

for icon in $(ls *.svg)
do
	cat ${icon} | sed -e "s/rgb([^)]*/rgb(${color_rgb}/g" | sed -e "s/#......\"/#${color_hex}\"/g" | sed -e "s/#......;/#${color_hex};/g" > ${name}/${icon}
	sync
done

for app in $(ls ../candy-icons/apps/scalable)
do
	mv ${name}/${app} ${name}/apps/scalable
done

for device in $(ls ../candy-icons/devices/scalable)
do
	mv ${name}/${device} ${name}/devices/scalable
done

for emblem in $(ls emblem*)
do
	cp ${name}/${emblem} ${name}/emblems/8
	cp ${name}/${emblem} ${name}/emblems/16
	cp ${name}/${emblem} ${name}/emblems/22
	mv ${name}/${emblem} ${name}/emblems/symbolic
done

for mimetype in $(ls ../candy-icons/mimetypes/scalable)
do
	mv ${name}/${mimetype} ${name}/mimetypes/scalable
done

for place in $(ls ../candy-icons/places/16 ../candy-icons/places/48)
do
	cp ${name}/${place} ${name}/places/16
	cp ${name}/${place} ${name}/places/32
	mv ${name}/${place} ${name}/places/48
done

for pref in $(ls ../candy-icons/preferences/scalable)
do
	mv ${name}/${pref} ${name}/preferences/scalable
done
