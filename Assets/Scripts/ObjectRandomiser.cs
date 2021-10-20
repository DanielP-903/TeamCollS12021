using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem.EnhancedTouch;
using UnityEngine.InputSystem;

public class ObjectRandomiser : MonoBehaviour
{
    [SerializeField] private List<GameObject> m_bookSpawnLocations;
    [SerializeField] private List<GameObject> m_plateSpawnLocations;
    [SerializeField] private List<GameObject> m_nessieSpawnLocations;

    [SerializeField] private GameObject m_nessie;
    [SerializeField] private GameObject m_nessieDestination;
    [SerializeField] private GameObject m_book;
    [SerializeField] private GameObject m_plate;

    [SerializeField] private int m_noOfBooks;
    [SerializeField] private int m_noOfPlates;
    [SerializeField] private int m_noOfNessies;

    [SerializeField] private TaskSystem m_taskSystem;

    private List<int> m_chosenNumbers = new List<int>();

    private int m_randomNo;
    private float m_inputTimer = 0.0f;
    private bool m_interact = false;
    // Start is called before the first frame update
    void Start()
    {
        Randomise();
    }

    void Update()
    {
        if (m_inputTimer != 0.0f)
        {
            m_inputTimer -= Time.deltaTime * 2;
            m_inputTimer = m_inputTimer < 0.01f ? 0.0f : m_inputTimer;
        }

        if (m_interact && m_inputTimer == 0.0f)
        {
            m_inputTimer = 0.5f;
            Debug.Log("Randomise!");
            Randomise();
        }
    }

    private void Randomise()
    {

        GameObject[] m_objects = GameObject.FindGameObjectsWithTag("Interactable");
        List<GameObject> m_nessies = new List<GameObject>();
        foreach (var obj in m_objects)
        {
            if (obj.GetComponent<TO_Basic>().m_type == TaskObject.Type.Toy)
            {
                Destroy(obj);
            }
        }


        m_chosenNumbers.Clear();
        UnityEngine.Random.InitState((int)System.DateTime.Now.Ticks);
        bool unique = false;

        for (int i = 0; i < m_noOfNessies; i++)
        {
            unique = false;
            while (!unique)
            {
                m_randomNo = UnityEngine.Random.Range(0, m_nessieSpawnLocations.Count);
                if (!m_chosenNumbers.Contains(m_randomNo))
                {
                    m_chosenNumbers.Add(m_randomNo);
                    unique = true;
                }
            }
        }

        m_nessie.GetComponent<TO_Basic>().tasksystem = m_taskSystem;
        m_nessie.GetComponent<TO_Basic>().m_destination = m_nessieDestination;

        Instantiate(m_nessie, m_nessieSpawnLocations[m_randomNo].transform.position, Quaternion.identity);
        Debug.Log("Spawn Nessie in location " + m_randomNo);
    }

    public void TestRandomise(InputAction.CallbackContext context)
    {
        float button = context.ReadValue<float>();
        m_interact = Math.Abs(button - 1.0f) < 0.1f ? true : false;
        //Debug.Log("Interact detected: " + m_interact);
    }
}
