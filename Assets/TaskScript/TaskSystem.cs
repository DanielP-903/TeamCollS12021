using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class TaskSystem : MonoBehaviour
{
    public List<Task> tasks = new List<Task>();

    public Text descriptionText;
    public Text rewardText;
    public Text currentamountText;
    public int rewarding;
    // Start is called before the first frame update
    void Start()
    {
       // descriptionText.text = tasks[0].description;
     //   rewardText.text = tasks[0].reward.ToString();
      //  currentamountText.text = tasks[0].currentAmount.ToString();
        tasks[0].CurrentStatus = Task.TaskStatus.Open;
        tasks[1].CurrentStatus = Task.TaskStatus.Open;
        tasks[2].CurrentStatus = Task.TaskStatus.Open;
        tasks[3].CurrentStatus = Task.TaskStatus.Open;

    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void Method()
    {
        if (tasks[0].CurrentStatus == Task.TaskStatus.Open)
        {
            tasks[0].ItemsCollected();
            if (tasks[0].isReached())
            {
                tasks[0].TaskCompleted();
                Debug.Log("Task has been completed");
                rewarding+= tasks[0].reward;
             //   rewardText.text = rewarding.ToString();
                tasks[0].reward = rewarding;
                Debug.Log("You have been rewarded");
                Debug.Log("You have finished a task");
            }
        }
    }

    public void Bookmisplaced()
    {
        if(tasks[0].CurrentStatus==Task.TaskStatus.Open)
        {
            tasks[0].ItemsDisposed();
            Debug.Log("is working");
        }
    }

    public void Platemisplaced()
    {
        if (tasks[1].CurrentStatus == Task.TaskStatus.Open)
        {
            tasks[1].ItemsDisposed();
            Debug.Log("is working");
        }
    }
    public void Toymisplaced()
    {
        if (tasks[2].CurrentStatus == Task.TaskStatus.Open)
        {
            tasks[2].ItemsDisposed();
            Debug.Log("is working");
        }
    }

    public void Coatmisplaced()
    {
        if (tasks[3].CurrentStatus == Task.TaskStatus.Open)
        {
            tasks[3].ItemsDisposed();
            Debug.Log("is working");
        }
    }

    public void Method2()
    {
        if(tasks[1].CurrentStatus==Task.TaskStatus.Open)
        {
            tasks[1].ItemsCollected();
            if(tasks[1].isReached())
            {
                tasks[1].TaskCompleted();
                Debug.Log("Second task has been completed");
                rewarding += tasks[1].reward;
                tasks[1].reward = rewarding;
                Debug.Log("You have been rewarded");
                Debug.Log("You have finished the second task");
            }
        }
    }

    public void Method3()
    {
        if (tasks[2].CurrentStatus == Task.TaskStatus.Open)
        {
            tasks[2].ItemsCollected();
            if (tasks[2].isReached())
            {
                tasks[2].TaskCompleted();
                Debug.Log("Third task has been completed");
                rewarding += tasks[2].reward;
                tasks[2].reward = rewarding;
                Debug.Log("You have been rewarded");
                Debug.Log("You have finished the third task");
            }
        }
    }

    public void Method4()
    {
        if (tasks[3].CurrentStatus == Task.TaskStatus.Open)
        {
            tasks[3].ItemsCollected();
            if (tasks[3].isReached())
            {
                tasks[3].TaskCompleted();
                Debug.Log("Third task has been completed");
                rewarding += tasks[3].reward;
                tasks[3].reward = rewarding;
                Debug.Log("You have been rewarded");
                Debug.Log("You have finished the third task");
            }
        }
    }
}
