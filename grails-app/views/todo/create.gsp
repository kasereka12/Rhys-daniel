<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'todo.label', default: 'Todo')}" />
        <title><g:message code="default.create.label" args="[entityName]" /></title>
    </head>
    <body>
    <div id="content" role="main">
        <div class="container">

            <section class="row">
                <div id="create-todo" class="col-12 content scaffold-create" role="main">
                    <g:if test="${flash.message}">
                    <div class="message" role="status">${flash.message}</div>
                    </g:if>
                    <g:hasErrors bean="${this.todo}">
                    <ul class="errors" role="alert">
                        <g:eachError bean="${this.todo}" var="error">
                        <li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message error="${error}"/></li>
                        </g:eachError>
                    </ul>
                    </g:hasErrors>
                    <g:form resource="${todo}" method="POST" class="p-4 shadow-sm rounded bg-light">
                        <fieldset class="form">
                            <div class="d-flex justify-content-between align-items-center">
                                <h3 class="mb-4 text-center">Create Todo</h3>

                                <g:link class="btn btn-info" action="index">Back To todoList</g:link>
                            </div>
                            <!-- Title -->
                            <div class="form-group mb-3">
                                <label for="title" class="form-label">Title <span class="text-danger">*</span></label>
                                <g:textField name="title" value="${todo?.title}" required="true" id="title" class="form-control" />
                            </div>

                            <!-- Description -->
                            <div class="form-group mb-3">
                                <label for="description" class="form-label">Description <span class="text-danger">*</span></label>
                                <g:textArea name="description" value="${todo?.description}" required="true" id="description" class="form-control" rows="3" />
                            </div>

                            <!-- Collaborators -->
                            <div class="form-group mb-3">
                                <label for="collaborators" class="form-label">Collaborators</label>
                                <ul class="list-group">
                                    <g:each in="${todo.collaborators}" var="collaborator">
                                        <li class="list-group-item">${collaborator.username}</li>
                                    </g:each>
                                </ul>
                                <a href="/user/create?todo.id=${todo.id}" class="btn btn-outline-primary btn-sm mt-2">Add Collaborator</a>
                            </div>

                            <!-- Permissions -->
                            <div class="form-group mb-3">
                                <label for="permissions" class="form-label">Permissions</label>
                                <ul class="list-group">
                                    <g:each in="${todo.permissions}" var="permission">
                                        <li class="list-group-item">${permission.role}</li>
                                    </g:each>
                                </ul>
                                <a href="/permission/create?todo.id=${todo.id}" class="btn btn-outline-primary btn-sm mt-2">Add Permission</a>
                            </div>

                            <!-- Author -->
                            <div class="form-group mb-3">
                                <label for="author" class="form-label">Author</label>
                                <input type="text" name="author" value="${todo.author ? todo.author.username : ''}" class="form-control" readonly />
                            </div>
                            <!-- Elements -->
                            <div class="form-group mb-3">
                                <label for="elements" class="form-label">Elements</label>
                                <ul class="list-group">
                                    <g:each in="${todo.elements}" var="element">
                                        <li class="list-group-item"><a href="/element/show/${element.id}">${element.title}</a></li>
                                    </g:each>
                                </ul>
                                <a href="/element/create?todo.id=${todo.id}" class="btn btn-outline-primary btn-sm mt-2">Add Element</a>
                            </div>
                        </fieldset>

                        <fieldset class="buttons text-center">
                            <g:submitButton name="create" class="btn btn-success btn-lg" value="${message(code: 'default.button.create.label', default: 'Create')}" />
                        </fieldset>
                    </g:form>
                </div>
            </section>
        </div>
    </div>
    </body>
</html>
