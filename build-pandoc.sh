#!/bin/bash

# Temporary documentation build script until proper infrastructure is in
# place

set -e

build_pandoc ()
{
	P=doc/$1/$2
	N=$1-$2
	T="$PWD"
	shift
	shift

	(cd $P
		# Normalize, so that pandoc is not confused by numbered links with
		# same numbers across multiple source files
		rm -rf stage
		mkdir -p stage
		for i in $@; do pandoc -t markdown -o stage/$i markdown/$i; done
		F2="$(for i in $@; do echo stage/$i; done)"

		pandoc -f markdown -t html $F2 -o "$T"/$N.html
		pandoc -o "$T"/$N.pdf $F2
	)
}

build_pandoc admin-guide en-US		\
	Book_Info.md			\
	Preface.md			\
	gfs_introduction.md		\
	admin_start_stop_daemon.md	\
	admin_console.md		\
	admin_storage_pools.md		\
	admin_setting_volumes.md	\
	admin_settingup_clients.md	\
	admin_managing_volumes.md	\
	admin_geo-replication.md	\
	admin_directory_Quota.md	\
	admin_monitoring_workload.md	\
	admin_ACLs.md			\
	admin_UFO.md			\
	admin_Hadoop.md			\
	admin_troubleshooting.md	\
	admin_commandref.md		\
	glossary.md			\
	Revision_History.md

build_pandoc hacker-guide en-US		\
	coding-standard.md		\
	overview.md			\
	translator-development.md	\
	adding-fops.md			\
	write-behind.md			\
	afr.md				\
	posix.md
