using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TO_Basic : TaskObject
{
    [SerializeField] bool m_requiresDestination = true;
    [SerializeField] internal GameObject m_destination;
    public bool m_inDestination = false;
    [SerializeField] public bool isplaced;
    public bool m_startSleepTimer = false;
    public float m_sleepTimer = 3.0f;

    [SerializeField] private float m_offsetZ = 0.0f;
    [SerializeField] private float m_offsetY = 0.0f;
    [SerializeField] private float m_offsetX = 0.0f;
    [SerializeField] private Vector3 m_offsetRotation = new Vector3(0, 90.0f, 0);

    void Start()
    {
        if (m_requiresDestination)
        {
            if (!m_destination)
            {
                Debug.LogWarning("No Destination object assigned!");
            }
        }
        m_taskSystem = GameObject.FindGameObjectWithTag("TaskSystem").GetComponent<TaskSystem>();
        LoadAssets();
    }

    void Update()
    {
        DetectObject();
        if (m_startSleepTimer)
        {
            m_sleepTimer -= Time.deltaTime;
            //Debug.Log("Sleep Timer: " + m_sleepTimer);

            if (m_sleepTimer < 0)
            {
                m_startSleepTimer = false;
                isplaced = true;
                GetComponent<Rigidbody>().constraints = RigidbodyConstraints.FreezeAll;
            }
        }
    }

    protected void DetectObject()
    {
        if (IsPickedUp)
        {
            transform.position = m_playerController.transform.position + (m_offsetZ * m_playerController.transform.forward) + (m_offsetY * m_playerController.transform.up) + (m_offsetX * m_playerController.transform.right);
            transform.rotation = m_playerController.transform.rotation * Quaternion.Euler(m_offsetRotation);
            GetComponent<Rigidbody>().isKinematic = true;
            if (TryGetComponent(out BoxCollider box))
            {
                GetComponent<BoxCollider>().enabled = false;
            }
            else if (TryGetComponent(out MeshCollider mesh))
            {
                GetComponent<MeshCollider>().enabled = false;
            }
            else
            {
                GetComponentInChildren<MeshCollider>().enabled = false;
            }
        }
        else
        {
            GetComponent<Rigidbody>().isKinematic = false;
            if (TryGetComponent(out BoxCollider box))
            {
                GetComponent<BoxCollider>().enabled = true;
            }
            else if (TryGetComponent(out MeshCollider mesh))
            {
                GetComponent<MeshCollider>().enabled = true;
            }
            else
            {
                GetComponentInChildren<MeshCollider>().enabled = true;
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
                            m_taskSystem.Complete(0);
                            break;
                        };
                    case (Type.Plate):
                        {
                            m_taskSystem.Complete(1);
                            break;
                        };
                    case (Type.Toy):
                        {
                            m_taskSystem.Complete(2);
                            break;
                        };
                    case (Type.Soup):
                        {
                            break;
                        };
                    case (Type.Coat):
                        {
                            m_taskSystem.Complete(3);
                            break;
                        };
                    default: break;
                }
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

    void OnTriggerExit(Collider collider)
    {
        if (collider == m_destination.GetComponent<Collider>() && !IsPickedUp)
        {
            if (m_type == Type.Book)
            {
                m_taskSystem.Bookmisplaced();
                m_sleepTimer = 3.0f;
                m_startSleepTimer = false;
                isplaced = false;
                m_inDestination = false;
                Debug.Log("OH NO IT FELL OUT");
            }
            else if(m_type==Type.Plate)
            {
                m_taskSystem.Platemisplaced();
                m_sleepTimer = 3.0f;
                m_startSleepTimer = false;
                isplaced = false;
                m_inDestination = false;
                Debug.Log("OH NO IT FELL OUT");
            }
            else if (m_type == Type.Toy)
            {
                m_taskSystem.Toymisplaced();
                m_sleepTimer = 3.0f;
                m_startSleepTimer = false;
                isplaced = false;
                m_inDestination = false;
                Debug.Log("OH NO IT FELL OUT");
            }
            else if (m_type == Type.Coat)
            {
                m_taskSystem.Coatmisplaced();
                m_sleepTimer = 3.0f;
                m_startSleepTimer = false;
                isplaced = false;
                m_inDestination = false;
                Debug.Log("OH NO IT FELL OUT");
            }
        }

    }
}
