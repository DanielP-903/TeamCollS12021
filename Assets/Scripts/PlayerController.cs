using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem.EnhancedTouch;
using UnityEngine.InputSystem;


public enum Day
{
    Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday
};

public enum IdleParams
{
    IsSitting, IsSneezing, IsLooking
};

public class PlayerController : MonoBehaviour
{
    private bool m_moveForward = false;
    private bool m_moveBackward = false;
    private bool m_rotLeft = false;
    private bool m_rotRight = false;
    private bool m_interact = false;
    private bool m_sprint = false;
    private float m_inputTimer = 0.0f;
    private bool m_colliding = false;
    private float m_barkTimer = 0.5f;
    [SerializeField] internal Day currentDay;
    private IdleParams m_idleParams = IdleParams.IsSitting;

    [Header("Player Speed Values")]
    [Tooltip("Velocity scale of thrown objects")]
    [SerializeField] private float m_velocityScale;
    [Tooltip("Base movement speed")]
    [SerializeField] private float m_speed;
    [Tooltip("Sprinting speed")]
    [SerializeField] private float m_sprintSpeed;
    [Tooltip("Base rotation speed")]
    [SerializeField] private float m_rotationSpeed;

    [Header("Player Animation")]
    [Tooltip("How long in seconds until Bonnie goes idle")]
    [SerializeField] private float m_idleInputTime;
    [Tooltip("Idle animation clip list")]
    [SerializeField] private List<AnimationClip> m_idleAnimations;
    //[Header("Tutorial")]
    //[Tooltip("How long in seconds until Bonnie sits down from being idle")]
    //private bool m_moveTutorialComplete = false;
    //private bool m_interactTutorialComplete = false;
    private ParticleSystem m_particleSystemChild;
    private ParticleSystem m_particleSystem;

    [Header("Misc")]
    [Tooltip("Time interval between inputs")]
    [SerializeField] private float m_timeBetweenInputs;

    private float m_interactingTimer = 0.0f;

    private readonly  Vector3 m_gravity = new Vector3(0,-9.8f,0);
    private CharacterController m_characterController;
    private GameObject m_heldObjectContainer;
    private TaskObject m_heldObject;

    private Animator m_animator;
    private bool m_hasReceivedInput = false;
    private float m_noInputTimer = 0.0f;
    private float m_sitWaitTimer = 0.0f;
    private float m_sneezeTimer = 1.0f;
    [Header("Sound Effects")]
    public AudioClip barksound;
    public AudioClip pickupsound;
    public AudioClip dooropensound;
    [Range(0, 1)]
    public float mainvolume;
    public AudioClip lightmatchsound;
    [Range(0, 1)]
    public float lightmatchvolume;

    void Start()
    {

        SoundManager.SoundVolume = mainvolume;
        SoundManager.MatchVolume = lightmatchvolume;
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

        if (gameObject.GetComponentInChildren<ParticleSystem>())
        {
            m_particleSystemChild = gameObject.GetComponentInChildren<ParticleSystem>();
        }
        else
        {
            Debug.LogError("ERROR: Particle System component not found on children!");
            Debug.DebugBreak();
        }

        if (gameObject.GetComponent<ParticleSystem>())
        {
            m_particleSystem = gameObject.GetComponentInChildren<ParticleSystem>();
        }
        else
        {
            Debug.LogError("ERROR: Particle System component not found!");
            Debug.DebugBreak();
        }

    }

