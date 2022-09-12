![image-20220515155822756](MarkDownImages/06-sed%E5%92%8Cawk.assets/image-20220515155822756.png)

![image-20220515155936959](MarkDownImages/06-sed%E5%92%8Cawk.assets/image-20220515155936959.png)

![image-20220515160220640](MarkDownImages/06-sed%E5%92%8Cawk.assets/image-20220515160220640.png)

![image-20220515160321530](MarkDownImages/06-sed%E5%92%8Cawk.assets/image-20220515160321530.png)

![image-20220515160442030](MarkDownImages/06-sed%E5%92%8Cawk.assets/image-20220515160442030.png)



### 案例

文件准备

```
1 the quick brown fox jumps over the lazy dog.
2 the quick brown fox jumps over the lazy dog.
3 the quick brown fox jumps over the lazy dog.
4 the quick brown fox jumps over the lazy dog.
5 the quick brown fox jumps over the lazy dog.
```

```sh
#每行追加一行hello world
sed 'a\hello world' data
#第3行追加一行hello world
sed '3a\hello world' data
#第2到4行追加一行hello world
sed '2,4a\hello world' data
#配置追加hello world
sed '/3 the/a\hello world' data
#每行前面插入一行hello world
sed 'i\hello world' data
sed '3i\hello world' data
sed '2,4i\hello world' data
sed '/3 the/i\hello world' data
#每行后面添加一行空行：
sed G data
# 每行前面添加一行空行：
sed  '{x;p;x;}' data
#每行后面添加两行空行：
sed  'G;G'  data
#每行前面添加两行空行：
sed '{x;p;x;x;p;x;}' data
sed '/shui/G' tmp  
sed '/shui/{x;p;x;G}' tmp 
sed '1{x;p;x;}' tmp
sed '1G' tmp
#删除 d
sed 'd' data
sed '3d' data
sed '2,4d' data
sed '/3 the/d' data
#正则表达式 -r
sed -r '/^1 the/d' data
#替换 s
sed 's/dog/cat/' data
sed '3s/dog/cat/' data
sed '2,4s/dog/cat/' data
sed '/3 the/s/dog/cat/' data
#更改 c
sed 'c\hello world' data
sed '3c\hello world' data
#把2到4行换成目标行
sed '2,4c\hello world' data
sed '/3 the/c\hello world' data
#转换 y
sed 'y/abcdefg/ABCDEFG/' data
sed '3y/abcdefg/ABCDEFG/' data
sed '2,4y/abcdefg/ABCDEFG/' data
sed '/3 the/y/abcdefg/ABCDEFG/' data
#打印
sed 'p' data
sed -n '/hadoopPath/p' hadoop-HA.conf
```



![image-20220515165953973](MarkDownImages/06-sed%E5%92%8Cawk.assets/image-20220515165953973.png)

```sh
#删除掉以#号开头的行
sed -r '/(^#|^\s+#)/d' nginx.conf
```

