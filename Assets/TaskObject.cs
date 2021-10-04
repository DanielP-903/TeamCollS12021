using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TaskObject : MonoBehaviour
{

    [SerializeField] internal bool IsPickedUp { get; set; }
    [SerializeField] private PlayerController m_playerRef;
    [SerializeField] private float m_offsetZ;


    // Update is called once per frame
    void Update()
    {
        if (IsPickedUp)
        {
            transform.position = m_playerRef.transform.position + (m_offsetZ * m_playerRef.transform.right);
            transform.rotation = m_playerRef.transform.rotation;
            GetComponent<Rigidbody>().isKinematic = true;
            GetComponent<BoxCollider>().enabled = false;
        }
        else
        {
            GetComponent<Rigidbody>().isKinematic = false;
            GetComponent<BoxCollider>().enabled = true;
        }
    }

}
