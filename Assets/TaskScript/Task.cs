using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


public class Task : MonoBehaviour
{
  
    public string description;
    public int reward;
    private string symbol = "/";

    public Text descriptionText;
    public Text rewardText;
    public Text currentamountText;
    public Text symbolText;
    public Text requiredamountText;

    public Animator anim;


    void Start()
    {
        descriptionText.text = description;
        currentamountText.text = currentAmount.ToString();
        symbolText.text = symbol;
        requiredamountText.text = requiredAmount.ToString();
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
        anim.SetBool("isChecked", true);
        yield return new WaitForSeconds(3f);
        rewardText.text = reward.ToString();
      //  Destroy(this);
    }
}
