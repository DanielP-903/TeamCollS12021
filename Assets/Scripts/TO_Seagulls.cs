using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TO_Seagulls : TaskObject
{
    [SerializeField] public TaskSystem tasksystem;

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
            Debug.Log("active");
            // Emit seagull noises here
        }
    }
    
    public override void Complete()
    {
        m_active = false;
        tasksystem.Method5();
    }

}
