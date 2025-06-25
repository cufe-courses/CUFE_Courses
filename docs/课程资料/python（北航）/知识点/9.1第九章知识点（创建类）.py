# 创建类：例（peop类）
# 找到（对象-属性）（对象-行为）（对象-……）
# 首字母大写为类
class People():
    """例子"""
    def __init__(self,name,age):
       """初始化属性name，age"""
       self.name = name
       self.age = age
    def walk(self):
        """模拟行为1"""
        print(f'{self.name} is now walking.')
    def say(self):
        """模拟行为2"""
        print(f'{self.name} says sth.')
# 创建实例：
my_love = People('Anna',18)

# 访问属性：self.name
# print(f"My love's name is {my_love.name}.")
# print(f"My love is {my_love.age} years old.")

# 使用方法：
my_love.walk()
my_love.say()

# 创建多个实例：
my_friend = People('Eric',18)
print(f"\nMy friend's name is {my_friend.name}.")
print(f"My friend is {my_friend.age} years old.")
my_friend.walk()
my_friend.say()











