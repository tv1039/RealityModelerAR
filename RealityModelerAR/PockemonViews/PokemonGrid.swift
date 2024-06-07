//
//  PokemonGrid.swift
//  RealityModelerAR
//
//  Created by 홍승표 on 5/16/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct PokemonGrid: View {
    @EnvironmentObject var dataSource: StorageDataSource
    var columns = Array(repeating: GridItem(.flexible()), count: 3)

    @State private var imageUrls = [String: URL]()
    @Binding var selectedPokemon: String?
    @Binding var isSheetPresented: Bool
    
    var body: some View {
        ScrollView {
            Text("원하는 모델을 골라주세요.")
                .font(.title3)
                .padding(.top, 20)
            
            LazyVGrid(columns: columns) {
                ForEach(dataSource.pokemonNames, id: \.self) { pokemon in
                    if let url = imageUrls[pokemon] {
                        WebImage(url: url)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100)
                            .padding()
                            .onTapGesture {
                                selectedPokemon = pokemon
                                isSheetPresented = false
                            }
                    } else {
                        ProgressView()
                            .frame(width: 100)
                            .padding()
                            .onAppear {
                                dataSource.getThumbnailURL(pokemonName: pokemon) { url in
                                    if let url = url {
                                        imageUrls[pokemon] = url
                                    }
                                }
                            }
                    }
                }
            }
        }
    }
}


#Preview {
    PokemonGrid(selectedPokemon: .constant(""), isSheetPresented: .constant(false))
}
