using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TO_Basic : TaskObject
{
    [SerializeField] private GameObject m_destination;
    [SerializeField] private bool m_inDestination = false;


    void Start()
    {
        if (!m_destination)
        {
            Debug.LogError("No Destination object assigned!");
            Debug.DebugBreak();
        }

        LoadAssets();
    }

    void Update()
    {
        DetectObject();
    }

    void OnTriggerStay(Collider collider)
    {
        if (collider == m_destination.GetComponent<Collider>() && !IsPickedUp)
        {
            // Update no of books in bookcase here
            Debug.Log("In bookcase!");
            m_inDestination = true;
        }
        else
        {
            m_inDestination = false;
        }
    }
    
}
