using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TO_Seagulls : TaskObject
{
    [SerializeField] public TaskSystem tasksystem;
    private bool m_active = false;

    void Start()
    {
        if (!TryGetComponent(out BoxCollider boxCollider))
        {
            Debug.LogWarning("No Box Collider found!");
            Debug.DebugBreak();
        }
        LoadAssets();
    }

    void Update()
    {
        GetComponent<BoxCollider>().enabled = m_active;
        if (m_active)
        {
            // Emit seagull noises here
        }
    }
    
    public void Complete()
    {
        m_active = false;
        tasksystem.Method5();
    }
}
