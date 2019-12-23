**sed编辑器**被称作流编辑器(stream editor)
sed命令格式如下
```
sed [-hnV][-e<script>][-f<script文件>][文本文件]

选 项 			描 述
-e 		script 在处理输入时，将script中指定的命令添加到已有的命令中
-f 		file 在处理输入时，将file中指定的命令添加到已有的命令中
-n 		不产生命令输出，使用print命令来完成输出
-h或--help 		显示帮助。
-V或--version 	显示版本信息。

动作说明：

a 		新增 a 的后面可以接字串，这些字串会在新的一行出现(目前的下一行)～
c 		取代，c 的后面可以接字串，这些字串可以取代 n1,n2 之间的行！
d 		删除，d 后面通常不接任何咚咚；
i 		插入，i 的后面可以接字串，而这些字串会在新的一行出现(目前的上一行)；
p 		打印，亦即将某个选择的数据印出。通常 p 会与参数 sed -n 一起运行～
r		从文件读取数据到文件。
y		映射字符，一个字符一个字符替换0
s 		取代，可以直接进行取代的工作，通常这个 s 的动作可以搭配正规表示法。
	s有4种可用的替换标记：
	数字，表明新文本将替换第几处模式匹配的地方；
	g，表明新文本将会替换所有匹配的文本；
	p，表明原先行的内容要打印出来；
	w file，将替换的结果写到文件中。
```
sed  s取代(替换)，只替换每行出现的第一处
```
$ echo "This is a test,test2" | sed 's/test/big/'
This is a big,test2
$
$ echo "This is a test,test2" | sed 's/test/big/2'
$ This is a big,big2
$
$ echo "This is a test,test2" | sed 's/test/big/g'
$ This is a big,big2
$
$ cat data5.txt
This is a test line.
This is a different line.
$
$ sed -n 's/test/trial/p' data5.txt  #p 通常与-n使用，-n选项将禁止sed编辑器输出，p替换标记会输出修改过的行
This is a trial line. 
$
$ sed 's/test/trial/w test.txt' data5.txt # w将输出指保存到指定文件。
This is a trial line.
This is a different line.
$
$ cat test.txt
This is a trial line.
$ 
 
```
替换字符
```
$ sed 's/\/bin\/bash/\/bin\/csh/' /etc/passwd
or
$ sed 's!/bin/bash!/bin/csh!' /etc/passwd
```

在sed命令行上执行多个命令时，用-e选项
```
$ cat data1.txt
The quick brown fox jumps over the lazy dog.
The quick brown fox jumps over the lazy dog.
The quick brown fox jumps over the lazy dog.
The quick brown fox jumps over the lazy dog.
$
sed 's/brown/green/; s/dog/cat/' data1.txt #用分号可以不用-e
The quick green fox jumps over the lazy cat.
The quick green fox jumps over the lazy cat.
The quick green fox jumps over the lazy cat.
The quick green fox jumps over the lazy cat. 
$
sed -e 's/brown/green/' -e 's/dog/cat/' data1.txt
The quick green fox jumps over the lazy cat.
The quick green fox jumps over the lazy cat.
The quick green fox jumps over the lazy cat.
The quick green fox jumps over the lazy cat.
```
 从文件中读取编辑器命令 -f
```
$ cat script1.sed
s/brown/green/
s/fox/elephant/
s/dog/cat/
$
$ sed -f script1.sed data1.txt
The quick green elephant jumps over the lazy cat.
The quick green elephant jumps over the lazy cat.
The quick green elephant jumps over the lazy cat.
The quick green elephant jumps over the lazy cat. 
```


