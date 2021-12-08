using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class StaticTask : Task
{
    private DayAndNightCycle m_dayNightCycleRef;


    [SerializeField] private List<TaskObject> m_taskObject = new List<TaskObject>();


    void Start()
    {
        m_dayNightCycleRef = GameObject.FindGameObjectWithTag("DayNight Cycle").GetComponent<DayAndNightCycle>();
        if (m_taskObject.Count == 0)
        {
            Debug.LogError("No Task Objects assigned to list on Static Task!");
            Debug.DebugBreak();
        }

        descriptionText = m_uiObjectRef.transform.GetChild(0).gameObject;
        currentamountText = m_uiObjectRef.transform.GetChild(1).gameObject;
        symbolText = m_uiObjectRef.transform.GetChild(2).gameObject;
        requiredamountText = m_uiObjectRef.transform.GetChild(3).gameObject;

        descriptionText.GetComponent<Text>().text = description;
        currentamountText.GetComponent<Text>().text = currentAmount.ToString();
        requiredamountText.GetComponent<Text>().text = requiredAmount.ToString();

        symbolText.GetComponent<Text>().text = "/";

        currentamountText.SetActive(false);
        requiredamountText.SetActive(false);
        symbolText.SetActive(false);

    }

}
