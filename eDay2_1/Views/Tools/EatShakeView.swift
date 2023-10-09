import SwiftUI
import Combine
import AVFoundation
import UIKit
import Foundation

struct Dish {
    let name: String
    let englishName: String
    let image: Image
}

struct ShakeDetectingViewControllerRepresentable: UIViewControllerRepresentable {
    let shakeBegan: () -> Void
    let shakeEnded: () -> Void
    private var audioPlayer: AVAudioPlayer?

    init(shakeBegan: @escaping () -> Void, shakeEnded: @escaping () -> Void) {
        self.shakeBegan = shakeBegan
        self.shakeEnded = shakeEnded

        // 初始化音频部分
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.playback, mode: .default)
        try? audioSession.setActive(true)

        if let soundURL = Bundle.main.url(forResource: "eat", withExtension: "mp3") {
            do {
                self.audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            } catch {
                print("Error initializing audio player: \(error)")
            }
        }
    }

    class ShakeDetectingViewController: UIViewController {
        var shakeBeganAction: (() -> Void)?
        var shakeEndedAction: (() -> Void)?

        override func becomeFirstResponder() -> Bool {
            return true
        }

        override var canBecomeFirstResponder: Bool {
            return true
        }

        override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
            if motion == .motionShake {
                print("DEBUG: motionBegan detected.")
                print("DEBUG: Invoking shakeBeganAction now.")
                shakeBeganAction?()
            }
        }


        override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
            if motion == .motionShake {
                print("DEBUG: motionEnded detected.")
                shakeEndedAction?()
            }
        }
    }

    func playSound() {
        audioPlayer?.play()
    }

    func stopSound() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
    }

    func makeUIViewController(context: Context) -> ShakeDetectingViewController {
           let vc = ShakeDetectingViewController()
        vc.shakeBeganAction = {
            self.playSound()
            self.shakeBegan()  // 这行是关键，确保调用它
        }

           vc.shakeEndedAction = {
               self.stopSound()
               self.shakeEnded()
           }
           vc.becomeFirstResponder()   // Remove async and directly set first responder
           return vc
       }


    func updateUIViewController(_ uiViewController: ShakeDetectingViewController, context: Context) {}
}

var fridgeItems = ["Milk", "Eggs", "Bread", "Rice", "Butter", "Cheese", "Yogurt", "Chicken", "Beef", "Fish", "Oranges", "Bananas"]
//var fridgeItems = ["Milk", "Eggs"]



extension Color {
    static let red100 = Color(red: 254/255, green: 226/255, blue: 226/255)
    static let blue100 = Color(red: 219/255, green: 234/255, blue: 254/255)
    static let green100 = Color(red: 209/255, green: 250/255, blue: 229/255)
    static let yellow100 = Color(red: 255/255, green: 251/255, blue: 209/255)
}
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0

        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}


