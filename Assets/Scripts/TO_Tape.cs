using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TO_Tape : TO_Basic
{

    [SerializeField] internal Day m_day;

    public override void Complete()
    {
        m_active = false;
        m_taskSystem.Complete(14);
    }

}
