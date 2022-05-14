### 数字运算

expr

let

bc

$(())

$[]



内存使用率

```sh
echo "`echo "scale=2;141*100/7966"|bc`%"
```



倒计时脚本

```sh
for time in `seq 9 -1 0`; do
	echo -n -e "\b$time"
	sleep 1
done
echo
```



### 基本输入

```sh
#!/bin/bash
clear
#echo -n -e "Login: "
#read acc
read -p "Login : " acc

echo -n -e "password: "
read -s -t5 -n6 pw
echo
echo "account: $acc password: $pw"
```



### 变量

```
a=10
unset a
echo $a
```



### 数组

```sh
ARRAY1=('A' 'B' 'C' 'D')
echo ${ARRAY1[2]}
ARRAY1[4]='E'
ARRAY1[5]='F'
#查看数组
declare -a

echo ${array1[0]} #访问数组中的第一个元素
echo ${array1[@]} #访问数组所有元素
echo ${#array1[@]} #访问数组中的元素个数
echo ${!array1[@]} #获取数组元素的索引
echo ${array1[@]:1} #从数组下标1开始
echo ${array1[@]:1:2} #从数组下标1开始，访问两个元素
```



 ### 关联数组（map）

```
decalre -A ass_array1
```



### 流程控制-if判断语句

![image-20220515022214733](MarkDownImages/01-shell%E5%9F%BA%E6%9C%AC%E8%AF%AD%E6%B3%95.assets/image-20220515022214733.png)

```sh
test `echo "1.5*10"|bc|cut -d '.' -f1` -eq $((2*10)) ; echo $?
```

![image-20220515024006475](MarkDownImages/01-shell%E5%9F%BA%E6%9C%AC%E8%AF%AD%E6%B3%95.assets/image-20220515024006475.png)

![image-20220515023125296](MarkDownImages/01-shell%E5%9F%BA%E6%9C%AC%E8%AF%AD%E6%B3%95.assets/image-20220515023125296.png)

![image-20220515024203678](MarkDownImages/01-shell%E5%9F%BA%E6%9C%AC%E8%AF%AD%E6%B3%95.assets/image-20220515024203678.png)

### if语法

![image-20220515024512805](MarkDownImages/01-shell%E5%9F%BA%E6%9C%AC%E8%AF%AD%E6%B3%95.assets/image-20220515024512805.png)

![image-20220515024620657](MarkDownImages/01-shell%E5%9F%BA%E6%9C%AC%E8%AF%AD%E6%B3%95.assets/image-20220515024620657.png)

![image-20220515024727529](MarkDownImages/01-shell%E5%9F%BA%E6%9C%AC%E8%AF%AD%E6%B3%95.assets/image-20220515024727529.png)

![image-20220515024847566](MarkDownImages/01-shell%E5%9F%BA%E6%9C%AC%E8%AF%AD%E6%B3%95.assets/image-20220515024847566.png)

![image-20220515025146038](MarkDownImages/01-shell%E5%9F%BA%E6%9C%AC%E8%AF%AD%E6%B3%95.assets/image-20220515025146038.png)



![image-20220515025236780](MarkDownImages/01-shell%E5%9F%BA%E6%9C%AC%E8%AF%AD%E6%B3%95.assets/image-20220515025236780.png)



![image-20220515025430062](MarkDownImages/01-shell%E5%9F%BA%E6%9C%AC%E8%AF%AD%E6%B3%95.assets/image-20220515025430062.png)

双小圆括号(())可以做数组表达式， 双方括号[[]]可以做条件中使用通配符



### 作业

![image-20220515030113059](MarkDownImages/01-shell%E5%9F%BA%E6%9C%AC%E8%AF%AD%E6%B3%95.assets/image-20220515030113059.png)
