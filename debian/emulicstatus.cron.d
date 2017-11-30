# crontab for emulicstatus

# Change this to point to your EMu installation:
EMUPATH=/opt/emu/umnh

*/5 * * * * root [ -x /usr/bin/licstatus ] && [ -f /var/spool/emulicstatus/emu.rrd ] && [ -x ${EMUPATH}/bin/emurun ] && /usr/bin/licstatus --rrdfile /var/spool/emulicstatus/emu.rrd --mode acquire --emupath ${EMUPATH}

# To draw to /var/www/html/licstatus.png every fifteen minutes, run:
#
#  touch /var/www/html/licstatus.png && chown www-data /var/www/html/licstatus.png
#
# and uncomment this example:
#
# */15 * * * * www-data [ -x /usr/bin/licstatus] && [ -f /var/www/spool/emulicstatus/emu.rrd] && [ -d /var/www/html ] && /usr/bin/licstatus --rrdfile /var/spool/emulicstatus/emu.rrd --mode-graph --graph-to /var/www/html/licstatus.png

# vim: set syntax=crontab:
