using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScratchEffect : MonoBehaviour
{
    public List<Animator> anim = new List<Animator>();
    // Start is called before the first frame update
    void Start()
    {
        StartCoroutine(startscratch());
    }

    IEnumerator startscratch()
    {
        yield return new WaitForSeconds(1f);
        anim[0].SetTrigger("Scratch");
        yield return new WaitForSeconds(0.5f);
        anim[1].SetTrigger("Scratch");
        yield return new WaitForSeconds(2f);
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
