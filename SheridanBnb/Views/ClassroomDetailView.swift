//
//  ClassroomDetailView.swift
//  SheridanBnb
//
//  Created by Michael Werbowy on 2024-01-07.
//

import SwiftUI

struct ClassroomDetailView: View {
    let classroom: IdentifiableClassroom

    var body: some View {
        ScrollView {
            VStack {
                Text(classroom.classroomID)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(.white)
                    .cornerRadius(10)

                // Schedule Section
                VStack(alignment: .leading) {
                    Text("Today \(DateFormatter.localizedString(from: Date(), dateStyle: .full, timeStyle: .none))")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.vertical)

                    ForEach(classroom.classroom.schedule[DayOfWeek.from(date: Date())] ?? [], id: \.id) { courseTime in
                        HStack {
                            Capsule()
                                .frame(width: 8, height: 40)
                                .foregroundColor(Color.blue)
                            VStack(alignment: .leading) {
                                Text(courseTime.time)
                                    .fontWeight(.bold)
                                Text("Course Code: \(courseTime.courseCode)")
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding()
            }
        }
        .navigationTitle("Classroom \(classroom.classroomID)")
        .navigationBarTitleDisplayMode(.inline)
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
