using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TO_Book : TaskObject
{
    [SerializeField] private GameObject m_destination;
    [SerializeField] private bool m_isBookInBookcase = false;

    void Update()
    {
        Debug.Log("Book picked up!");
        DetectObject();
    }

    void OnTriggerStay(Collider collider)
    {
        if (collider == m_destination.GetComponent<Collider>() && !IsPickedUp)
        {
            // Update no of books in bookcase here
            Debug.Log("In bookcase!");
            m_isBookInBookcase = true;
        }
        else
        {
            m_isBookInBookcase = false;
        }
    }
    
}
