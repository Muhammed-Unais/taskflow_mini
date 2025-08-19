import 'package:taskflow_mini/src/auth/domain/enitities/user.dart';
import 'package:taskflow_mini/src/tasks/domain/entities/task.dart';

bool isAdmin(User? user) => user != null && user.role == Role.admin;

/// Can create full tasks? (only admin)
bool canCreateTask(User? user) => isAdmin(user);

/// Can edit all task fields (title, assign, priority, status, archive, delete)?
/// Admin: yes. Staff: no (unless you want special rules).
bool canEditTaskFully(User? user) => isAdmin(user);

/// Can update task status?
/// Admin: yes. Staff: yes if they are assigned to the task.
bool canUpdateTaskStatus(User? user, Task task) {
  if (user == null) return false;
  if (isAdmin(user)) return true;
  // staff can update status only if they are in assignees
  return task.assignees.contains(user.id);
}

/// Can update timeSpent?
/// Admin: yes. Staff: yes if they are an assignee (they should log their own time).
bool canUpdateTimeSpent(User? user, Task task) {
  if (user == null) return false;
  if (isAdmin(user)) return true;
  return task.assignees.contains(user.id);
}

/// Can archive / delete tasks? (admin only)
bool canArchiveOrDelete(User? user) => isAdmin(user);

/// Can assign/unassign users to tasks? (admin only)
bool canAssignUsers(User? user) => isAdmin(user);