func getRecipeForDish(dishName: String) {

    // If there are too few items in the fridge
    print("fridgeItems.count=",fridgeItems.count)
    if fridgeItems.count < 3 {
        sampleRecipe = Recipe(
            name: "Making Something Out of Nothing",
            ingredients: fridgeItems,
            nutritionInfo: [
                Recipe.Nutrition(type: .protein, value: "Guesswork g"),
                Recipe.Nutrition(type: .calories, value: "Mystery kcal"),
                Recipe.Nutrition(type: .carbohydrates, value: "Surprise g"),
                Recipe.Nutrition(type: .fats, value: "Unknown g")
            ],
            steps: ["Contemplate the universe.", "Use your culinary wizardry.", "Serve with a side of imagination."]
        )
        return
    }

    let prompt = """
        Given the ingredients available in the fridge: \(fridgeItems.joined(separator: ", ")), please provide a detailed and practical recipe for \(dishName). Follow the precise format below:

        {
            "Name": "EXACT_DISH_NAME",
            "Ingredients": ["Relevant Ingredient1 from the fridge", "Relevant Ingredient2 from the fridge", ...],
            "Nutrition Info": {
                "Protein": "Exact Amount in g",
                "Calories": "Exact Amount in kcal",
                "Carbohydrates": "Exact Amount in g",
                "Fats": "Exact Amount in g"
            },
            "Steps": ["Detailed step 1", "Detailed step 2", ...]
        }
        """

    // Simulate a delay to mock the network request

        let response = """
        {
            "Name": "Tacos",
            "Ingredients": ["Tortillas", "Ground beef", "Garlic powder", "Onion powder", "Chili powder", "Cumin", "Salt", "Pepper", "Shredded lettuce", "Diced tomatoes", "Shredded cheese", "Sour cream"],
            "Nutrition Info": {
                "Protein": "24g",
                "Calories": "363",
                "Carbohydrates": "27g",
                "Fats": "16g"
            },
            "Steps": ["Brown the ground beef in a large skillet over medium-high heat.", "Once the beef is cooked through, drain any excess grease and remove from heat.", "Stir in the garlic powder, onion powder, chili powder, cumin, salt, and pepper.", "Preheat a smaller skillet over medium heat and warm the tortillas one at a time.", "Lay out each tortilla. Divide the beef evenly among each tortilla.", "Top the beef with shredded lettuce, diced tomatoes, shredded cheese, and sour cream. Fold up the tacos and serve immediately."]
        }
        """

        print("response=",response)
        sampleRecipe = parseRecipe(response: response) ?? Recipe(
            name: "Unknown Recipe",
            ingredients: [],
            nutritionInfo: [],
            steps: ["Unknown steps."]
        )

}

//func getRecipeForDish(dishName: String)  {
//
//    // If there are too few items in the fridge
//    print("fridgeItems.count=",fridgeItems.count)
//    if fridgeItems.count < 3 {
//        sampleRecipe = Recipe(
//            name: "Making Something Out of Nothing", // This is an attempt to capture the essence of "巧妇难为无米之炊" in English
//            ingredients: fridgeItems,
//            nutritionInfo: [
//                Recipe.Nutrition(type: .protein, value: "Guesswork g"),
//                Recipe.Nutrition(type: .calories, value: "Mystery kcal"),
//                Recipe.Nutrition(type: .carbohydrates, value: "Surprise g"),
//                Recipe.Nutrition(type: .fats, value: "Unknown g")
//            ],
//            steps: ["Contemplate the universe.", "Use your culinary wizardry.", "Serve with a side of imagination."]
//        )
//        return
//    }
//
//    // If there are enough items, call ChatGPT API with a prompt
//    let prompt = """
//        Given the ingredients available in the fridge: \(fridgeItems.joined(separator: ", ")), please provide a detailed and practical recipe for \(dishName). Follow the precise format below:
//
//        {
//            "Name": "EXACT_DISH_NAME",
//            "Ingredients": ["Relevant Ingredient1 from the fridge", "Relevant Ingredient2 from the fridge", ...],
//            "Nutrition Info": {
//                "Protein": "Exact Amount in g",
//                "Calories": "Exact Amount in kcal",
//                "Carbohydrates": "Exact Amount in g",
//                "Fats": "Exact Amount in g"
//            },
//            "Steps": ["Detailed step 1", "Detailed step 2", ...]
//        }
//
//        Do NOT include irrelevant ingredients (e.g., do not include fruits like Oranges or Bananas in a Chicken Curry recipe). Exclude all additional commentary or context. Assume the availability of common condiments: salt, pepper, oil, and basic spices. Ensure each nutritional value includes its respective unit and that the recipe is sensible.
//        """
//
//
//
//    let response = callChatGPTAPI(prompt: prompt)
//
//    print("response=",response)
//    sampleRecipe = parseRecipe(response: response) ?? Recipe(
//        name: "Unknown Recipe",
//        ingredients: [],
//        nutritionInfo: [],
//        steps: ["Unknown steps."]
//    )
//
//}

