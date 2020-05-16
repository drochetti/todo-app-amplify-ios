import SwiftUI

struct TodoListView: View {
    // MARK: View State

    @EnvironmentObject var appState: AppState
    @State var todoDraft: String = ""

    let loader = DataLoader()

    // MARK: View Body

    var body: some View {
        List {
            HStack {
                TextField("Enter a new todo...", text: $todoDraft, onCommit: self.onAddTodo)
                    .padding(.vertical, 12)
                Spacer()
                Button(action: self.onAddTodo) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24, weight: .thin))
                        .disabled(todoDraft.isEmpty)
                        .foregroundColor(todoDraft.isEmpty ? .secondary : .primary)
                }
                .contextMenu(menuItems: self.buildContextMenu)
            }
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

    // MARK: View Components

    private func buildContextMenu() -> some View {
        VStack {
            Button(action: { self.loader.generateTodos(count: 10) }) {
                Text("Add 10 items")
            }
            Button(action: { self.loader.generateTodos(count: 100) }) {
                Text("Add 100 items")
            }
            Button(action: { self.loader.generateTodos(count: 1000) }) {
                Text("Add 1,000 items")
            }
        }
    }

    // MARK: View Events

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
