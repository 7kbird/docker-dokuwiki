#!/bin/bash
set -e

source ${DOKUWIKI_BUILD_DIR}/plugin_installer

plugin_install smtp https://github.com/splitbrain/dokuwiki-plugin-smtp/zipball/master
