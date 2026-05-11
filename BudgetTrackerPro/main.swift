//
//  main.swift
//  BudgetTracker
//
//  Created by Валерия Пономарева on 11.05.2026.
//

import Foundation

// MARK: - Модели данных

enum ExpenseType: String, CaseIterable {
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

enum Command: String {
    case setBudget = "set budget"
    case addExpense = "add expense"
    case showAllExpenses = "show all expenses"
    case showBudget = "show budget"
    case showStats = "show stats"
    case resetDay = "reset day"
    case exit = "exit"
}

// MARK: - BudgetManager (ты уже написала)

class BudgetManager {
    // MARK: - Хранимые свойства
    private(set) var budget: Double = 0.0
    private(set) var expenses: [Expense] = []
    
    // MARK: - Вычисляемые свойства
    var remainingBudget: Double { max(0, budget) }
    var totalSpent: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }
    
    // MARK: - Методы
    func setBudget(amount: Double) {
        budget = amount
        print("✅ Budget set to \(budget)")
    }
    
    func addExpense(title: String, amount: Double, type: ExpenseType) {
        let expense = Expense(title: title, amount: amount, type: type)
        expenses.append(expense)
        budget -= amount
        print("✅ Added: \(expense.title) - \(expense.amount) [\(expense.type.rawValue)]")
    }
    
    func showBudget() {
        print("💰 Remaining budget: \(remainingBudget) | Total spent: \(totalSpent)")
    }
    
    func selectExpenseType() -> ExpenseType? {
        print("Choose category:")
        ExpenseType.allCases.enumerated().forEach { index, type in
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
        
        let stats = Dictionary(grouping: expenses, by: { $0.type })
            .mapValues { $0.reduce(0) { $0 + $1.amount } }
            .sorted { $0.value > $1.value }
        
        print("📊 Expenses by category:")
        for (type, sum) in stats {
            print("  \(type.rawValue): \(sum) ₽")
        }
    }
    
    func resetDay() {
        expenses.removeAll()
        budget = 0.0
        print("🔄 Day reset")
    }
}

// MARK: - Главная программа

let manager = BudgetManager()

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

repeat {
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
