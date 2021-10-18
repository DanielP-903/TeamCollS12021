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
    private float m_sleepTimer = 3.0f;
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
        if (m_startSleepTimer)
        {
            m_sleepTimer -= Time.deltaTime;
            Debug.Log("Sleep Timer: " + m_sleepTimer);
            
            if (m_sleepTimer < 0)
            {
                m_startSleepTimer = false;
                isplaced = true;
                GetComponent<Rigidbody>().constraints = RigidbodyConstraints.FreezeAll;
            }
        }
    }

    void OnTriggerEnter(Collider collider)
    {
        if (collider == m_destination.GetComponent<Collider>() && !IsPickedUp)
        {
            if (!isplaced)
            {
                switch (m_type)
                {
                    case (Type.Book):
                        {                
                            tasksystem.Method();
                            break;
                        };
                    case (Type.Plate):
                        {
                            tasksystem.Method2();
                            break;
                        };
                    case (Type.Toy):
                        {
                            tasksystem.Method3();
                            break;
                        };
                    case (Type.Soup):
                        {
                            break;
                        };
                    case (Type.Coat):
                        {
                            tasksystem.Method4();
                            break;
                        };
                    default: break;
                }
                m_inDestination = true;
                m_startSleepTimer = true;
                m_sleepTimer = 3.0f;
            }
            else
            {
                m_inDestination = false;
                m_startSleepTimer = false;
            }
        }
    }

    void OnTriggerExit(Collider collider)
    {
        if (collider == m_destination.GetComponent<Collider>() && !IsPickedUp)
        {
            //if (m_type == Type.Book || m_type == Type.Toy)
            //{
                m_sleepTimer = 3.0f;
                m_startSleepTimer = false;
                isplaced = false;
                m_inDestination = false;
                Debug.Log("OH NO IT FELL OUT");
            //}
        }
    }
}
