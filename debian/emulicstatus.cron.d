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
# */15 * * * * www-data [ -x /usr/bin/licstatus ] && [ -f /var/spool/emulicstatus/emu.rrd ] && [ -d /var/www/html ] && /usr/bin/licstatus --rrdfile /var/spool/emulicstatus/emu.rrd --mode=graph --graph-to /var/www/html/licstatus.png

# The following are for use with /usr/share/doc/emulicstatus/examples/licstatus.html
#
# */30 * * * * www-data [ -x /usr/bin/licstatus ] && [ -f /var/spool/emulicstatus/emu.rrd ] && [ -d /var/www/html ] && /usr/bin/licstatus --rrdfile /var/spool/emulicstatus/emu.rrd --mode=graph --graph-to /var/www/html/licstatus-7.png --graph-days 7
# */30 * * * * www-data [ -x /usr/bin/licstatus ] && [ -f /var/spool/emulicstatus/emu.rrd ] && [ -d /var/www/html ] && /usr/bin/licstatus --rrdfile /var/spool/emulicstatus/emu.rrd --mode=graph --graph-to /var/www/html/licstatus-14.png --graph-days 14
# 2 */2 * * * www-data [ -x /usr/bin/licstatus ] && [ -f /var/spool/emulicstatus/emu.rrd ] && [ -d /var/www/html ] && /usr/bin/licstatus --rrdfile /var/spool/emulicstatus/emu.rrd --mode=graph --graph-to /var/www/html/licstatus-31.png --graph-days 31
# 31 8 * * * www-data [ -x /usr/bin/licstatus ] && [ -f /var/spool/emulicstatus/emu.rrd ] && [ -d /var/www/html ] && /usr/bin/licstatus --rrdfile /var/spool/emulicstatus/emu.rrd --mode=graph --graph-to /var/www/html/licstatus-365.png --graph-days 365

# vim: set syntax=crontab:
