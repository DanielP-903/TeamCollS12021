using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TO_Coat : TO_Basic
{
    public override void Awake()
    {
        m_taskSystem = GameObject.FindGameObjectWithTag("TaskSystem").GetComponent<TaskSystem>();
        hungUpCoat = GameObject.FindGameObjectWithTag("Hung-Up Coat");
        hungUpCoat.SetActive(false);
    }
    public override void Complete()
    {
        hungUpCoat.SetActive(true);
        m_active = false;
        m_taskSystem.Complete(3);
    }

}
