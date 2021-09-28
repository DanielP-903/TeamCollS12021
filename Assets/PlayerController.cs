using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem.EnhancedTouch;
using UnityEngine.InputSystem;

public class PlayerController : MonoBehaviour
{

    private Vector3 m_move = new Vector3(0,0, 0);

    private bool m_moveForward = false;
    private bool m_moveBackward = false;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        GetComponent<Rigidbody>().AddForce(m_move*Time.deltaTime);
        if (m_moveForward)
        {
            m_move = new Vector3(10,m_move.y,m_move.z);
        }
        if (m_moveBackward)
        {
            m_move = new Vector3(-10, m_move.y, m_move.z);
        }

    }

    public void Forward(InputAction.CallbackContext context)
    {
        float value = context.ReadValue<float>();
        m_moveForward = value > 0;
        Debug.Log("Forward detected");
    }
    public void Backward(InputAction.CallbackContext context)
    {
        float value = context.ReadValue<float>();
        m_moveBackward = value > 0;
        Debug.Log("Backward detected");
    }
}
