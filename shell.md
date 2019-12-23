Bash参考手册（http://www.gnu.org/software/bash/manual/bash.html）
书 [《Linux命令行与shell脚本编程大全第4版》](https://pan.baidu.com/s/13TW7j7CxajMw_e0iDp8akQ)
提取码：jmav 

ps命令参数 P65页


env
printenv
set

默认环境变量各参数说明 p110页

useradd usermod
passwd chpasswd
chsh chfn chage

groupadd groupmod

SUID SGID 和粘着位
二进制值 八进制值 	描 述
000 	 0 		所有位都清零
001 	 1 		粘着位置位
010 	 2 		SGID位置位
011 	 3 		SGID位和粘着位都置位
100 	 4 		SUID位置位
101 	 5	 	SUID位和粘着位都置位
110 	 6 		SUID位和SGID位都置位
111 	 7 		所有位都置位

fdisk mkefs mkfs.ext4 fsck

yum remove
yum erase
yum deplist
yum clean all

vim nano emacs KWrite Kate GNOME
vim:
hjkl   ←↓↑→
Ctrl+F Ctrl+B
G 最后一行

expr 和 [] p223页
字符比较	p242页
文件比较 p246
双括号命令	P256
```
if  for while until 

$# $* $@ ${!$#} 区别
$#		#shell会将$#变量设为命令行输入的参数总数
$@		#$@变量将所有变量都保存为单独的词
$*		#变量会将所有参数当成单个参数，而$@变量会单独处理每个参数
shift 	 #移除变量  只能移掉一次，shift命令通过对位置参数进行轮转的方式来操作命令行参数。就算不知道有多少个参数，令也可以轻松遍历参数。
getopt 	#格式化脚本所携带的任何命令行选项或参数,不能处理双引号
getopts	#内建于bash shell
set --	 #双破折线（--），它会将命令行参数替换成set命令的命令行值
```

常用linux 选项含义 P305
```
read	#获取用户输入   read 变量名
-p	#指定提示符
-t	#指定一个计时器
-n	#限定字符，自动退出
-s	#隐藏输入字符
#cat 加管道符 输入到read处理读取文件内容 循环输出 
```

文件描述符号 0(<)STDIN ，1( 1> )STDOUT，2 (2>)STDERR  &> 
```
exec	#并将STDOUT文件描述符重定向到文件
exec 0< xx.txt   # while read xxx 去读取
exec 2> xxx.log
exec 1> xxx.log
exec 3> xxx.log  #自定义描述符
echo "xxxxx" >&3
exec 3>&1
exec 1>xxx.log
exec 3<> xxx.txt
exec 3>&-	#关闭文件描述符3  关闭后不能再写入文件描述符3  否则会报错
```

lsof #列出打开的文件描述符,用的文件描述符只有9个当前PID，可以用特殊环境变量$$（shell会将它设为当前PID）。-a选项用来对其他两个选项的结果执行布尔AND运算
lsof  的默认输出
```
$ lsof -a -p $$ -d 0,1,2 
COMMAND   PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
bash    15978 root    0u   CHR  136,1      0t0    4 /dev/pts/1
bash    15978 root    1u   CHR  136,1      0t0    4 /dev/pts/1
bash    15978 root    2u   CHR  136,1      0t0    4 /dev/pts/1
$
列 				描 述
COMMAND 	正在运行的命令名的前9个字符
PID 		进程的PID
USER		进程属主的登录名
FD 		 文件描述符号以及访问类型（r代表读，w代表写，u代表读写）
TYPE		文件的类型（CHR代表字符型，BLK代表块型，DIR代表目录，REG代表常规文件）
DEVICE  	设备的设备号（主设备号和从设备号）
SIZE		如果有的话，表示文件的大小
NODE		本地文件的节点号
NAME		文件名
```
mktemp -t #在/tmp下创建临时文件，返回全路径  -d 创建临时目录
tee
```
linux #信号量
信 号 	  值 		 描 述
1 		SIGHUP 		挂起进程
2 		SIGINT 		终止进程
3 		SIGQUIT 	停止进程
9 		SIGKILL 	无条件终止进程
15 		SIGTERM 	尽可能终止进程
17 		SIGSTOP 	无条件停止进程，但不是终止进程
18 		SIGTSTP 	停止或暂停进程，但不终止进程
19 		SIGCONT 	继续运行停止的进程
......
```
bash shell会处理收到的SIGHUP (1)和SIGINT (2)信号 其他忽略

Ctrl+C组合键会生成SIGINT信号
Ctrl+Z组合键会生成一个SIGTSTP信号

trap命令允许你来指定shell脚本要监看并从shell中拦截的Linux信号
如果脚本收到了trap命令中列出的信号，该信号不再由shell处理，而是交由本地处理
trap命令的格式：
```
trap commands signals
```
&
nohup
fg
bg
jobs
nice #命令允许你设置命令启动时的调度优先级
renice	#想改变系统上已运行命令的优先级
定时
at
crontab

使用其它SHELL  p497 第二十三章