import SwiftUI
import Speech
import AlertToast
import OpenAI

let openAI = OpenAI(apiToken: "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")

struct SSTView: View {
    @Binding var backColor: Color
    @Binding var showSSTView: Bool
    @State private var isRecording: Bool = false
    @State private var isFormatting: Bool = false
    @State var screen: CGRect = UIScreen.main.bounds
    @State var selectedLanguage = 0
    
    var body: some View {
        ZStack {
            VStack {
                SSTTopView(showSSTView: $showSSTView, selectedLanguage: $selectedLanguage, isFormatting: $isFormatting, isRecording: $isRecording)
                SSTEditorView(screen: $screen, selectedLanguage: $selectedLanguage, isFormatting: $isFormatting, isRecording: $isRecording)
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
        @Binding var isFormatting: Bool
        @Binding var isRecording: Bool
        var languages = ["English", "Chinese"]
        var body: some View {
            HStack {
                Picker(selection: $selectedLanguage, label: Text("")) {
                    ForEach(0..<languages.count, id: \.self) {
                        Text(self.languages[$0])
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .disabled(isFormatting || isRecording)
                
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
        @Binding var screen: CGRect
        @Binding var selectedLanguage: Int
        @Binding var isFormatting: Bool
        @Binding var isRecording: Bool
        @State private var transcript = ""
        @State private var isTranscriptPresenting = false
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
                    .shadow(color: .gray, radius: 5, x: 1, y: 1)  // 设置阴影
                    .padding(.top, 5)
                    .disabled(isFormatting)
                
                Spacer() // 添加一个Spacer，把按钮推向底部
                HStack {
                    Button(isRecording ? "Stop Recording" : "Start Recording") {
                        self.isRecording ? self.stopRecording() : self.startRecording()
                    }.frame(maxWidth: .infinity, maxHeight: 40)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.bottom, 50)  // 设置底部的padding，避免按钮被剪掉一半
                        .disabled(isFormatting)
                    
                    Spacer()
                    
                    Button(isFormatting ? "Formatting" : "Format") {
                        if !self.isFormatting
                        {
                            Task {
                                await startFormatting()
                            }
                        } else {
                            Task {
                                stopFormatting()
                            }
                        }
                    }.frame(maxWidth: .infinity, maxHeight: 40)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.bottom, 50)  // 设置底部的padding，避免按钮被剪掉一半
                        .disabled(isRecording)
                }
            }
            .onAppear {
                self.prepareRecording()
            }.toast(isPresenting: $isFormatting, duration: 0){
                AlertToast(type: .regular, title: "Formatting")
            }.toast(isPresenting: $isTranscriptPresenting, duration: 2){
                AlertToast(type: .regular, title: "No available string to format")
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
        
        private func startFormatting() async {
            if transcript.isEmpty {
                print("here")
                isTranscriptPresenting = true
                return
            }
            let result: ChatResult
            let prompt: String = "Please assist me in transforming the text provided below into a well-structured and logically coherent Markdown document with the following requirement\n---\n1. Your expertise will help in organizing the content to enhance readability and ensure a logical flow of information.\n2. By utilizing appropriate Markdown formatting, headings, lists, and other elements, I aim to create a document that clearly conveys the intended message and adheres to professional writing standards.\n3. Should the text given to you contains any illegitimate material, please respond with the string \"illegal\" with no other content\n---\nBelow is the Text Provided:\n---\n"

            let combinedPrompt = "\(prompt)\(transcript)\n---\n"
            let query = ChatQuery(model: .gpt3_5Turbo, messages: [.init(role: .user, content: combinedPrompt)])
            let resultString: String?

            isFormatting = true
            do {
                result = try await openAI.chats(query: query)
                // 处理结果
                resultString = result.choices.first?.message.content
                if let resultString = resultString, !resultString.elementsEqual("illegal") {
                    print(resultString)
                    transcript = resultString
                } else {
                    print("No response or illegal input")
                }
            } catch {
                // 处理可能的错误
                print("An error occurred: \(error)")
            }
            
            isFormatting = false
        }
        
        private func stopFormatting() {
            isFormatting = false
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
                guard error == nil else {
                    self.audioEngine.stop()
                    self.audioEngine.inputNode.removeTap(onBus: 0)
                    self.recognitionRequest = nil
                    self.recognitionTask = nil
                    return
                }
                guard result != nil else {
                    print("result is equal to nil")
                    return
                }
                
                guard let cur_result = result, !cur_result.bestTranscription.formattedString.isEmpty else {
                    print("result is equal to empty string")
                    return
                }
                
                if let result = result {
                    self.transcript = result.bestTranscription.formattedString
                }
            }
            
            isRecording = true
        }
        private func stopRecording() {
            print("Before stopping recording, transcript: \(transcript)") // 添加此行
            
            
            if audioEngine.isRunning {
                audioEngine.stop()
                audioEngine.inputNode.removeTap(onBus: 0)
                recognitionRequest.endAudio()
                recognitionTask.cancel()
            }
            
            
            //            recognitionRequest = nil  // 设置recognitionRequest为nil
            //            recognitionTask = nil     // 设置recognitionTask为nil
            
            isRecording = false
            print("After stopping recording, transcript: \(transcript)") // 添加此行
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
        ParentView()
    }
}
