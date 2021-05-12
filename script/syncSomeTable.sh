 #!/bin/bash

 # Database info
 DB_USER=""
 DB_PASS=""
 DB_HOST=""
 DB_PORT=""

 # Database array
 DB_NAMES=("")
 STRUCT_ONLY_TABLE=()

 # Others vars
 BIN_DIR="/usr/bin"            #the mysql bin path
 BCK_DIR="/var/www/http/mysqlBackup"    #the backup file directory
 DATE=`date +%F`
 LOG_LOCATION="$BCK_DIR/$DATE/LOG"
 # create file
 mkdir $BCK_DIR/$DATE

 # TODO
 # /usr/bin/mysqldump --opt -ubatsing -pbatsingpw -hlocalhost timepusher > /mnt/mysqlBackup/db_`date +%F`.sql

 for db_name in ${DB_NAMES[@]};
 do
     tables=(
""
)
     mkdir $BCK_DIR/$DATE/$db_name
     for table_name in ${tables[@]};
     do
        if [[ " ${STRUCT_ONLY_TABLE[@]} " =~ " ${table_name} " ]]; then
            echo -e "$table_name only dump construct"$'\n' >> "$LOG_LOCATION"
            $BIN_DIR/mysqldump -u$DB_USER -p$DB_PASS -h$DB_HOST -P$DB_PORT  \
            --no-data $db_name $table_name 2>>"$LOG_LOCATION" > $BCK_DIR/$DATE/$db_name/$table_name
        else
            echo -e "$table_name start at $(date +'%Y-%m-%d %H:%M:%S')"$'\n' >> "$LOG_LOCATION"
#           $BIN_DIR/mysqldump --opt --single-transaction --master-data=2 -u$DB_USER -p$DB_PASS -h$DB_HOST -P$DB_PORT $db_name $table_name 2>"$LOG_LOCATION" >  $BCK_DIR/$DATE/$db_name/db_$table_name.sql
            if $BIN_DIR/mysqldump -u$DB_USER -p$DB_PASS -h$DB_HOST -P$DB_PORT  \
            --max_allowed-packet=1G   --net-buffer-length=32704 --set-gtid-purged=OFF --quick --skip-tz-utc \
            --extended-insert=false --lock-tables=false $db_name $table_name 2>>"$LOG_LOCATION" > $BCK_DIR/$DATE/$db_name/$table_name
            then
                echo -e "$table_name successfully finished at $(date +'%Y-%m-%d %H:%M:%S')"$'\n' >> "$LOG_LOCATION"
            else
                echo -e "$table_name failed at $(date +'%Y-%m-%d %H:%M:%S')"$'\n' >> "$LOG_LOCATION"
            fi
        fi
        echo -e "source $table_name" >> $BCK_DIR/$DATE/$db_name/all.sql
     done
 done

