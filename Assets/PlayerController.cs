using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem.EnhancedTouch;
using UnityEngine.InputSystem;

public class PlayerController : MonoBehaviour
{
    private bool m_moveForward = false;
    private bool m_moveBackward = false;
    private bool m_rotLeft = false;
    private bool m_rotRight = false;
    private bool m_interact = false;
    private float inputTimer = 0.0f;
    private Vector3 m_addedVelocity = new Vector3(0,0,1);
    [SerializeField] private float m_timeBetweenInputs;
    [SerializeField] private float m_speed;
    [SerializeField] private float m_rotationSpeed;
    [SerializeField] private CharacterController m_characterController;
    [SerializeField] private GameObject heldObjectContainer;
    private TaskObject heldObject;
    private Vector3 m_left = new Vector3(0, 0, 0);
    private readonly Vector3 m_gravity = new Vector3(0, -9.8f, 0);

    void Start()
    {
    }

    // Update is called once per frame
    void Update()
    {
        //Debug.Log(inputTimer);

        if (m_moveForward || m_moveBackward)
        {
            Vector3 move = m_moveForward ? (transform.right * m_speed * Time.deltaTime) : (-transform.right * (m_speed / 2) * Time.deltaTime);
            m_characterController.Move(move);
        }

        if (inputTimer != 0.0f)
        {
            inputTimer -= Time.deltaTime * 2;
            inputTimer = inputTimer < 0.01f ? 0.0f : inputTimer;
        }

        if (inputTimer == 0.0f && heldObject)
        {
            if (m_interact)
            {
                heldObject.IsPickedUp = false;
                heldObjectContainer.GetComponent<Rigidbody>().velocity = m_characterController.velocity;
                heldObject = null;
                heldObjectContainer = null;
                GetComponent<BoxCollider>().enabled = true;
                inputTimer = m_timeBetweenInputs;
            }
        }

        m_characterController.Move(m_gravity * Time.deltaTime);

        if (m_rotLeft || m_rotRight)
        {
            float multiplier = m_rotLeft ? -1 : 1;
            transform.Rotate(0, m_rotationSpeed * multiplier, 0);
        }

    }

    // Input Actions
    // W
    public void Forward(InputAction.CallbackContext context)
    {
        float value = context.ReadValue<float>();
        m_moveForward = value > 0;
        //Debug.Log("Forward detected");
    }
    // S
    public void Backward(InputAction.CallbackContext context)
    {
        float value = context.ReadValue<float>();
        m_moveBackward = value > 0;
        //Debug.Log("Backward detected");
    }
    // A
    public void Left(InputAction.CallbackContext context)
    {
        float value = context.ReadValue<float>();
        m_rotLeft = value > 0;
        //Debug.Log("Forward detected");
    }
    // D
    public void Right(InputAction.CallbackContext context)
    {
        float value = context.ReadValue<float>();
        m_rotRight = value > 0;
        //Debug.Log("Backward detected");
    }
    // E or Space
    public void Interact(InputAction.CallbackContext context)
    {
        float button = context.ReadValue<float>();
        m_interact = button == 1 ? true : false;
        //Debug.Log("Interact detected: " + m_interact);
    }

    // Pick-up
    void OnTriggerStay(Collider other)
    {
        if (m_interact && inputTimer == 0.0f)
        {
            if (other.GetComponent<TaskObject>() && heldObject == null)
            {
                other.GetComponent<TaskObject>().IsPickedUp = true;
                GetComponent<BoxCollider>().enabled = false;
                heldObject = other.GetComponent<TaskObject>();
                heldObjectContainer = other.gameObject;
                inputTimer = m_timeBetweenInputs;
                Debug.Log("Detected!");
            }
        }
    }
}
