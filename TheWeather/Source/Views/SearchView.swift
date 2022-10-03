//
//  SearchView.swift
//  TheWeather
//
//  Created by Carlos González Martín on 30/9/22.
//

import SwiftUI

struct SearchView: View {
    
    @EnvironmentObject var errorHandling: ErrorHandling
    @EnvironmentObject private var principalData: PrincipalDataModel
    @Binding var showAlertSheet: Bool
    
    var body: some View {
        
        HStack {
            TextField("Search your city", text: $principalData.term)
                .keyboardType(.webSearch)
                .disableAutocorrection(true)
                .padding(5)
                .font(.headline)
                .foregroundColor(.white)
                .ignoresSafeArea(.keyboard)
                .onSubmit {
                    
                    if Reach().isConnected() {
                        showAlertSheet = true;
                    }else{
                        if principalData.term.count >= 1 {
                            
                            OpenWeatherMapProvider.shared.getCurrentWeatherData(term: principalData.term, country: principalData.country) { currentData in
                                
                                principalData.valuesAssignaments(currentData: currentData)

                            } failure: { error in
                                
                                self.errorHandling.handle(error: error)
                                
                            }
                            
                            
                        }
                    }
                }
            CountryView()
        }
        .background(Color.white.opacity(0.3))
        .cornerRadius(6)
        .padding(.horizontal, 20)
    }
    
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(showAlertSheet: .constant(false))
    }
}
