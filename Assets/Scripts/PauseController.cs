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
    public AudioClip Soundclick;
    [Range(0, 1)]
    public float soundclickvolume;
    public Camera cam;
    

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
        SoundManager.PlaySfx(Soundclick, soundclickvolume);
        m_Escape = false;
        isPaused = false;
        Time.timeScale = 1f;
    }

    public void Settings()
    {
        settingsPanel.SetActive(true);
        SoundManager.PlaySfx(Soundclick, soundclickvolume);
        pausePanel.SetActive(false);

    }

    public void Back()
    {
        isPaused = true;
        SoundManager.PlaySfx(Soundclick, soundclickvolume);
        settingsPanel.SetActive(false);
        pausePanel.SetActive(true);
    }

    public void QuitGame()
    {
        Application.Quit();
        SoundManager.PlaySfx(Soundclick, soundclickvolume);
       
    }

    public void OffSound()
    {
        cam.GetComponent<AudioListener>().enabled = false;  // one audio listener must remain
    }

    public void OnSound()
    {
        cam.GetComponent<AudioListener>().enabled = true;
    }

    public void DisableQuality()
    {
        Debug.Log("disabling");
    }

    public void ChangeQuality()
    {
        string quality = UnityEngine.EventSystems.EventSystem.current.currentSelectedGameObject.name;

        switch(quality)
        {
            case "Low":
                QualitySettings.SetQualityLevel(1);
                SoundManager.PlaySfx(Soundclick, soundclickvolume);
                break;

            case "Medium":
                QualitySettings.SetQualityLevel(2);
                SoundManager.PlaySfx(Soundclick, soundclickvolume);
                break;

            case "High":
                QualitySettings.SetQualityLevel(3);
                SoundManager.PlaySfx(Soundclick, soundclickvolume);
                break;

            case "Ultra":
                QualitySettings.SetQualityLevel(4);
                SoundManager.PlaySfx(Soundclick, soundclickvolume); 
                break;

            case "Remove Shadows":  
                    QualitySettings.shadows = ShadowQuality.Disable;
                    SoundManager.PlaySfx(Soundclick, soundclickvolume);
                break;

            case "On Shadows":
                if(QualitySettings.shadows==ShadowQuality.Disable)  // shadows enabled
                {
                    QualitySettings.shadows = ShadowQuality.All;
                    SoundManager.PlaySfx(Soundclick, soundclickvolume); 
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
                SoundManager.PlaySfx(Soundclick, soundclickvolume);
                Debug.Log("First");
                break;
            case "1280x720":
                Screen.SetResolution(1280, 720, true);
                SoundManager.PlaySfx(Soundclick, soundclickvolume);
                Debug.Log("Second");
                break;
            case "1360x768":
                Screen.SetResolution(1368, 768, true);
                SoundManager.PlaySfx(Soundclick, soundclickvolume);
                Debug.Log("Third");
                break;
            case "1920x1080":
                Screen.SetResolution(1920, 1080, true);
                SoundManager.PlaySfx(Soundclick, soundclickvolume);
                Debug.Log("Fourth");
                break;

        }
    }
}
