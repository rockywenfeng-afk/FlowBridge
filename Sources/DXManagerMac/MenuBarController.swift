import AppKit

@MainActor
final class MenuBarController {
    private weak var model: AppModel?
    private var statusItem: NSStatusItem?

    func configure(model: AppModel, visible: Bool) {
        self.model = model
        if statusItem == nil {
            let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
            if let image = NSImage(
                systemSymbolName: "rectangle.connected.to.line.below",
                accessibilityDescription: "Flow Bridge"
            ) {
                image.isTemplate = true
                item.button?.image = image
            } else {
                item.button?.title = "FB"
            }
            item.button?.toolTip = "Flow Bridge"

            let menu = NSMenu()
            menu.addItem(makeItem("Flow Bridge 열기", action: #selector(openMainWindow(_:))))
            menu.addItem(.separator())
            menu.addItem(makeItem("DEX 모드 시작", action: #selector(startDeX(_:))))
            menu.addItem(makeItem("세션 중지 및 정리", action: #selector(stopSession(_:))))
            menu.addItem(.separator())
            menu.addItem(makeItem("Flow Bridge 종료", action: #selector(quit(_:))))
            item.menu = menu
            statusItem = item
        }
        statusItem?.isVisible = visible
    }

    private func makeItem(_ title: String, action: Selector) -> NSMenuItem {
        let item = NSMenuItem(title: title, action: action, keyEquivalent: "")
        item.target = self
        return item
    }

    @objc private func openMainWindow(_ sender: Any?) {
        model?.showMainWindow()
    }

    @objc private func startDeX(_ sender: Any?) {
        model?.startDeX()
    }

    @objc private func stopSession(_ sender: Any?) {
        model?.stop()
    }

    @objc private func quit(_ sender: Any?) {
        model?.quit()
    }
}
