#!/usr/bin/env python3
"""Render the tree to k3s_cluster/base/."""
from pathlib import Path
from apps import tree
from render import render

if __name__ == "__main__":
    root = Path(tree.name)
    print(f"rendering {len(tree.children)} top-level folders -> {root}")
    render(tree)
    print("done")