func callChatGPTAPI(prompt: String) -> String {
    let apiKey = "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"  // 请更换为您新的API密钥
//    let url = URL(string: "https://api.openai.com/v1/engines/text-davinci-002/completions")!
    let url = URL(string: "https://api.openai.com/v1/engines/gpt-3.5-turbo/completions")!

    var request = URLRequest(url: url)
    request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    
    let data = [
        "prompt": prompt,
        "max_tokens": 300  // 或其他您想设置的值
    ] as [String : Any]
    
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
        request.httpBody = jsonData
    } catch {
        print("Error: \(error)")
        return ""
    }
    
    var responseString = ""
    let semaphore = DispatchSemaphore(value: 0)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error: \(error)")
            semaphore.signal()
            return
        }
        
        guard let data = data, let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let text = jsonResponse["choices"] as? [[String: Any]], let firstChoice = text.first, let finalText = firstChoice["text"] as? String else {
            print("Error in parsing response")
            semaphore.signal()
            return
        }
        
        responseString = finalText.trimmingCharacters(in: .whitespacesAndNewlines)
        semaphore.signal()
    }
    
    task.resume()
    semaphore.wait()
    
    return responseString
}


func parseRecipe(response: String) -> Recipe? {
    guard let data = response.data(using: .utf8) else {
        print("Failed to convert response to data.")
        return nil
    }
    
    guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
        print("Failed to parse JSON.")
        return nil
    }
    
    guard let name = json["Name"] as? String else {
        print("Failed to extract name.")
        return nil
    }

    guard let ingredients = json["Ingredients"] as? [String] else {
        print("Failed to extract ingredients.")
        return nil
    }

    guard let nutritionInfo = json["Nutrition Info"] as? [String: String],
          let proteinValue = nutritionInfo["Protein"],
          let caloriesValue = nutritionInfo["Calories"],
          let carbsValue = nutritionInfo["Carbohydrates"],
          let fatsValue = nutritionInfo["Fats"] else {
        print("Failed to extract nutrition info.")
        return nil
    }

    guard let steps = json["Steps"] as? [String] else {
        print("Failed to extract steps.")
        return nil
    }

    return Recipe(
        name: name,
        ingredients: ingredients,
        nutritionInfo: [
            Recipe.Nutrition(type: .protein, value: proteinValue),
            Recipe.Nutrition(type: .calories, value: caloriesValue),
            Recipe.Nutrition(type: .carbohydrates, value: carbsValue),
            Recipe.Nutrition(type: .fats, value: fatsValue)
        ],
        steps: steps
    )
}


struct CameraPicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var sourceType: UIImagePickerController.SourceType  // 新增的属性
    @Environment(\.presentationMode) private var presentationMode

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType  // 使用绑定的源类型
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: CameraPicker

        init(_ parent: CameraPicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                print("Successfully captured/selected image.")  // 输出
                parent.image = image
            } else {
                print("Failed to capture/select image.")  // 输出
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}





