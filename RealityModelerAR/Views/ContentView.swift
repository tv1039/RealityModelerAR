//
//  ContentView.swift
//  RealityModelerAR
//
//  Created by 홍승표 on 5/20/24.
//

import SwiftUI
import RealityKit
import SDWebImageSwiftUI

enum ButtonObjc: String {
    case addObject = "plus.viewfinder"
    case undoObject = "arrow.uturn.backward.circle"
    case resetObject = "arrow.counterclockwise.circle"
}

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
                    Spacer()
                    VStack {
                        Image(systemName: ButtonObjc.addObject.rawValue)
                            .imageStyle()
                            .onTapGesture {
                                handleButtonTap(.addObject)
                            }
                        Image(systemName: ButtonObjc.undoObject.rawValue)
                            .imageStyle()
                            .onTapGesture {
                                handleButtonTap(.undoObject)
                            }
                        Image(systemName: ButtonObjc.resetObject.rawValue)
                            .imageStyle()
                            .onTapGesture {
                                handleButtonTap(.resetObject)
                            }
                    }
                    .background(Color.black.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
#if os(iOS)
                    .scaleEffect(0.7)
                    .padding(0)
#else
                    .scaleEffect(1)
                    .padding()
#endif
                    
                }
                Spacer()
                    .sheet(isPresented: $isSheetPresented) {
                        PokemonGrid(selectedPokemon: $selectedPokemon, isSheetPresented: $isSheetPresented)
                            .presentationDetents([.medium])
                    }
            }
            VStack {
                Spacer()
                Button {
                    arViewModel.snapshotAndSave()
                } label: {
                    Image(systemName: "camera.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .padding()
                }
                .tint(.primary)
            }
        }
    }
    
    func handleButtonTap(_ button: ButtonObjc) {
        switch button {
        case .addObject:
            isSheetPresented = true
        case .undoObject:
            arViewModel.removeLastObject()
        case .resetObject:
            arViewModel.resetScene()
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
    ContentView(arViewModel: ARViewModel(dataSource: StorageDataSource(pokemonName: "Pokemon001"),
                                         model: ARModel(arView: ARView(frame: .zero)))
    )
}
