using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class DayAndNightCycle : MonoBehaviour
{
    [Range(0.0f, 2.0f)]
    public float time;
    public float fullDayLength;
    public float startTime;
    private float TimeRate;
    private float dayover;
    public Vector3 circlerotation;
    public Transform hourhandbase;

    // Light Settings
    public Light Sun;
    public Gradient gd;
    public AnimationCurve SunIntensity;

    public Light Moon;
    public Gradient gd2;
    public AnimationCurve MoonIntensity;

    //Default
    public AnimationCurve randomsunIntensity;
    public AnimationCurve randommoonIntensity;

    public bool isGameOver;
    public GameObject gameoverPanel;
    public Text numberoftasks;
    private TaskSystem tasksystem;



    // Start is called before the first frame update
    void Start()
    {
        TimeRate = 1.0f / fullDayLength;
        time = startTime;
        gameoverPanel.SetActive(false);
        tasksystem = GameObject.FindObjectOfType<TaskSystem>();
    


    }

    // Update is called once per frame
    void Update()
    {

        time += TimeRate * Time.deltaTime;     
        time += Time.deltaTime / fullDayLength; //  total time  full day cycle
        dayover = time % 1f;

        if (!isGameOver)
        {
            if (time >= 2.0f)                  // if time is 2.0 end game
            {
                isGameOver = true;
                gameoverPanel.SetActive(true);
                numberoftasks.text = TaskSystem.taskvalue.ToString();
              //  Time.timeScale = 0f;
                
            }
            if(time<=2.0f)
            {
                Time.timeScale = 1f;
            }

            hourhandbase.transform.eulerAngles = new Vector3(0, 0, -dayover*360f); //rotate hour hand 
          //  Sun.transform.eulerAngles = (time - 0.25f) * circlerotation * 4.0f;  
           // Moon.transform.eulerAngles = (time - 0.75f) * circlerotation * 4.0f;

            /*
            if (time <= 1.0f)
            {
                Sun.gameObject.SetActive(true);
                Moon.gameObject.SetActive(false);
                if (Sun.intensity < 0 && Sun.gameObject.activeInHierarchy)  // disable 
                    Sun.gameObject.GetComponent<Light>().enabled = false;
                else if (Sun.intensity > 0 && Sun.gameObject.activeInHierarchy) // enable
                    Sun.gameObject.GetComponent<Light>().enabled = true;
            }

            if (time > 1.0f)
            {
                Moon.gameObject.SetActive(true);
                Moon.gameObject.SetActive(false);
                if (Moon.intensity < 0 && Moon.gameObject.activeInHierarchy) // disable
                    Moon.gameObject.GetComponent<Light>().enabled = false;
                else if (Moon.intensity > 0 && Moon.gameObject.activeInHierarchy) // enable
                    Moon.gameObject.GetComponent<Light>().enabled = true;
            }*/


            // teller of tell tales morning sound
            // pippin afternoon and evening sound
            // Daniel change for build
            if (time < 1.0f)
            {
                Sun.transform.eulerAngles = (time - 0.25f) * circlerotation * 3.0f;
                Sun.intensity = SunIntensity.Evaluate(time);  // Light component intensity over time
                Sun.color = gd.Evaluate(time);  // Light component color over time
                if (Sun.intensity < 0 && Sun.gameObject.activeInHierarchy)  // disable 
                    Sun.gameObject.GetComponent<Light>().enabled = false;
                else if (Sun.intensity > 0 && Sun.gameObject.activeInHierarchy) // enable
                    Sun.gameObject.GetComponent<Light>().enabled = true;
            }
            if (time >= 1.0f)                        //skye cullin night sound
            {
                Sun.transform.eulerAngles = (time - 0.25f) * circlerotation * 3.0f;    
                Sun.intensity = MoonIntensity.Evaluate(time);
                Sun.color = gd2.Evaluate(time);
                if (Moon.intensity < 0 && Moon.gameObject.activeInHierarchy) // disable
                    Moon.gameObject.GetComponent<Light>().enabled = false;
                else if (Moon.intensity > 0 && Moon.gameObject.activeInHierarchy) // enable
                    Moon.gameObject.GetComponent<Light>().enabled = true;
            }

                


            // lighting intensity
           // RenderSettings.ambientIntensity = randomsunIntensity.Evaluate(time);
          //  RenderSettings.reflectionIntensity = randommoonIntensity.Evaluate(time);
        }
    }


    public void PlayAgain()
    {
        isGameOver = false;
        Invoke("Restart", 2f);
    }

    public void Restart()
    {
        SceneManager.LoadScene(SceneManager.GetActiveScene().name);
    }

    public void QuitToMenu()
    {
        SceneManager.LoadScene(0);
    }
}
