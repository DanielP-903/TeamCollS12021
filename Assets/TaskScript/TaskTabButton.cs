using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TaskTabButton : MonoBehaviour
{
    public GameObject levelpanel;
    public GameObject levelpanel2;
    public GameObject levelpanel3;
    // Start is called before the first frame update
    void Start()
    {
        levelpanel2.SetActive(false);
        levelpanel3.SetActive(false);
    }

    public void SelectTab()
    {
        levelpanel.SetActive(true);
        levelpanel2.SetActive(false);
        levelpanel3.SetActive(false);
    }

    public void SelectTab2()
    {
        levelpanel.SetActive(false);
        levelpanel2.SetActive(true);
        levelpanel3.SetActive(false);
    }

    public void SelectTab3()
    {
        levelpanel.SetActive(false);
        levelpanel2.SetActive(false);
        levelpanel3.SetActive(true);
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
