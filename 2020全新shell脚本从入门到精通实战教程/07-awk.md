![image-20220515171550606](MarkDownImages/07-awk.assets/image-20220515171550606.png)

![image-20220515172627113](MarkDownImages/07-awk.assets/image-20220515172627113.png)

![image-20220515172734126](MarkDownImages/07-awk.assets/image-20220515172734126.png)

```sh
#打印某一列
awk '{print $0}' test
awk '{print $3}' test
awk '{print $NF}' test
#打印某一行
awk 'NR==3{print $0}' test
#指定分隔符
awk -F ":" 'NR==3{print $1,$4}' test
awk -F ":" 'NR==3{print $1 "-" $4}' test

```

![image-20220515174626669](MarkDownImages/07-awk.assets/image-20220515174626669.png)

![image-20220515174546715](MarkDownImages/07-awk.assets/image-20220515174546715.png)

![image-20220515174830126](MarkDownImages/07-awk.assets/image-20220515174830126.png)



```sh
#内存使用率
head -2 /proc/meminfo | awk 'NR==1{t=$2}NR==2{f=$2;print (t-f)*100/t "%"}'
```

![image-20220515181227329](MarkDownImages/07-awk.assets/image-20220515181227329.png)

### 流程控制

![image-20220515182039527](MarkDownImages/07-awk.assets/image-20220515182039527.png)

![image-20220515182520202](MarkDownImages/07-awk.assets/image-20220515182520202.png)

![image-20220515182606774](MarkDownImages/07-awk.assets/image-20220515182606774.png)

![image-20220515183451595](MarkDownImages/07-awk.assets/image-20220515183451595-16526108921461.png)

![image-20220515183604813](MarkDownImages/07-awk.assets/image-20220515183604813.png)

![image-20220515183644356](MarkDownImages/07-awk.assets/image-20220515183644356.png)

![image-20220515183734074](MarkDownImages/07-awk.assets/image-20220515183734074.png)

![image-20220515183837162](MarkDownImages/07-awk.assets/image-20220515183837162.png)

