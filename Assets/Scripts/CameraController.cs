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
        float playerLerpX = Mathf.Lerp(transform.position.x, (m_player.transform.position.x - offset) / m_cameraMoveThreshold, Time.deltaTime);
        float playerLerpZ = Mathf.Lerp(transform.position.z, (m_player.transform.position.z - offset) / m_cameraMoveThreshold, Time.deltaTime);

        Vector3 newPos = new Vector3(playerLerpX, playerLerpY, playerLerpZ);
        transform.position = newPos;
    }
}