sed编辑器中使用的命令会作用于文本数据的所有行.如果只想将命令作用于特定行或某些行，则必须用行寻址（line addressing）。
有两种形式的行寻址：
1）以数字形式表示行区间
2）用文本模式来过滤出行
```
[address]command 
or
[address]command 
```
1. 数字方式的行寻址
sed编辑器会将文本流中的第一行编号为1，然后继续按顺序为接下来的行分配行号。
``` 	
		#只修改第二行
$ sed '2s/dog/cat/' data1.txt
The quick brown fox jumps over the lazy dog
The quick brown fox jumps over the lazy cat
The quick brown fox jumps over the lazy dog
The quick brown fox jumps over the lazy dog
$ 
		#行地址寻址
$ sed '2,3s/dog/cat/' data1.txt
The quick brown fox jumps over the lazy dog
The quick brown fox jumps over the lazy cat
The quick brown fox jumps over the lazy cat
The quick brown fox jumps over the lazy dog
		#从某行开始到结束
$ sed '2,$s/dog/cat/' data1.txt
The quick brown fox jumps over the lazy dog
The quick brown fox jumps over the lazy cat
The quick brown fox jumps over the lazy cat
The quick brown fox jumps over the lazy cat 
```
		
2. 用文本模式来过滤出行,必须用正斜线将要指定的pattern封起来
```
/pattern/command
```
只修改用户Samantha的默认shell
```
$ grep Samantha /etc/passwd
Samantha:x:502:502::/home/Samantha:/bin/bash
$
$ sed '/Samantha/s/bash/csh/' /etc/passwd
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
[...]
Christine:x:501:501:Christine B:/home/Christine:/bin/bash
Samantha:x:502:502::/home/Samantha:/bin/csh
Timothy:x:503:503::/home/Timothy:/bin/bash
$ 
```

**命令组合**
```
$ sed '3,${
> s/brown/green/
> s/lazy/active/
> }' data1.txt
The quick brown fox jumps over the lazy dog.
The quick brown fox jumps over the lazy dog.
The quick green fox jumps over the active dog.
The quick green fox jumps over the active dog.
$
	#单行中用分号结束
```
删除命令d，它会删除匹配指定寻址模式的所有行，如果不加寻址模式，删除所有文本行
```
$ cat data1.txt
The quick brown fox jumps over the lazy dog
The quick brown fox jumps over the lazy dog
The quick brown fox jumps over the lazy dog
The quick brown fox jumps over the lazy dog
$
$ sed 'd' data1.txt
$
		#指定行
$ cat data6.txt
This is line number 1.
This is line number 2.
This is line number 3.
This is line number 4.
$
$ sed '3d' data6.txt
This is line number 1.
This is line number 2.
This is line number 4.
$ 
		#指定区间
$ sed '2,3d' data6.txt
This is line number 1.
This is line number 4.
$ 

		#sed编辑器的模式匹配特性也适用于删除命令。
$ sed '/number 1/d' data6.txt
This is line number 2.
This is line number 3.
This is line number 4.
$ 
		#以使用两个文本模式来删除某个区间内的行
		#指定的第一个模式会“打开”行删除功能，第二个模式会“关闭”行删除功能
$ sed '/1/,/3/d' data6.txt
This is line number 4.
$
		#sed编辑器在数据流中匹配到了开始模式，删除功能就会打开。这可能会导致意外的结果
		#第二个出现数字“1”的行再次触发了删除命令，因为没有找到停止模式，所以就将数据流中的剩余行全部删除了
$ cat data7.txt
This is line number 1.
This is line number 2.
This is line number 3.
This is line number 4.
This is line number 1 again.
This is text you want to keep.
This is the last line in the file.
$
$ sed '/1/,/3/d' data7.txt
This is line number 4.
$
		#删除功能在匹配到第一个模式的时候打开了，但一直没匹配到结束模式，所以全部删除
$ sed '/1/,/5/d' data7.txt
$

```
*sed编辑器不会修改原始文件。你删除的行只是从sed编辑器的输出中消失了*

**插入和附加文本**
插入（insert）命令（i）会在指定行前增加一个新行；
附加（append）命令（a）会在指定行后增加一个新行。

     sed '[address]command \new line
