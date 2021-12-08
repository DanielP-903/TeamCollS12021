using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FadeScript : MonoBehaviour
{
    public GameObject fadescreen;
    private Animator anim;
    public GameObject pausecontroller;
    // Start is called before the first frame update
    void Start()
    {
        StartCoroutine(Fade());
        anim = fadescreen.GetComponent<Animator>();

    }

    private IEnumerator Fade()
    {
        fadescreen.SetActive(true);
        yield return new WaitForSeconds(1f);
        pausecontroller.SetActive(false);
        anim.SetBool("isfadeout", true);
        yield return new WaitForSeconds(3f);
        fadescreen.SetActive(false);            // fade remove
        pausecontroller.SetActive(true);
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
