# generate_directory.py (版本 8.0 - 最终版)
import os
import urllib.parse
from pathlib import Path

# --- 配置区 ---
# 1. 课程资料文件夹的路径 (相对于此脚本运行的位置)
COURSES_ROOT_DIR = 'docs/课程资料' 

# 2. 需要忽略的文件/文件夹名称列表 (不区分大小写)
FILES_TO_IGNORE = [
    '.DS_Store', 
    'Thumbs.db',
    '.obsidian',
    '.vscode',
    '__pycache__'
]
# --- 配置区结束 ---


def generate_file_tree(start_path: Path) -> str:
    """
    【最终版】生成一个既有清晰层级、又能点击下载的Markdown目录列表。
    """
    
    # --- 辅助函数 1: 构建目录的字典树，确保结构完整无误 ---
    def build_tree_dict(root_path: Path) -> dict:
        tree = {}
        ignore_list = [item.lower() for item in FILES_TO_IGNORE]
        for root, dirs, files in os.walk(str(root_path)):
            dirs[:] = sorted([d for d in dirs if d.lower() not in ignore_list])
            files = sorted([f for f in files if f.lower() not in ignore_list and f.lower() != 'readme.md'])
            
            current_path = Path(root)
            parts = current_path.relative_to(root_path).parts
            current_node = tree
            for part in parts:
                if part != '.':
                    current_node = current_node.setdefault(part, {})
            
            for d in dirs:
                current_node.setdefault(d, {})
            for f in files:
                current_node[f] = None
        return tree

    # --- 辅助函数 2: 将字典树格式化为带链接的Markdown嵌套列表 ---
    def format_as_markdown_list(tree_dict: dict, level: int = 0, path_parts: list = []) -> list[str]:
        lines = []
        indent = "  " * level  # Markdown列表的标准缩进
        
        for name, content in sorted(tree_dict.items()):
            if isinstance(content, dict):  # 是目录
                lines.append(f"{indent}- 📁 {name}")
                lines.extend(format_as_markdown_list(content, level + 1, path_parts + [name]))
            else:  # 是文件
                # 为链接路径进行URL编码，处理空格等特殊字符
                encoded_path = "/".join(urllib.parse.quote(part) for part in path_parts + [name])
                lines.append(f"{indent}- 📄 [{name}]({encoded_path})")
        return lines

    # --- 主逻辑 ---
    file_tree = build_tree_dict(start_path)

    if not file_tree:
        return "\n## 📄 文件目录与下载\n\n_该课程暂无文件资料。_\n"

    lines = ["\n## 📄 文件目录与下载\n"]
    lines.extend(format_as_markdown_list(file_tree))
        
    return "\n".join(lines)


def update_readme_file(readme_path: Path, content_to_insert: str):
    """
    通过查找目录标题“## 📄 文件目录与下载”来更新README.md。
    """
    directory_header = "## 📄 文件目录与下载"
    replacement_block = "\n" + content_to_insert.strip() + "\n"

    if not readme_path.exists():
        print(f"  ⚠️  警告: 未找到 {readme_path}，将自动创建。")
        readme_content = f"# {readme_path.parent.name}\n\n课程介绍待补充。" + replacement_block
        readme_path.write_text(readme_content, encoding='utf-8')
        print(f"  ✅ 已创建并初始化 {readme_path}。")
        return

    try:
        original_content = readme_path.read_text(encoding='utf-8')
        header_index = original_content.find(directory_header)
        
        if header_index != -1:
            content_before_header = original_content[:header_index]
            new_content = content_before_header.rstrip() + replacement_block
            status = "✅ 已更新"
        else:
            new_content = original_content.rstrip() + "\n" + replacement_block
            status = "⚠️  警告: 未找到目录标题，已在末尾追加"

        if new_content.strip() != original_content.strip():
            readme_path.write_text(new_content, encoding='utf-8')
            print(f"  {status} {readme_path.parent.name} 的文件目录。")
        else:
            print(f"  ℹ️  目录无变化，已跳过写入。")

    except Exception as e:
        print(f"  ❌ 错误: 处理 {readme_path} 时发生错误: {e}")


def main():
    """
    主函数，执行整个流程。
    """
    root_path = Path(COURSES_ROOT_DIR)
    if not root_path.is_dir():
        print(f"❌ 错误：找不到指定的课程根目录 '{root_path.resolve()}'。请检查路径是否正确。")
        return

    print(f"🚀 开始扫描课程目录: {root_path.resolve()}")
    print(f"🙈 将忽略以下文件/目录: {FILES_TO_IGNORE}")

    course_dirs = sorted([d for d in root_path.iterdir() if d.is_dir() and d.name.lower() not in [item.lower() for item in FILES_TO_IGNORE]])

    for course_dir in course_dirs:
        print(f"\n📁 正在处理课程: {course_dir.name}")
        readme_file_path = course_dir / "README.md"
        
        file_tree_md = generate_file_tree(course_dir)
        update_readme_file(readme_file_path, file_tree_md)

    print("\n✨ 所有课程目录更新完毕！")


if __name__ == "__main__":
    main()