//struct CameraPicker: UIViewControllerRepresentable {
//    @Binding var image: UIImage?
//    @Environment(\.presentationMode) private var presentationMode
//
//    func makeUIViewController(context: Context) -> UIImagePickerController {
//        let picker = UIImagePickerController()
//        picker.delegate = context.coordinator
//        picker.sourceType = .camera
//        return picker
//    }
//
//    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//        var parent: CameraPicker
//
//        init(_ parent: CameraPicker) {
//            self.parent = parent
//        }
//
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            if let image = info[.originalImage] as? UIImage {
//                print("Successfully captured image.")  // 输出
//                parent.image = image
//            } else {
//                print("Failed to capture image.")  // 输出
//            }
//            parent.presentationMode.wrappedValue.dismiss()
//        }
//
//    }
//}


class ImageAnalyzerViewModel: ObservableObject {
    @Published var detectedFood: String?

    func analyzeImage(_ image: UIImage) {
        print("Image analysis started.")

        // Convert UIImage to Data
        guard let imageData = image.jpegData(compressionQuality: 0.9) else {
            print("Failed to convert image to Data.")
            return
        }

        // Create URL request
        if let url = URL(string: "https://a769-122-199-9-25.ngrok.io/detect") {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"

            let boundary = UUID().uuidString
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

            // Construct the multipart/form-data body
            var body = Data()
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

            request.httpBody = body

            // Send request
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        print("Failed to fetch data from the backend server. Error: \(error.localizedDescription)")
                        return
                    }

                    if let data = data, let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        // Parse the response
                        if let detectedLabels = jsonResponse["detected_food"] as? [String] {
                            print("Successfully received response from the backend server.")
                            print("Detected Labels: \(detectedLabels.joined(separator: ", "))")
                            
                            // Add detected labels to fridgeItems
                            DispatchQueue.main.async {
                                for label in detectedLabels {
                                    if !fridgeItems.contains(label) {
                                        fridgeItems.append(label)
                                        print("New item added from detection: \(label)")  // 输出新检测到的食物
                                    }
                                }
                            }
                        } else {
                            print("Failed to parse the response from the backend server.")
                        }
                    } else {
                        print("Failed to decode response data.")
                    }
                }.resume()
            }
    }

}


var sampleRecipe: Recipe? = nil


struct InteractiveCard: View {
    @Binding var expanded: Bool
    @Binding var showArrow: Bool
    @State private var showRestaurantSheet = false


//    @State private var fridgeItems = ["Milk", "Eggs", "Bread","rice"]
    @State private var newItem: String = ""
    
    @State private var scrollOffset: CGFloat = 0
    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()

    @State private var scrollingForward = true
    
    @State private var image: UIImage?
    @State private var showCamera = false
    @ObservedObject private var viewModel = ImageAnalyzerViewModel()
    let apiKey = "AIzaSyCWeJOzJyhe3TtBskjGi5Nxg4sRqPqwhpM"
    
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary

    
    
