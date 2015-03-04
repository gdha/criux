criux
=====

# CRIUX (investigate clustered unix systems)

### License

GPLv3

### Usage

This project aims at creating a Korn shell scripting environment which should be portable between Linux, HP-UX, Solaris and AIX.
Each OS can have its own directory tree as we can see with the following dump command (on Linux):

````
$ sudo opt/criux/bin/criux -v dump
criux 1.0 / Git
Using log file: /home/gdhaese1/projects/criux/var/opt/criux/log/criux-32259-LOGFILE.log
Dumping out configuration and system information
This is a 'Linux-x86_64' system, compatible with 'Linux-i386'.
System definition:
                                    ARCH = Linux-i386
                                      OS = GNU/Linux
                        OS_MASTER_VENDOR =
                       OS_MASTER_VERSION =
                   OS_MASTER_VENDOR_ARCH =
                OS_MASTER_VENDOR_VERSION =
           OS_MASTER_VENDOR_VERSION_ARCH =
                               OS_VENDOR = suse
                              OS_VERSION = 11
                          OS_VENDOR_ARCH = suse/x86_64
                       OS_VENDOR_VERSION = suse/11
                  OS_VENDOR_VERSION_ARCH = suse/11/x86_64
Configuration tree:
                         Linux-i386.conf : missing/empty
                          GNU/Linux.conf : missing/empty
                               suse.conf : missing/empty
                        suse/x86_64.conf : missing/empty
                            suse/11.conf : missing/empty
                     suse/11/x86_64.conf : missing/empty
                               site.conf : missing/empty
                              local.conf : OK

````

And on HP-UX:


````
#-> opt/criux/bin/criux dump
criux 1.0 / Git
Using log file: /home/gdhaese1/projects/criux/var/opt/criux/log/criux-14950-LOGFILE.log
Dumping out configuration and system information
System definition:
                                    ARCH = HP-UX-ia64
                                      OS = HP-UX
                        OS_MASTER_VENDOR =
                       OS_MASTER_VERSION =
                   OS_MASTER_VENDOR_ARCH =
                OS_MASTER_VENDOR_VERSION =
           OS_MASTER_VENDOR_VERSION_ARCH =
                               OS_VENDOR = HP-UX
                              OS_VERSION = 11.31
                          OS_VENDOR_ARCH = HP-UX/ia64
                       OS_VENDOR_VERSION = HP-UX/11.31
                  OS_VENDOR_VERSION_ARCH = HP-UX/11.31/ia64
Configuration tree:
                         HP-UX-ia64.conf : missing/empty
                              HP-UX.conf : OK
                              HP-UX.conf : OK
                         HP-UX/ia64.conf : missing/empty
                        HP-UX/11.31.conf : missing/empty
                   HP-UX/11.31/ia64.conf : missing/empty
                               site.conf : missing/empty
                              local.conf : OK
````

And, on SunOS:


````
# opt/criux/bin/criux dump
criux 1.0 / Git
Using log file: /export/home/gdhaese1/projects/criux/var/opt/criux/log/criux-9325-LOGFILE.log
Dumping out configuration and system information
System definition:
                                    ARCH = SunOS-sun4u
                                      OS = SunOS
                        OS_MASTER_VENDOR =
                       OS_MASTER_VERSION =
                   OS_MASTER_VENDOR_ARCH =
                OS_MASTER_VENDOR_VERSION =
           OS_MASTER_VENDOR_VERSION_ARCH =
                               OS_VENDOR = SunOS
                              OS_VERSION = 5.10
                          OS_VENDOR_ARCH = SunOS/sun4u
                       OS_VENDOR_VERSION = SunOS/5.10
                  OS_VENDOR_VERSION_ARCH = SunOS/5.10/sun4u
Configuration tree:
                        SunOS-sun4u.conf : missing/empty
                              SunOS.conf : missing/empty
                              SunOS.conf : missing/empty
                        SunOS/sun4u.conf : missing/empty
                         SunOS/5.10.conf : missing/empty
                   SunOS/5.10/sun4u.conf : missing/empty
                               site.conf : missing/empty
                              local.conf : OK
````


Each OS can have its own configuration files as well (be careful the configuration file should be treated as shell scripts as these are sourced by the main script).

The help command shows the existing commands know by criux:

````
$ sudo opt/criux/bin/criux -h
Usage: criux [-dDsSvV] [-c DIR ] COMMAND [-- ARGS...]

criux comes with ABSOLUTELY NO WARRANTY; for details see
the GNU General Public License at: http://www.gnu.org/licenses/gpl.html

Available options:
 -c DIR       alternative config directory; instead of /etc/opt/criux
 -d           debug mode; log debug messages
 -D           debugscript mode; log every function call
 -s           simulation mode; show what scripts criux would include
 -S           step-by-step mode; acknowledge each script individually
 -v           verbose mode; show more output
 -V           version information

List of commands:
 dump            dump configuration and system information
 mkdist          create a compressed tar archive distribution
 purgelogs       purge the LOG [/home/gdhaese1/projects/criux/var/opt/criux/log] directory
````


