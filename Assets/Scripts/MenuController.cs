using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class MenuController : MonoBehaviour
{
	public GameObject mainPanel, optionsPanel, quitPanel;

	private MainMenuCamera mainMenuCamera;

	void Awake()
	{
		mainMenuCamera = Camera.main.GetComponent<MainMenuCamera>();
	}

	public void PlayGame()
	{

		//mainMenuCamera.ChangePosition(1);
		SceneManager.LoadScene("main");
		mainPanel.SetActive(false);
	}

	public void Options()
    {
		mainPanel.SetActive(false);
		optionsPanel.SetActive(true);
		mainMenuCamera.ChangePosition(1);
    }

	public void BackToMainMenu()
	{
		mainMenuCamera.ChangePosition(0);
		mainPanel.SetActive(true);
		optionsPanel.SetActive(false);


	}

	public void QuitGame()
    {
		mainPanel.SetActive(false);
		optionsPanel.SetActive(false);
		quitPanel.SetActive(true);
    }

	public void YesQuit()
    {
		Application.Quit();
		Debug.Log("Game has been exited");
    }

	public void NoQuit()
    {
		mainPanel.SetActive(true);
		quitPanel.SetActive(false);
    }
}
