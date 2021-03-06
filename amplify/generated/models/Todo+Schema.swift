// swiftlint:disable all
import Amplify
import Foundation

public extension Todo {
    // MARK: - CodingKeys

    enum CodingKeys: String, ModelKey {
        case id
        case name
        case done
        case priority
        case description
    }

    static let keys = CodingKeys.self

    //  MARK: - ModelSchema

    static let schema = defineSchema { model in
        let todo = Todo.keys

        model.pluralName = "Todos"

        model.fields(
            .id(),
            .field(todo.name, is: .required, ofType: .string),
            .field(todo.done, is: .required, ofType: .bool),
            .field(todo.priority, is: .optional, ofType: .enum(type: Priority.self)),
            .field(todo.description, is: .optional, ofType: .string)
        )
    }
}
