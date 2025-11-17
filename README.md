# Webdomain Test Notebooks

BAML project for NextJS code generation.

## Setup

1. Install dependencies:
```bash
poetry install
```

2. Set up environment variables (create `.env` file):
```
OPENAI_API_KEY=your_key_here
```

## Regenerating BAML Client

After modifying BAML files in `baml_src/`, regenerate the client:

### Option 1: Use the wrapper script (Recommended)
```bash
./regenerate_baml.sh
# or
poetry run ./regenerate_baml.sh
```

This script automatically:
- Regenerates the BAML client
- Fixes path issues to ensure the client always uses this project's `baml_src` directory

### Option 2: Manual regeneration
```bash
poetry run baml-cli generate
poetry run python3 fix_baml_paths.py
```

## Why the path fix is needed

The BAML generator creates `baml_client/globals.py` with a relative path `"baml_src"` that resolves from the current working directory. This can cause issues when:
- Running from different directories
- Having multiple BAML projects in parent directories
- The working directory changes

The `fix_baml_paths.py` script ensures the path is always resolved relative to the `baml_client` module location, making it work regardless of where Python is run from.

## Usage

```python
from baml_client import b

result = b.PlanNextjsProjectGenerationSteps(user_prompt="Create a todo app")
print(result)
```

