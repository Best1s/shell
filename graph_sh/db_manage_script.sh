#!/bin/bash
# A shell script for manage mysql server
# need install dialog package.
if [ ! $? -eq 0 ];then echo "please install dialog" && exit;fi
temp1=`mktemp -t tmp.XXXXXX`
temp_result=`mktemp -t tmp_re.XXXXXX`

db_user=root
db_port=3306
db_host=127.0.0.1

date_now=$(date +%Y%m%d%H%M)

function get_mysql_password {
    dialog --insecure --passwordbox "Enter mysql password:" 10 30 2> $temp_result
}

function get_mysql_dblist {
    mysql -u${db_user} -P${db_port} -p${db_password} -h${db_host} -e "show databases;" >  $temp_result
}

function show_all_databases {
    get_mysql_password
    db_password=`cat $temp_result`
    get_mysql_dblist
    if [ $? -eq 1 ]
    then
        dialog --msgbox "Error password" 10 30
    else
        sed -n '2,$p' $temp_result > $temp1
        dialog --title `sed -n 1p $temp_result` --textbox $temp1 20 60
    fi
}

function dump_selected_database {
    get_mysql_password
    db_password=`cat $temp_result`
    get_mysql_dblist
    if [ $? -eq 1 ]
    then
        dialog --msgbox "Error password" 10 30
	return
    else
        sed -n '2,$p' $temp_result > $temp1
    fi
    checklist_cmd=""

    while read line
    do
        checklist_cmd=$checklist_cmd" "$line" "$line" "$line
    done < $temp1

    # selected db to dump
    dialog --checklist "Databases press space select" 20 60 10 $checklist_cmd 2> $temp1
    arr_sel=`cat $temp1`
    OLD_IFS="$IFS" 
    IFS=" " 
    arr=($arr_sel) 
    IFS="$OLD_IFS" 
    for db_name in ${arr[@]} 
    do 
        mysqldump -u${db_user} -P${db_port} -p${db_password} -h${db_host} --hex-blob --single-transaction -B ${db_name}|gzip >  ./${db_name}_${date_now}.sql.gz
    done
}

while [ 1 ]
do 
    dialog --menu "MySQL Management " 20 50 10 \
        1 "Show all databases" \
        2 "Dump selected database" \
        0 "Exit" \
        2> $temp1

    if [ $? -eq 1 ]
    then
        break
    fi

    selection=`cat $temp1`

    case $selection in
        1)
            show_all_databases
            ;;
        2)
            dump_selected_database
            ;;
        0)
            dialog --title "Tips" --yesno "Sure to exit?" 10 30
            if [ $? -eq 0 ]
            then
                break
            fi
            ;;
        *)
            dialog --title "Error" --msgbox "Invalid selection." 10 30
    esac
done

rm -rf $temp1 2> /dev/null
rm -rf $temp_result 2> /dev/null

