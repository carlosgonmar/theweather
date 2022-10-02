//
//  CountryPicker.swift
//  TheWeather
//
//  Created by Carlos González Martín on 1/10/22.
//

import SwiftUI

struct Country: Identifiable, Hashable {
    let id: String
    let name: String
}

struct CountryView: View {
    
    @ObservedObject var myData: MyData
    
    let countries = Locale.Region.isoRegions.filter({ region in
        return !CharacterSet(charactersIn: region.identifier).isSubset(of: CharacterSet.decimalDigits)
    }) .compactMap {  Country(id: $0.identifier, name: Locale.current.localizedString(forRegionCode:$0.identifier)!) }
    
    @State var selectedCountry: Country? = Country(id:"ES",name: "España")
    
    var body: some View {
        
        Picker("Country", selection: $selectedCountry) {
            ForEach(countries) {
                Text($0.name)
                    .tag(Optional($0))
                    .font(.system(size: 8))
            }
        }.pickerStyle(.menu)
            .onChange(of: selectedCountry) { selected in
                if let cntry = selected {
                    self.myData.country=cntry.id
                }
            }
            .accentColor(.white)
            .font(.system(size: 3))
            .font(.headline)
            .foregroundColor(.white)
            .padding(0)
        
        
    }
}

struct CountryView_Previews: PreviewProvider {
    static var previews: some View {
        CountryView(myData: MyData())
    }
}
