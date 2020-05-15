import SwiftUI

struct TodoListView: View {
    // MARK: View State

    @EnvironmentObject var appState: AppState
    @State var draftTitle: String = ""
    @State var isEditing: Bool = false

    private var editButtonLabel: Text {
        isEditing ? Text("Done").bold() : Text("Edit")
    }

    // MARK: View Body

    var body: some View {
        List(appState.todos, id: \.id) { todo in
            Text(todo.name)
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

    private func onEdit() {
        isEditing.toggle()
    }
}