    private func createScrollView(for items: [String], scrollOffset: Binding<CGFloat>, timer: Publishers.Autoconnect<Timer.TimerPublisher>, scrollingForward: Binding<Bool>) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(items, id: \.self) { item in
                    Text(item)
                        .padding(5)
                        .background(progressColor(for: item, atIndex: fridgeItems.firstIndex(of: item) ?? 0))
                        .cornerRadius(8)
                        .foregroundColor(.black)
                }
                // 为了实现循环效果，再次显示列表
                ForEach(items, id: \.self) { item in
                    Text(item)
                        .padding(5)
                        .background(progressColor(for: item, atIndex: fridgeItems.firstIndex(of: item) ?? 0))
                        .cornerRadius(8)
                        .foregroundColor(.black)
                }
            }
            .offset(x: scrollOffset.wrappedValue)
            .onReceive(timer) { _ in
                let singleSetWidth = CGFloat(items.count) * 70

                if scrollingForward.wrappedValue {
                    if abs(scrollOffset.wrappedValue) >= singleSetWidth {
                        scrollingForward.wrappedValue.toggle()
                    } else {
                        scrollOffset.wrappedValue -= 1
                    }
                } else {
                    if scrollOffset.wrappedValue >= 0 {
                        scrollingForward.wrappedValue.toggle()
                    } else {
                        scrollOffset.wrappedValue += 1
                    }
                }
            }
        }
    }

    var body: some View {
        VStack {
            if expanded {
                HStack {
                    TextField("Enter food item", text: $newItem)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .padding(.leading)
                        .gesture(TapGesture())  //捕获点击手势

                    Button(action: {
                        if !newItem.isEmpty {
                            // 检查是否已存在此项目，以确定是否应将其添加
                            if !fridgeItems.contains(newItem) {
                                fridgeItems.append(newItem)
                                print("New item added: \(newItem)")  // 输出新添加的食物
                            }
                            newItem = ""  // 清空输入框
                        }
                    }) {
                        Image(systemName: "plus")
                            .padding()
                            .background(Color.white)
                            .clipShape(Circle())
                            .foregroundColor(Color(hex: "5856D6"))  // 使用 #5856D6
                    }
                    .frame(width: 50)  // 设置固定的宽度
                    .padding(.trailing)
                }
                .padding(.top)

                List {
                    ForEach(fridgeItems, id: \.self) { item in
                        HStack {
                            Button(action: {
                                print("Text tapped!")  // 控制台输出
                                newItem = item  // 将点击的项填入输入框
                            }) {
                                Text(item)
                            }
                            .background(Color.clear) // 给Text一个透明背景
                            .padding(.trailing) // 添加右边距以分隔text和trash

                            Spacer()

                            Button(action: {
                                print("Trash tapped!")  // 控制台输出
                                fridgeItems.removeAll { $0 == item }  // 删除选中的项
                            }) {
                                Image(systemName: "trash")
                            }
                            .background(Color.clear) // 给trash一个透明背景
                            .frame(width: 50)  // 设置与 plus 按钮相同的宽度
                        }
                    }
                }
                .highPriorityGesture(DragGesture(), including: .all)

                .listStyle(PlainListStyle())
                .cornerRadius(20)
            }
 else {
                HStack(alignment: .center) {
                    Image(systemName: "camera.fill")
                                  .resizable()
                                  .aspectRatio(contentMode: .fit)
                                  .frame(width: 50, height: 50)
                                  .padding([.top, .leading], 10)
                                  .foregroundColor(Color(hex: "5856D6"))
                                  .onTapGesture {
                                      self.showCamera.toggle()
                                  }
                                  .sheet(isPresented: $showCamera, onDismiss: {
                                      if let selectedImage = self.image {
                                          viewModel.analyzeImage(selectedImage)
                                      }
                                  }, content: {
                                      CameraPicker(image: $image, sourceType: $sourceType)
                                  })

                    
                    VStack(spacing: 5) { // 垂直堆栈以容纳两行
                        createScrollView(for: Array(fridgeItems.prefix(fridgeItems.count / 2)), scrollOffset: $scrollOffset, timer: timer, scrollingForward: $scrollingForward) // 第一行
                        createScrollView(for: Array(fridgeItems.suffix(fridgeItems.count - fridgeItems.count / 2)), scrollOffset: $scrollOffset, timer: timer, scrollingForward: $scrollingForward) // 第二行
                    }
                            .frame(maxHeight: 140) // 更新高度以容纳两行
//                            .border(Color.black, width: 1)
                            .padding([.top, .bottom], 10) // 添加上下边距

                    if showArrow {
                        Button(action: {
                            showRestaurantSheet.toggle()
                        }) {
                            Image(systemName: "arrow.right.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .padding([.top, .trailing], 10)
                                .background(Color.white)
                                .foregroundColor(Color(hex: "5856D6"))  // 使用 #5856D6
                        }
                        .highPriorityGesture(TapGesture().onEnded { showRestaurantSheet.toggle() })  // 提高此手势的优先级

                    }

                }

            }
        }
        .frame(width: 350, height: expanded ? 250 : 100)
        .background(
            Color.white
                .cornerRadius(20)
                .shadow(radius: 10)
                .gesture(TapGesture().onEnded {
                    withAnimation {
                        print("Card tapped!")  // 输出信息
                        expanded.toggle()
                    }
                })
        )
        .sheet(isPresented: $showRestaurantSheet) {
            RecipeNutritionView(recipe: sampleRecipe!)
        }

    }


}





func progressColor(for item: String, atIndex index: Int) -> Color {
    let colors: [Color] = [.red100, .blue100, .green100, .yellow100]
    return colors[index % colors.count]
}




