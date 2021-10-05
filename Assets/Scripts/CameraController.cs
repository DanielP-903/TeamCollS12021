using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraController : MonoBehaviour
{
    [SerializeField] private GameObject m_player = null;
    [SerializeField] private float offset = 10.0f;
    // Start is called before the first frame update
    void Start()
    {
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
        Vector3 newPos = new Vector3(transform.position.x, playerLerpY, transform.position.z);
        //if ((m_player.transform.position.y + offset) - transform.position.y > -0.05f && (m_player.transform.position.y + offset) - transform.position.y < 0.05f)
        //{
        //    newPos = new Vector3(newPos.x, m_player.transform.position.y + offset, newPos.z);   
        //}
        transform.position = newPos;
    }
}
