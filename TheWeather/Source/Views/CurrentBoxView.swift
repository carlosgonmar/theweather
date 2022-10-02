//
//  CurrentBox.swift
//  TheWeather
//
//  Created by Carlos González Martín on 1/10/22.
//

import SwiftUI

struct CurrentBoxView: View {
    
    @ObservedObject var myData: MyData
    
    var body: some View {
        VStack {
            VStack {
                Text(myData.north_town)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .font(.system(size: 12))
                Text("(N)")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .font(.system(size: 12))
            }
            .frame(
                alignment: .bottom
            )
            HStack {
                VStack {
                    Text(myData.west_town)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .font(.system(size: 12))
                    Text("(W)")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .font(.system(size: 12))
                }
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
                VStack (){
                    if(!myData.icon.isEmpty){ AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(myData.icon)@2x.png"))
                            .frame(width: 100, height: 100)
                        
                    }else{
                        Image("Rain")
                            .resizable()
                            .frame(width: 100, height: 100)
                        
                    }
                    Text(myData.description)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                    Text(myData.town)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .font(.system(size: 12))
                }
                .fixedSize(horizontal: true, vertical: false)
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .center
                )
                VStack {
                    Text(myData.east_town)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .font(.system(size: 12))
                    Text("(E)")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .font(.system(size: 12))
                }
                .frame(
                    maxWidth: .infinity,
                    alignment: .trailing
                )
            }
            .frame(
                alignment: .center
            )
            VStack {
                Text(myData.south_town)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .font(.system(size: 12))
                Text("(S)")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .font(.system(size: 12))
            }
        }
        .padding(10)
    }
}

struct CurrentBoxView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentBoxView(myData: MyData())
    }
}
