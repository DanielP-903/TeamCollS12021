using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IntroClipObject : MonoBehaviour
{
    [Tooltip("The sfx file to be played")]
    [SerializeField] internal AudioClip m_audioClip;

    [Tooltip("Time in sequence which it is played")]
    [SerializeField] internal float m_timeStamp;

    internal bool m_hasPlayed;
}
