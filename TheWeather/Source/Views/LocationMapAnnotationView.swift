//
//  LocationMapAnnotationView.swift
//  TheWeather
//
//  Created by Carlos González Martín on 1/10/22.
//

import SwiftUI

struct LocationMapAnnotationView: View {
    
    @State var name: String
    
    var body: some View {
        Text(name)
            .padding(5)
            .background(Color(red: 121/255, green: 104/255, blue: 134/255))
            .cornerRadius(5)
            .foregroundColor(Color.white)
            .font(.system(size: 10))
    }
}

struct LocationMapAnnotationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationMapAnnotationView(name: "-")
    }
}
