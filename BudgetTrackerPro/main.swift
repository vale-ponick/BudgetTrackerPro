//
//  main.swift
//  BudgetTrackerPro
//
//  Created by Валерия Пономарева on 11.05.2026.
//

import Foundation

enum ExpenseType: String, CaseIterable { // хранить + выводит виды трат
    case grosery = "grocery"
    case household = "household"
    case petProduct = "pet product"
    case cafe = "cafe"
    case sport = "sport"
}

struct Expense { // 1️⃣ Импорты и модель данных, struct = value type хранит значение с параметрами
    let title: String
    let amount: Double
    let type: ExpenseType
}

enum Command: String {// 2️⃣ Команды user
    case setBudget = "set budget" // 🔹 type Command with raw value - хранит и выводит названия действий user
    case addExpense = "add expense"
    case showAllExpenses = "show all expenses"
    case showBudget = "show budget"
    case showExpenseType = "show expense type"
    case resetDay = "reset day"
    case exit = "exit"
}
// 3️⃣ Бизнес-логика: ?
// 4️⃣ Вспомогательные функции ввода ?

class BudgetManager { // // 3️⃣ Бизнес-логика: класс BookShelf - reference type
    private(set) var budget: Double = 0.0 // 🔹 инкапсуляция: переменная скрыта от внешнего мира
    private(set) var expenses: [Expense] = [] // 🔹 инкапсуляция: массив скрыт от внешнего мира
    
    func setBudget(amount: Double) {
        budget = amount
    }
    func addExpense(title: String, amount: Double, type: ExpenseType) {
        let expense = Expense(title: title, amount: amount, type: type)
        expenses.append(expense)
        budget -= amount
        print("✅ Added: \(expense.title) - \(expense.amount) - [\(expense.type.rawValue)]")
    }
    func showBudget() {
        print("📝 Current budget - \(budget)")
    }
    func selectExpenseType() -> ExpenseType? {
        print("Choose category:")
        ExpenseType.allCases.enumerated().forEach { index, type in
            print("\(index + 1). \(type.rawValue)")
        }
        
        if let input = readLine(), let index = Int(input), index > 0 && index <= ExpenseType.allCases.count {
            return ExpenseType.allCases[index - 1]
        }
        
        print("❌ Invalid selection")
        return nil
    }

    func showAllExpenses() {
        if expenses.isEmpty {
            print("No expenses yet")
        } else {
       print("📋 Expenses:")
            for(index, expense) in expenses.enumerated() {
            print("\(index + 1). \(expense.title) - \(expense.amount) [\(expense.type.rawValue)]")
            }
        }
    }
    func resetDay() {
        expenses.removeAll()
        budget = 0.0
    }
    
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
    case .setBudget:
        print("💰 Enter budget amount: ", terminator: "")
        guard let input = readLine(), let amount = Double(input), amount > 0 else {
            print("❌ Invalid amount")
            continue
        }
        manager.setBudget(amount: amount)
        print("✅ Budget set to \(manager.budget)")
        
    case .addExpense:
        print("📝 Enter title: ", terminator: "")
        guard let title = readLine()?.trimmingCharacters(in: .whitespaces), !title.isEmpty else {
            print("❌ Title cannot be empty")
            continue
        }
        print("💰 Enter amount: ", terminator: "")
        guard let amountInput = readLine(), let amount = Double(amountInput), amount > 0 else {
            print("❌ Invalid amount")
            continue
        }
        guard let type = manager.selectExpenseType() else { continue }
        manager.addExpense(title: title, amount: amount, type: type)
        
    case .showAllExpenses:
        manager.showAllExpenses()
        
    case .showBudget:
        manager.showBudget()
        
    case .showExpenseType:
        _ = manager.selectExpenseType()  // просто показать категории (можно без сохранения результата)
        
    case .resetDay:
        manager.resetDay()
        print("🔄 Day reset. Budget cleared.")
        
    case .exit:
        print("👋 Bye, Vale.ponick!")
        break
    }
}
