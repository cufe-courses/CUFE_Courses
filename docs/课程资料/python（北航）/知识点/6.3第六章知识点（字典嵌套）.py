# 嵌套：将字典套入列表中
student_0 = {'name': 'Eric', 'points': 9}
student_1 = {'name': 'Lisa', 'points': 6}
student_2 = {'name': 'Kevin', 'points': 7}
# students = [student_0,student_1,student_2]
# for student in students:
#     print(student)

# 例子：
# students = []
# for s in range(30):
#     s_1  = {'name': 'Eric', 'points': 9}
#     students.append(s_1)
# for student in students[:5]:
#     print(student)
# print('……')
# print(f'length is {len(students)}.')

# 在字典中存储列表：
# pizza = {
#     "crust": 'thick',
#     'toppings': ['mushroom','extra cheese']
# }
# print(f"you:{pizza['crust']}-crust pizza.")
# for i in pizza['toppings']:
#     print("\t",i)

# 例子：（终于自己写出来了！）
favorit_languages = {
    'jen': ['python','rudy'],
    'sarah': ['c'],
    'edward': ['rudy','go'],
    'phil': ['python','haskell']
}
# for i in favorit_languages.keys():
#     print(f"\n{i.title()}'s favorite languages are:")
#     for j in favorit_languages[i]:
#         print("\t",j.title())
# 或者
# for name, languages in favorit_languages.items():
#     print(f"\n{name.title()}'s favorite languages are:")
#     for language in languages:
#         print(f"\t{language.title()}")

# 在字典中存储字典：
# users = {
#     'aeinstein':{
#         'first': 'albert',
#         'last': 'einstein',
#         'location': 'priceton',
#     },
#     'curie':{
#         'first': 'marie',
#         'last': 'curie',
#         'location': 'paris'
#     },
# }
# for user_name,user_info in users.items():
#     print(f"\nUsername:{user_name.title()}")
#     full_name = f"{user_info['first']} {user_info['last']}"
#     location = user_info['location']
#     print(f"\tFull name:{full_name.title()}\n\tLocation:{location.title()}")
