//
//  AddTagsSheet.swift
//  Muralisa
//
//  Created by Gustavo Sacramento on 02/11/24.
//

import SwiftUI


// Iremos definir essas tags em algum lugar, por enquanto hardcoded


struct AddTagsSheet: View {
    @Environment(\.dismiss) var dismiss
    // Provavelmente irá receber esse valor e alterar
    @Binding var selectedTags: [String]
    @State var newSelectedTags: [String] = []
    
    @State var tags = [
        "Tipografia", "Bomb", "Psicodélico", "Abstrato", "Colorido",
        "Natureza", "Sombrio", "Freestyle", "Tag", "Freehand",
        "Poster", "Pontilhismo", "Surrealismo", "Persona", "Retrato",
        "Branco e Preto", "Mural"
    ]
    
    
    var body: some View {
        NavigationStack {
            List {
                if !newSelectedTags.isEmpty {
                    Section {
                        ForEach(newSelectedTags, id:\.self) { tag in
                            HStack {
                                Button {
                                    removeTag(tag)
                                } label: {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundStyle(.red)
                                }
                                
                                Text(tag)
                            }
                        }
                    } header: {
                        Text("Tags selecionadas")
                    } footer: {
                        Text("Estas são as tags que melhor representam a obra adicionada.")
                    }
                }
                
                if !tags.isEmpty {
                    Section {
                        ForEach(tags, id:\.self) { tag in
                            HStack {
                                Button {
                                    addTag(tag)
                                } label: {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundStyle(.green)
                                }
                                
                                Text(tag)
                            }
                        }
                    } header: {
                        Text("Adicionar tags")
                    } footer: {
                        Text("Selecione as categorias que a obra adicionada mais se encaixa para adicioná-la como tag. Máximo de três categorias.")
                    }
                }
            }
            .animation(.easeInOut, value: newSelectedTags.count)
            .navigationTitle("Adicionar Tags")
            .toolbarTitleDisplayMode(.inline)
            .toolbarBackgroundVisibility(.visible)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancelar")
                    }
                    .padding()
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                        selectedTags = newSelectedTags
                    } label: {
                        Text("OK")
                            .bold()
                    }
                }
            }
            .onAppear {
                newSelectedTags = selectedTags
                for tag in newSelectedTags {
                    self.tags.removeAll { $0 == tag }
                }
            }
        }
    }
    
    private func addTag(_ tag: String) {
        // Limit of 3 tags per Work
        if newSelectedTags.count < 3 {
            newSelectedTags.append(tag)
            self.tags.removeAll { $0 == tag }
        }
    }
    
    private func removeTag(_ tag: String) {
        newSelectedTags.removeAll { $0 == tag }
        self.tags.append(tag)
    }
}


