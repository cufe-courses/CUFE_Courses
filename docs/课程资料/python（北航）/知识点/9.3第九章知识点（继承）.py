#一个类继承另外一个类，继承所有属性和方法
# 子类继承父类所有的属性，方法
# 子类在父类之下 子类（父类）


# class Car:
#     """模拟汽车"""
#     def __init__(self,make,model,year):
#         """初始化描述汽车的属性"""
#         self.make = make
#         self.model = model
#         self.year = year
#         self.odometer_reading = 0
#
#     def get_discriptive_name(self):
#         """返回描述性信息"""
#         long_name = f"{self.year} {self.make} {self.model}"
#         return long_name.title()
#
#     def read_odometer(self):
#         """打印汽车里程"""
#         print(f"car has {self.odometer_reading} miles.")
#
#     def update_odometer(self,mileage):
#         """将里程表读数设置为特定值"""
#         if mileage >= self.odometer_reading:
#             self.odometer_reading = mileage
#         else:
#              print("error!")
#
#     def increment_odometer(self,miles):
#         """将里程表读数增加指定的量"""
#         self.odometer_reading += miles
#
# class ElectricCar(Car):
#     """电动汽车"""
#
#     def __init__(self,make,model,year):
#         """初始化父类属性"""
#         super().__init__(make,model,year)
#         """设置初始值"""
#         self.battery_size = 75
# 新增方法
    # def describe_battery(self):
    #     """打印描述电瓶容量的信息"""
    #     print(f'Battery:{self.battery_size}')
#
#
# 创建ElectricCar实类，赋值给my_tesla
# my_tesla = ElectricCar('tesla',"models's",2019)
# print(my_tesla.get_discriptive_name())
# my_tesla.describe_battery()

# 修改父类：子类父类一样的方法，子类做变动即可
# class Car:
#     """模拟汽车"""
#     def __init__(self,make,model,year):
#         """初始化描述汽车的属性"""
#         self.make = make
#         self.model = model
#         self.year = year
#         self.odometer_reading = 0
#
#     def get_discriptive_name(self):
#         """返回描述性信息"""
#         long_name = f"{self.year} {self.make} {self.model}"
#         return long_name.title()
#
#     def read_odometer(self):
#         """打印汽车里程"""
#         print(f"car has {self.odometer_reading} miles.")
#
#     def update_odometer(self,mileage):
#         """将里程表读数设置为特定值"""
#         if mileage >= self.odometer_reading:
#             self.odometer_reading = mileage
#         else:
#              print("error!")
#
#     def increment_odometer(self,miles):
#         """将里程表读数增加指定的量"""
#         self.odometer_reading += miles
#     修改方法：
    # def fill_gas_tank(self):
    #    print('need gas tank!')
# class ElectricCar(Car):
#     """电动汽车"""
#
#     def __init__(self,make,model,year):
#         """初始化父类属性"""
#         super().__init__(make,model,year)
#         """设置初始值"""
#         self.battery_size = 75
# 新增方法
#     def describe_battery(self):
#         """打印描述电瓶容量的信息"""
#         print(f'Battery:{self.battery_size}')
# 修改方法：
#     def fill_gas_tank(self):
#         """电车没油箱"""
#         print('No need!')
# python忽略car类的方法，执行子类中的相同的方法
# my_tesla = ElectricCar('tesla',"models's",2019)
# print(my_tesla.get_discriptive_name())
# my_tesla.fill_gas_tank()


# 将实例用作属性：
# class Car:
#     """模拟汽车"""
#     def __init__(self,make,model,year):
#         """初始化描述汽车的属性"""
#         self.make = make
#         self.model = model
#         self.year = year
#         self.odometer_reading = 0
#
#     def get_discriptive_name(self):
#         """返回描述性信息"""
#         long_name = f"{self.year} {self.make} {self.model}"
#         return long_name.title()
#
#     def read_odometer(self):
#         """打印汽车里程"""
#         print(f"car has {self.odometer_reading} miles.")
#
#     def update_odometer(self,mileage):
#         """将里程表读数设置为特定值"""
#         if mileage >= self.odometer_reading:
#             self.odometer_reading = mileage
#         else:
#              print("error!")
#
#     def increment_odometer(self,miles):
#         """将里程表读数增加指定的量"""
#         self.odometer_reading += miles
#
# class Battery:
#     """模拟电动车电瓶的尝试"""
#     def __init__(self,battery_size):
#         """初始化电瓶属性"""
#         battery_size = int(input("battery size:"))
#         self.battery_size = battery_size
#
#     def descirbe_battery(self):
#         """打印描述电瓶容量的信息"""
#         print(f"battery:{self.battery_size}")
#
#     def get_range(self):
#         """打印一条消息，指出点评续航里程"""
#         if self.battery_size == 75:
#             range = 260
#         elif self.battery_size == 100:
#             range = 315
#         else:
#             range = 'unkown'
#         print(f'Can go {range} miles')
#
# class ElectricCar(Car):
#     """电动汽车"""
#
#     def __init__(self,make,model,year):
#         """初始化父类属性"""
#         super().__init__(make,model,year)
#         """定义新类，没有继承任何类"""
#         self.battery = Battery(self)
# my_tesla = ElectricCar('tesla',"models's",2019)
# print(my_tesla.get_discriptive_name())
# my_tesla.battery.descirbe_battery()
# my_tesla.battery.get_range()













