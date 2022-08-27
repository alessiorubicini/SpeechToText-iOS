//
//  OnboardingDetail.swift
//  TScribe
//
//  Created by Alessio Rubicini on 14/06/21.
//

import SwiftUI

struct OnboardingDetail: View {
    var image: String
    var color: Color
    var title: LocalizedStringKey
    var description: LocalizedStringKey
    
    var body: some View {
        HStack(alignment: .center) {
            HStack {
                Image(systemName: image)
                    .foregroundColor(self.color)
                    .font(.system(size: 40))
                    .frame(width: 50)
                    .padding()
                
                VStack(alignment: .leading) {
                    Text(title).bold()
                    
                    Text(description).fixedSize(horizontal: false, vertical: true)
                }
            }.frame(width: 340, height: 100)
        }
    }
}

struct OnboardingDetail_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingDetail(image: "person.circle.fill", color: .blue, title: "onboarding.feature1.title", description: "onboarding.feature1")
            .previewLayout(.sizeThatFits)
            .padding(10)
    }
}
