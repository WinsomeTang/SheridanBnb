//
//  DisplayViewModel.swift
//  SheridanBnb
//
//  Created by Winsome Tang on 2024-01-04.
//
import Foundation
import FirebaseFirestore

class DisplayViewModel: ObservableObject {
    @Published var wings: [Wing] = []
    @Published var availableClassrooms: [IdentifiableClassroom] = []

    func fetchClassroomsFromFirestore() {
        let db = Firestore.firestore()
        db.collection("schedule").document("wings").getDocument { [weak self] document, error in
            if let error = error {
                print("Error fetching document: \(error.localizedDescription)")
                return
            }

            guard let document = document, document.exists else {
                print("Document does not exist")
                return
            }
            print("Document fetched successfully: \(document.documentID)")
            self?.decodeWingsDocument(document: document)
            // Move the filter call inside the completion handler to ensure it is called after the data is loaded
            DispatchQueue.main.async {
                self?.availableClassrooms = self?.filterAvailableClassrooms() ?? []
            }
        }
    }
    
    func filterAvailableClassrooms() -> [IdentifiableClassroom] {
        print("filterAvailableClassrooms() is called!")
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE" // for the day of the week
        let dayString = dateFormatter.string(from: currentDate)

        dateFormatter.dateFormat = "HH:mm" // for the current time
        let currentTime = dateFormatter.string(from: currentDate)

        var availableClassrooms = [IdentifiableClassroom]()

        // Debug: print the wings and classrooms loaded
        print("Wings and classrooms loaded: \(wings)")

        for wing in wings {
            for (classroomID, classroom) in wing.classrooms {
                // Debug: print the day's schedule
                print("Checking schedule for classroom \(classroomID) on \(dayString)")
                if let daySchedule = classroom.schedule[dayString], !daySchedule.isEmpty {
                    let isOccupied = daySchedule.isClassroomOccupied(currentTime: currentTime)
                    // Debug: print whether the classroom is occupied or not
                    print("Classroom \(classroomID) is \(isOccupied ? "occupied" : "available") at \(currentTime)")
                    if !isOccupied {
                        availableClassrooms.append(IdentifiableClassroom(wingID: wing.id, classroomID: classroomID))
                    }
                } else {
                    // Debug: print that the classroom is available as no schedule was found
                    print("Classroom \(classroomID) is available as no schedule was found for \(dayString)")
                    availableClassrooms.append(IdentifiableClassroom(wingID: wing.id, classroomID: classroomID))
                }
            }
        }

        print("Available classrooms: \(availableClassrooms.map { "\($0.wingID)-\($0.classroomID)" })")
        return availableClassrooms
    }
    
    // Helper function to check if a classroom is occupied on a specific day
    private func isClassroomOccupied(daySchedule: [CourseTime], currentTime: String) -> Bool {
        daySchedule.contains { courseTime in
            courseTime.isTimeInRange(currentTime: currentTime)
            
        }
    }
    
    private func decodeWingsDocument(document: DocumentSnapshot) {
            guard let data = document.data() else {
                print("Document data was empty.")
                return
            }
            self.wings.removeAll()

            for (key, value) in data {
                print("Processing wing with key: \(key)")
                if let wingDict = value as? [String: Any], let classroomsDict = wingDict["classrooms"] as? [String: [String: Any]] {
                    var classrooms = [String: Classroom]()
                    for (classroomKey, classroomValue) in classroomsDict {
                        print("Processing classroom with key: \(classroomKey)")
                        // Now using JSONSerialization to convert the classroomValue into Data
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: classroomValue)
                            // Decoding the Classroom object from jsonData instead of directly initializing
                            let classroom = try JSONDecoder().decode(Classroom.self, from: jsonData)
                            classrooms[classroomKey] = classroom
                            print("Decoded schedule for classroom \(classroomKey): \(classroom.schedule)")
                        } catch {
                            print("Error decoding classroom data for key: \(classroomKey), error: \(error)")
                        }
                    }
                    let wing = Wing(id: key, classrooms: classrooms)
                    self.wings.append(wing)
                    print("Wing added with ID: \(wing.id)")
                }
            }
            print("Finished processing document. Total wings: \(self.wings.count)")
        }
    }


extension Array where Element == CourseTime {

    func isClassroomOccupied(currentTime: String) -> Bool {

        // If any course time includes the current time, the classroom is considered occupied
        for courseTime in self {
            if courseTime.isTimeInRange(currentTime: currentTime) {
                return true
            }
        }
        // If no course times include the current time, the classroom is not occupied
        return false
    }
}
