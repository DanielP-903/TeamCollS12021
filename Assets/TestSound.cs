using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestSound : MonoBehaviour
{

    public AudioClip sound;
    public AudioSource musicaudio;
    // Start is called before the first frame update
    void Start()
    {
        musicaudio.Play();
        StartCoroutine(StartFade());
    }

    IEnumerator StartFade()
    {
        float currentTime = 0;
        float start = musicaudio.volume;
        float duration = 3f;
        float targetvolume = 0f;
        while (currentTime < duration)
        {
            currentTime += Time.deltaTime;
            musicaudio.volume = Mathf.Lerp(start, targetvolume, currentTime / duration);
            Debug.Log("still running");
            yield return null;
        }
        yield break;
    }
}
