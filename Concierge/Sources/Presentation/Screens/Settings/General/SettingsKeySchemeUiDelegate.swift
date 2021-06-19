import Foundation

class SettingsKeySchemeUiDelegate: UiDelegate {
    
    private enum State {
        case idle
        case applying
    }
    
    private let header: NSTextField
    private let content: KeySchemeView
    
    private let countDownTimer: CountDownTimer
    
    private let hotKeysInteractor: HotKeysInteractor
    private let modifiersController: InAppModifiersController
    
    private var state: State = .idle
    
    init(header: NSTextField,
         content: KeySchemeView,
         hotKeysInteractor: HotKeysInteractor) {
        self.header = header
        self.content = content
        self.hotKeysInteractor = hotKeysInteractor
        self.modifiersController = InAppModifiersController()
        self.countDownTimer = CountDownTimer()
    }
    
    func update() {
        updateHeader()
        updateContent()
        
        self.modifiersController.onHotKeyChanged = { keys in
            if keys.isEmpty {
                return
            }
            self.content.setKeys(keys: keys)
        }
        
        countDownTimer.onTickListener = { [weak self] leftSeconds in
            guard let self = self else {
                return
            }
            
            self.content.rightButtonText = self.generateLeftTimeMessage(timeLeft: leftSeconds)
        }
        
        countDownTimer.onFinishListener = { [weak self] in
            guard let self = self else {
                return
            }
            
            self.state = .idle
            self.hotKeysInteractor.keyModifiers = self.modifiersController.getRecordedKeys()
            self.stopRecording()
            
            self.updateContent()
        }
    }
    
    private func updateHeader() {
        header.stringValue = "settings_general_active_schema_title".localized
    }
    
    private func updateContent() {
        content.text = "settings_general_active_schema_content".localized
        content.rightButtonText = "settings_general_active_schema_change_button".localized
        
        content.hotkeyBackgroundColor = NSColor.from(name: .backgroundPrimary)
        content.hotkeyTextColor = NSColor.from(name: .textPrimary)
        
        content.setKeys(keys: hotKeysInteractor.keyModifiers)
        
        content.clickHandler = { [weak self] in
            guard let self = self else {
                return
            }
            
            if self.state == .idle {
                self.startRecording()
            } else {
                self.stopRecording()
            }
        }
    }
    
    private func startRecording() {
        let defaultCountDownTime = 3.0
        
        self.state = .applying
        self.modifiersController.recordKeys()
        self.content.rightButtonText = self.generateLeftTimeMessage(timeLeft: defaultCountDownTime)
        self.countDownTimer.start(interval: defaultCountDownTime, tickInterval: 1.0)
    }
    
    private func generateLeftTimeMessage(timeLeft: Double) -> String {
        let prefix = "settings_general_active_schema_left_botton_prefix".localized
        let suffix = "settings_general_active_schema_left_botton_suffix".localized
        
        return "\(prefix) \(Int(timeLeft)) \(suffix)"
    }
    
    private func stopRecording() {
        self.state = .idle
        self.modifiersController.cancel()
        self.updateContent()
        self.countDownTimer.cancel()
    }
    
    deinit {
        modifiersController.cancel()
    }
    
}
