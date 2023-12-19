#!/bin/bash

grep -lr -e 'localhost' /home/devops/app/product/19.3.0.0/dbhome_1/network/admin/listener.ora | xargs sed -i 's/localhost/obdxdb.in.oracle.com/g'

grep -lr -e 'localhost' /home/devops/app/product/19.3.0.0/dbhome_1/network/admin/tnsnames.ora | xargs sed -i 's/localhost/obdxdb.in.oracle.com/g'

sh -x /home/devops/scripts/db_start.sh