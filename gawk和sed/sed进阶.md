**多行命令** 
的sed编辑器命令都是针对单行数据执行操作的。
有时需要对跨多行的数据执行特定操作时候需要多行处理。
sed编辑器包含了三个可用来处理多行文本的特殊命令。
```
N	#将数据流中的下一行加进来创建一个多行组（multiline group）来处理。
D	#删除多行组中的一行。
P	#打印多行组中的一行。

```
小写的n命令会告诉sed编辑器移动到数据流中的下一文本行
```
$ cat data1.txt
This is the header line.

This is a data line.

This is the last line.
$
$ sed '/header/{n ; d}' data1.txt
This is the header line.
This is a data line.

This is the last line.
$ 
```
多行版本的next命令（用大写N）会将下一文本行添加到模式空间中已有的文本后。
```
$ cat data2.txt
This is the header line.
This is the first data line.
This is the second data line.
This is the last line.
$
$ sed '/first/{ N ; s/\n/ / }' data2.txt
This is the header line.
This is the first data line. This is the second data line.
This is the last line.
$
```
如果要在数据文件中查找一个可能会分散在两行中的文本短语的话，这是个很实用的参数
```
$ cat data3.txt
On Tuesday, the Linux System
Administrator's group meeting will be held.
All System Administrators should attend.
Thank you for your attendance.
$
$ sed 'N ; s/System Administrator/Desktop User/' data3.txt
On Tuesday, the Linux System
Administrator's group meeting will be held.
All Desktop Users should attend.
Thank you for your attendance.
$ 
		#替换命令在System和Administrator之间用了通配符模式（.）来匹配空格和换行符
		#但当它匹配了换行符时，它就从字符串中删掉了换行符，导致两行合并成一行
$ sed 'N ; s/System.Administrator/Desktop User/' data3.txt
On Tuesday, the Linux Desktop User's group meeting will be held.
All Desktop Users should attend.
Thank you for your attendance.
$
		#在sed编辑器脚本中用两个替换命令
$ sed 'N
> s/System\nAdministrator/Desktop\nUser/
> s/System Administrator/Desktop User/
> ' data3.txt
On Tuesday, the Linux Desktop
User's group meeting will be held.
All Desktop Users should attend.
Thank you for your attendance.
$
```
sed编辑器命令前将下一行文本读入到模式空间。当它到了最后一行文本时，就没有下一行可读了，所以N命令会叫sed编辑器停止。
如果要匹配的文本正好在数据流的最后一行上，命令就不会发现要匹配的数据。
```
	#System Administrator文本出现在了数据流中的最后一行，N命令会错过它,因为没有其他行可读入到模式空间跟这行合并
$ cat data4.txt
On Tuesday, the Linux System
Administrator's group meeting will be held.
All System Administrators should attend.
$
$ sed 'N
> s/System\nAdministrator/Desktop\nUser/
> s/System Administrator/Desktop User/
> ' data4.txt
On Tuesday, the Linux Desktop
User's group meeting will be held.
All System Administrators should attend.
$ 

```
解决将单行命令放到N命令前面，并将多行命令放到N命令后面
```
$ sed '
> s/System Administrator/Desktop User/
> N
> s/System\nAdministrator/Desktop\nUser/
> ' data4.txt
On Tuesday, the Linux Desktop
User's group meeting will be held.
All Desktop Users should attend.
$
```
**多行删除命令**

删除命令（d）。sed编辑器用它来删除模式空间中的当前行。但和N命令起使用时，使用单行删除命令要小心
```
	#删除命令会在不同的行中查找单词System和Administrator，然后在模式空间中将两行都删掉。
$ sed 'N ; /System\nAdministrator/d' data4.txt
All System Administrators should attend.
$
```
sed编辑器提供了多行删除命令D，它只删除模式空间中的第一行。该命令会删除到换行符（含换行符）为止的所有字符。
```
$ sed 'N ; /System\nAdministrator/D' data4.txt
Administrator's group meeting will be held.
All System Administrators should attend.
$ 
```
删除数据流中出现在第一行前的空白行。
```
		#sed编辑器脚本会查找空白行，然后用N命令来将下一文本行添加到模式空间。如果新的模式空间内容含有单词header，
		#则D命令会删除模式空间中的第一行。如果不结合使用N命令和D命令，就不可能在不删除其他空白行的情况下只删除第一个空白行。
$ cat data5.txt

This is the header line.
This is a data line.

This is the last line.
$
$ sed '/^$/{N ; /header/D}' data5.txt
This is the header line
This is a data line.

This is the last line.
$
```
**多行打印**
多行打印命令（P），用-n选项来阻止脚本输出时，它和显示文本的单行p命令的用法大同小异。
多行P命令的强大之处在和N命令及D命令组合使用时才能显现出来。
D命令的独特之处在于强制sed编辑器返回到脚本的起始处，对同一模式空间中的内容重新执行这些命令

