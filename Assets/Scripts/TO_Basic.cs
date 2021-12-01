using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TO_Basic : TaskObject
{
    [SerializeField] bool m_requiresDestination = true;
    [SerializeField] internal GameObject m_destination;
    [SerializeField] internal bool isplaced;
    [SerializeField] private Vector3 m_offsetRotation = new Vector3(0, 90.0f, 0);
    [SerializeField] private Vector3 m_offsetPosition = new Vector3(0, 0, 0);
    public bool m_inDestination = false;
    public bool m_startSleepTimer = false;
    public float m_sleepTimer = 3.0f;

    internal GameObject hungUpCoat;
    public virtual void Awake()
    {
        m_taskSystem = GameObject.FindGameObjectWithTag("TaskSystem").GetComponent<TaskSystem>();
    }

    void Start()
    {
        if (m_requiresDestination)
        {
            if (!m_destination)
            {
                Debug.LogWarning("No Destination object assigned on " + m_type.ToString());
            }
        }
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
            if (transform.parent != m_neckReference.transform)
            {
                transform.rotation = m_neckReference.transform.rotation * Quaternion.Euler(m_offsetRotation);
                transform.position = m_neckReference.transform.position + m_offsetPosition;
                transform.parent = m_neckReference.transform;
            }
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
            transform.parent = null;
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
        if (m_requiresDestination)
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
                        case (Type.Clothes):
                            {
                                m_taskSystem.Complete(7);
                                break;
                            };
                        case (Type.Wood):
                            {
                                m_taskSystem.Complete(9);
                                break;
                            };
                        case (Type.Ledger):
                            {
                                m_taskSystem.Complete(10);
                                break;
                            };
                        case (Type.Soup):
                            {
                                m_taskSystem.Complete(11);
                                break;
                            };
                        case (Type.Newspaper):
                            {
                                m_taskSystem.Complete(17);
                                break;
                            };
                        case (Type.Package):
                            {
                                m_taskSystem.Complete(18);
                                break;
                            };

                        default: break;
                    }
                }
                m_inDestination = true;
                m_startSleepTimer = true;
                isplaced = true;
                m_sleepTimer = 3.0f;
            }
            else
            {
                m_inDestination = false;
                m_startSleepTimer = false;
                isplaced = false;
            }
        }
    }

    void OnTriggerExit(Collider collider)
    {
        if (m_requiresDestination)
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
                else if (m_type == Type.Plate)
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
            }
        }
    }
}
