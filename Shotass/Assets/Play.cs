using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.Serialization;
using UnityEngine.XR.Interaction.Toolkit;

public class Play : MonoBehaviour
{
    public static Play instance;
    public static void instanceSet(Play play)
    {
        if(instance is not null)
            VRDebug.LogWarning("Trying to set PlayRound instance twice");
        
        instance = play;
    }
    public static void EndRound()
    {
        instance.endRound();
        VRDebug.Log("Round Ended");
    }

    public static void CheckGameOver()
    {
        VRDebug.Log("CheckGameOver");
        if (
            (Play.instance.Player1 is not null && Play.instance.Player1.CheckGameOverByPlayTargets(Play.instance.Player1.Targets))||
            (Play.instance.Player2 is not null && Play.instance.Player2.CheckGameOverByPlayTargets(Play.instance.Player2.Targets))
        )
        {
            Play.EndRound();
        }
    }
    
    
    public Player Player1 = null;
    public Player Player2 = null;

    public GameObject Meteor;

    // Start is called before the first frame update
    void Start()
    {
        Play.instanceSet(this);
    }
    
    private void endRound()
    {
        Meteor.SetActive(true);
        //Wait 10 seconds
        StartCoroutine(WaitAndReload(13f));
    }
    
    //WaitAndReload
    IEnumerator WaitAndReload(float waitTime)
    {
        yield return new WaitForSeconds(waitTime);
        SceneManager.LoadScene(SceneManager.GetActiveScene().name);
    }


    public static bool IsAlliedTarget(Target target, Player player)
    {
        if (player.IsMyTarget(target))
        {
            VRDebug.Log("IsAlliedTarget : yes");
            return true;
        }
        VRDebug.Log("IsAlliedTarget : no");
        return false;
    }
    // Update is called once per frame
    void Update()
    {
        
    }
}
