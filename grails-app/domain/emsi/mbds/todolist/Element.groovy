package emsi.mbds.todolist

class Element {
    String title
    String description
    Boolean isChecked = Boolean.FALSE

    static belongsTo = [todo: Todo]
    static hasOne = [fileElement: FileElement]

    static constraints = {
        title nullable: false, blank: false
        description nullable: true, blank: true
        isChecked nullable: false
        fileElement nullable: true // Permet d'accepter un élément sans fichier
    }

    static mapping = {
        description type: "text"
    }
}
