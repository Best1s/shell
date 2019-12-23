创建函数的两种格式
1
```
function name {
 commands
}
```
2
```
name() {
commands
}
```
使用函数，直接指定函数名，函数需要提前定义

函数结束时会返回一个退出状态码

1)可以用标准变量$?来确定函数的退出状态码,**只能确定函数最后一条命令是否成功**
2)使用 return 命令指定退出状态码，退出状态码必须是0~255

函数作用域
函数使用两种类型的变量：
**全局变量**
**局部变量** 变量前加上local关键字，保证了变量只局限在该函数中
**函数递归** 函数调用函数
**创建库** 在脚本中 . (source) 需要调用的文件 然后执行需要的函数

在命令行上使用函数
1）命令行上定义函数，需要在函数大括号之前加个分号结束
```
$ function divem { echo $[ $1 / $2 ]; }
$ divem 100 5
20
$
```
2）是采用多行方式来定义函数
```
$ function multem {
> echo $[ $1 * $2 ]
> }
$ multem 2 5
10
$ 
```
3）
在文件.bashrc文件中定义函数

shtool 库函数
ftp://ftp.gnu.org/gnu/shtool/shtool-2.0.8.tar.gz

图形shell
select命令 #自动生成菜单
```
select variable in list
do
 commands
done 
```


**制作窗口 P384页**
1）dialog 包
2）KDE和GNOME桌面环境
