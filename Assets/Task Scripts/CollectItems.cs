using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CollectItems : Objective
{
public int itemId { get; set; }        


 public CollectItems(Task task,string description,int itemId,bool iscomplete,int currentitemnumber,int requireditemnumber)
    {
        this.Description = description;
        this.itemId = itemId;
        this.Iscomplete = iscomplete;
        this.CurrentItemNumber = currentitemnumber;
        this.RequiredItemNumber = requireditemnumber;
        this.task = task;
       
    }

    public override void Initialise()
    {
        base.Initialise();
        CurrentItemNumber = 0;
    }

   public void ItemPickedUp(Item item)
    {
        if(item.cases==this.itemId)
        {
            Debug.Log("item is collected" + itemId);
            this.CurrentItemNumber++;
            Analyse();

        }
    }
}
