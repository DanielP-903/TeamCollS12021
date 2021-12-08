using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class EventTask : Task
{
    // Times between which the event can happen
    [SerializeField] private Vector2 m_timeFrame;
    private Vector2 m_codeTimeFrame;

    // 0-100 in % of how likely this event will occur
    [SerializeField] private float m_likelihood;

    private DayAndNightCycle m_dayNightCycleRef;


    [SerializeField] private List<TaskObject> m_taskObject = new List<TaskObject>();

    private bool m_isHappening = false;

    private float m_currentSecond = 0.0f;
    private float m_savedSecond = 0.0f;

    void Start()
    {
        m_dayNightCycleRef = GameObject.FindGameObjectWithTag("DayNight Cycle").GetComponent<DayAndNightCycle>();
        if (m_taskObject.Count == 0)
        {
            Debug.LogError("No Task Objects assigned to list on Event Task!");
            Debug.DebugBreak();
        }

        //m_codeTimeFrame.x = (m_timeFrame.x / m_dayNightCycleRef.fullDayLength) * 2;
        //m_codeTimeFrame.y = (m_timeFrame.y / m_dayNightCycleRef.fullDayLength) * 2;

        descriptionText = m_uiObjectRef.transform.GetChild(0).gameObject;
        currentamountText = m_uiObjectRef.transform.GetChild(1).gameObject;
        symbolText = m_uiObjectRef.transform.GetChild(2).gameObject;
        requiredamountText = m_uiObjectRef.transform.GetChild(3).gameObject;
        descriptionText.GetComponent<Text>().text = description;
        currentamountText.GetComponent<Text>().text = currentAmount.ToString();
        requiredamountText.GetComponent<Text>().text = requiredAmount.ToString();
        symbolText.GetComponent<Text>().text = "/";



    }

    void Update()
    {
        m_uiObjectRef.SetActive(m_isHappening);
        //Debug.Log(m_dayNightCycleRef.time.ToString());
        if (!m_isHappening && !m_dayNightCycleRef.isGameOver)
        {
            m_currentSecond = (int)((m_dayNightCycleRef.time / 2) * m_dayNightCycleRef.fullDayLength);
            if (m_currentSecond >= (int)m_timeFrame.x && m_currentSecond <= (int)m_timeFrame.y && m_currentSecond > m_savedSecond)
            {
                RandomiseEvents();
            }
        }
        if (isComplete && taskTabButton.isClose)
        {
            //isComplete = false;
            Scratchmark();
        }
        //Debug.Log("Current Second: " + (int)((m_dayNightCycleRef.time / 2) * m_dayNightCycleRef.fullDayLength));

    }

    private void RandomiseEvents()
    {
        UnityEngine.Random.InitState((int)System.DateTime.Now.Ticks);
        float randomNo = UnityEngine.Random.Range(0, 100);
        if (randomNo < m_likelihood)
        {
            // DO EVENT STUFF HERE
            foreach (var task in m_taskObject)
            {
                task.m_active = true;
            }
            //Debug.Log("Event has been triggered!");
            m_isHappening = true;
           // m_taskSystem.Complete(4);
        }

        m_savedSecond = (int) ((m_dayNightCycleRef.time/2) * m_dayNightCycleRef.fullDayLength);
        //Debug.Log("savedSecond " + m_savedSecond + " , Caused by: " + randomNo + " out of a possible " + m_likelihood);
    }
}
