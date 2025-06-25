# 不要忘记冒号
# if-elif-else

# 例子
# age = [19,18,17,15]
# for age in age:
#     if age >=18:
#         print('vote')
#     else:
#         print('no')

# 处理列表：（例子）
# requested_toppings = ['mushroom','peppers','cheese']
# for r in requested_toppings:
#     if r == 'peppers':
#         print(f'no {r}.')
#     else:
#         print('Adding {} ingredients'.format(r))

# 确定列表不是空的：if判断，有元素时返回true，空为false
# requested_toppings = []
# if requested_toppings:
#     for requested_topping in requested_toppings:
#         print(f'Adding {requested_topping}')
# else:
#     print('?')

# 例子：
# available_toppings = ['apple','beef','crab','dog']
# requested_toppings = ['apple','dog','grap']
# for r in requested_toppings:
#     if r in available_toppings:
#         print(f'Adding {r}.')
#     else:
#         print(f'Sorry, no {r}.')
