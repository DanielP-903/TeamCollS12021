using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ActivateTasks : MonoBehaviour
{

    [SerializeField]
    private GameObject tasks;

    [SerializeField]
    private string taskType;
    private Task task { get; set; }
    // Start is called before the first frame update
    void Start()
    {
        task = (Task)tasks.AddComponent(System.Type.GetType(taskType));
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
