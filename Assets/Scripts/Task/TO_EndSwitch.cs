using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TO_EndSwitch : TaskObject
{
    private DayAndNightCycle m_dayNightCycleRef;
    [SerializeField] internal Animator m_animator;
    void Start()
    {
        m_dayNightCycleRef = GameObject.FindGameObjectWithTag("DayNight Cycle").GetComponent<DayAndNightCycle>();
        if (!TryGetComponent(out BoxCollider boxCollider))
        {
            Debug.LogError("No Box Collider found!");
            Debug.DebugBreak();
        }

        if (!m_animator)
        {
            Debug.LogError("No Animator assigned!");
            Debug.DebugBreak();
        }
        LoadAssets();
        m_active = true;
    }

    void Update()
    {
        GetComponent<BoxCollider>().enabled = m_active;
        if (m_active)
        {
            // Can end the game
        }
    }

    public override void Complete()
    {
        m_active = false;
        Debug.Log("End Game!");
        m_animator.SetBool("Activate", true);
        m_dayNightCycleRef.time = 1.99f;
    }
}
