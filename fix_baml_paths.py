#!/usr/bin/env python3
"""
Post-generation script to fix baml_client paths.
This ensures the BAML client always uses this project's baml_src directory.

Run this after 'baml-cli generate' or use the regenerate_baml.sh script.
"""

from pathlib import Path
import re

def fix_globals_py():
    """Fix globals.py to use absolute paths."""
    baml_client_dir = Path(__file__).parent / "baml_client"
    globals_py = baml_client_dir / "globals.py"
    
    if not globals_py.exists():
        print(f"⚠️  {globals_py} not found")
        return False
    
    content = globals_py.read_text()
    
    # Check if already fixed
    if "_baml_src_dir" in content:
        print("✓ globals.py already uses absolute paths")
        return True
    
    # Add Path import if needed
    if "from pathlib import Path" not in content:
        content = content.replace(
            "import os",
            "import os\nfrom pathlib import Path"
        )
    
    # Replace relative path with absolute path resolution
    pattern = r'DO_NOT_USE_DIRECTLY_UNLESS_YOU_KNOW_WHAT_YOURE_DOING_RUNTIME = BamlRuntime\.from_files\(\s+"baml_src",'
    replacement = '''# Resolve baml_src path relative to this file's location to ensure we use the correct project's BAML files
_baml_client_dir = Path(__file__).parent.absolute()
_baml_src_dir = _baml_client_dir.parent / "baml_src"

DO_NOT_USE_DIRECTLY_UNLESS_YOU_KNOW_WHAT_YOURE_DOING_RUNTIME = BamlRuntime.from_files(
  str(_baml_src_dir),'''
    
    new_content = re.sub(pattern, replacement, content)
    
    if new_content == content:
        print("⚠️  Could not find pattern to replace in globals.py")
        return False
    
    globals_py.write_text(new_content)
    print("✓ Fixed globals.py to use absolute paths")
    return True

def fix_init_py():
    """Add auto-fix code to __init__.py so it fixes globals.py on import."""
    baml_client_dir = Path(__file__).parent / "baml_client"
    init_py = baml_client_dir / "__init__.py"
    
    if not init_py.exists():
        print(f"⚠️  {init_py} not found")
        return False
    
    content = init_py.read_text()
    
    # Check if auto-fix code is already present
    if "# Auto-fix: Ensure baml_src path" in content:
        print("✓ __init__.py already has auto-fix code")
        return True
    
    # Auto-fix code to insert before __version__
    auto_fix_code = """# Auto-fix: Ensure baml_src path is always resolved correctly relative to this project
import os
from pathlib import Path

# Fix globals.py to use absolute paths before it's imported
_this_file = Path(__file__).absolute()
_baml_client_dir = _this_file.parent
_globals_py = _baml_client_dir / "globals.py"

if _globals_py.exists():
    _globals_content = _globals_py.read_text()
    # Check if it needs fixing (uses relative "baml_src" path)
    if '"baml_src"' in _globals_content and "_baml_src_dir" not in _globals_content:
        # Fix the path resolution
        if "from pathlib import Path" not in _globals_content:
            _globals_content = _globals_content.replace(
                "import os",
                "import os\\nfrom pathlib import Path"
            )
        
        # Replace relative path with absolute path resolution
        _replacement = '''# Resolve baml_src path relative to this file's location to ensure we use the correct project's BAML files
_baml_client_dir = Path(__file__).parent.absolute()
_baml_src_dir = _baml_client_dir.parent / "baml_src"

DO_NOT_USE_DIRECTLY_UNLESS_YOU_KNOW_WHAT_YOURE_DOING_RUNTIME = BamlRuntime.from_files(
  str(_baml_src_dir),'''
        _globals_content = _globals_content.replace(
            'DO_NOT_USE_DIRECTLY_UNLESS_YOU_KNOW_WHAT_YOURE_DOING_RUNTIME = BamlRuntime.from_files(\\n  "baml_src",',
            _replacement
        )
        _globals_py.write_text(_globals_content)

"""
    
    # Insert before __version__
    if "__version__" in content:
        content = content.replace("__version__ =", auto_fix_code + "\n__version__ =")
        init_py.write_text(content)
        print("✓ Added auto-fix to __init__.py")
        return True
    else:
        print("⚠️  Could not find __version__ in __init__.py")
        return False

if __name__ == "__main__":
    print("🔧 Fixing BAML client paths...")
    fix_globals_py()
    fix_init_py()
    print("✅ Done! Your baml_client now always uses the correct project's baml_src directory.")