    // Update is called once per frame
    void Update()
    {
        // Movement
        m_hasReceivedInput = false;
        if (m_moveForward || m_moveBackward)
        {
            m_animator.SetBool("IsInteracting", false);
            m_interactingTimer = 0.0f;
            float sprint = m_sprint ? m_sprintSpeed : 1.0f;
            Vector3 move = m_moveForward ? (transform.forward * (m_speed * sprint) * Time.deltaTime) : (-transform.forward * (m_speed / 1.5f) * Time.deltaTime);
            m_characterController.Move(move);
            m_hasReceivedInput = true;
            // AUDIO: Footstep audio?
        }

        m_animator.SetBool("IsWalking", m_moveForward || m_moveBackward);
        m_animator.SetBool("IsSprinting", m_sprint && m_moveForward);
        m_animator.SetBool("IsTurningL", m_rotLeft);
        m_animator.SetBool("IsTurningR", m_rotRight);

        if (m_inputTimer != 0.0f)
        {
            m_inputTimer -= Time.deltaTime * 2;
            m_inputTimer = m_inputTimer < 0.01f ? 0.0f : m_inputTimer;
        }

        if (m_inputTimer == 0.0f && m_interact)
        {
            if (m_heldObject)
            {
                m_heldObject.IsPickedUp = false;
                m_heldObjectContainer.GetComponent<Rigidbody>().velocity = (m_characterController.velocity + (Vector3.up * 2)) * m_velocityScale;
                m_heldObject = null;
                m_heldObjectContainer = null;
                GetComponent<BoxCollider>().enabled = true;
                m_inputTimer = m_timeBetweenInputs;
                m_hasReceivedInput = true;
            }
            if (m_colliding)
            {
                m_interactingTimer = 1.625f / 5.0f;
                m_animator.SetBool("IsInteracting", true);

            }
            else
            {
                // bork
                if (m_barkTimer <= 0.0f)
                {
                    SoundManager.PlaySfx(barksound, mainvolume);
                    Debug.Log("Bark!");
                    m_barkTimer = 0.5f;
                
                m_particleSystem.Clear();
                m_particleSystem.Play();
                }
            }
        }
        else
        {
            m_interactingTimer -= Time.deltaTime;
            if (m_interactingTimer <= 0.0f)
            {
                m_animator.SetBool("IsInteracting", false);
            }
        }

        if (m_barkTimer > 0.0f)
        {
            m_barkTimer -= Time.deltaTime;
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
                m_animator.SetBool(m_idleParams.ToString(), true);
                m_sitWaitTimer -= Time.deltaTime;
                if (m_sitWaitTimer <= 0.0f)
                {
                    m_sitWaitTimer = 0.0f;
                    m_animator.SetFloat("SitWait", 0.0f);
                }
                else
                {
                    m_animator.SetFloat("SitWait", 1.0f);
                }
                if (m_idleParams == IdleParams.IsSneezing || m_idleParams == IdleParams.IsLooking) 
                { 
                    m_sneezeTimer -= Time.deltaTime;
                    if (m_sneezeTimer <= 0.0f)
                    {
                        m_sneezeTimer = 0.0f;
                        m_animator.SetBool(m_idleParams.ToString(), false);
                    }
                }
            }
        }
        else
        {
            m_animator.SetBool(m_idleParams.ToString(), false);
            m_animator.SetFloat("SitWait", 1.0f);
            m_noInputTimer = m_idleInputTime;
            m_sitWaitTimer = 1.0f;
            m_sneezeTimer = 1.0f;
            RandomiseAnimation();
        }
    }

    private void RandomiseAnimation()
    {
        UnityEngine.Random.InitState((int)System.DateTime.Now.Ticks);
        int randomNo = UnityEngine.Random.Range(0, m_idleAnimations.Count);
        switch (randomNo)
        {
            case (0):
                {
                    m_idleParams = IdleParams.IsSitting;
                    m_animator.SetBool("IsLooking", false);
                    m_animator.SetBool("IsSneezing", false);
                    break;
                }
            case (1):
                {
                    m_idleParams = IdleParams.IsSneezing;
                    m_animator.SetBool("IsSitting", false);
                    m_animator.SetBool("IsLooking", false);
                    break;
                }
            case (2):
                {
                    m_idleParams = IdleParams.IsLooking;
                    m_animator.SetBool("IsSitting", false);
                    m_animator.SetBool("IsSneezing", false);
                    break;
                }
            default:
                {
                    break;
                }
        }

        //Debug.Log("Params chosen: " + m_idleParams.ToString());
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
       // Debug.Log("Interact detected: " + m_interact);
    }
    // Shift
    public void Sprint(InputAction.CallbackContext context)
    {
        float value = context.ReadValue<float>();
        m_sprint = value > 0;
        //Debug.Log("Sprint detected");
    }

    // Pick-up
    void OnTriggerStay(Collider other)
    {
        // Detect non-barkable objects
        if (other.tag == "Interactable" || other.tag == "Match")
        {
            m_colliding = true;
        }
        if (m_interact && m_inputTimer == 0.0f)
        {
            if (other.tag == "Door" && m_heldObject == null)
            {
                //Debug.Log("Interacting with door :)");
                other.GetComponent<TO_AnswerDoor>().Complete();

            }
            if (other.tag == "End Switch" && m_heldObject == null)
            {
                Debug.Log("Please end the game :)");
                other.GetComponent<TO_EndSwitch>().Complete();

            }

            if (other.tag == "Pillow" && m_heldObject == null)
            {
                Debug.Log("Fluff the pillow");
                other.GetComponent<TO_Pillow>().Complete();

            }
            if (other.tag == "Radio" && m_heldObject == null)
            {
                Debug.Log("Check the radio");
                other.GetComponent<TO_Radio>().Complete();

            }
            if (other.GetComponent<TO_Basic>())
            {
                if (m_heldObject == null && !other.GetComponent<TO_Basic>().isplaced)
                {
                    other.GetComponent<TaskObject>().IsPickedUp = true;
                    m_heldObject = other.GetComponent<TaskObject>();
                    m_heldObjectContainer = other.gameObject;
                    m_inputTimer = m_timeBetweenInputs;
                    if (other.tag == "Interactable")
                    {
                        GetComponent<BoxCollider>().enabled = false;
                        // AUDIO: Pickup 
                        SoundManager.PlaySfx(pickupsound, mainvolume);
                    }
                    else if (other.tag == "Match")
                    {
                        GetComponent<BoxCollider>().enabled = true;
                        // AUDIO: Light match
                        SoundManager.PlayMatchfx(lightmatchsound, lightmatchvolume);
                    }
                }

            }
            else if (other.tag == "Seagull" && m_heldObject == null)
            {
                other.GetComponent<TO_Seagulls>().Complete();
                //Debug.Log("I am interacting with the seagull trigger :)");

                // AUDIO: Bark
                SoundManager.PlaySfx(barksound, mainvolume);
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

               // Debug.Log("I am interacting with the candle trigger :)");

                // AUDIO: Light candle
                SoundManager.PlayMatchfx(lightmatchsound,lightmatchvolume);

            }
            else if (other.tag == "Radio_Tape" && m_heldObject.gameObject.tag == "Tape")
            {
                if (m_heldObject.gameObject.GetComponent<TO_Tape>().m_day == currentDay)
                {
                    Debug.Log("YAY! Right day :)");
                    m_heldObject.gameObject.GetComponent<TO_Tape>().Complete();
                    m_heldObject.gameObject.SetActive(false);
                    m_heldObject.IsPickedUp = false;
                    m_heldObjectContainer.GetComponent<Rigidbody>().velocity = (m_characterController.velocity + (Vector3.up * 2)) * m_velocityScale;
                    m_heldObject = null;
                    m_heldObjectContainer = null;
                    GameObject[] tapes = GameObject.FindGameObjectsWithTag("Tape");
                    
                    for (int i = 0; i < tapes.Length; i++)
                    {
                        if(tapes[i].gameObject.activeInHierarchy == true)
                        {
                            tapes[i].gameObject.GetComponent<Rigidbody>().constraints = RigidbodyConstraints.FreezeAll;
                            tapes[i].gameObject.GetComponent<BoxCollider>().enabled = false;
                        }
                    }


                    GetComponent<BoxCollider>().enabled = true;
                }
                else
                {
                    Debug.Log("Oops! Not the right day :(");
                }
            }
            else if (other.tag == "Hanger" && m_heldObject.gameObject.tag == "Coat")
            {
                m_heldObject.gameObject.GetComponent<TO_Coat>().Complete();
                m_heldObject.gameObject.SetActive(false);
                m_heldObject.IsPickedUp = false;
                m_heldObject = null;
                m_heldObjectContainer = null;
            }
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.tag == "Interactable" || other.tag == "Match")
        {
            m_colliding = false;
        }
    }

    void OnTriggerEnter(Collider other)
    {
       if(other.tag=="Noise")
        {
            other.GetComponent<NoiseTrigger>().PlaySound();
        }
       if(other.tag=="Interactable")
        {
            if(other.GetComponent<TO_Basic>().m_type==TaskObject.Type.Toy)
            {
                other.GetComponent<NoiseTrigger>().PlaySound();
            }
        }
    }
}