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
    def update_odometer(self,mileage):
        """将里程表读数设置为特定值"""
        if mileage >= self.odometer_reading:
            self.read_odometer()
        else:
            print("error!")
    def increment_odometer(self,miles):
        """增加里程"""
        self.odometer_reading += miles

class Battery:
    """模拟电动车电瓶的尝试"""
    def __init__(self,battery_size):
        """初始化电瓶属性"""
        battery_size = int(input("battery size:"))
        self.battery_size = battery_size
    #
    def descirbe_battery(self):
        """打印描述电瓶容量的信息"""
        print(f"battery:{self.battery_size}")

    def get_range(self):
        """打印一条消息，指出点评续航里程"""
        if self.battery_size == 75:
            range = 260
        elif self.battery_size == 100:
            range = 315
        else:
            range = 'unkown'
        print(f'Can go {range} miles')

class ElectricCar(Car):
    """电动汽车"""
    def __init__(self,make,model,year):
        """初始化父类属性"""
        super().__init__(make,model,year)
        """定义新类，没有继承任何类"""


