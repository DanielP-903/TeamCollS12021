using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class TestSound : MonoBehaviour
{

    public AudioClip sound;
    public AudioSource musicaudio;
    public Slider volumeslider;
    // Start is called before the first frame update


    void Start()
    {
        musicaudio.Play();
        if(PlayerPrefs.HasKey("musicvolume"))
        {
            PlayerPrefs.SetFloat("musicvolume", 1);
            Load();
        }
        else
        {
            Save();
        }
       // StartCoroutine(StartFade());
    }

    public void ChangeVolume()
    {
        AudioListener.volume = volumeslider.value;
    }

    private void Load()
    {
        volumeslider.value = PlayerPrefs.GetFloat("musicvolume");
    }

    private void Save()
    {
        PlayerPrefs.SetFloat("musicvolume", volumeslider.value);
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
