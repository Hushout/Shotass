using System;
using System.Collections;
using System.Collections.Generic;
using Unity.XR.CoreUtils;
using UnityEngine;

public class Target : MonoBehaviour
{
    [SerializeField]
    public HealthBar healthBar;
    
    [SerializeField]
    private double _health = 100;
    
    [SerializeField]
    private double _maxHealth = 100;

    [SerializeField]
    public GameObject fxCriticalFire;
    [SerializeField]
    public GameObject fxMediumFire;
    [SerializeField]
    public GameObject fxSoftFire;
    
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
        ToggleFX();
        if (_health <= 0)
        {
            Die();
        }
    }
    
    void Die()
    {
        Destroy(this.gameObject, 5);
        OnDie?.Invoke();
    }

    public void ToggleFX()
    {
        if (fxCriticalFire is null || fxMediumFire is null || fxSoftFire is null) return;
        if (_health <= (_maxHealth / 3))
        {
            fxSoftFire.SetActive(true);
            fxMediumFire.SetActive(true);
            fxCriticalFire.SetActive(true);
        } else if (_health <= (_maxHealth / 2))
        {
            fxSoftFire.SetActive(true);
            fxMediumFire.SetActive(true);
            fxCriticalFire.SetActive(false);
        } else if (_health <= (_maxHealth - 1))
        {
            fxSoftFire.SetActive(true);
            fxMediumFire.SetActive(false);
            fxCriticalFire.SetActive(false);
        }
    }
    
    public bool IsDead()
    {
        return _health <= 0;
    }
    
    //OnDie
    public delegate void OnDieDelegate();
    
    public event OnDieDelegate OnDie;
}
