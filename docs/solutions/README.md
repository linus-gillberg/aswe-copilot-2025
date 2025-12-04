# Exercise 2: Bug Hunt - Solutions

This directory contains the fixed versions of files for Exercise 2.

## Bug Fixes Summary

### Bug 1: Missing Default Priority
**File:** `todos.py` - `create_todo()` function (~line 115)

**Problem:** Quick-add todos don't have a default priority set.

**Fix:** Add `priority="low"` when creating the Todo object:
```python
todo = Todo(
    list_id=list_id,
    title=title.strip(),
    position=new_pos,
    priority="low",  # Added this line
)
```

---

### Bug 2: Due Dates Not Saving
**File:** `todos.py` - `update_todo()` function (~line 226)

**Problem:** HTML date inputs send dates in `"2024-01-15"` format, but the code expected `"2024-01-15T00:00"`.

**Fix:** Change the date format string:
```python
# Before (buggy):
todo.due_date = datetime.strptime(due_date, "%Y-%m-%dT%H:%M")

# After (fixed):
todo.due_date = datetime.strptime(due_date, "%Y-%m-%d")
```

---

### Bug 3: Sidebar Count Not Updating
**File:** `todos.py` - `delete_todo()` function (~line 286)

**Problem:** The delete endpoint was missing `response_class=HTMLResponse`, causing HTMX OOB (Out-of-Band) swap to fail.

**Fix:** Add `response_class=HTMLResponse` to the decorator:
```python
# Before (buggy):
@router.delete("/{todo_id}")

# After (fixed):
@router.delete("/{todo_id}", response_class=HTMLResponse)
```

---

### Bug 4: Overdue Styling Wrong
**File:** `utils.py` - `is_overdue()` and `is_due_today()` functions

**Problem:** Comparing a `datetime` object directly to a `date` object gives incorrect results in Python.

**Fix:** Convert datetime to date before comparison:
```python
# Before (buggy):
return todo.due_date < today

# After (fixed):
due = todo.due_date.date() if isinstance(todo.due_date, datetime) else todo.due_date
return due < today
```

---

## How to Use These Solutions

If you get stuck during Exercise 2, you can reference these files:

```bash
# View the solution for a specific bug
cat docs/solutions/todos.py | grep -A5 "FIX:"
cat docs/solutions/utils.py | grep -A5 "FIX:"

# Or compare with your current file
diff todo-app/src/app/routes/todos.py docs/solutions/todos.py
diff todo-app/src/app/utils.py docs/solutions/utils.py
```

To apply all fixes at once (not recommended - try to fix them yourself first!):
```bash
cp docs/solutions/todos.py todo-app/src/app/routes/todos.py
cp docs/solutions/utils.py todo-app/src/app/utils.py
```

---

## Verification

After fixing all bugs, run the tests to verify:
```bash
cd todo-app
uv run pytest tests/ -v
```

All tests should pass.
