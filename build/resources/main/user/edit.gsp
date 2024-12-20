<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'user.label', default: 'User')}" />
        <title><g:message code="default.edit.label" args="[entityName]" /></title>
    </head>
    <body>
    <div id="content" role="main">
        <div class="container">

            <section class="row">
                <div id="edit-user" class="col-12 content scaffold-edit" role="main">
                    <div class="container">
                        <div class="d-flex justify-content-end">
                            <g:link class="btn btn-secondary me-2" action="index">
                                <g:message code="default.list.label" args="[entityName]" />
                            </g:link>
                            <g:link class="btn btn-primary" action="create">
                                <g:message code="default.new.label" args="[entityName]" />
                            </g:link>
                        </div>
                    </div>

                    <g:if test="${flash.message}">
                    <div class="message" role="status">${flash.message}</div>
                    </g:if>
                    <g:hasErrors bean="${this.user}">
                    <ul class="errors" role="alert">
                        <g:eachError bean="${this.user}" var="error">
                        <li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message error="${error}"/></li>
                        </g:eachError>
                    </ul>
                    </g:hasErrors>
                    <form action="/user/update/2" method="post">
                        <!-- Simuler le PUT avec un champ _method -->
                        <input type="hidden" name="_method" value="PUT" id="_method" />

                        <!-- Version de l'utilisateur pour la gestion des versions en Grails -->
                        <input type="hidden" name="version" value="${user.version}" id="version" />

                        <fieldset class="form p-4 shadow-sm rounded bg-light">
                            <h3 class="mb-4 text-center">Edit User</h3>

                            <!-- Password -->
                            <div class="form-group mb-3">
                                <label for="password" class="form-label">Password
                                    <span class="text-danger">*</span>
                                </label>
                                <!-- Le champ passwordField sera vide si l'utilisateur ne modifie pas le mot de passe -->
                                <g:passwordField name="password" value="" id="password" class="form-control" />
                            </div>

                            <!-- Username -->
                            <div class="form-group mb-3">
                                <label for="username" class="form-label">Username
                                    <span class="text-danger">*</span>
                                </label>
                                <g:textField name="username" value="${user.username}" required="true" id="username" class="form-control" />
                            </div>

                            <!-- Password Expired -->
                            <div class="form-check mb-3">
                                <g:checkBox name="passwordExpired" checked="${user.passwordExpired}" class="form-check-input" />
                                <label for="passwordExpired" class="form-check-label">Password Expired</label>
                            </div>

                            <!-- Permissions -->
                            <div class="form-group mb-3">
                                <label for="permissions" class="form-label">Permissions</label>
                                <ul class="list-unstyled mb-2">
                                    <g:each in="${user.permissions}" var="permission">
                                        <li>${permission.name}</li>
                                    </g:each>
                                </ul>
                                <a href="/permission/create?user.id=${user.id}" class="btn btn-outline-primary btn-sm">Add Permission</a>
                            </div>

                            <!-- Account Locked -->
                            <div class="form-check mb-3">
                                <g:checkBox name="accountLocked" checked="${user.accountLocked}" class="form-check-input" />
                                <label for="accountLocked" class="form-check-label">Account Locked</label>
                            </div>

                            <!-- Todos -->
                            <div class="form-group mb-3">
                                <label for="todos" class="form-label">Todos</label>
                                <!-- Tableau des Todos -->
                                <table class="table table-bordered table-striped">
                                    <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Todo Title</th>
                                        <th>Actions</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <g:each in="${user.todos}" var="todo">
                                        <tr>
                                            <td>${todo.id}</td>
                                            <td>${todo.title}</td>
                                            <td>
                                                <a href="/todo/show/${todo.id}" class="btn btn-info btn-sm">View</a>
                                            </td>
                                        </tr>
                                    </g:each>
                                    </tbody>
                                </table>
                                <a href="/todo/create?user.id=${user.id}" class="btn btn-outline-primary btn-sm">Add Todo</a>
                            </div>

                            <!-- Account Expired -->
                            <div class="form-check mb-3">
                                <g:checkBox name="accountExpired" checked="${user.accountExpired}" class="form-check-input" />
                                <label for="accountExpired" class="form-check-label">Account Expired</label>
                            </div>

                            <!-- Enabled -->
                            <div class="form-check mb-3">
                                <g:checkBox name="enabled" checked="${user.enabled}" class="form-check-input" />
                                <label for="enabled" class="form-check-label">Enabled</label>
                            </div>
                        </fieldset>

                        <fieldset class="buttons text-center mt-4">
                            <button type="submit" class="btn btn-success btn-lg">Update</button>
                        </fieldset>
                    </form>



                </div>
            </section>
        </div>
    </div>
    </body>
</html>
