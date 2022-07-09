### 练习文本 coins.txt

> gold 1 1986 USA American Eagle
> gold 1 1908 Austria-Hungary Franz josef 100 Korona
> silver 10 1981 USA ingot
> gold 1 1984 Switzerland ingot
> gold 1 1979 RSA Krugerrand
> gold 0.5 1981 RSA Krugerrand
> gold 0.1 1986 PRC Panda
> silver 1 1986 USA Liberty dollar
> gold 0.25 1986 USA Liberty 5-dollar piece
> silver 1 1986 USA Liberty 50-cent piece
> silver 1 1987 USA Constitution dollar
> gold 0.25 1987 USA Constitution 5-dollar piece
> gold 1 1988 Canada Maple leaf



```shell
awk '{print}' coins.txt 
awk '{print $1}' coins.txt 
awk '{print $1, $2, $3}' coins.txt 
awk '{print $1 "\t" $2 "\t" $3}' coins.txt 
# 一行就是 record， NR：number of record
# 一列就是 field ， NF：number of field

# 打印行号
awk '{print NR "\t" $1 "\t" $2 "\t" $3}' coins.txt
# 打印有多少列
awk '{print NF "\t" $0}' coins.txt 
# 文本查找功能
awk '$3==1986{print $0}' coins.txt
awk '$1=="gold"{print $0}' coins.txt 

```

