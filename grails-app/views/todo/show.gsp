<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'todo.label', default: 'Todo')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
    </head>
    <body>
    <div id="content" role="main">
        <div class="container">

            <section class="row">
                <div id="show-todo" class="col-12 content scaffold-show" role="main">


                    <g:if test="${flash.message}">
                    <div class="message" role="status">${flash.message}</div>
                    </g:if>
                    <table class="table table-bordered">
                        <thead>
                        <tr>
                            <th>Property</th>
                            <th>Value
                                <g:link class="btn btn-danger float-end" action="index">Back</g:link></th>
                        </tr>
                        </thead>
                        <tbody>
                        <!-- Afficher le titre du Todo -->
                        <tr>
                            <td>Title</td>
                            <td><g:fieldValue bean="${todo}" field="title" /></td>
                        </tr>

                        <!-- Afficher la description du Todo -->
                        <tr>
                            <td>Description</td>
                            <td><g:fieldValue bean="${todo}" field="description" /></td>
                        </tr>

                        <!-- Afficher la date de création du Todo -->
                        <tr>
                            <td>Date Created</td>
                            <td><g:formatDate date="${todo.dateCreated}" format="yyyy-MM-dd HH:mm:ss" /></td>
                        </tr>

                        <!-- Afficher la date de dernière mise à jour du Todo -->
                        <tr>
                            <td>Last Updated</td>
                            <td><g:formatDate date="${todo.lastUpdated}" format="yyyy-MM-dd HH:mm:ss" /></td>
                        </tr>

                        <!-- Afficher les éléments associés au Todo -->
                        <tr>
                            <td>Elements</td>
                            <td>
                                <ul>
                                    <g:each in="${todo.elements}" var="element">

                                        <li>
                                            <g:link action="show" controller="element" id="${element.id}">${element.title}</g:link>
                                        </li>
                                    </g:each>
                                </ul>
                            </td>
                        </tr>

                        <!-- Afficher les collaborateurs associés au Todo -->
                        <tr>
                            <td>Collaborators</td>
                            <td>
                                <ul>
                                    <g:each in="${todo.collaborators}" var="collaborator">
                                        <li>${collaborator.username}</li>
                                    </g:each>
                                </ul>
                            </td>
                        </tr>

                        <!-- Afficher les permissions associées au Todo -->
                        <tr>
                            <td>Permissions</td>
                            <td>
                                <ul>
                                    <g:each in="${todo.permissions}" var="permission">
                                        <li>${permission}</li>  <!-- Remplacer par le champ pertinent de la permission -->
                                    </g:each>
                                </ul>
                            </td>
                        </tr>
                        </tbody>
                    </table>


                </div>
            </section>
        </div>
    </div>
    </body>
</html>
