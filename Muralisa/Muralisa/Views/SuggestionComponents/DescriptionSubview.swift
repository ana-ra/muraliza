//
//  DescriptionSubview.swift
//  Muralisa
//
//  Created by Rafael Antonio Chinelatto on 30/10/24.
//

import SwiftUI

struct DescriptionSubview: View {
    
    var work: Work
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                
                if let title = work.title {
                    Text(title)
                        .padding(.top)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    if let description = work.workDescription {
                        Text(description)
                            .multilineTextAlignment(.leading)
                    }
                }
                else {
                    if let description = work.workDescription {
                        Text("Sem Título")
                            .padding(.top)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(description)
                            .multilineTextAlignment(.leading)
                    }
                }
            }
            Spacer()
        }
        .padding(.horizontal)
    }
}
