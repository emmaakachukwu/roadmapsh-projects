# Task Tracker
CLI app solution for the [task-tracker](https://roadmap.sh/projects/task-tracker) challenge on [roadmap.sh](https://roadmap.sh)

### Setup
**Clone the repo**

```
git clone https://github.com/emmaakachukwu/roadmapsh-projects.git
```

**cd into the task tracker directory**
```
cd backend-projects/01-task-tracker
```

### How to use
**Add task**
```
./bin/task_cli.rb add 'Submit task tracker project' --description 'Build and submit roadmap.sh backend project' --status in-progress
# Task added successfully (ID: 1)

./bin/task_cli.rb add 'Sleep for 8 hours'
# Task added successfully (ID: 2)
```

**Update task**
```
./bin/task_cli.rb update 1 'Submit task-tracker project' --description 'A short task description'
# Task updated successfully (ID: 1)
```

**Delete task**
```
./bin/task_cli.rb delete 2
# Task deleted successfully (ID: 2)
```

**Mark task in progress**
```
./bin/task_cli.rb mark-in-progress 1
# Task marked as in-progress (ID: 1)
```

**Mark task done**
```
./bin/task_cli.rb mark-done 1
# Task marked as done (ID: 1)
```

**List all tasks**
```
./bin/task_cli.rb list

ID                            Task                          Description                   Status                        Created At                    Updated At

1                             Submit task-tracker project   A short task description      done                          2024-10-05 17:20:02 +0100     2024-10-05 17:29:03 +0100
```

**List tasks by status**
```
./bin/task_cli.rb list [todo,in-progress,done]
```

### Tests
```
rspec
```
