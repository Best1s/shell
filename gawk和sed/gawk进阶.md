###**使用变量**
内建变量
1. 字段和记录分隔符变量
```
变 量 					描 述
FIELDWIDTHS 	由空格分隔的一列数字，定义了每个数据字段确切宽度
FS 			 输入字段分隔符
RS 			 输入记录分隔符
OFS 			输出字段分隔符
ORS 			输出记录分隔符
	*默认情况下，awk将OFS设成一个空格
	*设置FIELDWIDTH变量，awk会忽略FS变量
	*FIELDWIDTHS变量值一旦设定，就不能再改变。不适用于变成字段。
```
```
$ cat data1
data11,data12,data13,data14,data15
data21,data22,data23,data24,data25
data31,data32,data33,data34,data35
$
$ gawk 'BEGIN{FS=","} {print $1,$2,$3}' data1
data11 data12 data13
data21 data22 data23
data31 data32 data33
$ 
$
$ gawk 'BEGIN{FS=","; OFS="-"} {print $1,$2,$3}' data1
data11-data12-data13
data21-data22-data23
data31-data32-data33
$ gawk 'BEGIN{FS=","; OFS="--"} {print $1,$2,$3}' data1
data11--data12--data13
data21--data22--data23
data31--data32--data33
$ gawk 'BEGIN{FS=","; OFS="<-->"} {print $1,$2,$3}' data1
data11<-->data12<-->data13
data21<-->data22<-->data23
data31<-->data32<-->data33
$  
```
2. 数据变量
```
变 量 				描 述
ARGC			当前命令行参数个数
ARGIND		  当前文件在ARGV中的位置
ARGV			包含命令行参数的数组
CONVFMT		 数字的转换格式（参见printf语句），默认值为%.6 g
ENVIRON		 当前shell环境变量及其值组成的关联数组
ERRNO		   当读取或关闭输入文件发生错误时的系统错误号
FILENAME		用作gawk输入数据的数据文件的文件名
FNR 			当前数据文件中的数据行数
IGNORECASE 	 设成非零值时，忽略gawk命令中出现的字符串的字符大小写
NF 			 数据文件中的字段总数
NR 			 已处理的输入记录数
OFMT 		   数字的输出格式，默认值为%.6 g
RLENGTH 		由match函数所匹配的子字符串的长度
RSTART 		 由match函数所匹配的子字符串的起始位置
```

自定义变量

 1. 在脚本中给变量赋值
```
$ gawk '
> BEGIN{
> testing="This is a test"
> print testing
> }'
This is a test
$
$ gawk 'BEGIN{x=4; x= x * 2 + 3; print x}'
11
$ 
```
 2. 在命令行上给变量赋值
```
$ cat script1
BEGIN{FS=","}
{print $n}
$ gawk -f script1 n=2 data1
data12
data22
data32
$ gawk -f script1 n=3 data1
data13
data23
data33
$
$
$ gawk -v n=3 -f script2 data1
The starting value is 3
data13
data23
data33
$
```

###**处理数组**
gawk编程语言使用关联数组提供数组功能。
1. 数组变量赋值的格式如下：
```
var[index] = element		#var是变量名，index是关联数组的索引值，element是数据元素值。
```
```
		#引用数组变量时，必须包含索引值来提取相应的数据元素值。
$ gawk 'BEGIN{
> capital["Illinois"] = "Springfield"
> print capital["Illinois"]
> }'
Springfield
$
		#在引用数组变量时，会得到数据元素的值。数据元素值是数字值时也一样。
$ gawk 'BEGIN{
> var[1] = 34
> var[2] = 3
> total = var[1] + var[2]
> print total
> }'
37
$ 
```
2. **删除数组变量**
```
delete array [index] 
```
删除命令会从数组中删除关联索引值和相关的数据元素值。
```
$ gawk 'BEGIN{
> var["a"] = 1
> var["g"] = 2
> for (test in var)
> {
> print "Index:",test," - Value:",var[test]
> }
> delete var["g"]
> print "..."
> for (test in var)
> print "Index:",test," - Value:",var[test]
> }'
Index: a - Value: 1
Index: g - Value: 2
...
Index: a - Value: 1
$ 
```

