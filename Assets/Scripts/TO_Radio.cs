using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TO_Radio : TaskObject
{
    private DayAndNightCycle m_dayNightCycleRef;
    private ParticleSystem m_particleSystem;
    void Start()
    {
        m_dayNightCycleRef = GameObject.FindGameObjectWithTag("DayNight Cycle").GetComponent<DayAndNightCycle>();
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

        m_active = true;
    }

    void Update()
    {
        GetComponent<BoxCollider>().enabled = m_active;
        if (m_active)
        {

            if(m_levelFadeRef.GetComponent<LevelFade>().currentLevel == 2)
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
    }

    public override void Complete()
    {
        m_active = false;
        m_particleSystem.Stop();
        Debug.Log("Checked Radio!");
        m_taskSystem.Complete(13);
        //m_dayNightCycleRef.time = 2.0f;
    }
}
