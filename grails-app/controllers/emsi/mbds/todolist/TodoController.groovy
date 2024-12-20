package emsi.mbds.todolist

import grails.gorm.transactions.Transactional
import grails.plugin.springsecurity.SpringSecurityService
import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException
import static org.springframework.http.HttpStatus.*

@Secured(['ROLE_ADMIN' , 'ROLE_USER'])
@Transactional
class TodoController {

    TodoService todoService
    UploadService uploadService
    SpringSecurityService springSecurityService
    UserService userService


    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        //respond todoService.list(params), model:[todoCount: todoService.count()]
        def user = springSecurityService.getCurrentUser()
        def userId =  user.id;
        if (user.authorities.any { it.authority == 'ROLE_ADMIN' }) {
            respond todoService.list(params), model: [todoCount: todoService.count()]
        } else {
            // Récupérer les Todo où l'utilisateur est l'auteur
            def todos = Todo.findAllByAuthor(user, params)

            // Récupérer les Todo où l'utilisateur est un collaborateur
            // / Récupérer l'utilisateur par son ID

            def todos1 = Todo.executeQuery(
                    'SELECT t FROM Todo t JOIN t.collaborators c WHERE c.id = :userId',
                    [userId: userId]
            )
            todos1.each { todo ->
                println "Todo: ${todo.title}, Description: ${todo.description}, Date Création: ${todo.dateCreated}, Dernière Mise à Jour: ${todo.lastUpdated}"
            }




            // Fusionner les deux listes
            def allTodos = todos + todos1;

            def finaltodos = allTodos.toSet()
            def permissions = RoleCollaborators.values();



            // Répondre avec les Todo fusionnés et l'utilisateur
            respond finaltodos.toList(), model: [user: user, todoCount: allTodos.size(), permissions: permissions]

        }
    }

    def addCollaborators(Long todoId, String collaborator, String permission) {


        // Find the user by username
        def user = User.findByUsername(collaborator)
        if (!user) {
            flash.message = "Collaborator not found."
            redirect(action: 'index')
            return
        }

        // Find the Todo by its ID
        def todo = Todo.get(todoId)

        if (!todo) {
            flash.message = "Todo not found."
            redirect(action: 'index')
            return
        }

        // Add the user as a collaborator
        todo.addToCollaborators(user)
        // Save the updated Todo
        if (!todo.save(flush: true)) {
            todo.errors.allErrors.each { println it }  // Log errors if save fails
        }

        def collaboratorPermission = new Permission(todo: todo, user: user, role: permission).save()


        flash.message = "Collaborator added successfully with permission: ${permission}"
        redirect(action: 'index')
    }




    def show(Long id) {
        respond todoService.get(id)
    }

    def create() {
        def todo = new Todo(params)

        // Assigner l'utilisateur connecté comme auteur de la Todo
        todo.author = springSecurityService.currentUser

        respond todo
    }

    def save(Todo todo) {
        if (todo == null) {
            notFound()
            return
        }

        try {
            todoService.save(todo)
            // TODO: Ajouter la logique d'ajout d'élément dans la Todolist
            // TODO : Il va aussi falloir gérer ici l'upload d'image, que l'on va déléguer à un service qui sera en charge de ça
        } catch (ValidationException e) {
            respond todo.errors, view:'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'todo.label', default: 'Todo'), todo.id])
                redirect todo
            }
            '*' { respond todo, [status: CREATED] }
        }
    }

    def edit(Long id) {
        // Get the current user
        def user = springSecurityService.getCurrentUser()

        // Find the Todo by its ID
        def todo = todoService.get(id)

        // Check if the Todo exists
        if (!todo) {
            flash.message = "Todo not found."
            redirect(action: 'index')
            return
        }

        // Check if the user has the 'editor' permission for the Todo

        def hasPermission = todo.permissions.any {
            ((it.user == user && it.role == RoleCollaborators.editor) ||
                    it.user.authorities.any { authority -> authority.authority == 'ROLE_ADMIN' })
        }

        if (!hasPermission && todo.author != user) {
            flash.message = "You do not have permission to edit this Todo."
            redirect(action: 'index')  // Redirect to another action or page as needed
            return
        }



        // If the user has permission, respond with the Todo object to be edited
        respond todo
    }


    def update(Todo todo) {
        if (todo == null) {
            notFound()
            return
        }

        try {
            todoService.save(todo)
        } catch (ValidationException e) {
            respond todo.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'todo.label', default: 'Todo'), todo.id])
                redirect todo
            }
            '*'{ respond todo, [status: OK] }
        }
    }

    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        todoService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'todo.label', default: 'Todo'), id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'todo.label', default: 'Todo'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
