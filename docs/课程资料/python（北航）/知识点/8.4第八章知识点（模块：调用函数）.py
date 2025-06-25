#导入模块方法1：
# from module_name import function_name
# from module_name import function_0,function_1,function_2
# from pizza import make_pizza
# 导入函数方法：function_name()
# make_pizza(15,'egg')

#导入模块方法2：
# import pizza
# 导入函数方法：module_name.function_name()
# pizza.make_pizza(15,'egg')

# 给函数设置别名：from module_name import function_name as fn
# from pizza import make_pizza as mp
# mp(17,'egg')

# 给模块设置别名：import module_name as mn
# import pizza as p
# p.make_pizza(18,'egg')

# 导入模块中的所有函数：from module_name import *
# from pizza import *
# make_pizza(5,'mushroom')