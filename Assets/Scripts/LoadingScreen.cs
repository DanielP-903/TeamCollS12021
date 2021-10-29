using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class LoadingScreen : MonoBehaviour
{
    public Transform loadingimage;
    public float targetAmount = 100f;
    public float speed = 5f;
    public float currentAmount;
    public GameObject fadescreen;
    public Animator anim;
    

    // Start is called before the first frame update
    void Start()
    {
        currentAmount = 0f;
    }

    // Update is called once per frame
    void Update()
    {
        if(currentAmount<targetAmount)
        {
            currentAmount += speed * Time.deltaTime;
            loadingimage.GetComponent<Image>().fillAmount = (float)currentAmount / 100f;
        }

        if(currentAmount>targetAmount)
        {
            StartCoroutine(loading());
     
        }
    }

    IEnumerator loading()
    {
        anim.SetBool("isfade", true);
        yield return new WaitForSeconds(4f);
        SceneManager.LoadScene("Main");         // Load  main scene
    }
}
