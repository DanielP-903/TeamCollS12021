using System;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using UnityEngine.InputSystem.EnhancedTouch;
using UnityEngine.InputSystem;
public class LoadingScreen : MonoBehaviour
{
    public Transform loadingimage;
    public float targetAmount = 100f;
    public float speed = 5f;
    public float currentAmount;
    public GameObject fadescreen;
    public Animator anim;
    private bool m_interact = false;

    [SerializeField] private GameObject _PressKeyToContinueRef;

    // Start is called before the first frame update
    void Start()
    {
        currentAmount = 0f;
        _PressKeyToContinueRef.SetActive(false);
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
            if (_PressKeyToContinueRef.activeInHierarchy == false)
                _PressKeyToContinueRef.SetActive(true);

            if (m_interact)
            {
                if (anim.GetBool("isfade") == false)
                {
                    StartCoroutine(loading());
                }
            }
        }
    }
    public void Interact(InputAction.CallbackContext context)
    {
        float button = context.ReadValue<float>();
        m_interact = Math.Abs(button - 1.0f) < 0.1f ? true : false;
        //Debug.Log("Interact detected: " + m_interact);
    }
    IEnumerator loading()
    {
        anim.SetBool("isfade", true);
        yield return new WaitForSeconds(1f);
        SceneManager.LoadScene("IntroScene");         // Load  main scene
    }
}
