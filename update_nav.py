# update_nav.py

import os
from ruamel.yaml import YAML

# --- 配置 ---
DOCS_DIR = 'docs'  # MkDocs 的文档目录
CONFIG_FILE = 'mkdocs.yml'  # MkDocs 的配置文件
HOMEPAGE_NAME = '首页' # 网站首页在导航栏的显示名称
# --- 配置结束 ---


def convert_tree_to_nav(tree):
    """递归函数，将嵌套的字典树转换为 MkDocs 的 nav 列表格式。"""
    nav_list = []
    # 对键进行排序，以确保导航栏顺序稳定
    for key in sorted(tree.keys()):
        value = tree[key]
        if isinstance(value, dict):
            # 如果值是字典，说明是一个子目录，需要递归处理
            nav_list.append({key: convert_tree_to_nav(value)})
        else:
            # 如果值是字符串，说明是最终的课程页面
            nav_list.append({key: value})
    return nav_list


def generate_nav():
    """
    扫描 docs 目录并生成 mkdocs nav 配置.
    此函数可以处理任意深度的嵌套目录。
    """
    print("🚀 开始扫描目录并生成导航配置...")
    
    yaml = YAML()
    yaml.preserve_quotes = True
    
    try:
        with open(CONFIG_FILE, 'r', encoding='utf-8') as f:
            config = yaml.load(f)
    except FileNotFoundError:
        print(f"❌ 错误：配置文件 '{CONFIG_FILE}' 未找到。")
        return

    # --- 核心逻辑开始 ---

    # 1. 使用 os.walk 遍历所有目录，找到包含 README.md 的文件夹
    readme_paths = {}
    for root, dirs, files in os.walk(DOCS_DIR):
        if 'README.md' in files:
            relative_dir_path = os.path.relpath(root, DOCS_DIR)
            if relative_dir_path == '.':
                continue
            path_parts = tuple(relative_dir_path.split(os.sep))
            full_md_path = os.path.join(relative_dir_path, 'README.md').replace('\\', '/')
            readme_paths[path_parts] = full_md_path

    # 2. 构建一个嵌套的字典树，以反映目录结构
    nav_tree = {}
    # 关键修复点 1：通过路径长度倒序排序，优先处理最深的路径
    sorted_paths = sorted(readme_paths.keys(), key=len, reverse=True)

    for path_parts in sorted_paths:
        current_level = nav_tree
        for part in path_parts[:-1]:
            current_level = current_level.setdefault(part, {})
        
        leaf_name = path_parts[-1]
        
        # 关键修复点 2：只有当这个位置尚未被创建为目录时，才将其设置为页面链接
        if not isinstance(current_level.get(leaf_name), dict):
            current_level[leaf_name] = readme_paths[path_parts]

    # 3. 使用递归函数将字典树转换为 mkdocs nav 格式
    generated_nav = convert_tree_to_nav(nav_tree)
    
    # --- 核心逻辑结束 ---

    # 4. 组装最终的导航列表
    homepage_file = 'index.md' if os.path.exists(os.path.join(DOCS_DIR, 'index.md')) else 'README.md'
    new_nav = [{HOMEPAGE_NAME: homepage_file}]
    new_nav.extend(generated_nav)

    # 5. 更新并写回配置文件
    config['nav'] = new_nav
    with open(CONFIG_FILE, 'w', encoding='utf-8') as f:
        yaml.dump(config, f)
        
    print(f"✅ 导航栏更新成功！请查看 '{CONFIG_FILE}' 文件。")

if __name__ == '__main__':
    generate_nav()