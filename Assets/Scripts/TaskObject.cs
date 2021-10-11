using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TaskObject : MonoBehaviour
{
    private enum Ownership
    {
        Level1,Level2,Level3
    };
    
    private GameObject m_playerRef;
    private PlayerController m_playerController;
    private GameObject m_levelFadeRef;
    private LevelFade m_levelFade;

    [SerializeField] internal bool IsPickedUp { get; set; }
    [SerializeField] private float m_offsetZ = 0.0f;
    [SerializeField] private float m_offsetY = 0.0f;

    [SerializeField] private Ownership m_levelOwnership;


    void Start()
    {
        m_levelFadeRef = GameObject.FindGameObjectWithTag("LevelFade");
        if (!m_levelFadeRef)
        {
            Debug.LogError("ERROR: No object with 'LevelFade' tag assigned!");
            Debug.DebugBreak();
        }
        if (m_levelFadeRef.TryGetComponent(out LevelFade levelFade))
        {
            m_levelFade = m_levelFadeRef.GetComponent<LevelFade>();
        }
        else
        {
            Debug.LogError("ERROR: LevelFade object does not have a LevelFade script component!");
            Debug.DebugBreak();
        }


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
            Debug.LogError("ERROR: Player object does not have a PlayerController script component!");
            Debug.DebugBreak();
        }
    }

    // Update is called once per frame
    void Update()
    {
        if (IsPickedUp)
        {
            transform.position = m_playerController.transform.position + (m_offsetZ * m_playerController.transform.right) + (m_offsetY * m_playerController.transform.up);
            transform.rotation = m_playerController.transform.rotation;
            GetComponent<Rigidbody>().isKinematic = true;
            GetComponent<BoxCollider>().enabled = false;
        }
        else
        {
            GetComponent<Rigidbody>().isKinematic = false;
            GetComponent<BoxCollider>().enabled = true;
        }

        //UpdateProgression();
    }

    void DropObject()
    {
    }

    void OnCollisionStay(Collision collision)
    {
        //if (collision.gameObject.tag == "Interactable")
        //{
        //    if (collision.gameObject == m_heldObjectContainer)
        //    {
        //        Physics.IgnoreCollision(m_heldObjectContainer.GetComponent<Collider>(), GetComponent<Collider>());
        //    }
        //}
    }

    private void UpdateProgression()
    {
        if (transform.position.y < m_levelFade.m_level2Threshold)
        {
            m_levelOwnership = Ownership.Level1;
        }
        else if (transform.position.y >= m_levelFade.m_level2Threshold  &&
                 transform.position.y < m_levelFade.m_level3Threshold)
        {
            m_levelOwnership = Ownership.Level2;
        }
        else if (transform.position.y >= m_levelFade.m_level3Threshold)
        {
            m_levelOwnership = Ownership.Level3;
        }


        switch (m_levelOwnership)
        {
            case Ownership.Level1:
            {
                transform.parent = m_levelFade.m_level1.transform;
                break;
            }
            case Ownership.Level2:
            {
                transform.parent = m_levelFade.m_level2.transform;
                break;
            }
            case Ownership.Level3:
            {
                transform.parent = m_levelFade.m_level3.transform;
                break;
            }
        }
    }
}