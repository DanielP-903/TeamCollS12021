using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class TaskSystem : MonoBehaviour
{
    public List<Task> tasks = new List<Task>();

    //public Text descriptionText;
    //public Text currentamountText;
    //public int rewarding;
    public static int taskvalue;
    public AudioClip harpsound;
    public float harpvolume;
    private TaskTabButton taskTabButton;


    // Start is called before the first frame update
    void Start()
    {
        SoundManager.UiVolume = harpvolume;
        // descriptionText.text = tasks[0].description;
        //   rewardText.text = tasks[0].reward.ToString();
        //  currentamountText.text = tasks[0].currentAmount.ToString();
        taskvalue = 0;
        PlayerPrefs.SetInt("Score", taskvalue);
        PlayerPrefs.Save();
        PlayerPrefs.DeleteAll();
        taskTabButton = GameObject.FindObjectOfType<TaskTabButton>();
        for (int i = 0; i < tasks.Count; i++)
        {
            tasks[i].CurrentStatus = Task.TaskStatus.Open;
        }
    }

    void Update()
    {
        if(tasks[0].isComplete)
        {
            if(taskTabButton.panelvalue==2 || taskTabButton.panelvalue==3)
            {
                taskTabButton.glowanim.SetBool("isGlow", true);
            }
            if(taskTabButton.panelvalue==1)
            {
                tasks[0].isComplete = false;
                taskTabButton.glowanim.SetBool("isGlow", false);
            }
        }
        if (tasks[1].isComplete)
        {
            if (taskTabButton.panelvalue == 2 || taskTabButton.panelvalue == 3)
            {
                taskTabButton.glowanim.SetBool("isGlow", true);
            }
            if (taskTabButton.panelvalue == 1)
            {
                tasks[1].isComplete = false;
                taskTabButton.glowanim.SetBool("isGlow", false);
            }
        }
        if (tasks[2].isComplete)
        {
            if (taskTabButton.panelvalue == 2 || taskTabButton.panelvalue == 3)
            {
                taskTabButton.glowanim.SetBool("isGlow", true);
            }
            if (taskTabButton.panelvalue == 1)
            {
                tasks[2].isComplete = false;
                taskTabButton.glowanim.SetBool("isGlow", false);
            }
        }
        if (tasks[7].isComplete)
        {
            if (taskTabButton.panelvalue == 1 || taskTabButton.panelvalue == 3)
            {
                taskTabButton.glowanim2.SetBool("isGlow", true);
            }
            if (taskTabButton.panelvalue == 2)
            {
                tasks[7].isComplete = false;
                taskTabButton.glowanim2.SetBool("isGlow", false);
            }
        }
        if (tasks[8].isComplete)
        {
            if (taskTabButton.panelvalue == 1 || taskTabButton.panelvalue == 3)
            {
                taskTabButton.glowanim2.SetBool("isGlow", true);
            }
            if (taskTabButton.panelvalue == 2)
            {
                tasks[8].isComplete = false;
                taskTabButton.glowanim2.SetBool("isGlow", false);
            }
        }
        if (tasks[9].isComplete)
        {
            if (taskTabButton.panelvalue == 1 || taskTabButton.panelvalue == 3)
            {
                taskTabButton.glowanim2.SetBool("isGlow", true);
            }
            if (taskTabButton.panelvalue == 2)
            {
                tasks[9].isComplete = false;
                taskTabButton.glowanim2.SetBool("isGlow", false);
            }
        }
        if (tasks[10].isComplete)
        {
            if (taskTabButton.panelvalue == 1 || taskTabButton.panelvalue == 3)
            {
                taskTabButton.glowanim2.SetBool("isGlow", true);
            }
            if (taskTabButton.panelvalue == 2)
            {
                tasks[10].isComplete = false;
                taskTabButton.glowanim2.SetBool("isGlow", false);
            }
        }
        if (tasks[12].isComplete)
        {
            if (taskTabButton.panelvalue == 1 || taskTabButton.panelvalue == 2)
            {
                taskTabButton.glowanim.SetBool("isGlow", true);
            }
            if (taskTabButton.panelvalue == 3)
            {
                tasks[12].isComplete = false;
                taskTabButton.glowanim.SetBool("isGlow", false);
            }
        }
        if (tasks[13].isComplete)
        {
            if (taskTabButton.panelvalue == 1 || taskTabButton.panelvalue == 2)
            {
                taskTabButton.glowanim3.SetBool("isGlow", true);
            }
            if (taskTabButton.panelvalue == 3)
            {
                tasks[13].isComplete = false;
                taskTabButton.glowanim3.SetBool("isGlow", false);
            }
        }
        if (tasks[14].isComplete)
        {
            if (taskTabButton.panelvalue == 1 || taskTabButton.panelvalue == 2)
            {
                taskTabButton.glowanim3.SetBool("isGlow", true);
            }
            if (taskTabButton.panelvalue == 3)
            {
                tasks[14].isComplete = false;
                taskTabButton.glowanim3.SetBool("isGlow", false);
            }
        }
        if (tasks[15].isComplete)
        {
            if (taskTabButton.panelvalue == 1 || taskTabButton.panelvalue == 2)
            {
                taskTabButton.glowanim3.SetBool("isGlow", true);
            }
            if (taskTabButton.panelvalue == 3)
            {
                tasks[15].isComplete = false;
                taskTabButton.glowanim3.SetBool("isGlow", false);
            }
        }
    }

    public bool GetTaskCompleted(int no)
    {
        return tasks[no].isComplete;
    }

    public void Method()
    {
        if (tasks[0].CurrentStatus == Task.TaskStatus.Open)
        {
            tasks[0].ItemsCollected();
            if (tasks[0].isReached())
            {
                tasks[0].TaskCompleted();
                taskvalue++;
                Debug.Log("Task has been completed");
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

    public void ItemsMisplaced(int no)
    {
        if (tasks[no].CurrentStatus == Task.TaskStatus.Open)
        {
            tasks[no].ItemsDisposed();
        }
    }




    public void Complete(int no)
    {
        if(tasks[no].CurrentStatus==Task.TaskStatus.Open)
        {
            tasks[no].ItemsCollected();
            if(tasks[no].isReached())
            {
                tasks[no].TaskCompleted();
                tasks[no].isComplete = true;
                SoundManager.PlayUifx(harpsound, harpvolume);
                taskvalue++;
                PlayerPrefs.SetInt("Score", taskvalue);
            }
        }
    }
}
