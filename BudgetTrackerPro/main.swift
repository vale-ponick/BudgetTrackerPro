//
//  main.swift
//  BudgetTracker
//
//  Created by Валерия Пономарева on 11.05.2026.
//

import Foundation

// MARK: - 1️⃣ Импорты и модели данных

enum ExpenseType: String, CaseIterable {  // позволяет получить массив всех кейсов (нужно для allCases).
    case grocery = "grocery"
    case household = "household"
    case petProduct = "pet product"
    case cafe = "cafe"
    case sport = "sport"
}

struct Expense {
    let title: String
    let amount: Double
    let type: ExpenseType
}

enum Command: String { // 2️⃣ Команды пользователя
    case setBudget = "set budget"
    case addExpense = "add expense"
    case showAllExpenses = "show all expenses"
    case showBudget = "show budget"
    case showStats = "show stats"
    case resetDay = "reset day"
    case exit = "exit"
}

// MARK: - BudgetManager

class BudgetManager { // 3️⃣ Класс BudgetManager
    
    private(set) var budget: Double = 0.0 // MARK: - Хранимые свойства - инкапсуляция
    private(set) var expenses: [Expense] = []
    
    var remainingBudget: Double { max(0, budget) } // MARK: - Вычисляемые свойства
    var totalSpent: Double { // Выглядят как переменные, но вычисляются каждый раз при обращении.
        expenses.reduce(0) { $0 + $1.amount }
    }
    
    // MARK: - Методы управления
    func setBudget(amount: Double) { // Просто сохраняет бюджет.
        budget = amount
        print("✅ Budget set to \(budget)")
    }
    
    func addExpense(title: String, amount: Double, type: ExpenseType) {
        let expense = Expense(title: title, amount: amount, type: type)
        expenses.append(expense)
        budget -= amount
        print("✅ Added: \(expense.title) - \(expense.amount) [\(expense.type.rawValue)]")
    }
    
    func showBudget() { // Использует вычисляемые свойства remainingBudget и totalSpent.
        print("💰 Remaining budget: \(remainingBudget) | Total spent: \(totalSpent)")
    }
    
    func selectExpenseType() -> ExpenseType? { // Читает ввод user и возвращает выбранный тип or nil.
        print("Choose category:")
        ExpenseType.allCases.enumerated().forEach { index, type in // enumerated() — даёт индекс и элемент.
            print("\(index + 1). \(type.rawValue)")
        }
        
        if let input = readLine(), let index = Int(input), index > 0, index <= ExpenseType.allCases.count {
            return ExpenseType.allCases[index - 1]
        }
        
        print("❌ Invalid selection")
        return nil
    }
    
    func showAllExpenses() {
        if expenses.isEmpty {
            print("📭 No expenses yet")
            return
        }
        print("📋 Expenses (total: \(totalSpent)):")
        for (index, expense) in expenses.enumerated() {
            print("\(index + 1). \(expense.title) - \(expense.amount) [\(expense.type.rawValue)]")
        }
    }
    
    func showStats() {
        guard !expenses.isEmpty else {
            print("📊 No data for statistics")
            return
        }
        
        let stats = Dictionary(grouping: expenses, by: { $0.type }) // группирует расходы по категориям.
            .mapValues { $0.reduce(0) { $0 + $1.amount } } // mapValues { ... } — заменяет массив расходов на сумму по категории.
            .sorted { $0.value > $1.value } // сортирует по убыванию суммы.
        
        print("📊 Expenses by category:")
        for (type, sum) in stats {
            print("  \(type.rawValue): \(sum) ₽")
        }
    }
    
    func resetDay() { // Очищает массив и обнуляет бюджет.
        expenses.removeAll()
        budget = 0.0
        print("🔄 Day reset")
    }
}

// MARK: - 4️⃣ Главная программа

let manager = BudgetManager() // Создаёт экземпляр класса.

print("""
📋 Available commands:
  💰 set budget     - set daily budget
  ➕ add expense    - add new expense
  📊 show budget    - show remaining budget
  🧾 show all expenses  - show all expenses
  📈 show stats     - show statistics by category
  🔄 reset day      - reset day (clear expenses and budget)
  🚪 exit           - exit program
""")

repeat { // repeat ... while true — бесконечный цикл, но с проверкой условия в конце (не принципиально).
    print("\n> ", terminator: "")
    guard let input = readLine()?.trimmingCharacters(in: .whitespaces), !input.isEmpty else { continue }
    
    guard let command = Command(rawValue: input) else {
        print("❌ Unknown command. Type 'exit' to quit.")
        continue
    }
    
    switch command {
    case .setBudget:
        print("💰 Enter budget amount: ", terminator: "")
        guard let input = readLine(), let amount = Double(input), amount > 0 else {
            print("❌ Invalid amount")
            continue
        }
        manager.setBudget(amount: amount)
        
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
        
    case .showBudget:
        manager.showBudget()
        
    case .showAllExpenses:
        manager.showAllExpenses()
        
    case .showStats:
        manager.showStats()
        
    case .resetDay:
        manager.resetDay()
        
    case .exit:
        print("👋 Bye, Vale.ponick!")
        break
    }
} while true
