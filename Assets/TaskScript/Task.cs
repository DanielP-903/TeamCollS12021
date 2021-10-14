using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


public class Task : MonoBehaviour
{
  
    public string description;
    public int reward;
    public int xp;

    public Animator anim;


    void Start()
    {
       
    }

    public enum TaskStatus
    {
        Open, Closed
    }
    public TaskStatus CurrentStatus;

    public int currentAmount;
    public int requiredAmount;
    public enum ItemType
    { Default,book,plate,cup }

    public ItemType itemtype;
    public bool isReached()
    {
        return (currentAmount >= requiredAmount);
    }

    public void ItemsCollected()
    {
        currentAmount+=1;
    }
    public void ItemsDisposed()
    {
        currentAmount--;
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
        Destroy(this);
    }
}
