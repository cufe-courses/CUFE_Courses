# 定义函数
# def greet_user(): #定义的函数叫什么，别忘记括号和冒号
#     """显示简单的问候语"""
#     print('hello！') #函数的内容
# greet_user() #调用函数

# 向函数传递信息
# def greet_user(user_name):
#     """显示简单的问候语"""
#     print(f'Hello, {user_name.title()}!')
# user_name = input("Enter your name: ")
# while user_name != 'quit':
#     greet_user(user_name)
#     user_name = input("Enter your name: ")
#     if user_name == 'quit':
#         break

# 位置实参：
# def describe_pet(animal_type, pet_name):
#     """显示宠物信息"""
#     print(f"\nI have a {animal_type}.")
#     print(f"My {animal_type}'s name is {pet_name.title()}.")
# describe_pet('hamster','harry')
# describe_pet('dog', 'Miqiu')

# 关键值实参：
# describe_pet(animal_type='hamster',pet_name='harry')

# 默认值：（默认值必须放在后面）
# def describe_pet(pet_name,animal_type = 'dog'):
#     """显示宠物信息"""
#     print(f"\nI have a {animal_type}.")
#     print(f"My {animal_type}'s name is {pet_name.title()}.")
# describe_pet('willie')




