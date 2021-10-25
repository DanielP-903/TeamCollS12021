using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EventTask : Task
{
    // Times between which the event can happen
    [SerializeField] private Vector2 m_timeFrame;
    private Vector2 m_codeTimeFrame;

    // 0-100 in % of how likely this event will occur
    [SerializeField] private float m_likelihood;

    [SerializeField] private DayAndNightCycle m_dayNightCycleRef;

    [SerializeField] private GameObject m_uiObjectRef;

    private bool m_isHappening = false;

    private float m_currentSecond = 0.0f;
    private float m_savedSecond = 0.0f;

    void Start()
    {
        m_codeTimeFrame.x = (m_timeFrame.x / m_dayNightCycleRef.fullDayLength) * 2;
        m_codeTimeFrame.y = (m_timeFrame.y / m_dayNightCycleRef.fullDayLength) * 2;
    }

    void Update()
    {
        m_uiObjectRef.SetActive(m_isHappening);

        if (!m_isHappening)
        {
            m_currentSecond = (int)((m_dayNightCycleRef.time / 2) * m_dayNightCycleRef.fullDayLength);
            if (m_dayNightCycleRef.time >= m_codeTimeFrame.x && m_dayNightCycleRef.time < m_codeTimeFrame.y && m_currentSecond > m_savedSecond)
            {
                //Debug.Log("It is time! " + m_dayNightCycleRef.time + " ... " + m_codeTimeFrame.x);
                RandomiseEvents();
            }
            Debug.Log("currentSecond " + m_currentSecond);

        }
    }

    private void RandomiseEvents()
    {
        UnityEngine.Random.InitState((int)System.DateTime.Now.Ticks);
        float randomNo = UnityEngine.Random.Range(0, 100);
        if (randomNo < m_likelihood)
        {
            Debug.Log("Event has been triggered!");
            m_isHappening = true;
        }

        m_savedSecond = (int) ((m_dayNightCycleRef.time/2) * m_dayNightCycleRef.fullDayLength);
        Debug.Log("savedSecond " + m_savedSecond);

    }
}
