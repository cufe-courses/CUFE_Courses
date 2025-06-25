#遍历给定字典：使用.item()分别存储值
user_0 = {
    'username': 'efermi',
    'first': 'enrico',
    'last': 'fermi'
}
# for a,b in user_0.items():
#     print(f'Key: {a}')
#     print(f'Value: {b}\n')

# 遍历字典中的所有键：.keys()方法
# for name in user_0.keys():
#     print(name.title())

# 例子：
# vip_name = ['first']
# for name in user_0.keys():
#     print(f"Hi, {name.title()}")
#     if name in vip_name:
#         print(f"{name.title()}'s favorite people is {user_0[name].title()}")

# 排序字典：sorted()临时排序
favorite_languages = {
    'jen':'python',
    'sarah':'c',
    'edward':'rudy',
    'phil':'python'
}
# for name in sorted(favorite_languages.keys()):
#     print(f"{name.title()}, thank you for sharing.")

# 遍历字典所有值：.value()
# for value in favorite_languages.values():
#     print(f'{value.title()}')

# 去除重复值：set()
# for value in set(favorite_languages.values()):
#     print(f'{value.title()}')



