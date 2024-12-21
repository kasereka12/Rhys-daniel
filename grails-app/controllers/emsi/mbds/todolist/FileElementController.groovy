package emsi.mbds.todolist

import grails.plugin.springsecurity.annotation.Secured

@Secured(['ROLE_USER', 'ROLE_ADMIN']) // Restriction aux utilisateurs autorisés
class FileElementController {

    def download(Long id) {
        def fileElement = FileElement.get(id)
        if (!fileElement) {
            flash.message = "File not found"
            redirect uri: '/' // Redirige si le fichier n'existe pas
            return
        }

        response.contentType = fileElement.contentType
        response.setHeader("Content-disposition", "attachment; filename=${fileElement.fileName}")
        response.outputStream << fileElement.data
        response.outputStream.flush()
    }

    def show(Long id) {
        def fileElement = FileElement.get(id)
        if (!fileElement) {
            flash.message = "File not found"
            redirect uri: '/' // Redirige si le fichier n'existe pas
            return
        }

        response.contentType = fileElement.contentType
        response.outputStream << fileElement.data
        response.outputStream.flush()
    }
}
