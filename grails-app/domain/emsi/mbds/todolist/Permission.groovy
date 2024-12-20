package emsi.mbds.todolist

class Permission {
    User user;
    Todo todo;
    RoleCollaborators role;
    static belongsTo = [user: User, todo: Todo]
}
