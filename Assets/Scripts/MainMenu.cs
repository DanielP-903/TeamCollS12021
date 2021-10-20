using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class MainMenu : MonoBehaviour
{
    public GameObject optionspanel;
    public GameObject quitpanel;


    void Start()
    {
        optionspanel.SetActive(false);
        quitpanel.SetActive(false);
    }
    public void PlayGame()
    {
        SceneManager.LoadScene("Main");
    }

    public void Options()
    {
        optionspanel.SetActive(true);
    }

    public void OptionsBack()
    {
        optionspanel.SetActive(false);
    }

    public void QuitPanel()
    {
        quitpanel.SetActive(true);
    }
    
    public void YesQuit()
    {
        Application.Quit();
        Debug.Log("You have exited the game");
    }

    public void NoQuit()
    {
        quitpanel.SetActive(false);
    }
}
