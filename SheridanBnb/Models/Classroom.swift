//
//  Classroom.swift
//  SheridanBnb
//
//  Created by Winsome Tang on 2024-01-04.
//
import Foundation
import FirebaseFirestore

struct Wing: Identifiable, Decodable {
    var id: String
    var classrooms: [String: Classroom]
}

struct Classroom: Codable {
    var schedule: [String: [CourseTime]]
    
    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: DynamicCodingKeys.self)

            var schedule = [String: [CourseTime]]()

            for key in container.allKeys {
                let trimmedKey = key.stringValue.trimmingCharacters(in: .punctuationCharacters)
                let courseTimes = try container.decode([CourseTime].self, forKey: DynamicCodingKeys(stringValue: trimmedKey)!)
                schedule[trimmedKey] = courseTimes
            }

            self.schedule = schedule
            // Initialize any other properties as needed
        }

    struct DynamicCodingKeys: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        var intValue: Int?
        init?(intValue: Int) {
            return nil
        }
    }
}

struct CourseTime: Identifiable, Codable {
    let id: UUID = UUID()
    var courseCode: String
    var time: String

    func isTimeInRange(currentTime: String) -> Bool {
        let timeRange = time.components(separatedBy: " - ")
        guard timeRange.count == 2,
              let startTime = DateFormatter.hourMinuteFormatter.date(from: timeRange[0]),
              let endTime = DateFormatter.hourMinuteFormatter.date(from: timeRange[1]),
              let currentTimeDate = DateFormatter.hourMinuteFormatter.date(from: currentTime) else {
            return false
        }

        return startTime <= currentTimeDate && currentTimeDate <= endTime
    }
}

extension DateFormatter {
    static let hourMinuteFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0) // Adjust if you store times in UTC
        return formatter
    }()
}

struct IdentifiableClassroom: Identifiable {
    let id: String
    let wingID: String
    let classroomID: String
    let classroom: Classroom
    var availableTime: String = "Calculating..."

    init(wingID: String, classroomID: String, classroom: Classroom, availableTime: String = "Calculating...") {
        self.wingID = wingID
        self.classroomID = classroomID
        self.classroom = classroom // Initialize the classroom property
        self.availableTime = availableTime
        self.id = "\(wingID)-\(classroomID)"
    }
}
