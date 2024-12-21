package emsi.mbds.todolist

import grails.plugin.springsecurity.annotation.Secured

@Secured(['ROLE_USER', 'ROLE_ADMIN']) // Restreint l'accès aux utilisateurs autorisés
class FileElement {
    String fileName
    String contentType
    byte[] data

    static belongsTo = [element: Element]

    static constraints = {
        fileName nullable: false, blank: false
        contentType nullable: false, blank: false
        data maxSize: 10485760 // Limite à 10 Mo
    }
}
