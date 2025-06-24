import pandas as pd
import numpy as np
from scipy.stats import kurtosis, skew

# 读取数据
df = pd.read_excel('/Users/mark/Desktop/merge.xlsx')

# 描述性统计分析
desc_stats = df.groupby('单品编码')['销量(千克)'].describe()

# 计算偏度和峰度
groups = df.groupby('单品编码')
skewness = groups['销量(千克)'].skew()
kurt = groups['销量(千克)'].apply(kurtosis)

# 将偏度和峰度添加到描述性统计分析结果中
desc_stats['skewness'] = skewness
desc_stats['kurtosis'] = kurt

# 异常值识别，这里使用Z-score方法，即偏离均值3个标准差的值为异常值
df['z_score'] = groups['销量(千克)'].apply(lambda x: np.abs((x - x.mean()) / x.std()))
outliers = df[df['z_score'] > 3]
outliers.to_excel('/Users/mark/Desktop/2.xlsx',sheet_name='非正常值',index = False,na_rep = 0,inf_rep = 0)