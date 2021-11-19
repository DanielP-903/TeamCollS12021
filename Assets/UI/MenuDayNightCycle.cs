using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class MenuDayNightCycle : MonoBehaviour
{
    [Range(0.0f, 2.0f)]
    public float time;
    public float fullDayLength;
    public float startTime;
    private float TimeRate;
    private float dayover;
    public Vector3 circlerotation;

    // Light Settings
    public Light Sun;
    public Gradient gd;
    public AnimationCurve SunIntensity;

    public Light Moon;
    public Gradient gd2;
    public AnimationCurve MoonIntensity;

    public GameObject lighthouselight;
    internal GameObject pipe;





    // Start is called before the first frame update
    void Start()
    {
        TimeRate = 1.0f / fullDayLength;
        time = startTime;
        lighthouselight.SetActive(false);
        pipe = GameObject.Find("Rotator");
       // pipe.SetActive(false);


    }

    // Update is called once per frame
    void Update()
    {

        time += TimeRate * Time.deltaTime;     
        time += Time.deltaTime / fullDayLength; //  total time  full day cycle
        dayover = time % 1f;

   

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
                Sun.transform.eulerAngles = (time - 0.45f) * circlerotation * 2.0f;
                Sun.intensity = SunIntensity.Evaluate(time);  // Light component intensity over time
                Sun.color = gd.Evaluate(time);  // Light component color over time
                if (Sun.intensity < 0 && Sun.gameObject.activeInHierarchy)  // disable 
                    Sun.gameObject.GetComponent<Light>().enabled = false;
                else if (Sun.intensity > 0 && Sun.gameObject.activeInHierarchy) // enable
                    Sun.gameObject.GetComponent<Light>().enabled = true;
            }
            if (time >= 1.0f)                        //skye cullin night sound
            {
                Sun.transform.eulerAngles = (time - 0.45f) * circlerotation * 2.0f;    
                Sun.intensity = MoonIntensity.Evaluate(time);
                Sun.color = gd2.Evaluate(time);
                if (Moon.intensity < 0 && Moon.gameObject.activeInHierarchy) // disable
                    Moon.gameObject.GetComponent<Light>().enabled = false;
                else if (Moon.intensity > 0 && Moon.gameObject.activeInHierarchy) // enable
                    Moon.gameObject.GetComponent<Light>().enabled = true;
            }

            if(time>2.0f)
        {
            time = 0f;
        }

         if(time>1.5f)
          {
            lighthouselight.SetActive(true);
        lighthouselight.transform.Rotate(new Vector3(0, 45, 0) * Time.deltaTime);
        pipe.transform.Rotate(new Vector3(0, 45, 0) * Time.deltaTime);
        }
        else
        {
            lighthouselight.SetActive(false);
            pipe.transform.Rotate(new Vector3(0, 0, 0) * Time.deltaTime);
        }

                


            // lighting intensity
           // RenderSettings.ambientIntensity = randomsunIntensity.Evaluate(time);
          //  RenderSettings.reflectionIntensity = randommoonIntensity.Evaluate(time);
        }
    }
