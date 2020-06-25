#! /usr/bin/env bash
SCRIPTPATH=$(cd "$(dirname "$0")" && pwd)
TARGETPATH=$(cd "${SCRIPTPATH}" && cd "../build" && pwd)
BASEPATH=$(cd "${SCRIPTPATH}" && cd ".." && pwd)