#!/bin/sh

set -e

case "$1" in
	server)
		shift
		;;

	*)
		exec $*
		;;
esac

config_dir="/etc/nsd"
data_dir="/var/lib/nsd"

if [ ! -f "${config_dir}/nsd.conf" ]; then
	echo "Generating ${config_dir}/nsd.conf..." >&2

	cat > "${config_dir}/nsd.conf" <<- EOF
#
# ${config_dir}/nsd.conf
#

server:
	zonesdir: "${config_dir}/zones"
	zonelistfile: "${data_dir}/zone.list"
	database: "${data_dir}/nsd.db"
	xfrdfile: "${data_dir}/xfrd.state"
	xfrdir: "${data_dir}/xfrdir"

remote-control:
	control-enable: yes
	control-interface: 127.0.0.1
	control-interface: ::1
	control-port: 8952
	server-key-file: "${config_dir}/nsd_server.key"
	server-cert-file: "${config_dir}/nsd_server.pem"
	control-key-file: "${config_dir}/nsd_control.key"
	control-cert-file: "${config_dir}/nsd_control.pem"

include: "${config_dir}/zones.conf"

EOF
fi

if [ ! -f "${config_dir}/zones.conf" ]; then
	echo "Generating ${config_dir}/zones.conf..." >&2

	cat > "${config_dir}/zones.conf" <<- EOF
#
# ${config_dir}/zones.conf
#

# add your zones here

EOF
fi

if [ ! -d "${config_dir}/zones" ]; then
	mkdir -p "${config_dir}/zones"
fi

if [ ! -f "${config_dir}/nsd_server.pem" ]; then
	nsd-control-setup
fi

mkdir -p /var/run/nsd
chown nsd:nsd /var/run/nsd

mkdir -p "${data_dir}"
chown nsd:nsd "${data_dir}"
chmod 0750 "${data_dir}"

exec /usr/sbin/nsd -d -c "${config_dir}/nsd.conf"

