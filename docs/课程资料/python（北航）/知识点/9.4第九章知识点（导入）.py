# 导入并使用类
# from car import Car
# new_car = Car('Audi',"a4",2018)
# print(new_car.get_discriptive_name())
# new_car.odometer_reading = 23
# new_car.read_odometer()

# 使用多个类
# from car import Car,ElectricCar
# new_car = Car('volkswagen','beetle',2009)
# print(new_car.get_discriptive_name())
#
# e_car = ElectricCar('tesla','roadster',2010)
# print(e_car.get_discriptive_name())

# 导入模块中所有类：
from car import *

# 标准库
# 例子：randit 生成两个整数之间的随机数
# 例子：choice 随机返回列表中的一个元素
# from random import randint,choice
# 例子：randit
# print(randint(1,10000))
# 例子：choice
# famous_people = ['mao','zhou','liu','zhu']
# c = choice(famous_people)
# print(c)

# 例子:（失败）
from random import randint as rd
while True:
    name = input('name:')
    sides = int(input("sides:"))
    if type(sides) == int:
        if 6 <= sides <= 20:
            print(f"{name}'s {sides} die")
            for r in range(10):
                print(rd(1, sides))
        else:
            print(f"{name}'s {sides} die")
            print('error')
            break
    elif sides == 'Q':
        print('Bye')
        break
    else:
        print('error')
        break










