package emsi.mbds.todolist

import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException
import static org.springframework.http.HttpStatus.*
import javax.transaction.Transactional
@Secured(['ROLE_USER', 'ROLE_ADMIN'])
@Transactional
class ElementController {

    ElementService elementService

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond elementService.list(params), model: [elementCount: elementService.count()]
    }

    def show(Long id) {
        respond elementService.get(id)
    }

    def create() {
        respond new Element(params)
    }

    def save(Element element) {
        if (element == null) {
            notFound()
            return
        }

        // Handle file upload
        def uploadedFile = request.getFile('file')
        if (uploadedFile && !uploadedFile.empty) {
            def fileElement = new FileElement(
                    name: uploadedFile.originalFilename,
                    fileName: uploadedFile.originalFilename,
                    contentType: uploadedFile.contentType,
                    data: uploadedFile.bytes
            )
            fileElement.save(flush: true)
            element.fileElement = fileElement
        }

        try {
            elementService.save(element)
        } catch (ValidationException e) {
            respond element.errors, view: 'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'element.label', default: 'Element'), element.id])
                redirect element
            }
            '*' { respond element, [status: CREATED] }
        }
    }

    def edit(Long id) {
        respond elementService.get(id)
    }

    def update(Element element) {
        if (element == null) {
            notFound()
            return
        }

        // Handle file update
        def uploadedFile = request.getFile('file')
        if (uploadedFile && !uploadedFile.empty) {
            def fileElement = element.fileElement ?: new FileElement()
            fileElement.name = uploadedFile.originalFilename
            fileElement.fileName = uploadedFile.originalFilename
            fileElement.contentType = uploadedFile.contentType
            fileElement.data = uploadedFile.bytes
            fileElement.save(flush: true)
            element.fileElement = fileElement
        }

        try {
            elementService.save(element)
        } catch (ValidationException e) {
            respond element.errors, view: 'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'element.label', default: 'Element'), element.id])
                redirect element
            }
            '*' { respond element, [status: OK] }
        }
    }

    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        elementService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'element.label', default: 'Element'), id])
                redirect action: "index", method: "GET"
            }
            '*' { render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'element.label', default: 'Element'), params.id])
                redirect action: "index", method: "GET"
            }
            '*' { render status: NOT_FOUND }
        }
    }
}
