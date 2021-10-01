using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TaskObject : MonoBehaviour
{

    [SerializeField] internal bool IsPickedUp { get; set; }
    [SerializeField] private PlayerController m_playerRef;


    // Update is called once per frame
    void Update()
    {
        if (IsPickedUp)
        {
            transform.position = m_playerRef.transform.position;
            GetComponent<BoxCollider>().enabled = false;
        }
        else
        {
            GetComponent<BoxCollider>().enabled = true;
        }
    }

}
