# dump-workflow.sh
#
# dump workflow for Relax & Recover
#
#    Relax & Recover is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.

#    Relax & Recover is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.

#    You should have received a copy of the GNU General Public License
#    along with Relax & Recover; if not, write to the Free Software
#    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#
#

WORKFLOW_dump_DESCRIPTION="Dump configuration and system information"
WORKFLOWS=( ${WORKFLOWS[@]} dump )
WORKFLOW_dump () {
	LogPrint "Dumping out configuration and system information"

	LogPrint "System definition:"
	for var in "ARCH" "OS" "OS_VENDOR" "OS_VERSION" "OS_VENDOR_ARCH" "OS_VENDOR_VERSION" "OS_VENDOR_VERSION_ARCH"; do
		LogPrint "$( printf "%40s = %s" "$var" "${!var}" )"	
	done

	LogPrint "Configuration tree:"
	for config in "$ARCH" "$OS" "$OS_VENDOR" "$OS_VENDOR_ARCH" "$OS_VENDOR_VERSION" "$OS_VENDOR_VERSION_ARCH" ; do
		LogPrint "$( printf "%40s : %s" "$config".conf "$(
								test -s $SHARE_DIR/conf/"$config".conf && echo OK || echo missing/empty
								)" )"
	done
	for config in site local ; do
		LogPrint "$( printf "%40s : %s" "$config".conf "$(
								test -s $CONFIG_DIR/"$config".conf && echo OK || echo missing/empty
								)" )"
	done
	
	LogPrint "Backup with $BACKUP"
	for opt in $(eval echo '${!'"$BACKUP"'_*}') ; do
		LogPrint "$( printf "%40s = %s" "$opt" "${!opt}" )"
	done

	case "$BACKUP" in
		NETFS)
		LogPrint "Backup program is '$BACKUP_PROG':"
		for opt in $(eval echo '${!BACKUP_PROG*}') ; do
			LogPrint "$( printf "%40s = %s" "$opt" "$(eval 'echo "${'"$opt"'[@]}"')" )"
		done
		;;
	esac
	
	LogPrint "Output to $OUTPUT"
	for opt in $(eval echo '${!'"$OUTPUT"'_*}') RESULT_MAILTO ; do
		LogPrint "$( printf "%40s = %s" "$opt" "$(eval 'echo "${'"$opt"'[@]}"')" )"
	done

	Print ""
	
	echo "$SHARE_DIR/lib/validated/$OS_VENDOR_VERSION_ARCH.txt" 
	if test -s "$SHARE_DIR/lib/validated/$OS_VENDOR_VERSION_ARCH.txt" ; then
		LogPrint "Your system is validated with the following details:"
		while read -r ; do
			LogPrint "$REPLY"
		done <"$SHARE_DIR/lib/validated/$OS_VENDOR_VERSION_ARCH.txt"
	else
		LogPrint "Your system is not yet validated. Please carefully check all functions"
		LogPrint "and create a validation record with '$0 validate'. This will help others"
		LogPrint "to know about the validation status of $PRODUCT on this system."
	fi

}