#/usr/bin/sh
if [ -z $1 ];then
	echo "Usage: $0 nginix_log_path "
	exit 2
fi
if [ -f $1 ];then
	logfile=$1
else
	echo "plase input nginx log path!"
	exit 2
fi
#read -p "请输入日志开始时间(默认昨天 格式:$(date -d yesterday +"%d/%b/%Y"))" yesterday
#yesterday=$(date -d yesterday +"%Y%m%d")
read -p "请输入日志时间(默认昨天 格式:$(date -d yesterday +"%d/%b/%Y")) :" date
if [ -z $date ];then
	date=$(date -d yesterday +"%d/%b/%Y")
elif  [ ! `echo "$date" |sed -n '/[0-9]\{1,2\}\/[A-Z][a-z]\{2\}\/[0-9]\{4\}$/p' ` ];then
	echo "格式错误！"
	exit 5	
fi
echo "-------$date-----file:$logfile-------------------" >> every_hour_pv_$1
echo "-------$date-----file:$logfile-------------------" >> max_everysec_pv_$1
#每小时的访问量
for i in $(seq 0 23)
do
	if [ $i -lt 10 ];then
		everyhour_pv=`cat $logfile | grep "$date:0$i" |wc -l`
		echo "Count PV on 0$i-hour is  $everyhour_pv" >> every_hour_pv_$1
	else
		everyhour_pv=`cat $logfile |grep "$date:$i" |wc -l`
		echo "Count PV on $i-hour is  $everyhour_pv" >> every_hour_pv_$1
	fi
	
done
#每秒钟的最高访问量,只要前300条数据
grep $date $logfile |awk -F '[' '{print $2}' | awk '{print $1}' | sort | uniq -c |sort -k1,1nr |head -n 300 >> max_everysec_pv_$1
