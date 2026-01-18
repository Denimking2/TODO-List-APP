#!/usr/bin/env python3
import os
import subprocess
import sys

def setup_project():
    print("Setting up Multi-Language Todo App...")
    
    # Create necessary directories
    dirs = [
        'native/python',
        'native/cpp',
        'native/build',
        'scripts'
    ]
    
    for dir_path in dirs:
        os.makedirs(dir_path, exist_ok=True)
        print(f"Created directory: {dir_path}")
    
    # Write Python script
    python_code = """
# Python todo processor
# Content from todo_processor.py above
"""
    
    with open('native/python/todo_processor.py', 'w') as f:
        f.write(python_code)
    
    print("\nProject structure created successfully!")
    print("\nNext steps:")
    print("1. Run 'flutter pub get'")
    print("2. Build C++ code for Android: cd android && ./gradlew build")
    print("3. For iOS: Open ios/Runner.xcworkspace in Xcode")
    print("4. Run 'flutter run' to start the app")

if __name__ == "__main__":
    setup_project()