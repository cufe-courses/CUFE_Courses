# ZeroDivisionError异常
# try:
#     print(5/0)
# except ZeroDivisionError:
#     print("Error!")

# 例子：
# print('Two num, divided.')
# print("Q to quit.")
#
# while True:
#     first_number = input('\nfirst number:')
#     if first_number == 'q':
#         break
#     second_number = input('\nsecond number:')
#     if second_number == 'q':
#         break
#     try:
#         ans = int(first_number)/int(second_number)
#         print(ans)
#     except ZeroDivisionError:
#         print('Error!')
#         break

# FileNotFoundError异常
# filename = 'alice.txt'
# try:
#     with open(filename,encoding='utf-8') as f:
#         contents = f.read()
# except FileNotFoundError:
#     print("Not found!")

# .split()方法：以空格未分隔符拆分字符串
# title = "Eric in world"
# title.split()

# 例子：读取一个文件有多少个单词
# file_name = 'C:/Users/Administrator/Desktop/源代码文件/chapter_10/alice.txt'
#
# try:
#     with open(file_name,encoding='utf-8') as f:
#         contents = f.read()
# except FileNotFoundError:
#     print("Error!")
# else:
#     """计算包含多少个单词"""
#     words = contents.split()
#     num_words = len(words)
#     print(f"{num_words} words.")

# 例子：读取多个文件有多少个单词
def count_words(filename):
    """计算一个文件包含多少个单词"""
    try:
        with open(filename,encoding='utf-8') as f:
            contents = f.read()
    except FileNotFoundError:
        print("Error!")
    else:
        """计算包含多少个单词"""
        words = contents.split()
        num_words = len(words)
        print(f"{num_words} words.")
filenames = ['C:/Users/Administrator/Desktop/源代码文件/chapter_10/alice.txt','C:/Users/Administrator/Desktop/源代码文件/chapter_10/siddhartha.txt','C:/Users/Administrator/Desktop/源代码文件/chapter_10/moby_dick.txt',"C:/Users/Administrator/Desktop/源代码文件/chapter_10/little_women.txt"]
for filename in filenames:
    count_words(filename)














