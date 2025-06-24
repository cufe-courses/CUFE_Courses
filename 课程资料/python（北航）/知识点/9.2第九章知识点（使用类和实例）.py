# 使用类
# class Car:
#     """模拟汽车"""
#     def __init__(self,make,model,year):
#         """初始化描述汽车的属性"""
#         self.make = make
#         self.model = model
#         self.year = year
#
#     def get_discriptive_name(self):
#         """返回描述性信息"""
#         long_name = f"{self.year} {self.make} {self.model}"
#         return long_name
# new_car = Car('Audi','A4',2019)
# print(new_car.get_discriptive_name())

# 指定属性的默认值（例：odometer）
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
#         return long_name
#     def read_odometer(self):
#         """打印汽车里程"""
#         print(f"car has {self.odometer_reading} miles.")
# new_car = Car('Audi','A4',2019)
# print(new_car.get_discriptive_name())
# new_car.read_odometer()
#
# 修改属性的值：
# new_car.odometer_reading = 23
# new_car.read_odometer()

# 通过方法修改属性的值：增添新函数（自己写的！）
class Car:
    """模拟汽车"""
    def __init__(self,make,model,year):
        """初始化描述汽车的属性"""
        self.make = make
        self.model = model
        self.year = year
        self.odometer_reading = 0

    def get_discriptive_name(self):
        """返回描述性信息"""
        long_name = f"{self.year} {self.make} {self.model}"
        return long_name
    def read_odometer(self):
        """打印汽车里程"""
        print(f"car has {self.odometer_reading} miles.")
    def update_odometer(self):
        """将里程表读数设置为特定值"""
        while True:
            mileage = int(input('write odometer:'))
            if 1000>= mileage >= self.odometer_reading:
                self.odometer_reading = mileage
                self.read_odometer()
            elif mileage <= mileage:
                print('incorrect!')
            else:
                print("error!")
                break
new_car = Car('Audi','A4',2019)
print(new_car.get_discriptive_name())
new_car.update_odometer()
new_car.read_odometer()

# 通过方法对属性的值进行递增：
class Car:
    """模拟汽车"""
    def __init__(self,make,model,year):
        """初始化描述汽车的属性"""
        self.make = make
        self.model = model
        self.year = year
        self.odometer_reading = 0

    def get_discriptive_name(self):
        """返回描述性信息"""
        long_name = f"{self.year} {self.make} {self.model}"
        return long_name.title()

    def read_odometer(self):
        """打印汽车里程"""
        print(f"car has {self.odometer_reading} miles.")

    def update_odometer(self,mileage):
        """将里程表读数设置为特定值"""
        if mileage >= self.odometer_reading:
            self.odometer_reading = mileage
        else:
             print("error!")

    def increment_odometer(self,miles):
        """将里程表读数增加指定的量"""
        self.odometer_reading += miles

new_car = Car('Subaru','outback',2019)
print(new_car.get_discriptive_name())
new_car.update_odometer(23_500)
new_car.read_odometer()

new_car.increment_odometer(1)
new_car.read_odometer()









