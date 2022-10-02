//
//  CurrentBox.swift
//  TheWeather
//
//  Created by Carlos González Martín on 1/10/22.
//

import SwiftUI

struct CurrentBoxView: View {
    
    @EnvironmentObject var principalData: PrincipalDataModel
    
    var body: some View {
        VStack {
            VStack {
                Text(principalData.north_town)
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
                    Text(principalData.west_town)
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
                    if(!principalData.icon.isEmpty){ AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(principalData.icon)@2x.png"))
                            .frame(width: 100, height: 100)
                        
                    }else{
                        Image("Rain")
                            .resizable()
                            .frame(width: 100, height: 100)
                        
                    }
                    Text(principalData.description)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                    Text(principalData.town)
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
                    Text(principalData.east_town)
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
                Text(principalData.south_town)
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
        CurrentBoxView()
    }
}
