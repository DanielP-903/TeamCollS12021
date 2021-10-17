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
        //    currentamountText.text = tasks[0].currentAmount.ToString();
            if (tasks[0].isReached())
            {
                tasks[0].TaskCompleted();
                Debug.Log("Task has been completed");
                rewarding = 450;
                rewarding+= tasks[0].reward;
             //   rewardText.text = rewarding.ToString();
                tasks[0].reward = rewarding;
                Debug.Log("You have been rewarded");
                Debug.Log("You have finished a task");
            }
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
                rewarding = 1000;
                rewarding += tasks[1].reward;
                tasks[1].reward = rewarding;
                Debug.Log("You have been rewarded");
                Debug.Log("You have finished the second task");
            }
        }
    }
}
