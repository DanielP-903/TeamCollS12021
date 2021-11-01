using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestSound : MonoBehaviour
{

    public AudioClip sound;
    [Range(0, 1)]
    public float soundvolume;

    public AudioClip sound2;
    [Range(0, 1)]
    public float soundvolume2;
    public int value;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    private void OnTriggerEnter(Collider other)
    {
        if(other.gameObject.tag=="Player")
        {
            if (value == 1)
            {
                SoundManager.PlaySfx(sound, soundvolume);
            }
            if(value==2)
            {
                SoundManager.PlaySfx(sound2, soundvolume2);
            }
        }
    }
}
