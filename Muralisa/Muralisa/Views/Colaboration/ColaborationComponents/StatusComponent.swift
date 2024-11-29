//
//  StatusComponent.swift
//  Muralisa
//
//  Created by Rafael Antonio Chinelatto on 31/10/24.
//

import SwiftUI

struct StatusComponent: View {
    
    var status: Int
    
    var body: some View {
        switch status {
        case 2:
            
            HStack {
                Image(systemName: "clock.fill")
                    .font(.body)
                Text("Pendente")
                    .font(.subheadline)
            }
            .foregroundStyle(.teal)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 40)
                    .foregroundStyle(.teal)
                    .opacity(0.15)
            )
            .padding(.vertical, 2)
            .frame(width: 120)
        case 1:
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .font(.body)
                Text("Aprovada")
                    .font(.subheadline)
            }
            .foregroundStyle(.green)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 40)
                    .foregroundStyle(.green)
                    .opacity(0.15)
            )
            .padding(.vertical, 2)
            .frame(width: 120)
        case 0:
            
            HStack {
                Image(systemName: "x.circle.fill")
                    .font(.body)
                Text("Recusada")
                    .font(.subheadline)
            }
            .foregroundStyle(.red)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 40)
                    .foregroundStyle(.red)
                    .opacity(0.15)
            )
            .padding(.vertical, 2)
            .frame(width: 120)
                
        default:
            EmptyView()
        }
    
    }
}

#Preview {
    StatusComponent(status: 1)
}