###**使用模式**
1. 使用正则表达式匹配
在使用正则表达式时，正则表达式必须出现在它要控制的程序脚本的左花括号前。
```
$ gawk '/root/{print $0}' /etc/passwd
$root:x:0:0:root:/root:/bin/bash
$operator:x:11:0:operator:/root:/sbin/nologin
$ 
```
2. **匹配操作符**
匹配操作符（matching operator）允许将正则表达式限定在记录中的特定数据字段。匹配操作符是波浪线（~）。
```
		#查找文本root,如果在记录中找到了这个模式,打印该记录的第一个和最后一个数据字段值。
$gawk 'BEGIN {FS=":"} $1 ~ /root/{print $1,$NF}' /etc/passwd
$root /bin/bash
$
		#可以用!符号来排除正则表达式的匹配。
$gawk 'BEGIN {FS=":"} $1 !~ /root/{print $1,$NF}' /etc/passwd
$bin /sbin/nologin
$daemon /sbin/nologin
$shutdown /sbin/shutdown
...
$
```
3. **数学表达式**
```
		#显示所有属于root用户组（组ID为0）的系统用户
$ gawk -F: '$4 == 0{print $1}' /etc/passwd
root
sync
shutdown
halt
operator
$
```
可以使用任何常见的数学比较表达式。
 x == y：值x等于y。
 x <= y：值x小于等于y。
 x < y：值x小于y。
 x >= y：值x大于等于y。
 x > y：值x大于y。
也可以对文本数据使用表达式，表达式必须完全匹配。
```
$awk  -F : '$1=="root" {print $0}' /etc/passwd
$root:x:0:0:root:/root:/bin/bash
$
```

###**结构化命令**
gawk编程语言支持常见的结构化编程命令
1. **if语句**
gawk编程语言支持标准的if-then-else格式的if语句。
格式
```
if (condition)
 	statement1
也可以将它放在一行上：
if (condition) statement1
```
```
$ cat data4
10
13
50
34
$ gawk '{if ($1 > 20) print $1}' data4
50
34
$
```
gawk的if语句也支持else子句
```
$ gawk '{
> if ($1 > 20)
> {
> x = $1 * 2
> print x
> } else
> { 
> x = $1 / 2
> print x
> }}' data4
5
6.5
100
68
$
```
可以在单行上使用else子句，但必须在if语句部分之后使用分号。
```
$ gawk '{if ($1 > 20) print $1 * 2; else print $1 / 2}' data4
5
6.5
100
68
$
```
2. **while 语句**
while语句为gawk程序提供了一个基本的循环功能。
while语句的格式:
```
while (condition)
{
 statements
}
```
while循环允许遍历一组数据，并检查迭代的结束条件。
```
$ cat data5
130 120 135
160 113 140
145 170 215
$ gawk '{
> total = 0
> i = 1
> while (i < 4)
> {
> total += $i
> i++
> }
> avg = total / 3
> print "Average:",avg
> }' data5
Average: 128.333
Average: 137.667 
Average: 176.667
$ 
```
gawk编程语言支持在while循环中使用break语句和continue语句
3. **do-while 语句**
这种格式保证了语句会在条件被求值之前至少执行一次。
格式:
```
do
{
 statements
} while (condition)
```
4. **for 语句**
gawk编程语言支持C风格的for循环。
格式：
```
for( variable assignment; condition; iteration process)
```
将多个功能合并到一个语句有助于简化循环。
```
$ gawk '{
> total = 0
> for (i = 1; i < 4; i++)
> {
> total += $i
> }
> avg = total / 3
> print "Average:",avg
> }' data5
Average: 128.333
Average: 137.667
Average: 176.667
$ 
```

