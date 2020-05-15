import SwiftUI

struct TodoListView: View {
    // MARK: View State

    @EnvironmentObject var appState: AppState
    @State var todoDraft: String = ""
    @State var isEditing: Bool = false

    private var editButtonLabel: Text {
        isEditing ? Text("Done").bold() : Text("Edit")
    }

    // MARK: View Body

    var body: some View {
        List {
            TextField("Enter a new todo...", text: $todoDraft, onCommit: self.onAddTodo)
            ForEach(appState.todos, id: \.id) { todo in
                Text(todo.name)
            }
        }
        .navigationBarTitle(Text("My Todo List"))
        .navigationBarItems(trailing: Button(action: self.onEdit) {
            editButtonLabel
        })
        .onAppear {
            self.appState.loadTodos()
        }
    }

    // MARK: View Functions

    private func onAddTodo() {
        if !todoDraft.isEmpty {
            let name = todoDraft.trimmingCharacters(in: .whitespacesAndNewlines)
            appState.createTodo(name) {
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

    private func onEdit() {
        isEditing.toggle()
    }
}
