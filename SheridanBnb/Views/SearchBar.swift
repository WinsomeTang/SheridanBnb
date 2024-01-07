import SwiftUI

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            TextField("Search a room...", text: $text)
                .font(.system(size: 22))
                .fontWeight(.medium)
                .padding(20)
                .padding(.horizontal, 25) // You might need to adjust this value based on the size of your icons.
                .foregroundColor(Color("Aqua"))
                .background(Color.white)
                .cornerRadius(40)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .scaledToFill()
                            .foregroundColor(Color.gray)
                            .padding(.leading, 15) // Padding to keep icon inside the border
                        
                        Spacer() // This will push the magnifying glass to the left and the clear button to the right
                        
                        if !text.isEmpty {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(Color("Aqua"))
                                    .padding(.trailing, 8) // Padding to keep icon inside the border
                            }
                        }
                    }
                )
                .padding(.horizontal, 10) // Padding for the entire search bar
        }
        .padding(.vertical, 20)
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant(""))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
