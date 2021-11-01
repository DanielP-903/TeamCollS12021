using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TO_Seagulls : TaskObject
{
    [SerializeField] public TaskSystem tasksystem;

    private ParticleSystem m_particleSystem;

    void Start()
    {
        if (!TryGetComponent(out BoxCollider boxCollider))
        {
            Debug.LogError("No Box Collider found!");
            Debug.DebugBreak();
        }
        if (!TryGetComponent(out ParticleSystem particleSystem))
        {
            Debug.LogError("No Particle System found!");
            Debug.DebugBreak();
        }

        m_particleSystem = particleSystem;

        LoadAssets();
    }
    
    void Update()
    {
        GetComponent<BoxCollider>().enabled = m_active;
        if (m_active)
        {
            if (!m_particleSystem.isPlaying)
            {
                GetComponent<ParticleSystem>().Play();
            }

            // AUDIO: Seagulls squawking

            //Debug.Log("active");
            // Emit seagull noises here
        }
        else
        {
            if (m_particleSystem.isPlaying)
            {
                GetComponent<ParticleSystem>().Stop();
            }
        }
    }
    
    public override void Complete()
    {
        m_active = false;
        tasksystem.Method5();
    }
}