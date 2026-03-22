#!/bin/zsh
# macOs (OSX) ham radio environment startup


if [[ "${1}" == "" ]] ; then
    RADIO_ROOT=~/src/radio
fi

var_munge () {
    eval "value=\"\${$1}\""
    case ":${value}:" in
        *:"$2":*)
            ;;
        *)
            if [[ "$3" = "after" ]] ; then
                eval ${1}=${value}:$2
            else
                eval ${1}=$2:${value}
            fi
    esac
}

var_print() {
    eval "value=\"\${$1}\""
    echo "${1}=${value}"
}

# Initialize conda explicitly
source /Users/natersoz/miniconda3/etc/profile.d/conda.sh

CONDA_ENV=hr
if [[ "${CONDA_DEFAULT_ENV}" != "${CONDA_ENV}" ]] ; then
    conda deactivate
    conda activate ${CONDA_ENV}
fi

CDPATH=""

export PATH
var_munge PATH /opt/hamlib/bin          after
# var_print PATH | tr ':' '\n'

cd ${RADIO_ROOT}

for dev in /dev/cu.SLAB_USBtoUART*; do
    [[ -e "$dev" ]] || continue
    port_number="${dev##*/cu.SLAB_USBtoUART}"
    echo "Found device: $dev (number=${port_number})"
done

# Check if hamlib rigctld is running. If not, start rigctld.
rigctld_pid=`pgrep -x rigctld`
if [[ "${rigctld_pid}" != "" ]] ; then
    echo "rigctld is Running:"
    ps ax ${rigctld_pid}
    echo ""
else
    echo "starting rigctrld"
    rigctld -m 1042 -r /dev/cu.SLAB_USBtoUART${port_number} -t 4532 &
    ps ax |grep rigctld ${rigctld_pid} |grep -v grep
fi

echo "To run not1mm:"
echo "cd not1mm"
echo "python not1mm"

alias rigchk='rigctl -m 2 -r localhost:4532 f'
alias rc='rigchk'
alias rk='rig_kill.sh'
