#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
修复课程组织：
1. 合并重复的"课程评价"部分
2. 检查课程评价中的课程，如果文件夹下有其他文件（不只是README），移回课程资料
"""

import os
import yaml
from pathlib import Path

def has_other_files(course_path):
    """检查课程文件夹下是否有除了README.md之外的其他文件"""
    course_dir = Path('docs') / course_path.replace('/README.md', '')
    
    if not course_dir.exists():
        print(f"警告: 文件夹不存在: {course_dir}")
        return False
    
    # 获取文件夹下所有文件和文件夹
    items = list(course_dir.iterdir())
    
    # 过滤掉README.md和隐藏文件/文件夹
    other_items = [
        item for item in items 
        if item.name != 'README.md' and not item.name.startswith('.')
    ]
    
    return len(other_items) > 0

def fix_courses():
    """修复课程组织"""
    # 读取mkdocs.yml文件
    with open('mkdocs.yml', 'r', encoding='utf-8') as f:
        data = yaml.safe_load(f)
    
    # 找到"课程资料"和"课程评价"部分
    nav = data['nav']
    course_materials_index = None
    course_materials_items = []
    course_evaluation_items = []
    evaluation_indices = []
    
    for i, item in enumerate(nav):
        if isinstance(item, dict):
            if '课程资料' in item:
                course_materials_index = i
                course_materials_items = item['课程资料'] if item['课程资料'] else []
            elif '课程评价' in item:
                evaluation_indices.append(i)
                if item['课程评价']:
                    course_evaluation_items.extend(item['课程评价'])
    
    # 合并所有课程：课程资料 + 课程评价
    all_courses = course_materials_items + course_evaluation_items
    
    # 重新分类所有课程
    courses_with_materials = []
    courses_without_materials = []
    
    print("正在检查所有课程...")
    for course_item in all_courses:
        if isinstance(course_item, dict):
            course_name = list(course_item.keys())[0]
            course_path = course_item[course_name]
            
            if has_other_files(course_path):
                courses_with_materials.append(course_item)
            else:
                courses_without_materials.append(course_item)
    
    # 更新导航结构
    # 更新"课程资料"
    nav[course_materials_index] = {'课程资料': courses_with_materials}
    
    # 删除所有旧的"课程评价"条目
    for idx in sorted(evaluation_indices, reverse=True):
        nav.pop(idx)
    
    # 添加新的"课程评价"（只有一个，且只在有课程时添加）
    if courses_without_materials:
        # 找到课程资料的位置，在其后插入
        nav.insert(course_materials_index + 1, {'课程评价': courses_without_materials})
    
    # 写回文件
    with open('mkdocs.yml', 'w', encoding='utf-8') as f:
        yaml.dump(data, f, allow_unicode=True, default_flow_style=False, sort_keys=False)
    
    print(f"\n处理完成！")
    print(f"课程资料中的课程（有资料）: {len(courses_with_materials)} 个")
    print(f"课程评价中的课程（只有README）: {len(courses_without_materials)} 个")

if __name__ == '__main__':
    fix_courses()

