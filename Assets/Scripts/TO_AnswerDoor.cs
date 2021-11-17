using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TO_AnswerDoor : TaskObject
{
    [SerializeField] private List<TaskObject> m_potentialTaskObjects = new List<TaskObject>();
    [SerializeField] private List<Task> m_potentialTasks = new List<Task>();

    // Start is called before the first frame update
    void Start()
    {
        if (!TryGetComponent(out BoxCollider boxCollider))
        {
            Debug.LogError("No Box Collider found!");
            Debug.DebugBreak();
        }

        for (int i = 0; i < m_potentialTaskObjects.Count; i++)
        {
            m_potentialTaskObjects[i].gameObject.SetActive(false);
            m_potentialTaskObjects[i].m_active = false;
        }
        for (int i = 0; i < m_potentialTasks.Count; i++)
        {
            m_potentialTasks[i].gameObject.SetActive(false);
            m_potentialTasks[i].enabled = false;
            m_potentialTasks[i].m_uiObjectRef.SetActive(false);

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
        RandomiseDoorEvent();
    }

    private void RandomiseDoorEvent()
    {
        UnityEngine.Random.InitState((int)System.DateTime.Now.Ticks);
        int randomNo = UnityEngine.Random.Range(0, m_potentialTaskObjects.Count);
        m_potentialTaskObjects[randomNo].gameObject.SetActive(true);
        m_potentialTaskObjects[randomNo].m_active = true;
        m_potentialTasks[randomNo].gameObject.SetActive(true);
        m_potentialTasks[randomNo].enabled = true;
        m_potentialTasks[randomNo].m_uiObjectRef.SetActive(true);

        Debug.Log("Added task " + randomNo);
    }

}
