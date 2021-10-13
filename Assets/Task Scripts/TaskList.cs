using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class TaskList : Task
{
    public string description2;
    public Text descriptiontext;
    // Start is called before the first frame update
    void Start()
    {
        description2 = "This is my first task";
        descriptiontext.text=description2.ToString();
        objectives.Add(new CollectItems(this,"collector", 0, false, 0, 5));

        objectives.ForEach(o => o.Initialise());
    }
}
