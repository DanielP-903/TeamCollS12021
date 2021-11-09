using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StaticTask : Task
{
    private DayAndNightCycle m_dayNightCycleRef;

    [SerializeField] private GameObject m_uiObjectRef;

    [SerializeField] private List<TaskObject> m_taskObject = new List<TaskObject>();


    void Start()
    {
        m_dayNightCycleRef = GameObject.FindGameObjectWithTag("DayNight Cycle").GetComponent<DayAndNightCycle>();
        if (m_taskObject.Count == 0)
        {
            Debug.LogError("No Task Objects assigned to list on Static Task!");
            Debug.DebugBreak();
        }

        descriptionText.text = description;
        currentamountText.text = currentAmount.ToString();
        symbolText.text = "/";
        requiredamountText.text = requiredAmount.ToString();

        currentamountText.enabled = false;
        requiredamountText.enabled = false;
        symbolText.enabled = false;

    }

}
