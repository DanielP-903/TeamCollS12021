using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TO_Basic : TaskObject
{
    [SerializeField] private GameObject m_destination;
    public bool m_inDestination = false;
    [SerializeField] public TaskSystem tasksystem;
    [SerializeField] public bool isplaced;
    private bool m_startSleepTimer = false;

    void Start()
    {
        if (!m_destination)
        {
            Debug.LogWarning("No Destination object assigned!");
        }

        LoadAssets();
    }

    void Update()
    {
        DetectObject();
        //if (m_startSleepTimer)
        //{

        //}
    }

    void OnTriggerEnter(Collider collider)
    {
        if (collider == m_destination.GetComponent<Collider>() && !IsPickedUp)
        {
            if (m_type == Type.Book)
            {
                if (!isplaced)
                {
                    tasksystem.Method();
                    // Update no of books in bookcase here
                    isplaced = true;
                    Debug.Log("In bookcase!");
                    m_inDestination = true;
                    m_startSleepTimer = true;
                }
                else
                {
                    m_inDestination = false;
                    m_startSleepTimer = false;
                }
            }
        }
    }
}
