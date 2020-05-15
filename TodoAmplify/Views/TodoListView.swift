import SwiftUI

struct TodoListView: View {
    // MARK: View State

    @EnvironmentObject var appState: AppState
    @State var todoDraft: String = ""

    // MARK: View Body

    var body: some View {
        List {
            TextField("Enter a new todo...", text: $todoDraft, onCommit: self.onAddTodo)
                .padding(.vertical, 12)
            ForEach(appState.todos, id: \.id) { todo in
                TodoItemView(todo: todo)
                    .environmentObject(self.appState)
            }
        }
        .navigationBarTitle(Text("My Todo List"))
        .onAppear {
            self.appState.loadTodos()
        }
    }

    // MARK: View Functions

    private func onAddTodo() {
        if !todoDraft.isEmpty {
            let name = todoDraft.trimmingCharacters(in: .whitespacesAndNewlines)
            appState.createTodo(withName: name) {
                switch $0 {
                case .success:
                    self.todoDraft = ""
                case let .failure(error):
                    print("Error adding a new todo")
                    print(error)
                }
            }
        }
    }
}
