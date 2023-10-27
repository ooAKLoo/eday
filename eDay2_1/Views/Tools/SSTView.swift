import SwiftUI
import Speech

struct SSTView: View {
    @Binding var backColor: Color
    @Binding var showSSTView: Bool
    @State var screen: CGRect = UIScreen.main.bounds
    @State var selectedLanguage = 0
    
    var body: some View {
        ZStack {
            VStack {
                SSTTopView(showSSTView: $showSSTView, selectedLanguage: $selectedLanguage)
                
                if showSSTView {
                    SSTEditorView(showSSTView: $showSSTView, screen: $screen, selectedLanguage: $selectedLanguage)
                }
            }
            .padding(.top, 40)
            .padding(.horizontal, 16)
            .offset(x: 0, y: 16)
            .frame(width: screen.width)
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    struct SSTTopView: View {
        @Binding var showSSTView: Bool
        @Binding var selectedLanguage: Int
        var languages = ["English", "Chinese"]
        
        var body: some View {
            HStack {
                Picker(selection: $selectedLanguage, label: Text("")) {
                    ForEach(0 ..< languages.count) {
                        Text(self.languages[$0])
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Spacer()
                
                Image(systemName: "xmark")
                    .frame(width: 36, height: 36)
                    .foregroundColor(.white)
                    .background(Color.black)
                    .clipShape(Circle())
                    .onTapGesture {
                        self.showSSTView = false
                    }
            }
        }
    }
    
    struct SSTEditorView: View {
        @Binding var showSSTView: Bool
        @Binding var screen: CGRect
        @Binding var selectedLanguage: Int
        @State private var isRecording = false
        @State private var transcript = ""
        @State private var audioEngine: AVAudioEngine!
        @State private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest!
        @State private var recognitionTask: SFSpeechRecognitionTask!
        @State private var englishSpeechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
        @State private var chineseSpeechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "zh-CN"))!
        @State private var isPolishing = false
        @State private var displayedText = ""
        @State private var animatePolishing = false
        
        @State private var originalText = ""

        
        var body: some View {
            VStack {
                if originalText != ""{
                    Text(originalText)  // 总是显示原始文本
                        .opacity(0.5)   // 使其变灰
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(color: .gray.opacity(0.4), radius: 13, x: 0, y: 2)
                        .transition(.opacity)  // 添加过渡效果
                        .animation(.default)   // 添加默认动画
                    Divider()  // 分割线
                }
                    
                    if isPolishing {
                        Spacer()
                        ProgressView() // 默认的转动的加载指示器
                            .scaleEffect(1.5) // 调整大小，可以根据需要调整
                            .padding()
                            .foregroundColor(.white)
                            .cornerRadius(15)
                    } else {
                        TextEditor(text: $transcript) // Use displayedText here
                            .padding()
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(color: .gray.opacity(0.4), radius: 13, x: 0, y: 2)
                            .padding(.top, 5)
                    }
                
                Spacer()
                
                Button(isRecording ? "Stop Recording" : "Start Recording") {
                    self.isRecording ? self.stopRecording() : self.startRecording()
                }
                .frame(width: screen.width - 40, height: 50)
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.bottom, 50)  // 设置底部的padding，避免按钮被剪掉一半
            }
            .onAppear {
                self.prepareRecording()
            }
        }
        
        private func prepareRecording() {
            self.audioEngine = AVAudioEngine()
            self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            SFSpeechRecognizer.requestAuthorization { (authStatus) in
                OperationQueue.main.addOperation {
                    switch authStatus {
                    case .authorized: break
                    case .denied: self.isRecording = false
                    case .restricted: self.isRecording = false
                    case .notDetermined: self.isRecording = false
                    @unknown default: self.isRecording = false
                    }
                }
            }
        }
        
        private func startRecording() {
            if audioEngine.isRunning {
                print("Audio engine is already running!")
                return
            }
            
            // 创建新的recognitionRequest
            self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            
            
            let node = audioEngine.inputNode
            let recordingFormat = node.outputFormat(forBus: 0)
            
            node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
                self.recognitionRequest.append(buffer)
            }
            
            audioEngine.prepare()
            
            do {
                try audioEngine.start()
                isRecording = true
            } catch {
                print("audioEngine start error: \(error.localizedDescription)")
                return
            }
            
            let recognizer = selectedLanguage == 0 ? englishSpeechRecognizer : chineseSpeechRecognizer
            
            if !recognizer.isAvailable {
                print("SFSpeechRecognizer not currently available.")
                return
            }
            
            
            if !recognizer.isAvailable {
                print("SFSpeechRecognizer not currently available.")
                return
            }
            
            recognitionTask = recognizer.recognitionTask(with: recognitionRequest) { result, error in
                if let result = result {
                    self.transcript = result.bestTranscription.formattedString
                } else if let error = error {
                    print("Recognition error: \(error.localizedDescription)")
                }
            }
            
            isRecording = true
        }
        
        private func stopRecording() {
            if audioEngine.isRunning {
                audioEngine.stop()
                audioEngine.inputNode.removeTap(onBus: 0)
                recognitionRequest.endAudio()
                recognitionTask.cancel()
            }
            
            originalText = transcript // 保存原始文本
            
            recognitionRequest = nil
            recognitionTask = nil
            
            isRecording = false
            
            // 开始润色动画
            startPolishingAnimation()
        }

        
        private func startPolishingAnimation() {
            isPolishing = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // 润色动画持续3秒
                isPolishing = false
                typeOutTextEffect()
            }
        }
        
        private func typeOutTextEffect() {
            let text = "In design, what we pursue is not just external aesthetics but inner simplicity and harmony. Color, like the spices of life, can set a mood and convey emotions. \"Less is more\" is not just a design philosophy but an attitude towards life. By simplifying, we highlight the most crucial messages, and through color, we connect with the audience. Let us explore how to create endless possibilities within limited spaces."
            
            var currentText = ""
            var words = text.split(separator: " ")
            
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                let randomCount = Int.random(in: 1...3) // 每次随机添加1-3个词
                if words.count > 0 {
                    for _ in 0..<randomCount {
                        if !words.isEmpty {
                            currentText += " \(words.removeFirst())"
                            transcript = currentText
                        }
                    }
                } else {
                    timer.invalidate()
                }
            }
        }
    }
}

struct ParentView: View {
    @State private var showSSTView = true
    @State private var backColor:Color = .purple

    var body: some View {
        VStack {
            if showSSTView {
                SSTView(backColor: $backColor, showSSTView: $showSSTView)
            }
        }
    }
}

struct Previews_SSTView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
