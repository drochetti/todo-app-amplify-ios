import Amplify
import SwiftUI

final class AppState: ObservableObject {
    @Published
    var todos: [Todo] = []

    // MARK: Query

    func loadTodos() {
        DispatchQueue.main.async {
            Amplify.DataStore.query(Todo.self) {
                switch $0 {
                case let .success(result):
                    self.todos = result
                case let .failure(error):
                    print("Error querying todos")
                    print(error)
                }
            }
        }
    }

    // MARK: Save

    typealias CreateTodoResult = (Result<Void, Error>) -> Void
    func createTodo(withName name: String, onResult: @escaping CreateTodoResult) {
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
        saveTodo(updatedTodo)
    }

    func saveTodo(_ todo: Todo) {
        DispatchQueue.main.async {
            Amplify.DataStore.save(todo) {
                switch $0 {
                case .success:
                    if let index = self.todos.firstIndex(where: { $0.id == todo.id }) {
                        self.todos[index] = todo
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

    // MARK: Delete

    typealias DeleteTodoResult = (Result<Void, Error>) -> Void
    func deleteTodo(withId id: String, onResult: DeleteTodoResult? = nil) {
        DispatchQueue.main.async {
            Amplify.DataStore.delete(Todo.self, withId: id) {
                switch $0 {
                case .success:
                    if let index = self.todos.firstIndex(where: { $0.id == id }) {
                        self.todos.remove(at: index)
                    } else {
                        print("Warning: could not find existing item with id \(id)")
                    }
                    onResult?(.successfulVoid)
                case let .failure(error):
                    onResult?(.failure(error))
                }
            }
        }
    }
}
