# EMU license charting tool

This tool EMu license count every five minutes in an RRD and optionally
generates pretty graphs suitable for web display.

Out of the box, the tool's cron job will log EMu license status every five
minutes to an RRD at `/var/spool/emulicstatus/emu.rrd`.

## Quick start

In `/etc/cron.d/emulicstatus`, change `EMUPATH` to point to your EMu
installation.

## Viewing your data

If you have a web server on your EMu system, uncomment the `--mode=graph`
example in `/etc/cron.d/emulicstatus` and edit it according to your
preferences.

If you don't have a web server, you'll need to make arrangements to ship
charts or the RRD file elsewhere for viewing. You could, for example,
generate a nightly e-mail:

```
30 0 * * * root [ -x /usr/bin/licstatus ] && [ -f /var/spool/emulicstatus/emu.rrd ] && /usr/bin/licstatus --rrdfile /var/spool/emulicstatus/emu.rrd --mode=graph --graph-to /var/spool/emulicstatus/licstatus.png && echo 'See attachment' | mail -s 'Yesterday's EMu license report' -A /var/spool/emulicstatus/licstatus.png 
```

