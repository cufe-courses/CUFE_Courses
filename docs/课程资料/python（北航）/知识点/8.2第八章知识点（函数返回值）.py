# 返回值：
# def get_formatted_name(first_name,last_name):
#     """返回全名"""
#     full_name = f"{first_name.title()} {last_name.title()}"
#     return full_name
# musician = get_formatted_name('jimi','hendrix')
# print(musician)

# 让实参变为可选的：
# def get_formatted_name(first_name,last_name,middle_name = ''):
#     """返回全名"""
#     检查是否提供中间名
    # if middle_name :
    #     full_name = f"{first_name} {middle_name} {last_name}"
    # else:
    #     full_name = f"{first_name} {last_name}"
    # return full_name.title()
# musician = get_formatted_name('john','lee','W')
# print(musician)

# 返回字典：（自己写的！）
# def build_person(first_name,last_name):
#     """返回字典"""
#     person = {
#         'first':first_name,
#         'last':last_name,
#     }
#     return person
# musician = build_person('jimi','hendrix')
# print(musician)

#添加字典内容：
# def build_person(first_name,last_name,age = None):
#     """返回字典"""
#     person = {
#         'first':first_name,
#         'last':last_name,
#     }
#     if age:
#         person['age'] = age
#     return person
# musician = build_person('jimi','hendrix',age = 18)
# print(musician)

#结合while循环：
# def get_formatted_name(first_name,last_name):
    # '''返回姓名'''
    # full_name = f"{first_name} {last_name}"
    # return full_name.title()
# while True:
#     print('Name please(Q):')
#     f = input('First name please:')
#     if f == 'Q' :
#         break
#     l = input('Last name please:')
#     if l == 'Q' :
#         break
#     musician = get_formatted_name(f, l)
#     print(f'Hello,{musician}')










