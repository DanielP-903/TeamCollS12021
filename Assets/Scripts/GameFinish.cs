using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class GameFinish : MonoBehaviour
{
    public GameObject fadescreen;
    private Animator anim;
    public GameObject pausecontroller;
    public int value;
    private int score;
    public Text FinalScoreText;
    // Start is called before the first frame update
    void Start()
    {
        if (value == 0)
        {
            StartCoroutine(Fade());
            anim = fadescreen.GetComponent<Animator>();
        }

        if (value == 1)
        {
            StartCoroutine(FadeOut());
            anim = fadescreen.GetComponent<Animator>();
            FinalScoreText.text = PlayerPrefs.GetInt("Score", TaskSystem.taskvalue).ToString();
            // if(PlayerPrefs.GetInt("Muted",0)==0)
            // {
            //     PlayerPrefs.SetInt("Muted", 1);
            //  }
            //   else
            //   {
            //      PlayerPrefs.SetInt("Muted", 0);
            // }
            if (PlayerPrefs.HasKey("musicvolume"))
            {
                PlayerPrefs.SetFloat("musicvolume", 1);
                SoundManager.Instance.Load();
            }
            else
            {
                SoundManager.Instance.Save();
            }
        }


    }

    private IEnumerator Fade()
    {
        fadescreen.SetActive(true);
        pausecontroller.SetActive(false);
        yield return new WaitForSeconds(1f);
        anim.SetBool("isfade", true);
        yield return new WaitForSeconds(5f);            // fade remove
        SceneManager.LoadScene("GameOver");
        
        
    }

    private IEnumerator FadeOut()
    {
        fadescreen.SetActive(true);
        yield return new WaitForSeconds(1f);
        anim.SetBool("isfadeout", true);
        yield return new WaitForSeconds(2f);
        fadescreen.SetActive(false);            // fade remove
    }

    public void PlayAgain()
    {
   
        Invoke("Restart", 2f);
    }

    public void Restart()
    {
        SceneManager.LoadScene("Main");
    }

    public void QuitToMenu()
    {
        SceneManager.LoadScene("Menu");
    }
}
