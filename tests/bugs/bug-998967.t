#!/bin/bash
. $(dirname $0)/../include.rc
. $(dirname $0)/../volume.rc

cleanup;

TEST glusterd
TEST pidof glusterd
TEST $CLI volume create $V0 $H0:$B0/${V0}{0,1}
TEST $CLI volume start $V0;

TEST glusterfs --acl --volfile-server=$H0 --volfile-id=$V0 $M0;

TEST touch $M0/file

# Create a file noone would be able to access, despite "nobody" user's read bit
# is set, as a mask masks it out
TEST setfacl --restore=- <<EOF
# file: $M0/file
# owner: root
# group: root
user::---
user:nobody:r--
group::---
mask::---
other::---
EOF

# Now turn on the read bit in mask
TEST chmod 040 $M0/file

# Access fails if entry known to FUSE is not invalidated
TEST "su nobody -s $SHELL -c 'cat $M0/file'"

# Entry cache expires in a second (default entry-timeout), so this access
# succeeds even without invalidation
sleep 1
TEST "su nobody -s $SHELL -c 'cat $M0/file'"

TEST $CLI volume stop $V0;
TEST $CLI volume delete $V0;

cleanup;
