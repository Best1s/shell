*gawk官方手册：http://www.gnu.org/software/gawk/manual/gawk.html*

**gawk**程序提供了一种编程语言而不只是编辑器命令。

在gawk编程语言中，可做下列事情

1）定义变量来保存数据；

2）使用算术和字符串操作符来处理数据；

3）使用结构化编程概念（比如if-then语句和循环）来为数据处理增加处理逻辑；

4）通过提取数据文件中的数据元素，将其重新排列或格式化，生成格式化报告。

gawk程序的基本格式如下(以下用awk代替)
```
awk [选项参数] 'script' var=value file(s)
或
awk [选项参数] -f scriptfile var=value file(s)

选 项 			描 述
-F 			fs 指定行中划分数据字段的字段分隔符
-f			 file 从指定的文件中读取程序
-v 			var=value 定义gawk程序中的一个变量及其默认值,允许你在BEGIN代码之前设定变量
-mf N 		 指定要处理的数据文件中的最大字段数
-mr N 		 指定数据文件中的最大数据行数
-W keyword 	指定gawk的兼容模式或警告等级
```
awk程序脚本用一对花括号来定义。你必须将脚本命令放到两个花括号（{}）中
```
pirntf "a\nb" |awk '{print "Hello World!"}'
#awk程序会针对数据流中的每行文本执行程序脚本
```
awk的主要特性之一是其处理文本文件中数据的能力
$0代表整个文本行；
$1代表文本行中的第1个数据字段；
$2代表文本行中的第2个数据字段；
$n代表文本行中的第n个数据字段。
```
$ cat data2.txt
One line of test text.
Two lines of test text.
Three lines of test text.
$
$ awk '{print $1}' data2.txt
One
Two
Three
$ 
```
如果读取采用了其他字段分隔符的文件，可以用-F选项指定。
```
gawk -F: '{print $1}' /etc/passwd
root
bin
daemon
adm
lp
sync
shutdown
halt
mail
[...] 
```
在程序脚本中使用多个命令

awk编程语言允许多条命令组合,只要在命令之间放个分号即可
```
$ echo "My name is Rich" | awk '{$4="Christine"; print $0}'
My name is Christine
$ 
#第一条命令会给字段变量$4赋值。第二条命令会打印整个数据字段。
```
跟sed编辑器一样，awk编辑器允许将程序存储到文件中
```
$ cat script2.awk
{print $1 "'s home directory is " $6}
$
$ gawk -F: -f script2.awk /etc/passwd
root's home directory is /root
bin's home directory is /bin
daemon's home directory is /sbin
adm's home directory is /var/adm
lp's home directory is /var/spool/lpd
[...]
Christine's home directory is /home/Christine
Samantha's home directory is /home/Samantha
Timothy's home directory is /home/Timothy
$ 
```
在处理数据前运行脚本
awk还允许指定程序脚本何时运行，。默认情况下，awk会从输入中读取一行文本，然后针对该行的数据执行程序脚本
BEGIN会在处理数据前运行脚本
```
$ cat data3.txt
Line 1
Line 2
Line 3
$
$ gawk 'BEGIN {print "The data3 File Contents:"}
> {print $0}' data3.txt
The data3 File Contents:
Line 1
Line 2
Line 3
$ 
```
与BEGIN关键字类似，END关键字允许你指定一个程序脚本，awk会在读完数据后执行它
```
$ gawk 'BEGIN {print "The data3 File Contents:"}
> {print $0}
> END {print "End of File"}' data3.txt
The data3 File Contents:
Line 1
Line 2
Line 3
End of File
$ 
```