**保持空间**
模式空间（pattern space）是一块活跃的缓冲区，在sed编辑器执行命令时它会保存待检查的文本。但它并不是sed编辑器保存文本的唯一空间。
sed编辑器有另一块称作保持空间（hold space）的缓冲区域。在处理模式空间中的某些行时，可以用保持空间来临时保存一些行。
```
sed编辑器的保持空间命令
命 令 				描 述
h 			将模式空间复制到保持空间
H 			将模式空间附加到保持空间
g 			将保持空间复制到模式空间
G 			将保持空间附加到模式空间
x 			交换模式空间和保持空间的内容
```
这些命令用来将文本从模式空间复制到保持空间。这可以清空模式空间来加载其他要处理的字符串。
```
$ cat data2.txt
This is the header line.
This is the first data line.
This is the second data line.
This is the last line.
$
$ sed -n '/first/ {h ; p ; n ; p ; g ; p }' data2.txt 
This is the first data line.
This is the second data line.
This is the first data line. 
#(1) sed脚本在地址中用正则表达式来过滤出含有单词first的行；
#(2) 当含有单词first的行出现时，h命令将该行放到保持空间；
#(3) p命令打印模式空间也就是第一个数据行的内容；
#(4) n命令提取数据流中的下一行（This is the second data line），并将它放到模式空间；
#(5) p命令打印模式空间的内容，现在是第二个数据行；
#(6) g命令将保持空间的内容（This is the first data line）放回模式空间，替换当前文本；
#(7) p命令打印模式空间的当前内容，现在变回第一个数据行了。
```
通过使用保持空间来回移动文本行，可以强制输出中第一个数据行出现在第二个数据行后面。如果丢掉第一个p命令，可以以相反的顺序输出这两行。
```
$ sed -n '/first/ {h ; n ; p ; g ; p }' data2.txt
This is the second data line.
This is the first data line.
$ 
```

