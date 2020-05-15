import Amplify
import Combine
import SwiftUI

final class AppState: ObservableObject {
    let didChange = PassthroughSubject<AppState, Never>()

    @Published
    var todos: [Todo] = []

    func loadTodos() {
        DispatchQueue.main.async {
            Amplify.DataStore.query(Todo.self) {
                switch $0 {
                case let .success(result):
                    self.todos.append(contentsOf: result)
                    self.didChange.send(self)
                case let .failure(error):
                    print("Error querying todos")
                    print(error)
                }
            }
        }
    }
}
