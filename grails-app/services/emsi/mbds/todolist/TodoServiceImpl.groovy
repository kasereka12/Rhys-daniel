//package emsi.mbds.todolist
//
//class TodoServiceImpl implements TodoService{
//    @Override
//    Todo get(Serializable id) {
//        return null
//    }
//
//    @Override
//    List<Todo> list(Map args) {
//        return null
//    }
//
//    @Override
//    Long count() {
//        return null
//    }
//
//    @Override
//    void delete(Serializable id) {
//
//    }
//
//    @Override
//    Todo save(Todo todo) {
//        return null
//    }
//
//    @Override
//    def addCollaborator(Long todoId, User collaborator, RoleCollaborators role) {
//        // Récupérer la To-Do List par son ID
//        def todo = Todo.get(todoId)
//        if (!todo) {
//            return "To-Do List non trouvée"
//        }
//
//        // Vérifier que l'utilisateur actuel est bien l'auteur de la To-Do List (ou qu'il a les droits nécessaires)
//        def user = springSecurityService.getCurrentUser()
//        if (todo.author != user) {
//            return "Vous n'avez pas l'autorisation d'ajouter un collaborateur à cette To-Do List"
//        }
//        def existingPermission = Permission.findByUserAndTodo(collaborator, todo)
//        if (existingPermission) {
//            return "Ce collaborateur est déjà ajouté à cette To-Do List"
//        }else{
//            // Créer un nouvel objet Permission pour l'utilisateur collaborateur
//            Permission permission = new Permission(user: collaborator, todo: todo, role: role)
//
//            // Ajouter le collaborateur dans la liste des collaborateurs via la relation Permission
//            if (permission.save()) {
//                // Si la permission est sauvegardée, cela signifie que le collaborateur a été ajouté avec succès
//                return "Collaborateur ajouté avec succès"
//            } else {
//                // En cas d'erreur lors de la sauvegarde
//                return "Erreur lors de l'ajout du collaborateur"
//            }
//        }
//
//    }
//}
