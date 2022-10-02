//
//  CurrentBox.swift
//  TheWeather
//
//  Created by Carlos González Martín on 1/10/22.
//

import SwiftUI

struct CurrentBoxView: View {
    
    var currentImage: String
    var currentDescription: String
    var currentTown: String
    
    var body: some View {
        VStack (){
            if(currentImage != ""){ AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(currentImage)@2x.png"))
                    .frame(width: 100, height: 100)
                
            }else{
                Image("Rain")
                    .resizable()
                    .frame(width: 100, height: 100)
                    
            }
            Text(currentDescription)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .font(.system(size: 16))
            Text(currentTown)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .font(.system(size: 12))
        }
        .frame(
            minWidth: 250,
            minHeight: 250,
            alignment: .center
        )
    }
}

struct CurrentBoxView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentBoxView(currentImage:"",currentDescription:"",currentTown:"")
    }
}
