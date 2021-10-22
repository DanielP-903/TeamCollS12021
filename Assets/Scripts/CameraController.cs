using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraController : MonoBehaviour
{
    [SerializeField] private GameObject m_player = null;
    [SerializeField] private float offset = 10.0f;
    [SerializeField] private float m_cameraMoveThreshold = 0.0f;

    private Vector3 m_centre;
    // Start is called before the first frame update
    void Start()
    {
        m_centre = transform.position;
        if (!m_player)
        {
            Debug.LogError("No PlayerController assigned!");
            Debug.Break();
        }
    }

    // Update is called once per frame
    void Update()
    {
        float playerLerpY = Mathf.Lerp(transform.position.y, m_player.transform.position.y + offset, Time.deltaTime);
        float playerLerpX = m_centre.x;
        float playerLerpZ = m_centre.z; 
        
        //if (Mathf.Abs(m_player.transform.position.x - m_centre.x) > m_cameraMoveThreshold)
        //{
        //    playerLerpX = Mathf.Lerp(m_centre.x, m_player.transform.position.x, Time.deltaTime);
        //}

        playerLerpX = Mathf.Lerp(transform.position.x, (m_player.transform.position.x - offset) / 2, Time.deltaTime);
        playerLerpZ = Mathf.Lerp(transform.position.z, (m_player.transform.position.z - offset) / 2, Time.deltaTime);

        //if (playerLerpX < -m_cameraMoveThreshold + 5.0f)
        //{
        //    playerLerpX = -m_cameraMoveThreshold + 5.0f;
        //}
        //else if (playerLerpX < -m_cameraMoveThreshold)
        //{
        //    playerLerpX = -m_cameraMoveThreshold;
        //}
        //if (playerLerpZ < -m_cameraMoveThreshold + 5.0f)
        //{
        //    playerLerpZ = -m_cameraMoveThreshold + 5.0f;
        //}
        //else if (playerLerpZ < -m_cameraMoveThreshold)
        //{
        //    playerLerpZ = -m_cameraMoveThreshold;
        //}
        //playerLerpX = Mathf.Lerp(playerLerpX, m_centre.x, Time.deltaTime);
        //if (playerLerpX < m_centre.x + 0.1f && playerLerpX > m_centre.x - 0.1f)
        //{
        //    playerLerpX = m_centre.x;
        //}
        //if (Mathf.Abs(m_player.transform.position.z - m_centre.z) > m_cameraMoveThreshold)
        //{
        //    playerLerpZ = Mathf.Lerp(m_centre.z, m_player.transform.position.z, Time.deltaTime);
        //}

        Vector3 newPos = new Vector3(playerLerpX, playerLerpY, playerLerpZ);
        transform.position = newPos;
    }
}
