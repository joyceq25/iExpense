//
//  ContentView.swift
//  iExpense
//
//  Created by Ping Yun on 9/28/20.
//

import SwiftUI

//struct representing single item of expense
struct ExpenseItem: Identifiable, Codable {
    //generates UUID automatically
    let id = UUID()
    let name: String
    let type: String
    let amount: Int
}

//class that stores array of items of expense and conforms to ObservableObject protocol
class Expenses: ObservableObject {
    @Published var items = [ExpenseItem]() {
        didSet {
            //creates instance of JSONEncoder that will convert data to JSON
            let encoder = JSONEncoder()
            
            //asks encoder to try writing data in items array to UserDefaults using key "Items"
            if let encoded = try? encoder.encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        //attempts to read "Items" key from UserDefaults
        if let items = UserDefaults.standard.data(forKey: "Items") {
            //creates instance of JSONDecoder
            let decoder = JSONDecoder()
            //asks decoder to convert data from UserDefaults into array of ExpenseItem objects
            if let decoded = try? decoder.decode([ExpenseItem].self, from: items) {
                //if it worked, assigns resulting array to items and exits
                self.items = decoded
                return
            }
        }
        //otherwise, sets items to be an empty array
        self.items = []
    }
}
    
struct ContentView: View {
    //creates instance of Expenses class, @ObservedObject asks SwiftUI to watch object for change announcements
    @ObservedObject var expenses = Expenses()
    //tracks whether or not SwiftUIView is being shown
    
    @State private var showingAddExpense = false
    var body: some View {
        NavigationView {
            List {
                //identifies each expense item uniquely by its id property automatically because ExpenseItem conforms to Identifiable protocol
                ForEach(expenses.items) { item in
                    HStack {
                        //inner VStack shows item name and type on the left
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        //outer HStack shows spacer and item amount on right
                        Spacer()
                        Text("$\(item.amount)")
                    }
                }
                //attatches removeItems to SwiftUI
                .onDelete(perform: removeItems)
            }
            .navigationBarTitle("iExpense")
            
            //trailing bar button item that adds example ExpenseItem instances to work with
            .navigationBarItems(trailing: Button(action: {
                    self.showingAddExpense = true
                }) {
                    //makes button a plus sign
                    Image(systemName: "plus")
                }
            )
        }
        //tells SwiftUI to use showingAddExpense Boolean as condition for showing a sheet
        .sheet(isPresented: $showingAddExpense) {
            //pass existing Expenses object from one view to another
            SwiftUIView(expenses: self.expenses)
        }
    }
    
    //deletes IndexSet of list items, passes it directly on to expenses array
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewDevice("iPhone 11")
        }
    }
}
