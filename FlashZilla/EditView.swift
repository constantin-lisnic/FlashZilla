//
//  EditView.swift
//  FlashZilla
//
//  Created by Constantin Lisnic on 25/12/2024.
//

import SwiftUI

struct EditView: View {
    @Environment(\.dismiss) var dismiss

    @State private var cards = [Card]()
    @State private var newPrompt = ""
    @State private var newAnswer = ""

    var body: some View {
        NavigationStack {
            List {
                Section("Add new card") {
                    TextField("Prompt", text: $newPrompt)
                    TextField("Answer", text: $newAnswer)
                    Button("Add Card", action: addCard)
                }

                Section {
                    ForEach(0..<cards.count, id: \.self) { index in
                        VStack(alignment: .leading) {
                            Text(cards[index].prompt)
                                .font(.largeTitle)

                            Text(cards[index].answer)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .onDelete(perform: deleteCards)
                }
            }
            .navigationTitle("Edit Cards")
            .toolbar {
                Button("Done", action: done)
            }
            .onAppear(perform: loadData)
        }
    }

    func addCard() {
        let trimmedPrompt = newPrompt.trimmingCharacters(in: .whitespaces)
        let trimmedAnswer = newAnswer.trimmingCharacters(in: .whitespaces)
        guard !trimmedPrompt.isEmpty && !trimmedAnswer.isEmpty else { return }

        let newCard = Card(prompt: trimmedPrompt, answer: trimmedAnswer)
        cards.insert(newCard, at: 0)

        saveData()
    }

    func deleteCards(at offsets: IndexSet) {
        cards.remove(atOffsets: offsets)
        saveData()
    }

    func done() {
        dismiss()
    }

    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards") {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data)
            {
                cards = decoded
            }
        }
    }

    func saveData() {
        if let data = try? JSONEncoder().encode(cards) {
            UserDefaults.standard.set(data, forKey: "Cards")
        }
    }
}

#Preview {
    EditView()
}
