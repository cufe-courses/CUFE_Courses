# 读取文件
# file_path = 'C:/Users/Administrator/Desktop/源代码文件/chapter_10/pi_digits.txt'
# with open(file_path) as file_object:
#     contents = file_object.read()
# print(contents.rstrip())

# 逐行读取
# file_path = 'C:/Users/Administrator/Desktop/源代码文件/chapter_10/pi_digits.txt'
# with open(file_path) as file_object:
#     for line in file_object:
#         print(line.rstrip())

# 创建包含各行内容的列表：.readlines()从文件中读取每一行，并存在列表中
# file_path = 'C:/Users/Administrator/Desktop/源代码文件/chapter_10/pi_digits.txt'
# with open(file_path) as file_object:
#     lines = file_object.readlines()
# for line in lines:
#     print(line.rstrip())

# 使用文件中的内容
# file_path = 'C:/Users/Administrator/Desktop/源代码文件/chapter_10/pi_digits.txt'
# with open(file_path) as file_object:
#     lines = file_object.readlines()
#
# pi_string = ''
# for line in lines:
#     pi_string += line.strip()
#
# print(pi_string)
# print(len(pi_string))

# 打印小数点一百万位中的前五十位
# file_path = 'C:/Users/Administrator/Desktop/源代码文件/chapter_10/pi_million_digits.txt'
# with open(file_path) as file_object:
#     lines = file_object.readlines()
#
# pi_string = ''
# for line in lines:
#     pi_string += line.strip()
#
# print(f"{pi_string[:52]}……")
# print(len(pi_string))
#
# 圆周率中是否包含生日（例子）
# file_path = 'C:/Users/Administrator/Desktop/源代码文件/chapter_10/pi_million_digits.txt'
# with open(file_path) as file_object:
#     lines = file_object.readlines()
#
# pi_string = ''
# for line in lines:
#     pi_string += line.strip()
#
# while True:
#     birthday = input('birthday(mmddyy):')
#     if birthday in pi_string:
#         print("In!")
#     elif birthday not in pi_string:
#         print('Error.')


