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
    [SerializeField] private TaskObject heldObject;
    private Vector3 m_left = new Vector3(0, 0, 0);
    private readonly Vector3 m_gravity = new Vector3(0, -9.8f, 0);

    // Update is called once per frame
    void Update()
    {
        if (m_moveForward)
        {
            m_characterController.Move(transform.right * m_speed * Time.deltaTime);
        }
        else if (m_moveBackward)
        {
            m_characterController.Move(-transform.right * (m_speed/2) * Time.deltaTime);
            if (heldObject)
            {
                heldObject.IsPickedUp = false;
                heldObject = null;
            }
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

    // Input Actions
    // W
    public void Forward(InputAction.CallbackContext context)
    {
        float value = context.ReadValue<float>();
        m_moveForward = value > 0;
        Debug.Log("Forward detected");
    }
    // S
    public void Backward(InputAction.CallbackContext context)
    {
        float value = context.ReadValue<float>();
        m_moveBackward = value > 0;
        Debug.Log("Backward detected");
    }
    // A
    public void Left(InputAction.CallbackContext context)
    {
        float value = context.ReadValue<float>();
        m_rotLeft = value > 0;
        Debug.Log("Forward detected");
    }
    // D
    public void Right(InputAction.CallbackContext context)
    {
        float value = context.ReadValue<float>();
        m_rotRight = value > 0;
        Debug.Log("Backward detected");
    }

    // Pick-up
    void OnTriggerEnter(Collider other)
    {
        if (other.GetComponent<TaskObject>())
        {
            other.GetComponent<TaskObject>().IsPickedUp = true;
            heldObject = other.GetComponent<TaskObject>();
        }

    }
}
