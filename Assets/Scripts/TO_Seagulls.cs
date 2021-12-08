using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TO_Seagulls : TaskObject
{

    private ParticleSystem m_particleSystem;

    private GameObject conveyance;
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
        conveyance = gameObject.transform.GetChild(0).gameObject;

        m_particleSystem = particleSystem;

        LoadAssets();
        conveyance.SetActive(false);
    }

    void Update()
    {
        GetComponent<BoxCollider>().enabled = m_active;
        if (m_active)
        {
            if (!m_particleSystem.isPlaying)
            {
                GetComponent<ParticleSystem>().Play();
                GetComponent<AudioSource>().Play();
                conveyance.SetActive(true);
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
                GetComponent<AudioSource>().Stop();
                conveyance.SetActive(false);
            }
        }
    }
    
    public override void Complete()
    {
        m_active = false;
        m_taskSystem.Complete(4);
    }
}