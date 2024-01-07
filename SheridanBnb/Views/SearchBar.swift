import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var onEditingChanged: ((Bool) -> Void)? = nil


    var body: some View {
        HStack {
            TextField("Search a room...", text: $text, onEditingChanged: { isEditing in
                onEditingChanged?(isEditing)
            })
                .font(.system(size: 22))
                .fontWeight(.medium)
                .padding(20)
                .padding(.horizontal, 25)
                .foregroundColor(Color("Aqua"))
                .background(Color.white)
                .cornerRadius(40)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .scaledToFill()
                            .foregroundColor(Color.gray)
                            .padding(.leading, 15)
                        
                        Spacer()
                        
                        if !text.isEmpty {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(Color("Aqua"))
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal, 10)
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
