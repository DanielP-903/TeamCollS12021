using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NoiseTrigger : MonoBehaviour
{
    public AudioSource noisesound;
    public AudioClip noiseclip;
    [Range(0, 1)]
    public float noisevolume;
    public bool AlreadyPlayed;
    public int waitTime;
    // Start is called before the first frame update

    private void Start()
    {
        noisesound.volume = noisevolume;
     
    }
    public void PlaySound()
    { 
    StartCoroutine(PlayEffect());
}
 
 IEnumerator PlayEffect() 
{
    if (!AlreadyPlayed) 
    {
        noisesound.PlayOneShot(noiseclip,noisevolume);
        AlreadyPlayed = true;
    }
        yield return new WaitForSeconds(waitTime);
        AlreadyPlayed = false;
}
}
