import Foundation
import FirebaseFirestore

// MARK: - Wing Structure
struct Wing: Identifiable, Decodable {
    var id: String
    var classrooms: [String: Classroom]
}

// MARK: - Classroom Structure
struct Classroom: Codable, Hashable {
    var schedule: [String: [CourseTime]]
    var attributes: [String: AttributeValue] // Added attributes map

    // MARK: - Equatable & Hashable
    static func == (lhs: Classroom, rhs: Classroom) -> Bool {
        lhs.schedule == rhs.schedule
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(schedule)
        hasher.combine(attributes)
    }

    // MARK: - Decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        var schedule = [String: [CourseTime]]()
        
        // Decoding schedule
        for key in container.allKeys.filter({ !$0.stringValue.starts(with: "a") }) {
            let trimmedKey = key.stringValue.trimmingCharacters(in: .punctuationCharacters)
            let courseTimes = try container.decode([CourseTime].self, forKey: DynamicCodingKeys(stringValue: trimmedKey)!)
            schedule[trimmedKey] = courseTimes
        }
        self.schedule = schedule

        // Decoding attributes
        self.attributes = try container.decode([String: AttributeValue].self, forKey: DynamicCodingKeys(stringValue: "attributes")!)
    }

    // MARK: - Dynamic Coding Keys
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

// MARK: - CourseTime Structure
struct CourseTime: Identifiable, Codable, Hashable {
    var id: UUID
    var courseCode: String
    var time: String
    
    // MARK: - Decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.courseCode = try container.decode(String.self, forKey: .courseCode)
        self.time = try container.decode(String.self, forKey: .time)
        self.id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
    }

    // MARK: - Coding Keys
    enum CodingKeys: String, CodingKey {
        case id, courseCode, time
    }

    // MARK: - Time Range Check
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

// MARK: - DateFormatter Extension
extension DateFormatter {
    static let hourMinuteFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
}

// MARK: - AttributeValue Enum
enum AttributeValue: Codable, Hashable {
    case string(String)
    case integer(Int)
    case boolean(Bool)
    
    // MARK: - Decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else if let intValue = try? container.decode(Int.self) {
            self = .integer(intValue)
        } else if let boolValue = try? container.decode(Bool.self) {
            self = .boolean(boolValue)
        } else {
            throw DecodingError.typeMismatch(AttributeValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unsupported type for AttributeValue"))
        }
    }
    
    // MARK: - Encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let stringValue):
            try container.encode(stringValue)
        case .integer(let intValue):
            try container.encode(intValue)
        case .boolean(let boolValue):
            try container.encode(boolValue)
        }
    }
}

// MARK: - IdentifiableClassroom Structure
struct IdentifiableClassroom: Identifiable, Hashable {
    var id: String
    let wingID: String
    let classroomID: String
    let classroom: Classroom
    var availableTime: String = "Calculating..."

    // MARK: - Initialization
    init(wingID: String, classroomID: String, classroom: Classroom, availableTime: String = "Calculating...") {
        self.wingID = wingID
        self.classroomID = classroomID
        self.classroom = classroom
        self.availableTime = availableTime
        self.id = "\(wingID)-\(classroomID)"
    }
}
