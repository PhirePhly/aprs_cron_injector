# aprs_cron_injector
A simple Bash script for injecting a single APRS object into the APRS-IS
backbone.

Objects are an important way to advertise and locate local services of
value to other amateur radio operators monitoring the APRS network.
Examples of things that may be included as objects include repeaters,
special event deployments, etc.

This script is designed to be run periodically by a system scheduler such
as the Unix cron daemon to repeatedly beacon a single object description.
This beacon will only be sent to the APRS-IS Internet backbone, so further
work is needed to configure RF-gates to correctly gate the beaconed objects
to any local RF LAN.

To use this script, make a local copy of it and edit the set of variables
at the top of the script. Then add a line to your cron table scheduling
this script to be run periodically.

Example:
    $ cp ./aprscroninjector.sh /usr/local/bin/aprs_OBJNAME.sh
    $ $EDITOR /usr/local/bin/aprs_OBJNAME.sh # Configure script header for object
    $ crontab -e # Add a line such as */15 * * * * /usr/local/bin/aprs_OBJNAME.sh


## APRS-IS Configuration Parameters

When multiple injector scripts are being run on a single system, they may use
the same APRS-IS login. 

* Replace APRS_CALL="N0CALL" with your legal FCC callsign and an SSID
* Replace APRS_PASS=-1 with your APRS-IS passcode calculated from your callsign
* Replace APRS_SERVER=noam.aprs2.net with your local APRS-IS server
* Leave APRS_PORT=14580 unless your needs require a different server port

## Object Configuration Parameters

These parameters control the information beaconed as the object.

* OBJ_NAME - This must be a nine character globally unique name for the object.
Pad the name with spaces to reach the nine character requirement
* OBJ_LAT - DDMM.mmN or DDMM.mmS latitude of the object. Replace least significant
digits with spaces to locate the object less specifically
* OBJ_LONG - DDDMM.mmE or DDDMM.mmW longitude of the object.
Replace least significant digits with spaces to locate the object less specifically
* OVERLAY + SYMBOL - The table selector and symbol selector based on 
the APRS icon set (see http://www.aprs.org/symbols.html)
* OBJ_COMMENT - A <40 character comment describing the object

