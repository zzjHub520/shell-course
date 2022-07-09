

```shell
# 打印每行的列数
awk '{print NF}' coins.txt 
# 打印行号
awk '{print NR}' coins.txt 
awk '{print NR, $0}' coins.txt 
# 打印第7行
awk 'NR==7{print NR, $0}' coins.txt
# 打印有7列的行
awk 'NF==7{print NR, $0}' coins.txt 
# 以键盘输入为文本
awk '{print $2, $1}'
# 以逗号为分隔符, BEGIN里面的是全局变量
awk 'BEGIN{FS=","} {print $1, $2}'
# 输出分隔符为逗号
awk 'BEGIN{OFS=","} {print $1, $2}'
# 输入和输出分隔符为逗号
awk 'BEGIN{FS=","; OFS=","} {print $1, $2}'
```



### 练习文本 data.txt

> hello world
> apple banana orange
> abcd efgh



```shell
# 连号（依次）输出各自的文本
awk '{print NR, $0}' coins.txt data.txt
# 打印输出行号，文件名和整行信息
awk '{print NR, FILENAME, $0}' coins.txt data.txt 
# 做计算，以键盘输入做计算
awk '{a=1; b=3; print a + b}'
# 空格默认把两个字符连接起来
awk '{a=1; b=2; c=3; print a b + c}'
# *号比空格优先级要高
awk '{a=1; b=2; c=3; print a b * c}'
awk '{a=1; b=2; c=3; print (a b) * c}'
# 
awk '{a=2; b="apple"; c=3; print b}'
# ans : apple
awk '{a=2; b="apple"; c=3; print b+c}'
# ans: 3
awk '{a=2; b="56apple"; c=3; print b+c}'
# ans: 59
awk '{a=2; b="apple56"; c=3; print b+c}'
# ans: 3
awk 'BEGIN{ print 1/3 }'
```

