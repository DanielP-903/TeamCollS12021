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
    [SerializeField] private GameObject m_bookDestination;
    [SerializeField] private GameObject m_plate;
    [SerializeField] private GameObject m_plateDestination;

    [SerializeField] private GameObject m_playerNeck;

    [SerializeField] private int m_noOfBooks;
    [SerializeField] private int m_noOfPlates;
    [SerializeField] private int m_noOfNessies;

    [SerializeField] private TaskSystem m_taskSystem;

    private List<int> m_chosenNumbers = new List<int>();

    private int m_randomNo;
    private bool m_interact;
    private float m_inputTimer = 0.0f;

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
            Randomise();
        }
    }

    private void DestroyAllInteractables()
    {
        GameObject[] m_gameObjects = GameObject.FindGameObjectsWithTag("Interactable");
        foreach (var obj in m_gameObjects)
        {
            if (obj.GetComponent<TO_Basic>().m_type == TaskObject.Type.Toy || obj.GetComponent<TO_Basic>().m_type == TaskObject.Type.Plate || obj.GetComponent<TO_Basic>().m_type == TaskObject.Type.Book)
            {
                Destroy(obj);
            }
        }
    }

    private void SpawnObject(TaskObject.Type type)
    {
        int m_noOf = 0;
        GameObject m_object = new GameObject();
        GameObject m_objectDestination = new GameObject();
        List<GameObject> m_objectSpawnLocations = new List<GameObject>();

        switch (type)
        {
            case (TaskObject.Type.Toy):
                {
                    m_noOf = m_noOfNessies;
                    m_object = m_nessie;
                    m_objectDestination = m_nessieDestination;
                    m_objectSpawnLocations = m_nessieSpawnLocations;
                    break;
                }
            case (TaskObject.Type.Plate):
                {
                    m_noOf = m_noOfPlates;
                    m_object = m_plate;
                    m_objectDestination = m_plateDestination;
                    m_objectSpawnLocations = m_plateSpawnLocations;
                    break;
                }
            case (TaskObject.Type.Book):
                {
                    m_noOf = m_noOfBooks;
                    m_object = m_book;
                    m_objectDestination = m_bookDestination;
                    m_objectSpawnLocations = m_bookSpawnLocations;
                    break;
                }
            default:
                break;
        }

        m_object.GetComponent<TO_Basic>().tasksystem = m_taskSystem;
        m_object.GetComponent<TO_Basic>().m_destination = m_objectDestination;
        m_object.GetComponent<TO_Basic>().m_neckReference = m_playerNeck;


        m_chosenNumbers.Clear();
        bool unique = false;
        for (int i = 0; i < m_noOf; i++)
        {
            unique = false;
            while (!unique)
            {
                m_randomNo = UnityEngine.Random.Range(0, m_objectSpawnLocations.Count);
                if (!m_chosenNumbers.Contains(m_randomNo))
                {
                    m_chosenNumbers.Add(m_randomNo);
                    unique = true;
                }
            }

            Instantiate(m_object, m_objectSpawnLocations[m_randomNo].transform.position, Quaternion.identity);
        }
    }

    private void Randomise()
    {
        DestroyAllInteractables();

        UnityEngine.Random.InitState((int)System.DateTime.Now.Ticks);

        SpawnObject(TaskObject.Type.Toy);
        SpawnObject(TaskObject.Type.Plate);
        SpawnObject(TaskObject.Type.Book);
    }

    public void TestRandomise(InputAction.CallbackContext context)
    {
        float button = context.ReadValue<float>();
        m_interact = Math.Abs(button - 1.0f) < 0.1f ? true : false;
        //Debug.Log("Interact detected: " + m_interact);
    }
}