using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TaskObject : MonoBehaviour
{
    private GameObject m_playerRef;
    private PlayerController m_playerController;
    [SerializeField] internal bool IsPickedUp { get; set; }
    [SerializeField] private float m_offsetZ = 0.0f;

    void Start()
    {
        m_playerRef = GameObject.FindGameObjectWithTag("Player");
        if (!m_playerRef)
        {
            Debug.LogError("ERROR: No object with 'Player' tag assigned!");
            Debug.DebugBreak();
        }

        if (m_playerRef.TryGetComponent(out PlayerController playerController))
        {
            m_playerController = m_playerRef.GetComponent<PlayerController>();
        }
        else
        {
            Debug.LogError("ERROR: Player object does not have a PlayerController component!");
            Debug.DebugBreak();
        }
    }

    // Update is called once per frame
    void Update()
    {
        if (IsPickedUp)
        {
            transform.position = m_playerController.transform.position + (m_offsetZ * m_playerController.transform.right);
            transform.rotation = m_playerController.transform.rotation;
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
