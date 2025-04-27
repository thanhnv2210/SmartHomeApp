//
//  ScheduleManagementView.swift
//  SmartHomeApp
//
//  Created by Nguyen Van Thanh on 27/4/25.
//

import SwiftUI

struct ScheduleManagementView: View {
    @Binding var device: Device
    @State private var newSchedule: Device.Schedule = Device.Schedule(name: "", morning: "", evening: "", durationMinutes: 0)

    var body: some View {
        Form {
            Section(header: Text("Manage Schedules")) {
                List {
                    ForEach(device.schedules) { schedule in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(schedule.name)
                                Text("Morning: \(schedule.morning), Evening: \(schedule.evening), Duration: \(schedule.durationMinutes) mins")
                            }
                            Spacer()
                            Button(action: {
                                deleteSchedule(schedule) // Call delete function
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .onDelete(perform: deleteScheduleAt) // Allow deletion by swipe
                }
                
                Section {
                    TextField("Schedule Name", text: $newSchedule.name)
                    TextField("Morning Time", text: $newSchedule.morning)
                        .keyboardType(.default)

                    TextField("Evening Time", text: $newSchedule.evening)
                        .keyboardType(.default)

                    TextField("Duration (mins)", value: $newSchedule.durationMinutes, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                    
                    Button(action: {
                        addSchedule() // Call add function
                    }) {
                        Text("Add Schedule")
                    }
                }
            }
        }
        .navigationTitle("Schedules for \(device.name)")
    }

    private func addSchedule() {
        device.schedules.append(newSchedule)
        newSchedule = Device.Schedule(name: "", morning: "", evening: "", durationMinutes: 0) // Reset the form
        // Here you would also want to update Firebase with the new schedule if applicable
    }

    private func deleteSchedule(_ schedule: Device.Schedule) {
        if let index = device.schedules.firstIndex(where: { $0.id == schedule.id }) {
            device.schedules.remove(at: index)
            // Also update Firebase if you've stored schedules there
        }
    }

    private func deleteScheduleAt(offsets: IndexSet) {
        device.schedules.remove(atOffsets: offsets)
        // Also update Firebase accordingly
    }
}
