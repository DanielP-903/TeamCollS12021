using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem.EnhancedTouch;
using UnityEngine.InputSystem;

public class PauseController : MonoBehaviour
{
    public bool isPaused;
    private bool m_Escape;
    public GameObject pausePanel;
    public GameObject settingsPanel;
    

    // Start is called before the first frame update
    void Start()
    {
        pausePanel.SetActive(false);
        settingsPanel.SetActive(false);
    }

    public void EscapeButton(InputAction.CallbackContext context)
    {
        float button = context.ReadValue<float>();
        m_Escape = (button - 1.0f) < 0.1f ? true : false;
    }

    // Update is called once per frame
    void Update()
    {
        if (m_Escape)
        {
            if (!isPaused)
            {
                PauseGame();
            }
        }
    }

    public void PauseGame()
    {
        isPaused = true;
        Time.timeScale = 0f;
        pausePanel.SetActive(true);
    }

    public void Resume()
    {
        pausePanel.SetActive(false);
        m_Escape = false;
        isPaused = false;
        Time.timeScale = 1f;
    }

    public void Settings()
    {
        settingsPanel.SetActive(true);
        pausePanel.SetActive(false);

    }

    public void Back()
    {
        isPaused = true;
        settingsPanel.SetActive(false);
        pausePanel.SetActive(true);
    }

    public void QuitGame()
    {
        Application.Quit();
       
    }

    public void ChangeQuality()
    {
        string quality = UnityEngine.EventSystems.EventSystem.current.currentSelectedGameObject.name;

        switch(quality)
        {
            case "Low":
                QualitySettings.SetQualityLevel(1);
                break;

            case "Medium":
                QualitySettings.SetQualityLevel(2);
                break;

            case "High":
                QualitySettings.SetQualityLevel(3);
                break;

            case "Ultra":
                QualitySettings.SetQualityLevel(4);
                break;

            case "Remove Shadows":
                if (QualitySettings.shadows == ShadowQuality.All)
                {
                    QualitySettings.shadows = ShadowQuality.Disable;
                }
                else
                {
                    QualitySettings.shadows = ShadowQuality.All;
                }
                break;
        }
    }

    public void SetResolution()
    {
        string setresolution = UnityEngine.EventSystems.EventSystem.current.currentSelectedGameObject.name;

        switch(setresolution)
        {
            case "800x600":
                Screen.SetResolution(800, 600, true);
                Debug.Log("First");
                break;
            case "1280x720":
                Screen.SetResolution(1280, 720, true);
                Debug.Log("Second");
                break;
            case "1360x768":
                Screen.SetResolution(1360, 768, true);
                Debug.Log("Third");
                break;
            case "1920x1080":
                Screen.SetResolution(1920, 1080, true);
                Debug.Log("Fourth");
                break;
        }
    }
}
