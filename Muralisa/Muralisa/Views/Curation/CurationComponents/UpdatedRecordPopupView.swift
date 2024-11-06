//
//  UpdatedRecordPopupView.swift
//  Muralisa
//
//  Created by Gustavo Sacramento on 31/10/24.
//

import SwiftUI

struct UpdatedRecordPopupView: View {
    let status: Int
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Image(systemName: status == 1 ? "checkmark.circle" : "xmark.circle")
              .font(Font.custom("SF Pro", size: 36))
              .multilineTextAlignment(.center)
              .foregroundColor(status == 1 ? Color.green : Color.red)
              .frame(maxWidth: .infinity, alignment: .center)
            
            Text(status == 1 ? "Obra Aceita" : "Obra Rejeitada")
                .fontWeight(.semibold)
        }
        .frame(width: getWidth() / 1.4, height: getHeight() / 7)
        .background(Color(red: 0.7, green: 0.7, blue: 0.7).opacity(0.5))
        .cornerRadius(14)
    }
}

#Preview {
    UpdatedRecordPopupView(status: 2)
}
