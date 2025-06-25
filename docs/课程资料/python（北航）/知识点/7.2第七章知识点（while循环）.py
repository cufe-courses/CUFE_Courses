# while循环：不断运行，直到不满足指定条件
# current_number= 1
# while current_number <= 5:
#     print(current_number)
#     current_number += 1

# 设定退出值
# 空字符串：a = ""
# 空列表：a = []
# 空字典：a = {}
# prompt = '\nTell me somthing'
# prompt += '(Enter quit to quit.): '
# message = ''
# while message != 'quit':
#     message = input(prompt)
#     if message != 'quit':
#         print(message)

# 使用标志
# prompt = '\nTell me somthing'
# prompt += '(Enter quit to quit.): '
# active = True
# while active:
#     message = input(prompt)
#     if message == 'quit':
#         active = False#循环不再进行
#     else:
#         print(message)

# break退出循环
# prompt = '\nTell me somthing'
# prompt += '(Enter quit to quit.):'
# while True:
#     message = input(prompt)
#     if message == 'quit':
#         break
#     else:
#         print(message)

# continue不执行余下代码，返回开头（自己写出来的！）
current_number = int(input('enter:'))
while current_number < 10:
    current_number += 1
    if current_number % 2 == 0:
        continue
    else:
        print(current_number)

# 避免无限循环

