//
//  ContentView.swift
//  RealityModelerAR
//
//  Created by 홍승표 on 5/16/24.
//

import SwiftUI
import RealityKit
import SDWebImageSwiftUI

struct ContentView : View {
    @StateObject var arViewModel: ARViewModel
    @State private var isSheetPresented = false
    @State private var selectedPokemon: String?
    
    var body: some View {
        ZStack {
            ARViewContainer(arViewModel: arViewModel)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture { location in
                    if let pokemon = selectedPokemon {
                        arViewModel.placeObject(named: pokemon, for: location)
                    }
                }
            
            VStack {
                HStack {
                    Button {
                        isSheetPresented = true
                    } label: {
                        Image(systemName: "plus")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                    }
                    .padding()
                    Spacer()
                    Button {
                        arViewModel.switchCamera()
                    } label: {
                        Image(systemName: "arrow.triangle.2.circlepath.camera")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                    }
                    .padding()
                }
                Spacer()
            }
            .sheet(isPresented: $isSheetPresented) {
                PokemonGrid(selectedPokemon: $selectedPokemon, isSheetPresented: $isSheetPresented)
                    .presentationDetents([.medium])
            }
            
            VStack {
                Spacer()
                Button {
                    arViewModel.snapshotAndSave()
                } label: {
                    Circle()
                        .frame(width: 60, height: 60)
                        .padding()
                }
            }
        }
    }
}


struct ARViewContainer: UIViewRepresentable {
    var arViewModel: ARViewModel
    
    func makeUIView(context: Context) -> ARView {
        let arView = arViewModel.arView
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

#Preview {
    ContentView(arViewModel: ARViewModel(dataSource: DataSource(pokemonName: "Pokemon001"),
                                         model: ARModel(arView: ARView(frame: .zero)))
    )
}
