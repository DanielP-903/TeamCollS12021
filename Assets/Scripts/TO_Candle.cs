using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TO_Candle : TaskObject
{
    private ParticleSystem m_particleSystem;
    internal bool Lit { get; set; }

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

        LoadAssets();

        m_particleSystem = particleSystem;
        m_particleSystem.Stop();

    }

    void Update()
    {
        GetComponent<BoxCollider>().enabled = m_active;
        if (m_active)
        {

            Debug.Log("active");
            // Do Candle

            // AUDIO: Flame flicker noise (?)
        }
    }
    
    public override void Complete()
    {
        m_active = false;
        m_taskSystem.Method6();
    }
}