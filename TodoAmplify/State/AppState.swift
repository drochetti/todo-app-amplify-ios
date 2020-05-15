import Amplify
import SwiftUI

final class AppState: ObservableObject {
    @Published
    var todos: [Todo] = []

    func loadTodos() {
        DispatchQueue.main.async {
            Amplify.DataStore.query(Todo.self) {
                switch $0 {
                case let .success(result):
                    self.todos.append(contentsOf: result)
                case let .failure(error):
                    print("Error querying todos")
                    print(error)
                }
            }
        }
    }

    typealias CreateTodoResult = (Result<Void, Error>) -> Void
    func createTodo(_ name: String, onResult: @escaping CreateTodoResult) {
        let todo = Todo(name: name, done: false, priority: .normal)
        DispatchQueue.main.async {
            Amplify.DataStore.save(todo) {
                switch $0 {
                case .success:
                    self.todos.insert(todo, at: 0)
                    onResult(.successfulVoid)
                case let .failure(error):
                    onResult(.failure(error))
                }
            }
        }
    }

    func toggleDone(on todo: Todo) {
        var updatedTodo = todo
        updatedTodo.done = !todo.done
        DispatchQueue.main.async {
            Amplify.DataStore.save(updatedTodo) {
                switch $0 {
                case .success:
                    if let index = self.todos.firstIndex(where: { $0.id == todo.id }) {
                        self.todos[index] = updatedTodo
                    } else {
                        print("Warning: could not find existing item with id \(todo.id)")
                    }
                case let .failure(error):
                    print("Error updating todo done status")
                    print(error)
                }
            }
        }
    }
}
