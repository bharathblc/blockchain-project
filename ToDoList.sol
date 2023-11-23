pragma solidity ^0.8.0;

contract ToDoList {
    enum TaskStatus {Pending, Finished}
    address owner;
    struct Task {
        string desc;
        TaskStatus status;
    }

    Task[] public tasks;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Not owner");
        _;
    }

    function addTask(string memory _desc) public onlyOwner {
        tasks.push(Task(_desc, TaskStatus.Pending));
    }

    function markAsFinished(uint256 id) public onlyOwner {
        require(id < tasks.length, "No task has been added");
        tasks[id].status= TaskStatus.Finished;
    }

    function getAllTasks() public view returns (Task[] memory) {
        uint256 pendingCount = 0;
        for (uint256 i = 0; i < tasks.length; i++) {
            if (tasks[i].status == TaskStatus.Pending) {
                pendingCount++;
            }
        }

        Task[] memory pendingTasks = new Task[](pendingCount);
        uint256 index = 0;
        for (uint256 i = 0; i < tasks.length; i++) {
            if (tasks[i].status == TaskStatus.Pending) {
                pendingTasks[index] = tasks[i];
                index++;
            }
        }

        return pendingTasks;
    }

    function getTask(uint256 id) public view returns (string memory, TaskStatus) {
        require(id < tasks.length, "No task has been added");
        return(tasks[id].desc, tasks[id].status);
    }
}