//
//  ContentView.swift
//  SwiftUICoreData
//
//  Created by techfun on 2020/03/20.
//  Copyright © 2020 Naw Su Su Nyein. All rights reserved.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var context
    
    @State private var taskName : String = ""
    @FetchRequest(
        entity: Task.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.dateAdded, ascending: false)],
        predicate: NSPredicate(format: "isComplete == %@", NSNumber(value: false))
    ) var notCompletedTasks : FetchedResults<Task>
    
    var body: some View {
        VStack{
            HStack{
                TextField("Task Name",text: $taskName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.leading,20)
                Button(action:{
                    self.addTask()
                }){Text("Add Task")
                    .frame(width:80,height:40)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    .cornerRadius(5)
                    .padding(.trailing,20)
                }
            }
            List{
                
                ForEach(notCompletedTasks){task in
                    Button(action:{
                        self.updateTask(task)
                    }){
                        TaskRow(task:task)
                    }
                }
            }
        }
        
        
    }
    
    func addTask(){
        let newTask = Task(context: context)
        newTask.id = UUID()
        newTask.isComplete = false
        newTask.name = taskName
        newTask.dateAdded = Date()
        
        do{
            try context.save()
        }catch{
            print("inserting data into core data invalide : \(error)")
        }
    }
    
    func updateTask(_ task : Task){
        let isComplete = true
        let taskID = task.id! as NSUUID
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Task")
        fetchRequest.predicate = NSPredicate(format: "id == %@", taskID as CVarArg)
        fetchRequest.fetchLimit = 1
        
        do{
            let test = try context.fetch(fetchRequest)
            let taskUpdate = test[0] as! NSManagedObject
            taskUpdate.setValue(isComplete, forKey: "isComplete")
        }catch{
            print(error)
        }
    }
}

struct TaskRow: View{
    var task : Task
    var body : some View{
    Text(task.name ?? "No given name")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
