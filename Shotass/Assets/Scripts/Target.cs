using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Target : MonoBehaviour
{
    [SerializeField]
    private double _health = 100;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
    
    public void TakeDamage(double damage)
    {
        Debug.Log($"Target took {damage} damage");
        _health -= damage;
        if (_health <= 0)
        {
            Die();
        }
    }
    
    void Die()
    {
        Debug.Log("Target died");
        Destroy(this.gameObject);
    }
}