###格式化打印
gawk中的printf命令用法和C语言的printf用法一样
printf命令的格式：
```
printf "format string", var1, var2 . . . 
```
格式化指定符采用如下格式：
```
%[modifier]control-letter
```
格式化指定符的控制字母
```
控制字母 			描 述
c 			将一个数作为ASCII字符显示
d 			显示一个整数值
i 			显示一个整数值（跟d一样）
e 			用科学计数法显示一个数
f 			显示一个浮点值
g 			用科学计数法或浮点数显示（选择较短的格式）
o 			显示一个八进制值
s 			显示一个文本字符串
x 			显示一个十六进制值
X 			显示一个十六进制值，但用大写字母A~F 
```
控制字母外，还有3种修饰符可以用来进一步控制输出。
```
width：指定了输出字段最小宽度的数字值。如果输出短于这个值，printf会将文本右对齐，并用空格进行填充。
	   如果输出比指定的宽度还要长，则按照实际的长度输出。

prec：这是一个数字值，指定了浮点数中小数点后面位数，或者文本字符串中显示的最大字符数。

-（减号）：指明在向格式化空间中放入数据时采用左对齐而不是右对齐。
```
###内建函数 
1. gawk中内建的数学函数。如下
```
函 数 					描 述
atan2(x, y) 	   x/y的反正切，x和y以弧度为单位
cos(x) 			x的余弦，x以弧度为单位
exp(x) 			x的指数函数
int(x) 			x的整数部分，取靠近零一侧的值
log(x) 			x的自然对数
rand() 			比0大比1小的随机浮点值
sin(x) 			x的正弦，x以弧度为单位
sqrt(x) 		   x的平方根
srand(x) 		  为计算随机数指定一个种子值
```
2. 标准数学函数外，gawk还支持一些按位操作数据的函数。
```
and(v1, v2)：执行值v1和v2的按位与运算。
compl(val)：执行val的补运算。
lshift(val, count)：将值val左移count位。
or(v1, v2)：执行值v1和v2的按位或运算。
rshift(val, count)：将值val右移count位。
xor(v1, v2)：执行值v1和v2的按位异或运算。		#位操作函数在处理数据中的二进制值时非常有用。
```
3. gawk编程语言还提供了一些可用来处理字符串值的函数.
```
函 数 					描 述
asort(s [,d]) 	将数组s按数据元素值排序。索引值会被替换成表示新的排序顺序的连续数字。另外，果指定了d，则排序后的数组会存储在数组d中
asorti(s [,d]) 	将数组s按索引值排序。生成的数组会将索引值作为数据元素值，用连续数字索引来表明排序顺序。另外如果指定了d，排序后的数组会存储在数组d中
gensub(r, s, h [, t]) 	查找变量$0或目标字符串t（如果提供了的话）来匹配正则表达式r。如果h是一个以g或G开头的字符串，就用s替换掉匹配的文本。如果h是一个数字，它表示要替换掉第h处r匹配的地方
gsub(r, s [,t]) 	查找变量$0或目标字符串t（如果提供了的话）来匹配正则表达式r。如果找到了，就全部替换成字符串s
index(s, t) 	返回字符串t在字符串s中的索引值，如果没找到的话返回0
length([s]) 	返回字符串s的长度；如果没有指定的话，返回$0的长度
match(s, r [,a]) 	返回字符串s中正则表达式r出现位置的索引。如果指定了数组a，它会存储s中匹配正则表达式的那部分
split(s, a [,r]) 	将s用FS字符或正则表达式r（如果指定了的话）分开放到数组a中。返回字段的总数
sprintf(format,variables)	用提供的format和variables返回一个类似于printf输出的字符串
sub(r, s [,t]) 	在变量$0或目标字符串t中查找正则表达式r的匹配。如果找到了，就用字符串s替换掉第一处匹配
substr(s, i [,n]) 返回s中从索引值i开始的n个字符组成的子字符串。如果未提供n，则返回s剩下的部分
tolower(s) 	将s中的所有字符转换成小写
toupper(s) 	将s中的所有字符转换成大写
```
4. 时间函数
```
函 数 							描 述
mktime(datespec) 		将一个按YYYY MM DD HH MM SS [DST]格式指定的日期转换成时间戳值①
strftime(format[,timestamp])		将当前时间的时间戳或timestamp（如果提供了的话）转化格式化日期（采用shell函数date()的格式）
systime( ) 返回当前时间的时间戳
```

**自定义函数**
要定义自己的函数，必须用function关键字,函数名必须能够唯一标识函数。可以在调用的gawk程序中传给这个函数一个或多个变量。
格式如下:
```
function name([variables])
{
 statements
}
```
**使用自定义函数**
在定义函数时，它必须出现在所有代码块之前（包括BEGIN代码块）。
```
$ gawk '
> function myprint()
> {
> printf "%-16s - %s\n", $1, $4
> }
> BEGIN{FS="\n"; RS=""}
> {
> myprint()
> }' data2
Riley Mullen - (312)555-1234
Frank Williams - (317)555-9876
Haley Snell - (313)555-4938
$ 
```
**创建函数库**
gawk提供了一种途径来将多个函数放到一个库文件中.
```
$ cat funclib
function myprint()
{
 printf "%-16s - %s\n", $1, $4
}
function myrand(limit)
{
 return int(limit * rand())
}
function printthird()
{
 print $3
}
$ 
```
使用库，只要创建一个含有你的gawk程序的文件，然后在命令行上同时指定库文件和程序文件就行了
```
$ cat script4
BEGIN{ FS="\n"; RS=""}
{
 myprint()
}
$ gawk -f funclib -f script4 data2
Riley Mullen - (312)555-1234
Frank Williams - (317)555-9876
Haley Snell - (313)555-4938
$
```
