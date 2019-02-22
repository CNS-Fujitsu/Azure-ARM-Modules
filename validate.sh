#!/usr/bin/env bash
# Description: File to validate json files
# Iterate over the arm Module files

#TODO: Validate CF template > Validate matching name parameter file >  validate param file - DONE
#TODO: Ensure matching parameter file is present - DONE
#TODO: Do we want to halt the program when a matching parameter file is NOT present? - DONE
#TODO: Enhance validation to include yaml - DONE
#TODO: Refactor to handle generic codebase - DONE


colblk='\033[0;30m' # Black - Regular
colred='\033[0;31m' # Red
colgrn='\033[0;32m' # Green
colylw='\033[0;33m' # Yellow
colpur='\033[0;35m' # Purple
colrst='\033[0m'    # Text Reset

verbosity=4

### verbosity levels
silent_lvl=0
crt_lvl=1
err_lvl=2
wrn_lvl=3
ntf_lvl=4
inf_lvl=5
dbg_lvl=6

## esilent prints output even in silent mode
esilent () { verb_lvl=${silent_lvl} elog "$@" ;}
enotify () { verb_lvl=${ntf_lvl} elog "$@" ;}
eok ()    { verb_lvl=${ntf_lvl} elog "${colgrn}SUCCESS${colrst} ---- $@" ;}
ewarn ()  { verb_lvl=${wrn_lvl} elog "${colylw}WARNING${colrst} - $@" ;}
einfo ()  { verb_lvl=${inf_lvl} elog "${colwht}INFO${colrst} ---- $@" ;}
edebug () { verb_lvl=${dbg_lvl} elog "${colgrn}DEBUG${colrst} --- $@" ;}
eerror () { verb_lvl=${err_lvl} elog "${colred}ERROR${colrst} --- $@" ;}
ecrit ()  { verb_lvl=${crt_lvl} elog "${colpur}FATAL${colrst} --- $@" ;}
edumpvar () { for var in $@ ; do edebug "$var=${!var}" ; done }
elog() {
        if [ ${verbosity} -ge ${verb_lvl} ]; then
                datestring=`date +"%Y-%m-%d %H:%M:%S"`
                echo -e "${datestring} - $@"
        fi
}

case $2 in
    -s)
            verbosity=${silent_lvl}
            edebug "-s specified: Silent mode"
            ;;
    -V)
            verbosity=${inf_lvl}
            edebug "-V specified: Verbose mode"
            ;;
    -G)
            verbosity=${dbg_lvl}
            edebug "-G specified: Debug mode"
            ;;
esac

check_output () {
    if [[ $1 -eq 0 ]]
    then
        einfo "Processing completed."
    else
        eerror "Processing encountered a failure. Exiting with status: $1"
        exit $1
    fi
}

process_templates () {
    case ${1} in
        "json")
                key="json"
                ;;
        "yaml")
                key="yaml"
                ;;
        *)
                eerror "Unknown key supplied. Please supply json | yaml."
                check_output 2
                ;;
    esac

    einfo "key is: ${key}"

    einfo "Target directory: ${baseDirectory}"

    templates=`ls ${baseDirectory}/modules/*.${key}`

    for filename in ${templates}
    do
        baseFileName=$(basename ${filename})

        einfo "Working: ${baseFileName}"

        templateBasename=`echo ${baseFileName} | cut -f1 -d"."`

        if [[ `find ${baseDirectory}/parameters -name parameter-${templateBasename}.${key}` ]]
        then
            cd ${baseDirectory}/modules
            validate_${key} ${filename}
            einfo "Working: ${templateBasename}.${key}"
            cd ${baseDirectory}/parameters
            validate_${key} parameter-${templateBasename}.${key}
        else
            eerror "Matching parameter file not found for: ${baseFileName} "
            check_output 2
        fi
    done
    eok "Processing completed."
}


validate_json (){
    cat ${1} | jq empty
    check_output $?
}

validate_yaml() {
    python -c 'import yaml, sys; yaml.safe_load(sys.stdin)' < $1
    check_output $?
}

# Init program validation of input parameters. Expecting the path to templates.
if [[ -z $1 ]]
then
    eerror "Please supply the working folder"
    exit $?
else
    baseDirectory=$1
fi

process_templates "json"