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
    
    @EnvironmentObject var principalData: PrincipalDataModel
    
    let countries = Locale.Region.isoRegions.filter({ region in
        return !CharacterSet(charactersIn: region.identifier).isSubset(of: CharacterSet.decimalDigits)
    }) .compactMap {  Country(id: $0.identifier, name: Locale.current.localizedString(forRegionCode:$0.identifier)!) }
    
    @State var selectedCountry: Country?
    
    var body: some View {
        
        Picker("Country", selection: $principalData.country) {
            ForEach(countries) {
                Text($0.name)
                    .tag(Optional($0))
                    .font(.system(size: 8))
            }
        }.pickerStyle(.menu)
            .onChange(of: selectedCountry) { selected in
                if let cntry = selected {
                    self.principalData.country=cntry.id
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
        CountryView()
    }
}
