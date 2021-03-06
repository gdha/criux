# usage-workflow.sh
#

function WORKFLOW_help  {
    cat <<EOF
Usage: $PROGRAM [-dDmsSvV] [-c DIR ] COMMAND [-- ARGS...]

$PRODUCT comes with ABSOLUTELY NO WARRANTY; for details see
the GNU General Public License at: http://www.gnu.org/licenses/gpl.html

Available options:
 -c DIR       alternative config directory; instead of /etc/opt/$PROGRAM
 -d           debug mode; log debug messages
 -D           debugscript mode; log every function call
 -m           mail the report to \$MAILDESTINATION  ($MAILDESTINATION)
 -s           simulation mode; show what scripts $PROGRAM would include
 -S           step-by-step mode; acknowledge each script individually
 -v           verbose mode; show more output
 -V           version information

List of commands:
$(
    for workflow in ${WORKFLOWS[@]} ; do
        description=WORKFLOW_${workflow}_DESCRIPTION
        if [[ ! -z "${description}" ]]; then
            printf " %-16s%s\n" $workflow "$(show_var ${description})"
        fi
    done
)

EOF

EXIT_CODE=1
}
