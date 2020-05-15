import SwiftUI

struct TodoItemView: View {
    @EnvironmentObject var appState: AppState

    let todo: Todo

    private var todoDoneIconName: String {
        "checkmark.circle" + (todo.done ? ".fill" : "")
    }

    var body: some View {
        HStack {
            Image(systemName: self.todoDoneIconName)
                .onTapGesture(perform: self.onDoneTap)
                .font(.system(size: 28, weight: .thin))
                .padding(.trailing, 4)
                .foregroundColor(.orange)
            VStack {
                Text(todo.name)
                    .strikethrough(todo.done)
                    .foregroundColor(todo.done ? .secondary : .primary)
                    .lineLimit(1)
            }
        }
        .padding(.vertical, 8)
        .contextMenu(menuItems: self.buildContextMenu)
    }

    private func onDoneTap() {
        appState.toggleDone(on: todo)
    }

    private func onDelete() {
        appState.deleteTodo(withId: todo.id)
    }

    private func buildContextMenu() -> some View {
        VStack {
            Button(action: self.onDoneTap) {
                Text(self.todo.done ? "Uncheck" : "Check")
                Image(systemName: "checkmark.circle" + (self.todo.done ? "" : ".fill"))
            }
            Button(action: self.onDelete) {
                Text("Delete")
                Image(systemName: "trash")
            }
        }
    }
}
