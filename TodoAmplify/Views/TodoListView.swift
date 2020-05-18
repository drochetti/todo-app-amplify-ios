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
        .navigationBarTitle(Text("Todo List (\(self.appState.todos.count))"))
        .onAppear {
            self.onLoad()
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
            Button(action: { self.loader.generateTodos(count: 10000) }) {
                Text("Add 10,000 items")
            }
            Button(action: { self.loader.generateTodos(count: 100_000) }) {
                Text("Add 100,000 items")
            }
        }
    }

    // MARK: View Events

    private func onLoad() {
        appState.loadTodos()
        let queue = DispatchQueue.global(qos: .background)
        let start = DispatchTime.now()
        _ = appState.subscribe()
            .subscribe(on: queue)
            .sink(receiveCompletion: { print($0) }) { event in
                print("------------")
                print("event = \(event)")
                let elapsed = Double(DispatchTime.now().uptimeNanoseconds - start.uptimeNanoseconds) / 1_000_000_000
                print("elapsedTime = \(elapsed) seconds")
                DispatchQueue.main.async {
                    self.appState.loadTodos()
                }
            }
    }

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
