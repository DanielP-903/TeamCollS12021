using System;
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
    private float m_inputTimer = 0.0f;

    [SerializeField] private float m_velocityScale;
    [SerializeField] private float m_speed;
    [SerializeField] private float m_rotationSpeed;
    [SerializeField] private float m_timeBetweenInputs;

    private readonly  Vector3 m_gravity=new Vector3(0,-9.8f,0);
    private CharacterController m_characterController;
    [SerializeField] private GameObject m_heldObjectContainer;
    [SerializeField] private TaskObject m_heldObject;
    //[SerializeField] private bool isgrounded;
    public float velocity;
    public float fallforce;
    private Animator m_animator;
    private bool m_hasReceivedInput = false;
    private float m_noInputTimer = 0.0f;

    void Start()
    {
        if (transform.parent.gameObject.TryGetComponent(out CharacterController charController))
        {
            m_characterController = charController;
        }
        else
        {
            Debug.LogError("ERROR: Player has no CharacterController component!");
            Debug.DebugBreak();
        }

        if (gameObject.GetComponentInChildren<Animator>()) 
        {
            m_animator = gameObject.GetComponentInChildren<Animator>();
        }
        else
        {
            Debug.LogError("ERROR: Skeletal mesh has no Animator component!");
            Debug.DebugBreak();
        }
    }

    //void GroundUpdater()
    //{
    //    isgrounded = false;
    //    RaycastHit[] hit;
    //    hit = Physics.RaycastAll(transform.position, Vector3.down, 0.8f);
    //    foreach (var hits in hit)
    //    {
    //        Debug.DrawRay(hits.point, hits.normal, Color.red, 0.8f);
    //        if (hits.collider.gameObject == gameObject)
    //            continue;
    //        else if (hits.collider.CompareTag("Ground"))
    //        {
    //            isgrounded = true;
    //        }
    //    }     
    //}

    void FixedUpdate()
    {
        //GroundUpdater();
    }

    // Update is called once per frame
    void Update()
    {
        m_hasReceivedInput = false;
        if (m_moveForward || m_moveBackward)
        {
            Vector3 move = m_moveForward ? (transform.forward * m_speed * Time.deltaTime) : (-transform.forward * (m_speed / 2) * Time.deltaTime);
            m_characterController.Move(move);
            m_animator.SetBool("IsWalking", true);
            m_hasReceivedInput = true;

            // AUDIO: Footstep audio?

        }
        else
        {
            m_animator.SetBool("IsWalking", false);
        }

        if (m_inputTimer != 0.0f)
        {
            m_inputTimer -= Time.deltaTime * 2;
            m_inputTimer = m_inputTimer < 0.01f ? 0.0f : m_inputTimer;
        }

        if (m_inputTimer == 0.0f && m_heldObject)
        {
            if (m_interact)
            {
                m_heldObject.IsPickedUp = false;
                m_heldObjectContainer.GetComponent<Rigidbody>().velocity = (m_characterController.velocity + (Vector3.up*2)) * m_velocityScale;
                m_heldObject = null;
                m_heldObjectContainer = null;
                GetComponent<BoxCollider>().enabled = true;
                m_inputTimer = m_timeBetweenInputs;
                m_hasReceivedInput = true;
            }
        }

        m_characterController.Move(m_gravity*Time.deltaTime);
 
    

        if (m_rotLeft || m_rotRight)
        {
            float multiplier = m_rotLeft ? -1 : 1;
            transform.Rotate(0, m_rotationSpeed * multiplier * Time.deltaTime * 200.0f, 0);
            m_hasReceivedInput = true;
        }


        if (!m_hasReceivedInput)
        {
            m_noInputTimer -= Time.deltaTime;
            if (m_noInputTimer <= 0.0f)
            {
                m_noInputTimer = 0.0f;
                m_animator.SetBool("IsSitting", true);
            }
        }
        else
        {
            m_animator.SetBool("IsSitting", false);
            m_noInputTimer = 1.0f;
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
        m_interact = Math.Abs(button - 1.0f) < 0.1f ? true : false;
        //Debug.Log("Interact detected: " + m_interact);
    }


    // Pick-up
    void OnTriggerStay(Collider other)
    {
        if (m_interact && m_inputTimer == 0.0f)
        {
            if (other.GetComponent<TO_Basic>())
            {
                if (m_heldObject == null && !other.GetComponent<TO_Basic>().m_inDestination)
                {
                    other.GetComponent<TaskObject>().IsPickedUp = true;
                    m_heldObject = other.GetComponent<TaskObject>();
                    m_heldObjectContainer = other.gameObject;
                    m_inputTimer = m_timeBetweenInputs;
                    if (other.tag == "Interactable")
                    {
                        GetComponent<BoxCollider>().enabled = false;
                        // AUDIO: Pickup
                    }
                    else if (other.tag == "Match")
                    {
                        GetComponent<BoxCollider>().enabled = true;
                        // AUDIO: Light match
                    }
                }

            }
            else if (other.tag == "Seagull" && m_heldObject == null)
            {
                other.GetComponent<TO_Seagulls>().Complete();
                Debug.Log("I am interacting with the seagull trigger :)");

                // AUDIO: Bark

            }
        }

        if (m_heldObject != null)
        {
            if (other.tag == "Candle" && m_heldObject.gameObject.tag == "Match")
            {
                other.GetComponent<TO_Candle>().Complete();
                if (!other.GetComponent<ParticleSystem>().isPlaying)
                {
                    other.GetComponent<ParticleSystem>().Play();
                }

                other.GetComponent<Light>().enabled = true;
                
                Debug.Log("I am interacting with the candle trigger :)");

                // AUDIO: Light candle

            }
        }
    }
}