struct ShakeView: View {
    @State private var recommendedDish: Dish?
    @State private var isFirstTimeOpened: Bool = true
    @State private var expanded: Bool = false
    @State private var keyboardHeight: CGFloat = 0
    @State private var isKeyboardVisible: Bool = false
    @State private var showRecommendationArrow: Bool = false
    @State private var showRestaurantSheet = false
    @State private var isLoading = false
    @State private var lastDragPosition: CGFloat = 0.0


    var onDismiss: (() -> Void)? = {
           // 这里是默认操作，你可以根据需要调整
           print("Dismiss action called!")
       }

    
    let dishes: [Dish] = [
        // 中国
        Dish(name: "炒饭", englishName: "Fried Rice", image: Image("chaofan")),
        Dish(name: "饺子", englishName: "Dumplings", image: Image("dumplings")),
        Dish(name: "粥", englishName: "Porridge", image: Image("porridge")),
        Dish(name: "面条", englishName: "Noodles", image: Image("noodles")),
        
        
        // 日本
        Dish(name: "寿司", englishName: "Sushi", image: Image("sushi")),
        Dish(name: "乌冬面", englishName: "Udon", image: Image("udon")),
        Dish(name: "拉面", englishName: "Ramen", image: Image("ramen")),
        Dish(name: "味增汤", englishName: "Misoshiru", image: Image("misoshiru")),
        
        // 泰国
        Dish(name: "泰国猪肉饭", englishName: "Thai Pad Krapow", image: Image("padkrapow")),
        Dish(name: "绿咖喱", englishName: "Green Curry", image: Image("greencurry")),
        Dish(name: "泰国椰子鸡汤", englishName: "Thai Coconot Chicken Soup", image: Image("coconutchickensoup")),
        Dish(name: "冬阴功汤", englishName: "Tom Yum", image: Image("tomyum")),
        
        // 印度
        Dish(name: "咖喱鸡", englishName: "Chicken Curry", image: Image("chickencurry")),
        Dish(name: "印度烤饼", englishName: "Naan", image: Image("naan")),
        Dish(name: "印度查特", englishName: "Chaat", image: Image("chaat")),
        Dish(name: "印度玛撒拉香料卷饼", englishName: "Masala Dosa", image: Image("masaladosa")),
        
        // 法国
        Dish(name: "法式吐司", englishName: "French Toast", image: Image("frenchtoast")),
        Dish(name: "羊角面包", englishName: "Croissant", image: Image("croissant")),
        
        // 意大利
        Dish(name: "比萨", englishName: "Pizza", image: Image("pizza")),
        Dish(name: "意大利面", englishName: "Pasta", image: Image("pasta")),
        
        // 墨西哥
        Dish(name: "玉米饼", englishName: "Tacos", image: Image("tacos")),
        Dish(name: "玉米浆", englishName: "Tortilla", image: Image("tortilla")),
        
        // 美国
        Dish(name: "汉堡", englishName: "Burger", image: Image("burger")),
        Dish(name: "热狗", englishName: "Hot Dog", image: Image("hotdog")),
        
        // 英国
        Dish(name: "炸鱼薯条", englishName: "Fish and Chips", image: Image("fishandchips")),
        Dish(name: "英式早餐", englishName: "English Breakfast", image: Image("englishbreakfast")),
        
        // 越南
        Dish(name: "河粉", englishName: "Pho", image: Image("pho")),
        Dish(name: "越南鸡饭", englishName: "Vietnamese Chicken Rice", image: Image("vchickenrice")),
        Dish(name: "越南包", englishName: "Vietnamese Pate Bread", image: Image("patebread")),
        
        // 韩国
        Dish(name: "泡菜", englishName: "Kimchi", image: Image("kimchi")),
        Dish(name: "石锅拌饭", englishName: "Bibimbap", image: Image("bibimbap")),
        Dish(name: "辣豆腐汤", englishName: "Spicy Tofu Stew", image: Image("spicytofustew")),
        Dish(name: "海鲜饼", englishName: "Seafood Pancake", image: Image("seafoodpancake")),
        
        // 俄罗斯
        Dish(name: "俄式馅饼", englishName: "Pirozhki", image: Image("pirozhki")),
        
        // ... 可以继续添加更多国家的饮食推荐
    ]
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.purple.edgesIgnoringSafeArea(.all)
                VStack {
                    InteractiveCard(expanded: $expanded, showArrow: $showRecommendationArrow)
                    Spacer()  // Push the InteractiveCard to the top
                        if let dish = recommendedDish {
                            VStack {
                                dish.image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding()

                                Text(dish.name)
                                    .font(.headline)
                                Text(dish.englishName)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)

                                Button("For Details") {
                                    self.showRestaurantSheet.toggle()
                                }
                                .padding(.top)
                            }
                            .sheet(isPresented: $showRestaurantSheet){
                                NearbyRestaurantsView(dish: dish.englishName)
                            }
                            .padding()
                            .frame(width: 350, height: geometry.size.height - (expanded ? 250 : 100))
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(radius: 10)
                        } else if isFirstTimeOpened {
                            VStack {
                                if isLoading{
                                    ProgressView()
                                        .scaleEffect(2)
                                        .progressViewStyle(CircularProgressViewStyle(tint: Color.black))
                                        
                                }else{
                                    Image(systemName: "arrow.up.arrow.down.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                        .padding()
                                        .foregroundColor(Color(hex: "5856D6"))
                                    Text("Shake to get a recommendation!")
                                }
                            }
                            .padding()
                            .frame(width: 350, height: geometry.size.height - (expanded ? 250 : 100))
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(radius: 10)
                        }
                    

                }
                .offset(y: isKeyboardVisible ? keyboardHeight : 0)
                
