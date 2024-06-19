//
//  MessageViewModel.swift
//  JoyFlow
//
//  Created by god on 07/06/2024.
//

import SwiftUI

struct MessageRow: View {
    let message: String
    let isMyMessage: Bool
    let user: String
    let date: Date
    
    var body: some View {
        HStack {
            if isMyMessage {
                Spacer()
                VStack {
                    Text(message)
                        .padding(8)
                        .background(Color.blue)
                        .cornerRadius(6)
                        .foregroundColor(.white)
                    Text(DateUtils.stringFromDate(date: date, format: "yyyy/MM/dd HH:mm:ss"))
                        .font(.callout)
                }
            } else {
                VStack(alignment: .leading) {
                    Text(message)
                        .padding(8)
                        .background(Color.gray)
                        .cornerRadius(6)
                        .foregroundColor(.white)
                    HStack {
                        Text(user)
                            .font(.callout)
                            .foregroundColor(.secondary)
                        Text(DateUtils.stringFromDate(date: date, format: "yyyy/MM/dd HH:mm:ss"))
                            .font(.callout)
                    }
                }
                Spacer()
            }
        }
    }
}


