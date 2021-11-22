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
        for (int i = 0; i < tasks.Count; i++)
        {
            tasks[i].CurrentStatus = Task.TaskStatus.Open;
        }
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

    public void Complete(int no)
    {
        if(tasks[no].CurrentStatus==Task.TaskStatus.Open)
        {
            tasks[no].ItemsCollected();
            if(tasks[no].isReached())
            {
                tasks[no].TaskCompleted();
                SoundManager.PlayUifx(harpsound, harpvolume);
                taskvalue++;
                PlayerPrefs.SetInt("Score", taskvalue);
            }
        }
    }
}
