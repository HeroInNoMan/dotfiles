#!/usr/bin/env bash

# exit shell with err_code
# $1 : err_code
# $2 : err_msg
exit_on_err() {
  [[ ! -z "${2}" ]] && echo "${2}" 1>&2
  exit ${1}
}

log() {
  echo $(date "+%F %T") $@
}

parse_arguments() {
  POSITIONAL=()
  while [[ $# -gt 0 ]]
  do
    key="$1"

    case $key in
      -h|--help)
        usage
        exit 0
        ;;
      --versions)
        list_versions
        exit 0
        ;;
      --use-version)
        USE_VERSION="$2"
        shift # past argument
        shift # past value
        ;;
      -v|--verbose)
        VERBOSE=true
        shift # past argument
        ;;
      --default)
        DEFAULT=YES
        shift # past argument
        ;;
      *)    # unknown option
        POSITIONAL+=("$1") # save it in an array for later
        shift # past argument
        ;;
    esac
  done
  set -- "${POSITIONAL[@]}" # restore positional parameters
}
