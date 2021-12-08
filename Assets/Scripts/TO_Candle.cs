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

        Lit = false;
    }

    void Update()
    {
        GetComponent<BoxCollider>().enabled = m_active;
        if (Lit)
        {
            m_active = false;
            if (m_levelFadeRef.GetComponent<LevelFade>().currentLevel == ((int)m_levelOwnership))
            {
                if (m_particleSystem.isPlaying == false)
                {
                    m_particleSystem.Clear();
                    m_particleSystem.Play();
                }
            }
            else
            {
                if (m_particleSystem.isPlaying == true)
                {
                    m_particleSystem.Stop();
                }
            }
        }
        if (m_active)
        {
            
            //Debug.Log("active");
            // Do Candle

            // AUDIO: Flame flicker noise (?)
        }
    }
    
    public override void Complete()
    {
        m_active = false;
        m_taskSystem.Complete(5);
        Lit = true;
    }
}