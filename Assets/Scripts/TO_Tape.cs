using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TO_Tape : TO_Basic
{
    public enum Day
    {
        Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday
    };

    [SerializeField] private Day day;
}
