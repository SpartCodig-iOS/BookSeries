import SwiftUI
import Model
import Core

public struct ContentView: View {
    public init() {}

    public var body: some View {
      VStack {
        Text("Hello, World!")
            .padding()
      }
      .task {
//        do {
//          let dto = try await JSONManager.parseFromFile(BookDTO.self)
//          let books: [Book] = dto.data.toDomain()
//          print("📚 App 번들에서 로드 성공: \(books) 권")
//        } catch {
//          print("❌ 책 로드 실패: \(error)")
//        }
      }

    }
}


#Preview {
  ContentView()
}






