# 方括号表示列表，用逗号隔开元素
# famous_people = ['mao','zhou','liu','zhu']

# 索引从0开始
# print(famous_people[0])

# 索引也可以从负数开始，-1即从倒数第一个开始
# print(famous_people[-1])

# 插入索引
# print(f'Hi, {famous_people[0].title()}. \n\t{famous_people[1].title()} is waiting for you.')
# print('Hi, {}. \n{} is waiting for you.'.format(famous_people[0].title(), famous_people[1].title()))

# 修改元素
# famous_people[2] = 'ren'
# print(famous_people)

# 添加元素:末尾添加
# famous_people.append('ren')
# print(famous_people)

# 插入元素：.insert(位置, 元素)
# famous_people.insert(4,'ren')
# print(famous_people)

# 删除元素：del；pop()空的话默认弹出最后一个元素；
# del famous_people[2]
# print(famous_people)
# popped_famous_people = famous_people.pop(0)
# print(f'{popped_famous_people.title()} is the greatest people in China')

# 删除特定值：.remove(元素)
# famous_people.remove("liu")
# print(famous_people)

