# mtppics.sh  

*Copyright 2016 by Ben Cotton* 

*Licensed under the GNU General Public License version 3 (or later). See COPYING.txt for full terms.*

This script is designed to copy pictures off of Android phones to some location on your hard drive.
The KDE MTP stack and Samsung phones don't get along very well, so I wrote this to make it easy for
my wife and I to save off our pictures on a regular basis. The general idea is that you're doing it
on a time-based system (months for now).

## Options

**-l** Use last month as the date

**-s** *string* Use *string* as the date (it must appease [date(1)](http://linux.die.net/man/1/date)).

## Requirements

* `simple-mtpfs`
