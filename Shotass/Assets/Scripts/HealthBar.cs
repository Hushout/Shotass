using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HealthBar : MonoBehaviour
{
    [SerializeField]
    private GameObject lifeBar;
    [SerializeField]
    private float life = 100;
    
    private float maxWidth = 600;
    
    // Start is called before the first frame update
    void Start()
    {
        life = 100; 
        // TODO : Get background width (600px)
        //maxWidth = this.GetComponentInParent<Transform>().localScale.x;
    }

    // Update is called once per frame
    void Update()
    {
        Debug.Log("Update HealthBar");
        UpdateDisplay();
    }

    public void UpdateHealth(float health)
    {
        life = health;
        if (life > 100)
        {
            life = 100;
        }
        else if (life < 0)
        {
            life = 0;
        }
        UpdateDisplay();
    }

    public void UpdateDisplay()
    {
        float lifeWidth = (life * maxWidth) / 100;
        Debug.Log(lifeWidth);
        var sizeDelta = lifeBar.GetComponentInParent<RectTransform>().sizeDelta;
        lifeBar.GetComponentInParent<RectTransform>().sizeDelta = new Vector2(lifeWidth, sizeDelta.y);
    }
}