```
		#当使用插入命令时，文本会出现在数据流文本的前面。
$ echo "Test Line 2" | sed 'i\Test Line 1'
Test Line 1
Test Line 2
$
		#当使用附加命令时，文本会出现在数据流文本的后面。
$ echo "Test Line 2" | sed 'a\Test Line 1'
Test Line 2
Test Line 1
$
		#将一个新行插入到数据流第三行前。
$ sed '3i\
> This is an inserted line.' data6.txt
This is line number 1.
This is line number 2.
This is an inserted line.
This is line number 3.
This is line number 4.
$
		#将一个新行附加到数据流中第三行后。
$ sed '3a\
> This is an appended line.' data6.txt
This is line number 1.
This is line number 2.
This is line number 3.
This is an appended line.
This is line number 4.
$ 
		#将新行附加到数据流的末尾
$ sed '$a\
> This is a new line of text.' data6.txt
This is line number 1.
This is line number 2.
This is line number 3.
This is line number 4.
This is a new line of text.
$
		#插入或附加多行文本
$ sed '1i\
> This is one line of new text.\
> This is another line of new text.' data6.txt
This is one line of new text.
This is another line of new text.
This is line number 1.
This is line number 2.
This is line number 3.
This is line number 4.
$
```
**修改行**
```
	#修改（change）命令允许修改数据流中整行文本的内容。你必须在sed命令中单独指定新行。
$ sed '3c\
> This is a changed line of text.' data6.txt
This is line number 1.
This is line number 2.
This is a changed line of text.
This is line number 4.
$
#		sed编辑器会修改第三行中的文本。也可以用文本模式来寻址。
$ sed '/number 3/c\
> This is a changed line of text.' data6.txt
This is line number 1.
This is line number 2.
This is a changed line of text.
This is line number 4.
$
		#文本模式修改命令会修改它匹配的数据流中的任意文本行。
$ cat data8.txt
This is line number 1.
This is line number 2.
This is line number 3.
This is line number 4.
This is line number 1 again.
This is yet another line.
This is the last line in the file.
$
$ sed '/number 1/c\
> This is a changed line of text.' data8.txt
This is a changed line of text.
This is line number 2.
This is line number 3.
This is line number 4.
This is a changed line of text.
This is yet another line.
This is the last line in the file.
$
		#可以在修改命令中使用地址区间，但结果未必如愿。
$ sed '2,3c\
> This is a new line of text.' data6.txt
This is line number 1.
This is a new line of text.
This is line number 4.
$
#sed编辑器会用这一行文本来替换数据流中的两行文本，而不是逐一修改这两行文本。
```
**转换命令**
转换（transform）命令（y）是唯一可以处理单个字符的sed编辑器命令。
转换命令格式如下。

    [address]y/inchars/outchars/
