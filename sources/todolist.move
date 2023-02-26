module todolist_addr::todolist {

use aptos_framework::event;
use std::string::String;
use aptos_std::table::Table;
use std::signer;
use aptos_std::table::{Self, Table}; // This one we already have, need to modify it



    // The following Sturct has key abilities
    // key ability allows struct to be used as a storage identifier. 
    // In other words, key  is an ability to be stored at the top-level and act as a storage. 
    // We need it here to have TodoList be a resource stored in our user account.
    struct TodoList has key {
        tasks: Table<u64, Task>,
        set_task_event: event::EventHandle<Task>,
        task_counter: u64,
    }
    // The following Sturct has store, drop and copy abilities
    // Store - Task needs Store as its stored inside another struct (TodoList)
    // Copy - value can be copied (or cloned by value).
    // Drop - value can be dropped by the end of scope.
    struct Task has store, drop, copy {
        task_id: u64,
        address:address,
        content:String,
        completed:bool,
    }

    // @entry - an entry function is a function that can be called via transactions. 
    // Simply put, whenever you want to submit a transaction to the chain, you should call an entry function.

    // &signer - The signer argument is injected by the Move VM as the address who signed that transaction.
    public entry fun create_list(account: &signer) {
        let tasks_holder = TodoList {
            tasks: table::new(),
            set_task_event: account::new_event_handle<Task>(account),
            task_counter: 0
        };
        // move the TodoList resource under the signer account
        move_to(account, tasks_holder);
    }

    public entry fun create_task(account: &signer, content: String) acquires TodoList {
        // gets the signer address
        let signer_address = signer::address_of(account);
        // gets the TodoList resource 
        let todo_list = borrow_global_mut<TodoList>((signer_address));
        // increment task counter
        let counter = todo_list.task_counter + 1;
        // creates a new Task
        let new_task = Task{
            task_id: counter, 
            address: signer_address,
            content,
            completed: false
        };
        // adds the new task into the tasks table
        table::upsert(&mut todo_list.tasks, counter, new_task);
        // set the task counter to be the incremented counter
        todo_list.task_counter = counter;
        // fires a new task created event
        event:: emit_event<Task>{
        &mut borrow_global_mut<TodoList>(signer_address).set_task_event,
        new_task,
        }
    }


}