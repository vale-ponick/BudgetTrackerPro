//
//  main.swift
//  BudgetTrackerPro
//
//  Created by Валерия Пономарева on 11.05.2026.
//

import Foundation


struct Expense { // 1️⃣ Импорты и модель данных, struct = value type хранит значение с параметрами
    let title: String
    let amount: Double
}

enum ExpenseType:String { // хранить + выводит виды трат
    case grosery = "grocery"
    case household = "household"
    case petProduct = "pet product"
    case cafe = "cafe"
    case sport = "sport"
}

enum Command: String {// 2️⃣ Команды user
    case setBudget = "set budget" // 🔹 type Command with raw value - хранит и выводит названия действий user
    case addExpense = "add expense"
    case showAllExpenses = "show all expenses"
    case showBudget = "show budget"
    case resetDay = "reset Day"
    case exit = "exit"
}
// 3️⃣ Бизнес-логика: ?
// 4️⃣ Вспомогательные функции ввода ?

class BudgetManager { // // 3️⃣ Бизнес-логика: класс BookShelf - reference type
    private(set) var budget: Double = 0.0 // 🔹 инкапсуляция: переменная скрыта от внешнего мира
    private(set) var expenses: [Expense] = [] // 🔹 инкапсуляция: массив скрыт от внешнего мира
    
    func setBudget(amount: Double) {...}
    func addExpense(title: String, amount: Double) {...}
    func showBudget() {}
    func selectExpenseType() -> ExpenseType? {}
    func showExpenses() {...}
    func reset() {...}
    
}
// MARK: 5️⃣ Основная программа

let manager = BudgetManager()

print("""
📋 Available commands:
  💰 set  budget     - set daily budget
  ➕ add expense    - add new expense
  📊 show budget    - show remaining budget
  🧾 show all expenses  - show all expenses
  🔄 reset day      - reset day (clear expenses and budget)
  🚪 exit           - exit program
""")

while true {
    print("\n> ", terminator: "")
    guard let input = readLine()? // безопасное чтение
        .trimmingCharacters(in: .whitespaces),
          !input.isEmpty else { continue }
    
    if input == "exit" {
        print("By, Vale.ponick!")
        break
    }
    
    guard let command = Command(rawValue: input) else {
        print("Uncnown command. Type 'exit' to quit.")
        continue
    }
    
    switch command { // switch — чистая обработка, каждая команда вызывает метод
    case .addExpense:
        print("📝 Enter title: ", terminator: "")
        guard let title = readLine()?.trimmingCharacters(in: .whitespaces), !title.isEmpty else {
            print("❌ Title cannot be empty")
            continue
        }
