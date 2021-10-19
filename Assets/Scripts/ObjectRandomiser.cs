using System.Collections;
using System.Collections.Generic;
using UnityEngine;

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
    // Start is called before the first frame update
    void Start()
    {
        Randomise();
    }

    private void Randomise()
    {
        Random.InitState((int)System.DateTime.Now.Ticks);
        bool unique = false;

        for (int i = 0; i < m_noOfNessies; i++)
        {
            unique = false;
            while (!unique)
            {
                m_randomNo = Random.Range(0, m_nessieSpawnLocations.Count);
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
    }
}
