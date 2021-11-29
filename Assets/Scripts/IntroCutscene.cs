using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class IntroCutscene : MonoBehaviour
{
    [Tooltip("Add intro clip objects here to be played in sequence")]
    [SerializeField]
    private List<IntroClipObject> m_introClips = new List<IntroClipObject>();

    [Tooltip("The length of the intro cutscene (must be longer than any timestamp!)")]
    [SerializeField] 
    private float m_introCutsceneLength = 0.0f;

    [Tooltip("Potential time offset")]
    [SerializeField]
    private float m_timeOffset = 0.01f;

    private float m_introTimer = 0.0f;
    // Start is called before the first frame update
    void Start()
    {
        foreach (var clip in m_introClips)
        {
            if (clip.m_timeStamp > m_introCutsceneLength)
            {
                Debug.LogError("A timestamp is beyond the length of the cutscene!");
                Debug.DebugBreak();
            }
        }
    }

    // Update is called once per frame
    void Update()
    {
        m_introTimer += Time.deltaTime;
        if (m_introTimer > m_introCutsceneLength)
        {
            StartCoroutine(loading());
            // End the cutscene
        }
        else
        {
            for (int i = 0; i < m_introClips.Count; i++)
            {
                if (m_introClips[i].m_hasPlayed == false)
                {
                    if (m_introTimer >= m_introClips[i].m_timeStamp - m_timeOffset && m_introTimer <= m_introClips[i].m_timeStamp + m_timeOffset)
                    {
                        m_introClips[i].m_hasPlayed = true;
                        GetComponent<AudioSource>().PlayOneShot(m_introClips[i].m_audioClip, 1.0f);
                    }
                }
            } 
        }
    }

    IEnumerator loading()
    {
        yield return new WaitForSeconds(1f);
        SceneManager.LoadScene("Main");         // Load  main scene
    }
}
