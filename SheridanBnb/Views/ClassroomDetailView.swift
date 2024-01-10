import SwiftUI

struct ClassroomDetailView: View {
    let classroom: IdentifiableClassroom
    @State private var phase = 2.5
    @EnvironmentObject var displayViewModel: DisplayViewModel
    var body: some View {
        ZStack{
            Color("BlueTheme")
                .edgesIgnoringSafeArea(.all)
            //Waves positioned on top right corner
            Wave(phase: phase, strength: 22, frequency: 50)
                .stroke(Color("OrangeTheme"), lineWidth: 45)
                .rotationEffect(.degrees(219))
                .frame(width: 1400)
                .offset(x: 165, y: -325)
            Wave(phase: 1.0, strength: 22, frequency: 50)
                .stroke(Color("LightGreenTheme"), lineWidth: 45)
                .rotationEffect(.degrees(219))
                .frame(width: 1400)
                .offset(x: 220, y: -305)
            Wave(phase: 1.0, strength: 22, frequency: 50)
                .stroke(Color("AquaTheme"), lineWidth: 45)
                .rotationEffect(.degrees(219))
                .frame(width: 1400)
                .offset(x: 390, y: -225)
            Wave(phase: 1.0, strength: 22, frequency: 50)
                .stroke(Color("AquaTheme"), lineWidth: 45)
                .rotationEffect(.degrees(219))
                .frame(width: 1400)
                .offset(x: 390, y: -225)
            Wave(phase: 1.0, strength: 22, frequency: 50)
                .stroke(Color("BlueTheme"), lineWidth: 45)
                .rotationEffect(.degrees(219))
                .frame(width: 1400)
                .offset(x: 390, y: -255)
            ScrollView {
                VStack {
                    Text(classroom.classroomID)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                        .padding(.top, 10)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    // the features of selected classroom
                    Spacer()
                    ScrollView(.horizontal){
                        HStack(spacing: 20){
                            Spacer()
                                .frame(width: 10)
//MARK: - Lock Access Status
                            VStack{
                                switch
                                classroom.classroom.attributes["doorStatus"]{
                                case .some(.string("LOCKED")):
                                    Image(systemName: "lock.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(.white)
                                        .padding(.top, 10)
                                    Text("Locked")
                                        .font(.system(size: 15))
                                        .foregroundColor(.white)
                                        .padding(.top, 10)
                                        .padding(.horizontal, 10)
                                    
                                case .some(.string("KEYCARD REQUIRED")):
                                    Image(systemName: "person.text.rectangle.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(.white)
                                        .padding(.top, 10)
                                    Text("Need\nKeycard")
                                        .font(.system(size: 15))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.white)
                                        .padding(.top, 10)
                                        .padding(.horizontal, 10)
                                    
                                case .some(.string("OPEN")):
                                    Image(systemName: "lock.open.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(.white)
                                        .padding(.top, 10)
                                    Text("Open")
                                        .font(.system(size: 15))
                                        .foregroundColor(.white)
                                        .padding(.top, 10)
                                        .padding(.horizontal, 10)
                                default:
                                    EmptyView()
                                }
                            }
                            .padding(.vertical, 22)
                           
                            .background(Color("BlueTheme"))
                            .cornerRadius(40)
                            .overlay(
                                RoundedRectangle(cornerRadius: 40).stroke(Color("BlueTheme"), lineWidth: 1)
                            )
//MARK: - Can Door lock?
                            VStack{
                                switch classroom.classroom.attributes["canDoorLock"]{
                                case .some(.boolean(true)):
                                    Image(systemName: "door.left.hand.closed")
                                        .font(.system(size: 24))
                                        .foregroundColor(.white)
                                        .padding(.top, 10)
                                    Text("Can\nLock")
                                        .font(.system(size: 15))
                                        .foregroundColor(.white)
                                        .padding(.top, 8)
                                        .padding(.horizontal, 10)
                                case .some(.boolean(false)):
                                    Image(systemName: "door.left.hand.open")
                                        .font(.system(size: 24))
                                        .foregroundColor(.white)
                                        .padding(.top, 10)
                                    Text("Can't\nLock")
                                        .font(.system(size: 15))
                                        .foregroundColor(.white)
                                        .padding(.top, 8)
                                        .padding(.horizontal, 10)
                                default:
                                    EmptyView()
                                }
                            }
                            .padding(.vertical, 20)
    
                            .background(Color("BlueTheme"))
                            .cornerRadius(40)
                            .overlay(
                                RoundedRectangle(cornerRadius: 40).stroke(Color("BlueTheme"), lineWidth: 1)
                            )
//MARK: - Power Outlet Count
                            VStack{
                                if let powerOutletValue = classroom.classroom.attributes["outletCount"], case .integer(let count) = powerOutletValue {
                                    Image(systemName: "poweroutlet.type.a.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(.white)
                                        .padding(.top, 10)
                                    Text("\(count)")
                                        .font(.system(size: 15))
                                        .foregroundColor(.white)
                                        .padding(.top, 12)
                                        .padding(.horizontal, 20)
                                } else {
                                    EmptyView()
                                }
                            }
                            .padding(.vertical, 24)
                            
                            .background(Color("BlueTheme"))
                            .cornerRadius(40)
                            .overlay(
                                RoundedRectangle(cornerRadius: 40).stroke(Color("BlueTheme"), lineWidth: 1)
                            )
//MARK: - Lighting Rating
                            VStack{
                                if let lightRatingValue = classroom.classroom.attributes["lightingRating"], case .integer(let lightRate) = lightRatingValue {
                                    Image(systemName: "lightbulb.max.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(.white)
                                        .padding(.top, 10)
                                    Text("\(lightRate)")
                                        .font(.system(size: 15))
                                        .foregroundColor(.white)
                                        .padding(.top, 12)
                                        .padding(.horizontal, 10)
                                } else {
                                    EmptyView()
                                }
                            }
                            .padding(.vertical, 20)
                            
                            .background(Color("BlueTheme"))
                            .cornerRadius(40)
                            .overlay(
                                RoundedRectangle(cornerRadius: 40).stroke(Color("BlueTheme"), lineWidth: 1)
                            )
//MARK: - Speaker Rating
                            VStack{
                                if let speakerRatingValue = classroom.classroom.attributes["speakerRating"], case .string(let speakerRate) = speakerRatingValue {
                                    Image(systemName: "hifispeaker.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(.white)
                                        .padding(.top, 10)
                                    Text("\(speakerRate)")
                                        .font(.system(size: 15))
                                        .foregroundColor(.white)
                                        .padding(.top, 12)
                                        .padding(.horizontal, 10)
                                } else {
                                    EmptyView()
                                }
                            }
                            .padding(.vertical, 22)
                            
                            .background(Color("BlueTheme"))
                            .cornerRadius(40)
                            .overlay(
                                RoundedRectangle(cornerRadius: 40).stroke(Color("BlueTheme"), lineWidth: 1)
                            )
                        }//HStack for features section
                        .padding(.vertical, 20)
                        .padding(.horizontal, 500)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color("OrangeTheme"), Color("LightGreenTheme"), Color("AquaTheme")]), startPoint: .leading, endPoint: .trailing))
                            
                    }
                    .padding(.bottom, 15)
                    // Schedule Section
                    VStack(alignment: .leading) {
                        Text("Today \(DateFormatter.localizedString(from: Date(), dateStyle: .full, timeStyle: .none))")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.vertical, 5)
                            .foregroundColor(.black)
                        
                        ForEach(classroom.classroom.schedule[DayOfWeek.from(date: Date())] ?? [], id: \.id) { courseTime in
                            HStack {
                                Capsule()
                                    .frame(width: 8, height: 40)
                                    .foregroundColor(isClassPast(courseTime: courseTime.time) ? Color.gray : Color("AquaTheme"))
                                VStack(alignment: .leading) {
                                    Text(courseTime.time)
                                        .fontWeight(.bold)
                                        .foregroundColor(isClassPast(courseTime: courseTime.time) ? Color.gray : Color("AquaTheme"))
                                    Text("Course Code: \(courseTime.courseCode)")
                                        .foregroundColor(isClassPast(courseTime: courseTime.time) ? Color("LightGrayTheme") :  Color("BlueTheme"))
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            //Waves positioned at bottom left corner
            Wave(phase: phase, strength: 22, frequency: 45)
                .stroke(Color("OrangeTheme"), lineWidth: 45)
                .rotationEffect(.degrees(219))
                .frame(width: 1400)
                .offset(x: -165, y:255)
            Wave(phase: 1.0, strength: 22, frequency: 45)
                .stroke(Color("LightGreenTheme"), lineWidth: 45)
                .rotationEffect(.degrees(219))
                .frame(width: 1400)
                .offset(x: -20, y: 415)
            Wave(phase: 1.0, strength: 22, frequency: 45)
                .stroke(Color("AquaTheme"), lineWidth: 45)
                .rotationEffect(.degrees(219))
                .frame(width: 1400)
                .offset(x: -50, y: 430)
            Wave(phase: 1.0, strength: 22, frequency: 45)
                .stroke(Color("BlueTheme"), lineWidth: 45)
                .rotationEffect(.degrees(219))
                .frame(width: 1400)
                .offset(x: -50, y: 450)
        }
    }
}

//struct ClassroomDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        // Creating a mock JSON representation of a Classroom
//        let mockClassroomJSON = """
//        {
//            "schedule": {
//                "Monday": [
//                    {
//                        "id": "UUID",
//                        "courseCode": "PROG 101",
//                        "time": "10:00 - 12:00"
//                    }
//                ]
//            }
//        }
//        """.data(using: .utf8)!
//
//        // Decoding the mock JSON to create a Classroom instance
//        let mockClassroom = try! JSONDecoder().decode(Classroom.self, from: mockClassroomJSON)
//
//        ClassroomDetailView(classroom: IdentifiableClassroom(wingID: "G", classroomID: "201", classroom: mockClassroom))
//    }
//}

// Helper struct to convert Date to day of week string
struct DayOfWeek {
    static func from(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
    }
}

//Function that finds out whether a class has passed current time
func isClassPast(courseTime: String) -> Bool {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"

    // Split the courseTime string to get the start time
    let times = courseTime.split(separator: "-").map(String.init)
    guard let startTimeString = times.first,
          let startTime = dateFormatter.date(from: startTimeString.trimmingCharacters(in: .whitespaces)),
          let currentTime = dateFormatter.date(from: dateFormatter.string(from: Date())) else {
        return false
    }

    // Compare current time to the start time of the class
    return currentTime > startTime
}

