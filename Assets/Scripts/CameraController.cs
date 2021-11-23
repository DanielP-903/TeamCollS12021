using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraController : MonoBehaviour
{
    [SerializeField] private GameObject m_player = null;
    [SerializeField] private float m_offset = 10.0f;
    [SerializeField] private float m_cameraMoveThreshold = 0.0f;

    [Header("Start Panning Animation Values")]
    [Tooltip("How long (in seconds) before camera pans away from Bonnie")]
    [SerializeField] private float m_startTimer = 3.0f;
    [Tooltip("Panning out speed")]
    [SerializeField] private float m_speed = 1.0f;
    private Camera m_camera;

    // Start is called before the first frame update
    void Start()
    {
        if (!m_player)
        {
            Debug.LogError("No PlayerController assigned!");
            Debug.Break();
        }
        if (gameObject.TryGetComponent(out Camera cam))
        {
            m_camera = cam;
            m_camera.orthographicSize = 3.0f;
        }
        else
        {
            Debug.LogError("ERROR: Camera object does not have an actual camera on it!");
            Debug.DebugBreak();
        }
        m_startTimer = 3.0f;
    }

    // Update is called once per frame
    void Update()
    {
        if (m_startTimer > 0.0f)
        {
            m_startTimer -= Time.deltaTime;
        }
        else
        {
            m_camera.orthographicSize = Mathf.Lerp(m_camera.orthographicSize, 8.0f, Time.deltaTime / m_speed);
            if (m_camera.orthographicSize > 7.99f)
            {
                m_camera.orthographicSize = 8.0f;
            }
        }
        float playerLerpY = Mathf.Lerp(transform.position.y, m_player.transform.position.y + m_offset + 20.0f, Time.deltaTime);
        float playerLerpX = Mathf.Lerp(transform.position.x, (m_player.transform.position.x - m_offset - 5.0f) / m_cameraMoveThreshold, Time.deltaTime);
        float playerLerpZ = Mathf.Lerp(transform.position.z, (m_player.transform.position.z - m_offset - 20.0f) / m_cameraMoveThreshold, Time.deltaTime);

        Vector3 newPos = new Vector3(playerLerpX, playerLerpY, playerLerpZ);
        transform.position = newPos;
    }
}
