using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LevelFade : MonoBehaviour
{
    [SerializeField] internal GameObject m_level1;
    [SerializeField] internal float m_level2Threshold;
    [SerializeField] internal GameObject m_level2;
    [SerializeField] internal float m_level3Threshold;
    [SerializeField] internal GameObject m_level3;
    private GameObject m_player;
    // Start is called before the first frame update
    void Start()
    {
        if (!m_level1 || !m_level2 || !m_level3)
        {
            Debug.LogError("ERROR: Level objects have not been assigned!");
            Debug.DebugBreak();
        }
        //m_level1.SetActive(true);
        //m_level2.SetActive(false);
        //m_level3.SetActive(false);
        foreach (var meshRenderer in m_level2.GetComponentsInChildren<MeshRenderer>())
        {
            meshRenderer.enabled = false;
        }
        foreach (var meshRenderer in m_level3.GetComponentsInChildren<MeshRenderer>())
        {
            meshRenderer.enabled = false;
        }
        m_player = GameObject.FindGameObjectWithTag("Player");
        if (!m_player)
        {
            Debug.LogError("ERROR: No object with 'Player' tag assigned!");
            Debug.DebugBreak();
        }
    }

    // Update is called once per frame
    void Update()
    {
        //m_level2.SetActive(m_player.transform.position.y > m_level2Threshold);
        //m_level3.SetActive(m_player.transform.position.y > m_level3Threshold);

        if (m_player.transform.position.y < m_level2Threshold)
        {
            foreach (var meshRenderer in m_level2.GetComponentsInChildren<MeshRenderer>())
            {
                meshRenderer.enabled = false;
            }
            foreach (var meshRenderer in m_level3.GetComponentsInChildren<MeshRenderer>())
            {
                meshRenderer.enabled = false;
            }
        }
        else
        {
            foreach (var meshRenderer in m_level2.GetComponentsInChildren<MeshRenderer>())
            {
                meshRenderer.enabled = true;
            }
            //foreach (var meshRenderer in m_level3.GetComponentsInChildren<MeshRenderer>())
            //{
            //    meshRenderer.enabled = true;
            //}
        }

    }
}
