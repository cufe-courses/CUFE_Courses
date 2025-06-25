# 数字列表的统计运算
# 最大值；最小值；求和
# digits = [1,2,3,4,5,6,7,8,9,0]
# print(max(digits))
# print(min(digits))
# print(sum(digits))

players = ['charles','martin','lisa','eric','anna']
# 切片：打印特定元素[0:1]
# print(players[:1])#默认从0开始打印
# print(players[1:3])#打印第2-3个元素
# print(players[-3:])#负数索引
# print(players[::2])#隔一个获取一个
# 例子：遍历切片
# print('Here are the first three players on my team:')
# for p in players[:3]:
#     print(p.title())

# 复制列表：
# players = ['charles','martin','lisa','eric','anna']
# players_1 = players[:]
# print(players_1)

#元组（不可变的列表）:
# 访问元组
dimensions = (200,5)
# print(dimensions[:])

# 遍历元组：
# for dimension in dimensions:
#     print(dimension)

# 修改元组变量
# print('Original dimensions:')
# for dimension in dimensions:
#     print(dimension)
# print('\nModified dimensions:')
# dimensions = (400,10)
# for dimension in dimensions:
#     print(dimension)
