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


        var body: some View {
            VStack {
                TextEditor(text: $transcript)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)  // 设置圆角
                    .shadow(color: .gray, radius: 10, x: 5, y: 5)  // 设置阴影
                    .padding(.top, 5)

                Spacer() // 添加一个Spacer，把按钮推向底部

                Button(isRecording ? "Stop Recording" : "Start Recording") {
                    self.isRecording ? self.stopRecording() : self.startRecording()
                }
                .frame(width: screen.width - 40, height: 50)
                .background(Color.green)
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

            recognitionRequest = nil  // 设置recognitionRequest为nil
            recognitionTask = nil     // 设置recognitionTask为nil

            isRecording = false
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
