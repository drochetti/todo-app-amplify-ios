
class TodoViewModel {
    // read-only
    let id: String
    let originalName: String

    // form-binding properties
    var name: String
    var description: String
    var done: Bool
    var priority: String

    init(from todo: Todo) {
        id = todo.id
        originalName = todo.name
        name = todo.name
        description = todo.description ?? ""
        done = todo.done
        priority = todo.priority?.label ?? Priority.normal.label
    }

    func asModel() -> Todo {
        let description = self.description.isEmpty
            ? nil
            : self.description.trimmingCharacters(in: .whitespacesAndNewlines)
        let name = self.name.isEmpty
            ? originalName
            : self.name.trimmingCharacters(in: .whitespacesAndNewlines)
        return Todo(id: id,
                    name: name,
                    done: done,
                    priority: .fromLabel(priority),
                    description: description)
    }
}
