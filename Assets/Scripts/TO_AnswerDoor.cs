using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TO_AnswerDoor : TaskObject
{

    // Start is called before the first frame update
    void Start()
    {
        if (!TryGetComponent(out BoxCollider boxCollider))
        {
            Debug.LogError("No Box Collider found!");
            Debug.DebugBreak();
        }

        LoadAssets();
    }

    // Update is called once per frame
    void Update()
    {
        GetComponent<BoxCollider>().enabled = m_active;
        if (m_active)
        {
            //Debug.Log("Ding Dong!");
            // AUDIO: Doorbell sound
        }
    }

    public override void Complete()
    {
        m_active = false;
        m_taskSystem.Complete(6);
    }

    private void RandomiseDoorEvent()
    {

    }

}