转换命令会对inchars和outchars值进行一对一的映射
inchars中的第一个字符会被转换为outchars中的第一个字符，第二个字符会被转换成outchars中的第二个字符
如果inchars和outchars的长度不同，则sed编辑器会产生一条错误消息。
```
$ sed 'y/123/789/' data8.txt
This is line number 7.
This is line number 8.
This is line number 9.
This is line number 4.
This is line number 7 again.
This is yet another line.
This is the last line in the file.
$
```
转换命令是一个全局命令，它会文本行中找到的所有指定字符自动进行转换，而不会考虑它们出现的位置。
```
$ echo "This 1 is a test of 1 try." | sed 'y/123/456/'
This 4 is a test of 4 try.
$
```
**打印**
1) p命令用来打印文本行；
2) 等号（=）命令用来打印行号；
3) l（小写的L）命令用来列出行。
```
		#p命令可以打印sed编辑器输出中的一行
$ echo "this is a test" | sed 'p'
this is a test
this is a test
$
		#它所做的就是打印已有的数据文本。打印命令最常见的用法是打印包含匹配文本模式的行。
$ cat data6.txt
This is line number 1.
This is line number 2.
This is line number 3.
This is line number 4.
$
$ sed -n '/number 3/p' data6.txt
This is line number 3.
$
		#在命令行上用-n选项，可以禁止输出其他行，只打印包含匹配文本模式的行。也可以用它来快速打印数据流中的某些行。
$ sed -n '2,3p' data6.txt
This is line number 2.
This is line number 3.
$
		#如果需要在修改之前查看行,可以创建一个脚本在修改行之前显示该行。
$ sed -n '/3/{
> p
> s/line/test/p
> }' data6.txt
This is line number 3.
This is test number 3.
$ 
```
**打印行号**
等号命令会打印行在数据流中的当前行号
```
$ cat data1.txt
The quick brown fox jumps over the lazy dog.
The quick brown fox jumps over the lazy dog.
The quick brown fox jumps over the lazy dog.
The quick brown fox jumps over the lazy dog.
$
$ sed '=' data1.txt
1
The quick brown fox jumps over the lazy dog.
2
The quick brown fox jumps over the lazy dog.
3
The quick brown fox jumps over the lazy dog.
4
The quick brown fox jumps over the lazy dog.
$
		#sed编辑器在实际的文本行出现前打印了行号。如果要在数据流中查找特定文本模式的话，等号命令用起来非常方便。
$ sed -n '/number 4/{
> =
> p
> }' data6.txt
4
This is line number 4.
$
	#利用-n选项，能让sed编辑器只显示包含匹配文本
模式的行的行号和文本。
```
**列出行**
列出（list）命令（l）可以打印数据流中的文本和不可打印的ASCII字符。
```
$ cat data9.txt
This	line	contains	tabs.
$
$ sed -n 'l' data9.txt
This\tline\tcontains\ttabs.$
$
```
**写入文件**
```
$ sed '1,2w test.txt' data6.txt
This is line number 1.
This is line number 2.
This is line number 3.
This is line number 4.
$
$ cat test.txt
This is line number 1.
This is line number 2.
$ 
		#如果不想让行显示到STDOUT上，你可以用sed命令的-n选项
$ cat data11.txt
Blum, R Browncoat
McGuiness, A Alliance
Bresnahan, C Browncoat
Harken, C Alliance
$
$ sed -n '/Browncoat/w Browncoats.txt' data11.txt
$
$ cat Browncoats.txt
Blum, R Browncoat
Bresnahan, C Browncoat
$
```
**从文件读取数据**
格式如下：

    [address]r filename
```
$ cat data12.txt
This is an added line.
This is the second added line.
$
$ sed '3r data12.txt' data6.txt
This is line number 1.
This is line number 2.
This is line number 3.
This is an added line.
This is the second added line.
This is line number 4.
$
		#同样的方法在使用文本模式地址时也适用
$ sed '/number 2/r data12.txt' data6.txt
This is line number 1.
This is line number 2.
This is an added line.
This is the second added line.
This is line number 3.
This is line number 4.
$
	#如果要在数据流的末尾添加文本，只需用美元符地址符
$ sed '$r data12.txt' data6.txt
This is line number 1.
This is line number 2.
This is line number 3.
This is line number 4.
This is an added line.
This is the second added line.
$
```
读取命令的另一个用法是和删除命令配合使用：利用另一个文件中的数据来替换文件中的占位文本。举例来说，假定你有一份套用信件保存在文本文件中：
```
$ cat notice.std
Would the following people:
LIST
please report to the ship's captain.
$
$ sed '/LIST/{
> r data11.txt
> d
> }' notice.std
Would the following people:
Blum, R Browncoat
McGuiness, A Alliance
Bresnahan, C Browncoat
Harken, C Alliance
please report to the ship's captain.
$
#现在占位文本已经被替换成了数据文件中的名单
```