                .zIndex(1)  // Make sure this VStack is on top
                
                
                
                ShakeDetectingViewControllerRepresentable(shakeBegan: {
                    print("Shake began")
                    print("isLoading is now \(self.isLoading)")
                    self.isLoading = true
                }, shakeEnded: {
                    print("Shake ended")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.recommendedDish = self.dishes.randomElement()
                        self.isFirstTimeOpened = false

                        if let dishName = self.recommendedDish?.englishName {
                            getRecipeForDish(dishName: dishName)  // 假设这是您异步获取食谱的函数
                            
                            if sampleRecipe != nil {
                                // Only set showRecommendationArrow to true if we get a valid recipe
                                self.showRecommendationArrow = true
                            }
                        }
                        
                        self.isLoading = false  // 加载完成时
                    }
                })



            }
            .gesture(
                DragGesture(minimumDistance: 10, coordinateSpace: .local)
                .onChanged { value in
                    // If the y translation is positive, it means it's a downward scroll.
                    // If it's negative, it's an upward scroll.
                    if value.translation.height > 0 {
                        self.expanded = true
                    } else {
                        self.expanded = false
                    }
                }
                .onEnded { value in
                    if value.startLocation.x < geometry.size.width / 4 && value.translation.width > 100 {
                        self.onDismiss?()
                    }
                }
            )

            .gesture(
                   DragGesture(minimumDistance: 30, coordinateSpace: .local)  // 30为开始识别拖动的最小距离
                   .onEnded { value in
                       if value.startLocation.x < geometry.size.width / 4 && value.translation.width > 100 {  // 从左边开始并且拖动的距离超过100
                           self.onDismiss?()
                       }
                   }
               )
        }
        .onAppear {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (notification) in
                guard let userInfo = notification.userInfo else { return }
                guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
                let keyboardFrame = keyboardSize.cgRectValue
                self.keyboardHeight = keyboardFrame.height
                self.isKeyboardVisible = true
            }

            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                self.keyboardHeight = 0
                self.isKeyboardVisible = false
            }
        }

        .onDisappear {
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }

    }

}


struct ShakeView_Previews: PreviewProvider {
    static var previews: some View {
        ShakeView()
    }
}
