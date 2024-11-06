//
//  AddTagsSheet.swift
//  Muralisa
//
//  Created by Gustavo Sacramento on 02/11/24.
//

import SwiftUI


// Iremos definir essas tags em algum lugar, por enquanto hardcoded
var tags = [
    "Tipografia", "Bomb", "Psicodélico", "Abstrato", "Colorido",
    "Natureza", "Sombrio", "Freestyle", "Tag", "Freehand",
    "Poster", "Pontilhismo", "Surrealismo", "Persona", "Retrato",
    "Branco e Preto", "Mural"
]

struct AddTagsSheet: View {
    @Environment(\.dismiss) var dismiss
    // Provavelmente irá receber esse valor e alterar
    @Binding var selectedTags: [String]
    
    
    var body: some View {
        NavigationStack {
            List {
                if !selectedTags.isEmpty {
                    Section {
                        ForEach(selectedTags, id:\.self) { tag in
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

                Section {
                    Button {
                        // Por enquanto só volta, podemos implementar alguma lógica aqui
                        dismiss()
                    } label: {
                        Text("Salvar")
                    }
                    .buttonStyle(CustomBorderedProminentButtonStyle(color: .accentColor, isFullScreen: true))
                    .listRowBackground(Color.clear)
                }
                .padding(.horizontal, -16)
            }
            .animation(.easeInOut, value: selectedTags.count)
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
            }
        }
    }
    
    private func addTag(_ tag: String) {
        // Limit of 3 tags per Work
        if selectedTags.count < 3 {
            selectedTags.append(tag)
            tags.removeAll { $0 == tag }
        }
    }
    
    private func removeTag(_ tag: String) {
        selectedTags.removeAll { $0 == tag }
        tags.append(tag)
    }
}


