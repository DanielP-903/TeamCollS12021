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
    private bool m_rotLeft = false;
    private bool m_rotRight = false;
    [SerializeField] private float m_speed;
    [SerializeField] private float m_rotationSpeed;
    [SerializeField] private CharacterController m_characterController;
    private Vector3 m_left = new Vector3(0, 0, 0);
    private readonly Vector3 m_gravity = new Vector3(0, -9.8f, 0);

    // Start is called before the first frame update
    void Start()
    {
        //transform.Rotate(0,20,0);
    }

    // Update is called once per frame
    void Update()
    {
        if (m_moveForward)
        {
            //rb.AddForce(transform.right * m_speed * Time.fixedDeltaTime * 100, ForceMode.Force);
            m_characterController.Move(transform.right * m_speed * Time.deltaTime);
        }
        else if (m_moveBackward)
        {
            //rb.AddForce(-transform.right * m_speed * Time.fixedDeltaTime * 100, ForceMode.Force);
            m_characterController.Move(-transform.right * m_speed * Time.deltaTime);
        }

        m_characterController.Move(m_gravity*Time.deltaTime);
        if (m_rotLeft)
        {
            transform.Rotate(0, -m_rotationSpeed, 0);
        }
        else if (m_rotRight)
        {
            transform.Rotate(0, m_rotationSpeed, 0);
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
    public void Left(InputAction.CallbackContext context)
    {
        float value = context.ReadValue<float>();
        m_rotLeft = value > 0;
        Debug.Log("Forward detected");
    }
    public void Right(InputAction.CallbackContext context)
    {
        float value = context.ReadValue<float>();
        m_rotRight = value > 0;
        Debug.Log("Backward detected");
    }
}
