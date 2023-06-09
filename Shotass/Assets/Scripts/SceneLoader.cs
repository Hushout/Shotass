using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SceneLoader : MonoBehaviour
{
    private GameObject _mySceptre;
    // Start is called before the first frame update
    void Start()
    {
        _mySceptre = GameObject.FindGameObjectWithTag("MySceptre");

    }

    // Update is called once per frame
    void Update()
    {
        // Each 5 seconds
        if (Time.frameCount % 300 == 0)
        {
            _mySceptre.GetComponent<Sceptre>().CastSpell();
        }
    }
}
