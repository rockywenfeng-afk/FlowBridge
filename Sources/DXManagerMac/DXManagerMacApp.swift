import SwiftUI

@main
struct DXManagerMacApp: App {
    @StateObject private var model = AppModel()

    var body: some Scene {
        WindowGroup { ContentView().environmentObject(model).onAppear(perform: model.configureLaunchPresentation) }
            .commands { CommandGroup(replacing: .appTermination) { Button("Flow Bridge 종료", action: model.quit).keyboardShortcut("q") } }
    }
}
