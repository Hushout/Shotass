using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR.Interaction.Toolkit;


public class Sceptre : Weapon
{
    [SerializeField]
    public Transform _projectileOrigin;
    [SerializeField]
    public GameObject _projectilePrefab;
    [SerializeField]
    public float fireSpeed = 20f;
    [SerializeField]
    public float chargeDuration = 2f;
    [SerializeField]
    public float maxBulletScale = 2f;
    
    private GameObject currentBullet;
    private Coroutine chargeCoroutine;
    
    
    void Start()
    {
        XRGrabInteractable grabbable = GetComponent<XRGrabInteractable>();
        grabbable.activated.AddListener(Charge);
        grabbable.deactivated.AddListener(Fire);
    }

    void Update()
    {
        if (currentBullet != null)
        {
            currentBullet.transform.position = _projectileOrigin.position;
        }
    }

    public GameObject CreateProjectile()
    {
        var gameObj = Instantiate(_projectilePrefab, _projectileOrigin.position, _projectileOrigin.rotation);
        var projectile = gameObj.GetComponent<Projectile>();
        gameObj.transform.SetParent(this.transform);
        projectile.SetDamage(_damage);
        return gameObj;
    }

    private IEnumerator GrowBullet()
    {
        float elapsedTime = 0f;
        Vector3 initialScale = currentBullet.transform.localScale;

        while (elapsedTime < chargeDuration)
        {
            float t = elapsedTime / chargeDuration;
            float scale = Mathf.Lerp(1f, maxBulletScale, t);
            currentBullet.transform.localScale = initialScale * scale;

            elapsedTime += Time.deltaTime;
            yield return null;
        }
    }
    
    public void Charge(ActivateEventArgs arg)
    {
        currentBullet = CreateProjectile();
        chargeCoroutine = StartCoroutine(GrowBullet());
    }
    
    public void Fire(DeactivateEventArgs arg)
    {
        if (chargeCoroutine != null)
        {
            StopCoroutine(chargeCoroutine);
            chargeCoroutine = null;
        }
        currentBullet.transform.position = _projectileOrigin.position;
        currentBullet.GetComponent<Rigidbody>().velocity = _projectileOrigin.up * fireSpeed;
        // Move outside Sceptre parent 
        currentBullet.transform.SetParent(null);
        Destroy(currentBullet, 60);
        currentBullet = null;
    }

}
