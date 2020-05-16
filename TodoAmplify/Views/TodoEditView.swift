import Combine
import SwiftUI

struct TodoEditView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State
    var todo: TodoViewModel

    var body: some View {
        Form {
            Section(header: Text("About")) {
                TextField("e.g. Release new version of Amplify",
                          text: $todo.name,
                          onCommit: self.onSave)
                    .lineLimit(1)
                TextField("Detailed description",
                          text: $todo.description,
                          onCommit: self.onSave)
                    .lineLimit(6)
            }
            Section(header: Text("Status")) {
                Toggle(isOn: $todo.done) {
                    Text("Is it done?")
                }
            }
            Section(header: Text("Priority")) {
                HStack {
                    Picker(selection: $todo.priority, label: Text("Priority")) {
                        ForEach(Priority.all, id: \.label) { priority in
                            Text(priority.label)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            Section(header: Text("Action")) {
                Button(action: self.onDelete) {
                    HStack {
                        Image(systemName: "trash")
                        Text("Delete").bold()
                        Spacer()
                        Text("cannot undo")
                            .font(.system(.caption))
                            .foregroundColor(.secondary)
                    }
                }
                .foregroundColor(.red)
            }
        }
        .navigationBarTitle("Todo")
    }

    private func onSave() {
        appState.saveTodo(todo.asModel())
    }

    private func onDelete() {
        appState.deleteTodo(withId: todo.id) {
            switch $0 {
            case .success:
                self.presentationMode.wrappedValue.dismiss()
            case let .failure(error):
                print("Error deleting todo")
                print(error)
            }
        }
    }
}
