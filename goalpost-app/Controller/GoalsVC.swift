//
//  ViewController.swift
//  goalpost-app
//
//  Created by Hector Barrios on 8/28/20.
//  Copyright © 2020 Hector Barrios. All rights reserved.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as? AppDelegate

class GoalsVC: UIViewController  {
    
    @IBOutlet weak var tableView: UITableView!
    
    var goals: [Goal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden.toggle()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCoreDataObjects()
        tableView.reloadData()
    }
    
    private func fetchCoreDataObjects() {
        self.fetch { complete in
            if complete {
                if goals.count >= 1 {
                    //tableView.reloadData()
                    tableView.isHidden = false
                } else {
                    tableView.isHidden = true
                }
            }
        }
    }


    @IBAction func addGoalBtnWasPressed(_ sender: Any) {
        guard let createGoalVC = storyboard?.instantiateViewController(identifier: "CreateGoalVC") else { return }
        presentDetail(createGoalVC)
    }
}


extension GoalsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { goals.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "goalCell") as? GoalCell else { return UITableViewCell() }
        
        let goal = goals[indexPath.row]
        cell.configureCell(description: goal.goalDescription!, type: GoalType(rawValue: goal.goalType!)!, goalProgressAmount: Int(goal.goalProgress))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { return true }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle { .none }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, escape) in
            
            self.removeGoal(atIndexPath: indexPath)
            self.fetchCoreDataObjects()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }

        return UISwipeActionsConfiguration(actions: [action])
    }
    
}

extension GoalsVC {
    func removeGoal(atIndexPath indexPath: IndexPath) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        managedContext.delete(goals[indexPath.row])
        do {
            try managedContext.save()
            print("Successfully removed goal!")
        } catch {
            debugPrint("Could not remove: \(error.localizedDescription)")
        }
    }
    
    func fetch(completion: (_ complete: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let fetchRequest = NSFetchRequest<Goal>(entityName: "Goal")
        
        do {
            goals = try managedContext.fetch(fetchRequest)
            print("Successfully fetched data.")
            completion(true)
        } catch {
            debugPrint("Could not fetch: \(error.localizedDescription)")
            completion(false)
        }
        
    }
}
