
import Foundation

 class LocalJSONDataSource {

    func fetchHomeContent() -> HomeContentModel? {
        print("LocalJSONDataSource called")
        guard let url = Bundle.main.url(forResource: "home_content",withExtension: "json") else{
            print("not found")
            return nil
        }
        print("JSON URL:", url)
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }

        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(HomeContentModel.self, from: data)
            print("JSON decoded:", result.hero.title)
            return result
        } catch {
            print("JSON decode error:", error)
            return nil
        }
       
    }
}
