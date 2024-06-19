//
//  TaksListView.swift
//  JoyFlow
//
//  Created by god on 17/06/2024.
//

import SwiftUI

struct TaskListView: View {
    var tasks: [Task]
    
    var body: some View {
        List(tasks) { task in
            VStack(alignment: .leading) {
                Text(task.title)
                    .font(.headline)
                Text(task.description)
                    .font(.subheadline)
                Text(task.date, style: .time)
                    .font(.caption)
            }
        }
    }
}

