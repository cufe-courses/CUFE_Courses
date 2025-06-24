import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import pywt

# 读取数据
df = pd.read_excel('/Users/mark/Desktop/merge.xlsx')

# 将销售时间设为索引
df['销售日期'] = pd.to_datetime(df['销售日期'])
df = df.set_index('销售日期')

# 将数据按商品品类编码进行分组，然后对每组数据进行小波分析
groups = df.groupby('分类编码')
for name, group in groups:
    # 对销售量进行小波分解，这里使用最大级别的小波分解
    signal = group['销量(千克)']
    level = pywt.dwt_max_level(data_len=len(signal), 
    filter_len=pywt.Wavelet('db2').dec_len)
    coeffs = pywt.wavedec(signal, 'db2', level=5)

    
    # 绘制小波分析的结果
    fig, ax = plt.subplots(len(coeffs), 1, figsize=(10, 20))
    for i in range(len(coeffs)):
        ax[i].plot(coeffs[i])
        ax[i].set_title(f'Level {i+1}')
    plt.tight_layout()
    plt.show()