**排查命令**
感叹号命令（!）用来排除（negate）命令。相当于逻辑not
![](http://cdn.binver.top/linux/sed/file_content_reversal.png "文本反转过程")
```
$ cat data2.txt
This is the header line.
This is the first data line.
This is the second data line.
This is the last line.
$
$ sed -n '{1!G ; h ; $p }' data2.txt
This is the last line.
This is the second data line.
This is the first data line.
This is the header line. 
```
```
$ cat data2.txt
This is the header line.
This is the first data line.
This is the second data line.
This is the last line.
$
$ sed -n '{1!G ; h ; $p }' data2.txt
This is the last line.
This is the second data line.
This is the first data line.
This is the header line. 
```
**改变流**
通常，sed编辑器会从脚本的顶部开始，一直执行到脚本的结尾（D命令是个例外，它会强制sed编辑器返回到脚本的顶部，而不读取新的行）。
sed编辑器提供了一个方法来改变命令脚本的执行流程，其结果与结构化编程类似。
1. **分支**
sed编辑器可以基于地址、地址模式或地址区间排除一整块命令，允许对数据流中的特定行执行一组命令。
分支（branch）命令b的格式如下：
```
[address]b [label] 	#如果没有加label参数，跳转命令会跳转到脚本的结尾。
```
```
#分支命令在数据流中的第2行和第3行处跳过了两个替换命令。
$ cat data2.txt
This is the header line.
This is the first data line.
This is the second data line.
This is the last line.
$
$ sed '{2,3b ; s/This is/Is this/ ; s/line./test?/}' data2.txt
Is this the header test?
This is the first data line.
This is the second data line.
Is this the last test?
$
```
为分支命令定义一个要跳转到的标签。标签以冒号开始，最多可以是7个字符长度。
```
:label2 
```
```
$ sed '{/first/b jump1 ; s/This is the/No jump on/
> :jump1
> s/This is the/Jump here on/}' data2.txt
No jump on header line
Jump here on first data line
No jump on second data line
No jump on last line
$ 
```
```
		#脚本的每次迭代都会删除文本中的第一个逗号，并打印字符串。
$ echo "This, is, a, test, to, remove, commas." | sed -n '{
> :start
> s/,//1p
> /,/b start
> }'
This is, a, test, to, remove, commas.
This is a, test, to, remove, commas.
This is a test, to, remove, commas.
This is a test to, remove, commas.
This is a test to remove, commas.
This is a test to remove commas.
$ 
```

2. **测试**
类似于分支命令，测试（test）命令（t）也可以改变执行流程。测试命令会根据替换命令的结果跳转到某个标签，而不是根据地址进行跳转。
测试命令使用与分支命令相同的格式。
```
[address]t [label] 
```
跟分支命令一样，在没有指定标签的情况下，如果测试成功，sed会跳转到脚本的结尾。
```
		#测试命令提供了对数据流中的文本执行基本的if-then语句的一个低成本办法。
$ sed '{
> s/first/matched/
> t
> s/This is the/No match on/
> }' data2.txt
No match on header line
This is the matched data line
No match on second data line
No match on last line
$
```

**模式替代**
sed在通配符匹配下，很难知道到底哪些文本会匹配模式。如何知道哪些被匹配到的文本？
```
$ echo "The cat sleeps in his hat." | sed 's/cat/"cat"/'
The "cat" sleeps in his hat.
$
```
```
	#但如果你在模式中用通配符（.）来匹配多个单词呢？
$ echo "The cat sleeps in his hat." | sed 's/.at/".at"/g'
The ".at" sleeps in his ".at".
$
```

&符号可以用来代表替换命令中的匹配的模式。
不管模式匹配的是什么样的文本，都可以在替代模式中使用&符号来使用这段文本
```
$ echo "The cat sleeps in his hat." | sed 's/.at/"&"/g'
The "cat" sleeps in his "hat".
$ 
```
替代单独的单词
&符号会提取匹配替换命令中指定模式的整个字符串。如何提取这个字符串的一部分？

sed编辑器用**圆括号**来定义替换模式中的子模式。你可以在替代模式中使用特殊字符来引用每个子模式。
替代字符由反斜线和数字组成。数字表明子模式的位置。sed编辑器会给第一个子模式分配字符\1，给第二个子模式分配字符\2，依此类推。
*当在替换命令中使用圆括号时，必须用转义字符将它们标示为分组字符而不是普通的圆括号。这跟转义其他特殊字符正好相反。*
```
		#替换命令用一对圆括号将单词System括起来，将其标示为一个子模式。然后它在替代模式中使用\1来提取第一个匹配的子模式。
		#子模式在处理通配符模式时特别有用。
$ echo "The System Administrator manual" | sed '
> s/\(System\) Administrator/\1 User/'
The System User manual
$

$ echo "That furry cat is pretty" | sed 's/furry \(.at\)/\1/'
That cat is pretty
$
$ echo "That furry hat is pretty" | sed 's/furry \(.at\)/\1/'
That hat is pretty
$

$ echo "1234567" | sed '{
> :start
> s/\(.*[0-9]\)\([0-9]\{3\}\)/\1,\2/
> t start
> }'
1,234,567
$
这个脚本将匹配模式分成了两部分。
.*[0-9]
[0-9]{3}
```


sed编辑器脚本的过程很烦琐，可以将sed编辑器命令放到shell包装脚本（wrapper）中。
```
$ cat reverse.sh
#!/bin/bash
# Shell wrapper for sed editor script.
# to reverse text file lines. 
#
sed -n '{ 1!G ; h ; $p }' $1
#
$ 

$ ./reverse.sh data2.txt
This is the last line.
This is the second data line.
This is the first data line.
This is the header line.
$ 
```

**重定向 sed 的输出**
默认情况下，sed编辑器会将脚本的结果输出到STDOUT上。可以在shell脚本中使用各种标准方法对sed编辑器的输出进行重定向。
```
$ cat fact.sh
#!/bin/bash
# Add commas to number in factorial answer
#
factorial=1
counter=1
number=$1
#
while [ $counter -le $number ]
do
 factorial=$[ $factorial * $counter ]
 counter=$[ $counter + 1 ]
done
#
result=$(echo $factorial | sed '{
:start
s/\(.*[0-9]\)\([0-9]\{3\}\)/\1,\2/
t start
}')
#
echo "The result is $result"
#
$
$ ./fact.sh 20
The result is 2,432,902,008,176,640,000
$ 
```

sed 实用工具
