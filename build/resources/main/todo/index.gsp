<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'todo.label', default: 'Todo')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
    </head>
    <body>
    <div id="content" role="main">
        <div class="container">

            <section class="row">
                <div id="list-todo" class="col-12 content scaffold-list" role="main">

                    <g:if test="${flash.message}">
                        <div class="message" role="status">${flash.message}</div>
                    </g:if>


                    <div class="card mb-4">
                        <div class="card-header d-flex justify-content-between">
                            <span><i class="fas fa-table me-1"></i>Todo List</span>
                            <g:link class="btn btn-primary" action="create">
                                <g:message code="default.new.label" args="[entityName]"/>
                            </g:link>
                        </div>

                    <table id="datatablesSimple">
                     <thead>
                       <th>title</th>
                       <th>Description</th>
                       <th>Collaborators</th>
                       <th>Author</th>
                       <th>Elements</th>
                       <th>Action</th>
                     </thead>
                        <tfoot>
                        <tr>
                            <th>title</th>
                            <th>Description</th>
                            <th>Collaborators</th>
                            <th>Author</th>
                            <th>Elements</th>
                            <th>Action</th>
                        </tr>
                        </tfoot>
                    <tbody>
                    <g:each in="${todoList}" var="todo">
                        <tr>
                            <td>
                                <g:link action="show" id="${todo.id}">${todo.title}</g:link>
                            <td>${todo.description}</td>
                            <td>
                                <!-- Tableau des collaborateurs -->
                                <table class="table table-bordered table-striped">
                                    <thead>
                                    <tr>
                                        <th><Name></Name></th>
                                        <th>Actions</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <g:each in="${todo.collaborators}" var="collaborator">
                                        <tr>
                                            <td>${collaborator.username}</td>
                                            <td>
                                                <!-- Lien pour supprimer le collaborateur -->
                                                <g:link  class="btn btn-danger btn-sm">
                                                    Supprimer
                                                </g:link>
                                            </td>
                                        </tr>
                                    </g:each>
                                    </tbody>
                                </table>


                            </td>
                            <td>${todo.author.username}</td>
                            <td>
                               <ul>
                                   <g:each in="${todo.elements}" var="element">
                                        <li>                                       <g:link action="show" controller="element" id="${element.id}">${element.title}</g:link>
                                        </li>
                                   </g:each>
                               </ul>

                            </td>

                            <td>
                                <g:if test="${todo.author == user }">
                                    <!-- Lien pour ouvrir la modal, avec l'attribut data-todo-id pour passer l'ID du Todo -->
                                    <a class="btn btn-outline-success"
                                       href="#addCollaboratorModal"
                                       data-bs-toggle="modal"
                                       data-bs-target="#addCollaboratorModal"
                                       data-todo-id="${todo.id}">Ajouter collaborateur</a>

                                </g:if>
                                <g:form resource="${todo}" method="DELETE">
                                    <fieldset class="buttons">

                                        <g:link class="btn btn-warning" action="edit" resource="${todo}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
                                        <input class="btn btn-danger    " type="submit" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
                                    </fieldset>
                                </g:form>
                            </td>
                        </tr>
                    </g:each>
                    </tbody>
                </table></div>

                    <g:if test="${todoCount > params.int('max')}">
                    <div class="pagination">
                        <g:paginate total="${todoCount ?: 0}" />
                    </div>
                    </g:if>
                </div>
                <!-- Modal -->
                <div class="modal fade" id="addCollaboratorModal" tabindex="-1" aria-labelledby="addCollaboratorModalLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">

                            <div class="modal-header">
                                <h5 class="modal-title" id="addCollaboratorModalLabel">Ajouter un collaborateur</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>

                            <div class="modal-body">
                                <!-- Formulaire pour ajouter un collaborateur -->
                                <form method="post" action="${createLink(controller: 'todo', action: 'addCollaborators')}">

                                    <!-- Input pour le nom d'utilisateur du collaborateur -->
                                    <label for="collaborator">
                                        <input type="text" name="collaborator" id="collaborator" placeholder="Entrer le username du collaborateur" required class="form-control"/>
                                    </label>

                                    <!-- Dropdown pour sélectionner la permission -->
                                    <label for="permission" class="mt-3">
                                        <select name="permission" id="permission" class="form-select">
                                            <g:each in="${permissions}" var="permission">
                                                <option value="${permission}">${permission}</option>
                                            </g:each>
                                        </select>
                                    </label>

                                    <!-- Input caché pour l'ID du todo -->
                                <input type="hidden" name="todoId" id="todoId" value="" />

                                    <!-- Bouton de soumission -->
                                    <button type="submit" class="btn btn-outline-success mt-3">Ajouter Collaborateur</button>
                                </form>
                            </div>

                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fermer</button>
                            </div>

                        </div>
                    </div>
                </div>

            </section>
        </div>
    </div>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Sélectionner tous les liens qui ouvrent la modal
            const openModalLinks = document.querySelectorAll('a[data-bs-target="#addCollaboratorModal"]');

            openModalLinks.forEach(link => {
                // Ajouter un écouteur d'événement sur chaque lien
                link.addEventListener('click', function() {
                    // Récupérer l'ID du Todo à partir de l'attribut 'data-todo-id'
                    const todoId = this.getAttribute('data-todo-id');

                    // Mettre à jour l'input caché du formulaire dans la modal avec l'ID du Todo
                    document.getElementById('todoId').value = todoId;
                });
            });
        });
    </script>

    </body>
</html>