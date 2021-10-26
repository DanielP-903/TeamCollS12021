using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TO_Candle : TaskObject
{
    [SerializeField] public TaskSystem tasksystem;
    internal bool Lit { get; set; }

    void Start()
    {
        if (!TryGetComponent(out BoxCollider boxCollider))
        {
            Debug.LogError("No Box Collider found!");
            Debug.DebugBreak();
        }
        LoadAssets();
    }

    void Update()
    {
        GetComponent<BoxCollider>().enabled = m_active;
        if (m_active)
        {
            //Debug.Log("active");
            // Do Candle
        }
    }
    
    public override void Complete()
    {
        m_active = false;
        tasksystem.Method6();
    }
}