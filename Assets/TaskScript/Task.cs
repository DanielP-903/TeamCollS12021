using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


public class Task : MonoBehaviour
{
  
    public string description;
    private string symbol = "/";

    public Text descriptionText;
    public Text currentamountText;
    public Text symbolText;
    public Text requiredamountText;

    // public Animator anim;
   // public GameObject ScratchEffect;


    void Start()
    {
        descriptionText.text = description;
        currentamountText.text = currentAmount.ToString();
        requiredamountText.text = requiredAmount.ToString();
        symbolText.text = symbol;
        //ScratchEffect.SetActive(false);
    }

    public enum TaskStatus
    {
        Open, Closed
    }
    public TaskStatus CurrentStatus;

    public int currentAmount;
    public int requiredAmount;

    public bool isReached()
    {
        return (currentAmount >= requiredAmount);
    }

    public void ItemsCollected()
    {
        currentAmount+=1;
        currentamountText.text = currentAmount.ToString();
    }


    public void ItemsDisposed()
    {
        currentAmount-=1;
        currentamountText.text = currentAmount.ToString();
    }
    public void TaskCompleted()
    {
        CurrentStatus = TaskStatus.Closed;
        StartCoroutine(Checkmark());
    }

    IEnumerator Checkmark()
    {
        //anim.SetBool("isChecked", true);
     //   ScratchEffect.SetActive(true);
        yield return new WaitForSeconds(3f);
      //  Destroy(this);
    }
}
