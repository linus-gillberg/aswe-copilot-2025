# Exercise 2: Bug Hunt

**Goal:** Fix 4 bugs using Copilot Agent Mode

**Prerequisites:** Exercise 1 completed, todo-app running

---

## Setup

```bash
cd todo-app
uv run uvicorn app.main:app --reload
```

> The app has 4 planted bugs. Your job: find and fix them with Copilot.
>
> **The challenge:** Describe the *symptom* to Copilot, not the solution. Let AI do the detective work.
>
> Solutions available in `docs/solutions/` if you get stuck.

---

## Bug 1: Missing Default Priority

**Symptom:** Quick-add todos have no priority set.

**Reproduce:**
1. Add a todo using just the title field
2. Edit it — priority is empty or wrong

**Your task:** Craft a prompt describing this bug to Copilot. Focus on the symptom, not the fix.

<details>
<summary>Stuck? Try this prompt</summary>

> ```md
> @workspace Quick-add todos don't have a default priority.
> Find where todos are created and ensure they get a default priority.
> ```
</details>

<details>
<summary>Hint (if Copilot can't find it)</summary>

File: `todo-app/src/app/routes/todos.py` — `create_todo` function.
Add `priority="low"` when creating the Todo object.
</details>

**Verify:** New quick-add todos show priority "low" when edited.

---

## Bug 2: Due Dates Not Saving

**Symptom:** Setting a due date in edit dialog doesn't persist.

**Reproduce:**
1. Edit a todo and set a due date
2. Save and reopen — due date is gone

**Your task:** Describe the symptom to Copilot. What's the user experiencing?

<details>
<summary>Stuck? Try this prompt</summary>

> ```md
> @workspace Due dates aren't saving when I edit todos.
> The date disappears after saving. Find and fix the issue.
> ```
</details>

<details>
<summary>Hint (if Copilot can't find it)</summary>

File: `todo-app/src/app/routes/todos.py` — `update_todo` function.
HTML date inputs send `"2024-01-15"` format.
Change `"%Y-%m-%dT%H:%M"` to `"%Y-%m-%d"`.
</details>

**Verify:** Due dates persist after editing.

---

## Bug 3: Sidebar Count Not Updating

**Symptom:** Deleting a todo doesn't update the sidebar count.

**Reproduce:**
1. Create a list with 3+ todos
2. Delete one — sidebar count stays the same

**Your task:** This is an HTMX issue. How would you describe it to Copilot?

<details>
<summary>Stuck? Try this prompt</summary>

> ```md
> @workspace When I delete a todo, the sidebar count doesn't update.
> The count only updates after a page refresh. Fix it.
> ```
</details>

<details>
<summary>Hint (if Copilot can't find it)</summary>

File: `todo-app/src/app/routes/todos.py` — `delete_todo` function.
Add `response_class=HTMLResponse` to the `@router.delete` decorator.
</details>

**Verify:** Sidebar count updates immediately after deletion.

---

## Bug 4: Overdue Styling Wrong

**Symptom:** Overdue/due-today styling appears on wrong todos.

**Reproduce:**
1. Create todos with yesterday, today, and tomorrow due dates
2. Check styling — it's inconsistent or completely wrong

**Your task:** This is a type comparison bug. Describe what you observe.

<details>
<summary>Stuck? Try this prompt</summary>

> ```md
> @workspace The overdue styling is wrong. Todos that aren't overdue
> are showing as overdue, and vice versa. Check the date comparison logic.
> ```
</details>

<details>
<summary>Hint (if Copilot can't find it)</summary>

File: `todo-app/src/app/utils.py` — `is_overdue` and `is_due_today` functions.
Add `.date()` conversion:
```python
due = todo.due_date.date() if isinstance(todo.due_date, datetime) else todo.due_date
```
</details>

**Verify:** Yesterday=red (overdue), today=orange, tomorrow=normal.

---

## Final Check

```bash
uv run pytest tests/ -v
```

All tests should pass.

---

## Key Takeaways

| Concept | Remember |
|---------|----------|
| Context | Use `@workspace` + describe the symptom |
| Silent failures | Watch for `pass` in except blocks |
| Type mismatches | datetime vs date is common |
| HTMX | Response types matter for swaps |

---

## Resources

- [Copilot Chat Cookbook: Debugging](https://docs.github.com/en/copilot/tutorials/copilot-chat-cookbook#debugging-code)
- [Using @workspace](https://docs.github.com/en/copilot/using-github-copilot/asking-github-copilot-questions-in-your-ide)
- [/fix Slash Command](https://docs.github.com/en/copilot/reference/cheat-sheet#slash-commands)
