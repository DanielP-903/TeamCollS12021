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

    private void Awake()
    {
        anim[0].keepAnimatorControllerStateOnDisable = true;
        anim[1].keepAnimatorControllerStateOnDisable = true;
     }

IEnumerator startscratch()
    {

                yield return new WaitForSeconds(1f);
                anim[0].SetBool("Scratch",true);
                yield return new WaitForSeconds(0.5f);
                anim[1].SetBool("Scratch",true);
                yield return new WaitForSeconds(2f);
    }


    // Update is called once per frame
    void Update()
    {
        
    }
}
