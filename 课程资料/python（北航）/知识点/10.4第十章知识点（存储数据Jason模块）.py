# Jason 模块：
import json

# json.dump()要存什么数据，存在哪里
numbers = [2,3,5,7,11,13]
filname = 'F:/pythonProject/json/number.jason'
with open(filname,'a') as f:
    json.dump(numbers,f)
