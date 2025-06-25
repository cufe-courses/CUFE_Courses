# 创建字典{}：学生姓名（Eric）+分数（9）
student_0 = {'name': 'Eric', 'points': 9}
# print(student_0['name'].upper())

# 访问字典：字典名+键
# print(f"You just get {student_0['points']} points.")

# 添加键值对：添加新的信息
# student_0['gender'] = 'male' #添加性别
# student_0['class'] = 1 #添加班级
# print(student_0)

# 修改字典中的值
# student_0['points'] = 10 #直接修改
# print('{} now get {} points.'.format(student_0['name'],student_0['points']))

# 例子：根据成绩判断排名
# if student_0['points'] > 7:
#     student_0['rate'] = '10%'
#     if student_0['points'] >= 9:
#         student_0['rate'] = '1%'
# else:
#     student_0['rate'] = '-'
# print(student_0['rate'])

# 删除键值对
# del student_0['points']
# print(student_0)

# 例子：给字典打印一句话
# favorite_languages = {
#     'jen':'python',
#     'sarah':'c',
#     'edward':'rudy',
#     'phil':'python'
# }
# print("Sarah's favorite languages is {}".format(favorite_languages['sarah'].title()))

# 用get()来访问值：避免访问错误，访问到没有的值
# gender_1 = student_0.get('gender', 'No assigned') #若存在键则返回值，不存在则返回不存在
# gender_1 = student_0.get('gender') #也可以空着，返回None
# print(gender_1)


