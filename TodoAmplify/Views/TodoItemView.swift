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
                .foregroundColor(.accentColor)
            VStack {
                Text(todo.name)
                    .strikethrough(todo.done)
                    .foregroundColor(todo.done ? .secondary : .primary)
                    .lineLimit(1)
            }
        }
        .padding(.vertical, 8)
    }

    private func onDoneTap() {
        appState.toggleDone(on: todo)
    }
}
