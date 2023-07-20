using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR.Interaction.Toolkit;
public class FireBullet : MonoBehaviour
{
    public GameObject bullet;
    public Transform spawnPoint;
    public float fireSpeed = 20f;
    public float chargeDuration = 2f;
    public float maxBulletScale = 2f;

    private GameObject currentBullet;
    private Coroutine chargeCoroutine;
    private bool crystal = false;
    // Start is called before the first frame update
    void Start()
    {
        XRGrabInteractable grabbable = GetComponent<XRGrabInteractable>();
        grabbable.activated.AddListener(Charge);
        grabbable.deactivated.AddListener(Fire);
        XRSocketInteractor slot = GetComponentInChildren<XRSocketInteractor>();
        slot.selectEntered.AddListener(onCrytalSelect);
        slot.selectExited.AddListener(offCrystalSelect);
    }

    // Update is called once per frame
    void Update()
    {
        if (currentBullet != null)
        {
            currentBullet.transform.position = spawnPoint.position;
        }
    }

    public void Charge(ActivateEventArgs arg)
    {
        if (crystal)
        {
            currentBullet = Instantiate(bullet, spawnPoint.position, spawnPoint.rotation);
            chargeCoroutine = StartCoroutine(GrowBullet());
        }
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



    public void Fire(DeactivateEventArgs arg)
    {
        if (crystal)
        {
            if (chargeCoroutine != null)
            {
                StopCoroutine(chargeCoroutine);
                chargeCoroutine = null;
            }
            currentBullet.transform.position = spawnPoint.position;
            currentBullet.GetComponent<Rigidbody>().velocity = -spawnPoint.right * fireSpeed;
            Destroy(currentBullet, 60);
            currentBullet = null;
        }
    }

    public void onCrytalSelect(SelectEnterEventArgs arg)
    {
        crystal = true;
    }

    public void offCrystalSelect(SelectExitEventArgs arg)
    {
        crystal = false;
    }
}
