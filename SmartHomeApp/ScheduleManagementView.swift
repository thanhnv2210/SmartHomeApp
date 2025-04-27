//
//  ScheduleManagementView.swift
//  SmartHomeApp
//
//  Created by Nguyen Van Thanh on 27/4/25.
//

import SwiftUI

struct ScheduleManagementView: View {
    @Binding var device: Device
    @State private var newSchedule: Device.Schedule = Device.Schedule(name: "")
    @State private var daysOfWeek = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"] // Days of the week

    var body: some View {
        Form {
            Section(header: Text("Manage Schedules")) {
                ForEach(device.schedules) { schedule in
                    VStack(alignment: .leading) {
                        Text(schedule.name)
                        Text("Start Time: \(formatTime(schedule.startTime))")
                        Text("Duration: \(schedule.durationMinutes) minutes")
                        Text("Days: \(schedule.selectedDays.joined(separator: ", "))")
                    }
                }

                Section {
                    TextField("Schedule Name", text: $newSchedule.name)

                    // Toggling each day of the week
                    ForEach(daysOfWeek, id: \.self) { day in
                        Toggle(day, isOn: Binding<Bool>(
                            get: {
                                newSchedule.selectedDays.contains(day)
                            },
                            set: { isSelected in
                                if isSelected {
                                    newSchedule.selectedDays.append(day)
                                } else {
                                    newSchedule.selectedDays.removeAll(where: { $0 == day })
                                }
                            }
                        ))
                    }

                    // Time Picker for Start Time
                    DatePicker("Start Time", selection: $newSchedule.startTime, displayedComponents: .hourAndMinute)

                    // Input for Duration Minutes
                    TextField("Duration (minutes)", value: $newSchedule.durationMinutes, formatter: NumberFormatter())
                        .keyboardType(.numberPad)

                    Button(action: {
                        addSchedule() // Add new schedule
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
        newSchedule = Device.Schedule(name: "") // Reset the form for a new schedule
        // Here you would also want to update Firebase with the new schedule if applicable
    }

    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a" // Format to show in 12-hour format
        return formatter.string(from: date)
    }
}
