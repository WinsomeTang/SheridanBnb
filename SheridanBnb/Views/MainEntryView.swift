import SwiftUI

struct MainEntryView: View {
    @State private var phase = 2.5
    @State private var isShowingContentView = false
    @EnvironmentObject var displayViewModel: DisplayViewModel
    var body: some View {

            ZStack {
                // Use the blue color from your assets for the background
                Color("Blue")
                    .edgesIgnoringSafeArea(.all)
                
                //Wave decoration starts
                Wave(phase: phase, strength: 20, frequency: 30)
                    .stroke(Color("Orange"), lineWidth: 45)
                    .rotationEffect(.degrees(230))
                    .frame(width: 1000)
                    .offset(x: 100, y: -214)
                
                Wave(phase: phase, strength: 20, frequency: 30)
                    .stroke(Color("Light Green"), lineWidth: 45)
                    .rotationEffect(.degrees(230))
                    .frame(width: 1000)
                    .offset(x: 140, y: -235)
                Wave(phase: phase, strength: 20, frequency: 30)
                    .stroke(Color("Aqua"), lineWidth: 47)
                    .rotationEffect(.degrees(230))
                    .frame(width: 1000)
                    .offset(x: 175, y: -265)
                Wave(phase: phase, strength: 20, frequency: 30)
                    .stroke(Color.white, lineWidth: 45)
                    .rotationEffect(.degrees(230))
                    .frame(width: 1000)
                    .offset(x:203.001, y: -300)
                Wave(phase: phase, strength: 20, frequency: 30)
                    .stroke(Color.white, lineWidth: 60)
                    .rotationEffect(.degrees(230))
                    .frame(width: 1000)
                    .offset(x:210, y: -335)
             //Wave ends
                
                VStack {
                                Spacer()
                                Text("Find\nan empty \nclassroom \nat Sheridan")
                                    .font(.largeTitle)
                                    .fontWeight(.heavy)
                                    .foregroundColor(Color.white)
                                    .multilineTextAlignment(.leading)
                                    .lineSpacing(30)
                                    .offset(x: -30, y: 25)
                                    .padding()
                                Spacer()
                                Button(action: {
                                    self.isShowingContentView = true // When button is tapped, show the content view
                                }) {
                                    Text("Let's Start!")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20, weight: .bold))
                                        .padding()
                                        .frame(width: 265, height: 60)
                                        .background(.clear)
                                        .cornerRadius(15)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(Color.white, lineWidth: 2)
                                        )
                                }
                                .fullScreenCover(isPresented: $isShowingContentView) {
                                    // Present the ContentView as a sheet
                                    ContentView().environmentObject(displayViewModel)
                                }
                                Spacer()
                            }

                        }
                        .navigationBarHidden(true)
       
                    }
                }

struct MainEntryView_Previews: PreviewProvider {
    static var previews: some View {
        MainEntryView()
    }
}
