import SwiftUI
import Combine
import CoreLocation
import Foundation

// 1. 创建API模型
struct Restaurant: Decodable {
    var name: String
    var distance: Double // 例如，距离单位为公里
}

// 2. 创建ViewModel
class NearbyRestaurantsViewModel:NSObject, CLLocationManagerDelegate, ObservableObject {
    @Published var currentDish: String = ""
    @Published var isLoading: Bool = false
    @Published var restaurants: [Restaurant] = []
    var cancellables: Set<AnyCancellable> = []
    
    private var locationManager = CLLocationManager()
    @Published var currentLocation: CLLocation?

    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.locationManager.distanceFilter=500.0
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location
        print("currentDish=",currentDish)
        if !currentDish.isEmpty {
            fetchNearbyRestaurants(for: currentDish)  // 使用currentDish作为参数
        }else{
            fetchNearbyRestaurants(for: "Noodles")
        }
    }


    
    func loadMockData() {
           let mockData = [
               Restaurant(name: "Good Noodles", distance: 1.5),
               Restaurant(name: "Yummy Sushi", distance: 2.0),
               Restaurant(name: "Tasty Pizza", distance: 5.5)
           ]
           
           DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
               self.restaurants = mockData
           }
       }
    func fetchNearbyRestaurants(for dish: String) {
        self.isLoading = true
        guard let encodedDish = dish.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Failed to encode dish name.")
            return
        }

        // 设定您当前的位置。这里是一个示例，您应该从设备获取实际的位置数据。
        guard let currentLocation = self.currentLocation else {
            print("Location is not available.")
            return
        }

        let currentLatitude = "\(currentLocation.coordinate.latitude)"
        let currentLongitude = "\(currentLocation.coordinate.longitude)"

        let apiKey = "AIzaSyCWeJOzJyhe3TtBskjGi5Nxg4sRqPqwhpM" // 不要在实际应用中直接使用

        let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(currentLatitude),\(currentLongitude)&radius=5000&keyword=\(encodedDish)&type=restaurant&key=\(apiKey)"

        guard let url = URL(string: urlString) else {
            print("Invalid URL.")
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: GooglePlacesResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.isLoading = false
                    break
                case .failure(let error):
                    print("Error fetching restaurants: \(error)")
                }
            }, receiveValue: { [weak self] response in
//                print("Google Places API Response: \(response)")  // 输出Google返回的结果
                print("Google Places API Response:")  // 输出Google返回的结果
                self?.restaurants = response.results.compactMap { place in
                    let restaurantLocation = CLLocation(latitude: place.geometry.location.lat, longitude: place.geometry.location.lng)
                    let distanceInMeters = currentLocation.distance(from: restaurantLocation)
                    let distanceInKm = distanceInMeters / 1000.0
                    return Restaurant(name: place.name, distance: distanceInKm)
                }
                .sorted(by: { $0.distance < $1.distance })  // 将返回的餐厅按照距离从近到远排序
                      })
            .store(in: &cancellables)
    }

    // This is a sample model for Google Places API response
    struct GooglePlacesResponse: Decodable {
        var results: [Place]
    }

    struct Place: Decodable {
        var name: String
        var vicinity: String
        var geometry: Geometry
    }

    struct Geometry: Decodable {
        var location: Location
    }

    struct Location: Decodable {
        var lat: Double
        var lng: Double
    }
    func openInMaps(name: String) {
        let combinedName = "\(name)"
        if let encodedName = combinedName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            
            // 检查是否可以打开Google Maps
            if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {
                print("Detected Google Maps is available.") // 输出信息
                let googleMapsURL = URL(string: "comgooglemaps://?q=\(encodedName)&zoom=14")
                
                UIApplication.shared.open(googleMapsURL!, options: [:]) { success in
                    if success {
                        print("Successfully opened the URL in Google Maps.")
                    } else {
                        print("Failed to open the URL in Google Maps.")
                    }
                }
            } else { // 使用Apple Maps
                print("Google Maps not detected. Trying Apple Maps.") // 输出信息
                if let appleMapsURL = URL(string: "http://maps.apple.com/?q=\(encodedName)") {
                    UIApplication.shared.open(appleMapsURL, options: [:]) { success in
                        if success {
                            print("Successfully opened the URL in Apple Maps.")
                        } else {
                            print("Failed to open the URL in Apple Maps.")
                        }
                    }
                }
            }
        } else {
            print("Failed to create a URL for the restaurant name.")
        }
    }
}

struct NearbyRestaurantsView: View {
    @ObservedObject var viewModel: NearbyRestaurantsViewModel
    var dish: String
    // 改变初始化方法
    init(dish: String, viewModel: NearbyRestaurantsViewModel = NearbyRestaurantsViewModel()) {
        self.dish = dish
        self.viewModel = viewModel
        self.viewModel.currentDish = dish
        self.viewModel.fetchNearbyRestaurants(for: dish) // 调用API加载方法
    }


    
    
    var body: some View {
        NavigationView {
            if viewModel.isLoading {
                            // 当正在加载时，显示一个加载指示器
                            ProgressView("Loading...")
                                .scaleEffect(1.5, anchor: .center)
                                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        } else {
            List(viewModel.restaurants, id: \.name) { restaurant in
                Button(action: {
                    print("Button for \(restaurant.name) tapped.") // 这行将打印出点击的餐厅名称
                    // 当用户点击这个条目时，调用地图软件
                    viewModel.openInMaps(name: restaurant.name)
                }) {
                    HStack {
                        // 餐厅名称
                        Text(restaurant.name)
                            .font(.headline)
                            .foregroundColor(.primary)
                        Spacer()
                        // 距离
                        Text("\(restaurant.distance, specifier: "%.1f") km")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Nearby Restaurants")
        }
        }
    }
}

// 预览部分
struct NearbyRestaurantsView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = NearbyRestaurantsViewModel()
        viewModel.loadMockData() // 调用模拟加载方法
        return NearbyRestaurantsView(dish: "Noodles", viewModel: viewModel)
    }
}
