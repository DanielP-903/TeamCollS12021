using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TaskObject : MonoBehaviour
{
    private enum Ownership
    {
        Level1,Level2,Level3
    };

    public enum Type
    {
        Default, Book, Plate, Toy, Soup, Coat, Clothes, Ledger, Wood, Tape, Newspaper, Package, Other
    };

    private GameObject m_playerRef;
    internal PlayerController m_playerController;
    internal GameObject m_levelFadeRef;
    private LevelFade m_levelFade;
    internal TaskSystem m_taskSystem;

    [SerializeField] internal bool IsPickedUp { get; set; }

    [SerializeField] private Ownership m_levelOwnership;
    [SerializeField] internal Type m_type;

    internal GameObject m_neckReference;

    public bool m_active = false;

    void Start()
    {

        LoadAssets();
    }

    public virtual void Complete()
    {
        // nothing for now...
    }

    protected void LoadAssets()
    {
        m_neckReference = GameObject.FindGameObjectWithTag("Player Neck");

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
            m_playerController = playerController;
        }
        else
        {
            Debug.LogError("ERROR: Player object does not have a PlayerController script component!");
            Debug.DebugBreak();
        }


        GameObject tSys = GameObject.FindGameObjectWithTag("TaskSystem");
        if (!tSys)
        {
            Debug.LogError("ERROR: No object with 'TaskSystem' tag assigned!");
            Debug.DebugBreak();
        }
        if (tSys.TryGetComponent(out TaskSystem taskSystem))
        {
            m_taskSystem = taskSystem;
        }
        else
        {
            Debug.LogError("ERROR: Player object does not have a PlayerController script component!");
            Debug.DebugBreak();
        }

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