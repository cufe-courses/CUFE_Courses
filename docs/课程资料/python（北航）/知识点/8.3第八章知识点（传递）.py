# def greet_users(names):
#     """向列表中的人发出问候"""
#     for name in names:
#         msg = f"Hello, {name.title()}!"
#         print(msg)
# names = ['hannah','ty','margot']
# greet_users(names)

# 在函数中修改列表：
# def print_models(unprinted_designs,completed_models):
#     """把内容移到模型中"""
#     while unprinted_designs:
#         current_design = unprinted_designs.pop()
#         print(f"Printing model:{current_design}")
#         completed_models.append(current_design)
# def show_completed_models(completed_models):
#     """显示打印好的模型"""
#     print("\nThe following models printed:")
#     for completed_model in completed_models:
#         print(completed_model)
# unprinted_designs = ['phone','robot','dod']
# completed_models = []
# print_models(unprinted_designs,completed_models)
# show_completed_models(completed_models)


# 禁止函数修改列表：（将列表的副本传递给函数）
# 给列表加上[:]即可保留原列表
# print_models(unprinted_designs[:],completed_models)

#传递实参：*,在形参前面加一个*即可传递任意实参（创建元组）
# def make_cake(*toppings):
#     """打印配料"""
#     print(toppings)
# make_cake('egg','chiken')

# 例子：
# def make_pizza(*toppings):
#     """打印配料"""
#     print(f'\nMaking with :')
#     for topping in toppings:
#         print(f'-{topping}')
# make_pizza('egg','chiken')

# 结合使用位置实参和任意数量的的实参（放在最后）
# def make_pizza(size,*toppings):
#     """打印配料"""
#     print(f'\nMaking {size} inchs pizza with :')
#     for topping in toppings:
#         print(f'-{topping}')
# make_pizza(16,'egg','chiken')

# 使用任意数量的关键字实参（**创建字典）
# def build_profile(first,last,**user_info):
#     """创建字典"""
#     user_info['first_name'] = first
#     user_info['last_name'] = last
#     return user_info
# user_profile = build_profile(
#     'albert',
#     'einstein',
#     location = 'princeton',
#     field = 'physics'
# )
# print(user_profile)





