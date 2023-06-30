using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Target : MonoBehaviour
{
    [SerializeField]
    private double _health = 100;
    [SerializeField]
    public HealthBar healthBar;
    // Start is called before the first frame update
    void Start()
    {
        healthBar = GetComponentInChildren<HealthBar>();
    }

    // Update is called once per frame
    void Update()
    {
        healthBar.UpdateHealth((float)_health);
    }
    
    public void TakeDamage(double damage)
    {
        _health -= damage;
        healthBar.UpdateHealth((float)_health);
        if (_health <= 0)
        {
            Die();
        }
    }
    
    void Die()
    {
        Destroy(this.gameObject);
        OnDie?.Invoke();
    }

    public bool IsDead()
    {
        return _health <= 0;
    }
    
    //OnDie
    public delegate void OnDieDelegate();
    
    public event OnDieDelegate OnDie;
}
