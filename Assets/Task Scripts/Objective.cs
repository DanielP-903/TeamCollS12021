using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Objective 
{
  public string Description { get; set; }
    public bool Iscomplete { get; set; }

     public int  CurrentItemNumber { get; set; }
    public int RequiredItemNumber { get; set; }

    public Task task { get; set; }


    public virtual void Initialise()
    {

    }
    public void Analyse()
    {
        if(CurrentItemNumber== RequiredItemNumber)
        {
            TaskCompleted();
        }
    }

    public void TaskCompleted()
    {
        task.checkobjectives();
        Iscomplete = true;
        Debug.Log("task is completed");
    }
}
