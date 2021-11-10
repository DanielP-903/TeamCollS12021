using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class TaskTabButton : MonoBehaviour
{
    public GameObject levelpanel;
    public GameObject levelpanel2;
    public GameObject levelpanel3;
    public GameObject mainTabbutton;


    public int panelvalue;
    private Animator anim;
    private Animator anim2;
    private Animator anim3;
    private Animator buttonanim;
    // Start is called before the first frame update
    void Start()
    {
        levelpanel2.SetActive(false);
        levelpanel3.SetActive(false);
        anim = levelpanel.GetComponent<Animator>();
        anim2 = levelpanel2.GetComponent<Animator>();
        anim3 = levelpanel3.GetComponent<Animator>();
        buttonanim = mainTabbutton.GetComponent<Animator>();
    }

    public void SelectTab()
    {
        panelvalue = 1;
        levelpanel.SetActive(true);
        levelpanel2.SetActive(false);
        levelpanel3.SetActive(false);
    }

    public void SelectTab2()
    {
        panelvalue = 2;
        levelpanel.SetActive(false);
        levelpanel2.SetActive(true);
        levelpanel3.SetActive(false);
    }

    public void SelectTab3()
    {
        panelvalue = 3;
        levelpanel.SetActive(false);
        levelpanel2.SetActive(false);
        levelpanel3.SetActive(true);
    }

    public void CloseTab()
    {
        if (panelvalue == 1)
        {
            if (anim != null && buttonanim !=null)
            {
                bool isClose = anim.GetBool("Close");
                anim.SetBool("Close", !isClose);
                bool buttonisClose = buttonanim.GetBool("Close");
                buttonanim.SetBool("Close", !buttonisClose);
            }
        }
        if (panelvalue == 2)
        {
            if (anim != null && buttonanim != null)
            {
                bool isClose = anim2.GetBool("Close");
                anim2.SetBool("Close", !isClose);
                bool buttonisClose = buttonanim.GetBool("Close");
                buttonanim.SetBool("Close", !buttonisClose);
            }
        }
        if (panelvalue == 3)
        {
            if (anim != null && buttonanim != null)
            {
                bool isClose = anim3.GetBool("Close");
                anim3.SetBool("Close", !isClose);
                bool buttonisClose = buttonanim.GetBool("Close");
                buttonanim.SetBool("Close", !buttonisClose);
            }
        }
    }


    // Update is called once per frame
    void Update()
    {

    }
}
