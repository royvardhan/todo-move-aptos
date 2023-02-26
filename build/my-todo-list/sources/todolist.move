module todolist_addr::todolist {

use aptos_framework::event;
use std::string::String;
use aptos_std::table::Table;



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





}