//
//  SwiftUIView.swift
//  iExpense
//
//  Created by Ping Yun on 9/29/20.
//

import SwiftUI

struct SwiftUIView: View {
    //@Environment(\.presentationMode) var presentationMode //stores reference to SwiftUIView's presentation mode
    @State private var name = "" //stores name of expense
    @State private var type = "Personal" //stores type of expense
    @State private var amount = "" //stores amount of expense
    @ObservedObject var expenses: Expenses //stores Expenses object to share the existing instance from ContentView
    
    static let types = ["Business", "Personal"] //array of possible types for an expense
    
    var body: some View {
        NavigationView{
            Form {
                //text field for name
                TextField("Name", text: $name)
                //picker for type
                Picker("Type", selection: $type) {
                    ForEach(Self.types, id: \.self) {
                        Text($0)
                    }
                }
                //text field for amount
                TextField("Amount", text: $amount)
                    //changes default keyboard to one with only numbers
                    .keyboardType(.numberPad)
            }
            .navigationBarTitle("Add new expense")
            //button that creates an ExpenseItem out of properties and adds it to expenses items when tapped
            .navigationBarItems(trailing: Button("Save") {
                if let actualAmount = Int(self.amount) {
                    let item = ExpenseItem(name: self.name, type: self.type, amount: actualAmount)
                    self.expenses.items.append(item)
                    //causes showingAddExpense in ContentView to go back to false and hides SwiftUIView
                    //self.presentationMode.wrappedValue.dismiss()
                }
            })
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        //passes in dummy value for expenses property 
        SwiftUIView(expenses: Expenses())
            .previewDevice("iPhone 11")
    }
}
