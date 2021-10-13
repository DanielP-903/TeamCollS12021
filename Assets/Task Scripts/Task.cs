using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using System.Linq;

public class Task : MonoBehaviour
{

    public static Task instance;
    public List<Objective> objectives  = new List<Objective>();
    public string TaskName { get; set; }
    public string description { get; set; }
    public bool completed { get; set; }
    public int xp { get; set; }
    // Start is called before the first frame update
    void Awake()
    {
        if (instance != null && instance != this)
        {
            Destroy(this.gameObject);
        }
        else
        {
            instance = this;
            DontDestroyOnLoad(gameObject);
        }
    }

    /* public void DisplayMyList()
     {
         arrayOfItems = listOfItems.ToArray();
         listOfItems.Add("abcd");
         stringOfItems = string.Join("\n", arrayOfItems);
         textOfItems.text = stringOfItems;
     }

     public void Deletelist()
     {
         arrayOfItems = listOfItems.ToArray();
         listOfItems.Remove("abcd");
         stringOfItems = string.Join("\n", arrayOfItems);
         textOfItems.text = stringOfItems;
     }*/

    public void checkobjectives()
    {
        
        completed = objectives.All(o=> o.Iscomplete);
        if(completed)
        {
            GiveReward();
        }
    }

    public void GiveReward()
    {
        xp += 500;
    }
}
