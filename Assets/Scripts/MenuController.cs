using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class MenuController : MonoBehaviour
{
	public GameObject mainPanel, optionsPanel, quitPanel,settingsPage,keybindingsPage;
	public AudioClip soundClick;
	[Range(0, 1)]
	public float soundClickvolume;
	public GameObject optionsanchor;

	private MainMenuCamera mainMenuCamera;

	void Awake()
	{

		mainMenuCamera = Camera.main.GetComponent<MainMenuCamera>();
	}

	public void PlayGame()
	{

		//mainMenuCamera.ChangePosition(1);
		SceneManager.LoadScene("LoadingScreen");
		mainPanel.SetActive(false);
	}

	public void Options()
    {
		mainPanel.SetActive(false);
		optionsPanel.SetActive(true);
		settingsPage.SetActive(true);
		keybindingsPage.SetActive(false);
		SoundManager.PlayUifx(soundClick, soundClickvolume);
		optionsanchor.SetActive(false);
		//mainMenuCamera.ChangePosition(1); // changes to position
    }

	public void SettingsPage2()
    {
		settingsPage.SetActive(true);
		keybindingsPage.SetActive(false);
		SoundManager.PlayUifx(soundClick, soundClickvolume);
	}
	public void Keybindings()
	{
		settingsPage.SetActive(false);
		keybindingsPage.SetActive(true);
		SoundManager.PlayUifx(soundClick, soundClickvolume);
	}

	public void BackToMainMenu()
	{
	//	mainMenuCamera.ChangePosition(0);
		mainPanel.SetActive(true);
		SoundManager.PlayUifx(soundClick, soundClickvolume);
		optionsPanel.SetActive(false);


	}

	public void QuitGame()
    {
		mainPanel.SetActive(false);
		optionsPanel.SetActive(false);
		SoundManager.PlayUifx(soundClick, soundClickvolume);
		quitPanel.SetActive(true);
    }

	public void YesQuit()
    {
		Application.Quit();
		SoundManager.PlayUifx(soundClick, soundClickvolume);
		Debug.Log("Game has been exited");
    }

	public void NoQuit()
    {
		SoundManager.PlayUifx(soundClick, soundClickvolume);
		mainPanel.SetActive(true);
		quitPanel.SetActive(false);
    }
}
