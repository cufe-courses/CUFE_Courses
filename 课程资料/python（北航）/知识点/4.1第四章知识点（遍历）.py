# famous_people = ['mao','zhou','liu','zhu']
# 遍历列表
# 循环，打印每一个元素（注意冒号）
# for f in famous_people:
#     print(f)
# 例子
# for f in famous_people:
#     print(f'{f.title()}, hi.\nI am {f.title()}.')

# range函数：生成特定区间的一系列的数,默认从0开始，取不到结尾
# print(list(range(0,3,2)))
# 例子：打印1-10的偶（奇）数
# even_numbers = list(range(2,11,2))
# print(even_numbers)
# odd_numbers = list(range(1,10,2))
# print(odd_numbers)

# 重点例子（应用）
# 例子：打印1-10的平方
# squares = []
# for value in range(1,11):
#     square = value**2
#     squares.append(square)
# print(squares)

# 列表解析：
# squares = [value**2 for value in range(1,11)]
# print(squares)

